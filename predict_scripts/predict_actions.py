import os
import re
import openai
import build_prompts
import read_files
import few_shot_examples
import time
from pprint import pprint
import argparse
from openai import OpenAI

os.environ["OPENAI_API_KEY"]= ''
client = OpenAI(
  api_key=os.environ['OPENAI_API_KEY'],
)

model_name_map = {
    "gpt4o": "gpt-4o",
    "gpt4": "gpt-4-32k",
    "gpt3.5": "gpt-3.5-turbo-16k",
}

prompt_type_map = {
    "pair": "instruction_pair",
    "no_text": "instruction_no_text",
    "whole": "instruction_text",
}

# setup function
# "gpt-4-32k"
def get_gpt_response(messages, model="gpt-4-32k"):
    response = client.chat.completions.create(
        model=model,
        messages=messages,
        # prompt = messages,
        # temperature=1,
        # max_tokens=4000 # 32768, # 8192 #4096
        # top_p=1,
        # frequency_penalty=0,
        # presence_penalty=0
        )
    return response.choices[0].message.content

def postprocess_completion(completion):
  lines=['']
  for line in completion.split('\n'):
      if line:
        line = line.replace('```','')
        # remove (To be continued upon request)
        if not re.findall(r'^(\(:action|:parameters|:precondition|:effect|\?|\(|\))',line.strip()): # or 'Note:' in line
          continue
      if lines[-1].strip() or line.strip():
        lines.append(line)

  lines='\n'.join(lines).strip()
  lines+='\n\n)' # to concat actions with previous components in domain file
  return lines

def postprocess_completion_whole_domain(completion):
  lines=['']
  for line in completion.split('\n'):
      if line:
        line = line.replace('```','')
        # remove (To be continued upon request)
        # (continued in next response...)
        # if not re.findall(r'\(:action|:parameters|:precondition|:effect|^\(|^\)', line.strip()) or \
        if not re.findall(r'^(\(:action|:parameters|:precondition|:effect|\?|\(|\))',line.strip()) or \
               any([t in line for t in ['Note', 'actions', 'continued']]):
          continue
      if lines[-1].strip() or line.strip():
        lines.append(line)
  lines='\n'.join(lines).strip()
  try:
    s_idx = re.search(r' *\(:action', lines, ).start() #, flags=re.MULTILINE
  except:
    print(lines)
  lines = lines[s_idx:]
  if s_idx==0: # start with action
      lines += '\n\n)'
  return lines

def postprocess_completion_action(completion):
    pattern = re.compile(r"```\S*\s*(\(:action.*?)\s*```", re.DOTALL)
    action_code_blocks = pattern.findall(completion)
    return '\n\n'.join(action_code_blocks)+'\n\n)'

def save_output(folder_name, file_name, text):
  parent_dir = '../pddl_evaluation/pred'
  path = os.path.join(parent_dir, folder_name)

  if not os.path.exists(path):
    os.mkdir(path)

  with open(os.path.join(path,file_name), 'w') as f:
    f.write(text)

def main():
  # argparse
  parser = argparse.ArgumentParser()
  parser.add_argument('--model', type=str, default="gpt4", help="gpt model name")
  # parser.add_argument('--prompt', type=str, default="whole", help="the type of prompt to use")
  parser.add_argument('--instruct_prompt', type=str, default="instruction_ZPD", help="the type of prompt instruction")
  parser.add_argument('--pddl_prompt', type=str, default="instruction_no_text", help="the type of pddl prompt")
  # parser.add_argument('--cot', action="store_true", help="whether to use cot prompt")
  parser.add_argument('--few_shot', action="store_true", help="whether to use few shot examples")

  args = parser.parse_args()

  model = model_name_map[args.model]
  # prompt = prompt_type_map[args.prompt]
  instruct_prompt_type = args.instruct_prompt # "instruction_ZPD"
  pddl_prompt_type = args.pddl_prompt #"instruction_no_text"
  few_shot = args.few_shot
  pred_path = f'{model}_{instruct_prompt_type[12:]}_{pddl_prompt_type[12:]}_few_shot_{few_shot}'
  pred_raw_path = f'{model}_{instruct_prompt_type[12:]}_{pddl_prompt_type[12:]}_few_shot_{few_shot}_raw'

  # model = "gpt-4o"
  rt_path = '../pddl_data'
  # pred_path = 'gpt4o_3shot_desc_ZPD'
  # pred_raw_path = 'gpt4o_3shot_desc_ZPD_raw'
  # instruct_prompt_type = "instruction_ZPD"
  # pddl_prompt_type = "instruction_no_text" # "instruction_no_text_CoT", "instruction_pair_CoT"
  # few_shot = True

  prompts = build_prompts.read_prompt("prompts.json")
  instruct_prompt = prompts['instruction_task'] +'\n'+ prompts[instruct_prompt_type]
  if few_shot:
      prefix='here are 3 examples for the text to pddl translation task.'
      few_shot_prompt = prefix
      for i, key in enumerate(few_shot_examples.examples.keys()):
          few_shot_prompt += '\n' + build_prompts.compose_prompt(
              prompts['instruction_few_shot'],
              few_shot_examples.examples[key]
          ).replace('<i>', str(i+1))
  # print(few_shot_prompt)

  for path, dirs, files in os.walk(rt_path):
        # print(path,dir,files)
        if 'problem' not in path and path!=rt_path:
            # all([id not in path for id in ['114905535', '114934221', '115230790', '114994170', '114971046','114756331']]):
                # any([id in path for id in ['114394848', '114985787', '114778947']]):
                # all([id not in path for id in ['114905535','114756331','115230790','114994170']]):
                # not '114756331' in path:

            print(path)
            components={}
            for file in files:
                if file=='domain.pddl':
                    components.update(read_files.read_parse_pddl_domain_file(os.path.join(path, file),remove_desc=False))
                    last_action = components['action_names'][-1].split(';')[0].strip()
                    components['action_names']='\n'.join(components['action_names'])
                    components['goal']=re.sub(r'(\(define|\(domain|how_to_|\)|_)',' ',components['domain']).strip()
                    # topic_set.add(components['goal'])
                elif file[-4:]==".txt" and "wikihow" in file:
                    components['text'] = read_files.read_wikihow_file(os.path.join(path, file))
            # print(components)

            if components:

                # need below if action_step pair:
                # action_steps=read_files.read_txt_file(os.path.join(path, 'action_step_map.txt'))
                # action_text_pairs=build_prompts.process_action_text_pair(components['text'], action_steps)
                # components['action_text_pairs']='\n\n'.join(['\n'.join([act,steps]) for act, steps in action_text_pairs.items()])

                # need below if only keep relevant actions in text:
                # action_steps=read_files.read_txt_file(os.path.join(path, 'action_step_map.txt'))
                # components['text'] = build_prompts.process_action_text_whole(components['text'], action_steps)

                pddl_prompt = prompts[pddl_prompt_type]
                pddl_prompt = build_prompts.compose_prompt(pddl_prompt,components)
                # print(f'prompt:\n{pddl_prompt}')

                messages = [
                    {"role": "system", "content": 'you are a helpful assistant.'}, # few_shot_prompt
                    {"role": "user", "content": instruct_prompt},
                    {"role": "user", "content": few_shot_prompt} if few_shot
                    else {"role": "user", "content": 'please follow the instruction and generate pddl actions.'},
                    {"role": "user", "content": pddl_prompt}
                    # {"role": "user", "content": '\n'.join([instruct_prompt,few_shot_prompt, pddl_prompt])}
                ]
                # pprint(messages)

                try:
                  completion = get_gpt_response(messages, model=model)
                except:
                   print('wait...')
                   time.sleep(20)
                   completion = get_gpt_response(messages, model=model)

                # completion = get_gpt_response(messages, model=model)
                if not last_action in completion:
                  completion_extend = completion
                  for i in range(7):
                    messages.extend([{"role": "assistant", "content": completion_extend},{"role": "user", "content": "continue"}]) # ,{"role": "user", "content":"continue"}
                    try:
                        completion_extend = get_gpt_response(messages, model=model)
                    except:
                        print('wait...')
                        time.sleep(20)
                        completion_extend = get_gpt_response(messages, model=model)
                    completion+='\n'+completion_extend
                    print(f'continue {i+1} time')
                    # if last_action in completion_extend:
                    if last_action in completion:
                        print('reach end')
                        break
                else:
                    print('reach end')
                # print(f'comp:\n{completion}')

                # # re-write post processing file:
                # file_name=path.split('/')[-1]+'.txt'
                # # print(path)
                # completion = read_files.read_txt_file(os.path.join(pred_raw_path,file_name))

                comp_post = postprocess_completion_action(completion)
                # print(f'post_comp:\n{comp_post}')
                file_name=path.split('/')[-1]+'.txt'
                if pred_raw_path:
                  save_output(pred_raw_path,file_name,completion)
                save_output(pred_path,file_name,comp_post)
                print(f'save {file_name}')


main()
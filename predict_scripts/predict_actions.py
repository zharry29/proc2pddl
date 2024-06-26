import os
import re
import openai
import build_prompts
import read_files
import few_shot_examples
import time
from pprint import pprint
import argparse

os.environ["OPENAI_API_KEY"]= ''
openai.api_key = os.getenv("OPENAI_API_KEY")

model_name_map = {
    "gpt4": "gpt-4-32k",
    "gpt3.5": "gpt-3.5-turbo-16k",
}

prompt_type_map = {
    "pair": "instruction_pair",
    "no_text": "instruction_no_text",
    "whole": "instruction_text",
}

# argparse
parser = argparse.ArgumentParser()
parser.add_argument('--model', type=str, default="gpt4", help="gpt model name")
parser.add_argument('--prompt', type=str, default="whole", help="the type of prompt to use")
parser.add_argument('--cot', action="store_true", help="whether to use cot prompt")

args = parser.parse_args()

model = model_name_map[args.model]
prompt = prompt_type_map[args.prompt]
if args.cot:
    prompt += "_CoT"

# setup function
# "gpt-4-32k"
def get_gpt_response(messages, model="gpt-4-32k"):
    response = openai.ChatCompletion.create(
    model=model,
    messages=messages,
    # temperature=1,
    max_tokens=10000 # 32768, # 8192 #4096
    # top_p=1,
    # frequency_penalty=0,
    # presence_penalty=0
    )
    return response['choices'][0]['message']['content']

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
        if not re.findall(r'^(\(:action|:parameters|:precondition|:effect|\?|\(|\))',line.strip()) or \
               any([t in line for t in ['Note', 'actions']]):
          continue
      if lines[-1].strip() or line.strip():
        lines.append(line)
  lines='\n'.join(lines).strip()
  s_idx = re.search(r' *\(:action', lines, ).start() #, flags=re.MULTILINE
  lines = lines[s_idx:]
  if s_idx==0: # start with action
      lines += '\n\n)'
  return lines

def save_output(folder_name, file_name, text):
  parent_dir = '.'
  path = os.path.join(parent_dir, folder_name)

  if not os.path.exists(path):
    os.mkdir(path)

  with open(os.path.join(path,file_name), 'w') as f:
    f.write(text)

def main():
  model = "gpt-4-32k"
  rt_path = '../pddl_annotation'
  pred_path = 'gpt4_3shot_desc_CoT'
  pred_raw_path = 'gpt4_3shot_desc_CoT_raw'
  instruct_prompt_type = "instruction_CoT"
  # pred_path = f'{model}_{prompt}'
  # pred_raw_path = f'{model}_{prompt}_raw'
  pddl_prompt_type = "instruction_no_text" # "instruction_no_text_CoT", "instruction_pair_CoT"
  few_shot = True

  instruct_prompt = build_prompts.read_prompt('prompts.json')[instruct_prompt_type]
  pddl_prompt = build_prompts.read_prompt('prompts.json')[pddl_prompt_type]
  if few_shot:
      prefix='here are 3 examples for the text to pddl translation task.'
      few_shot_prompt = prefix
      for i, key in enumerate(few_shot_examples.examples.keys()):
          few_shot_prompt += '\n' + build_prompts.compose_prompt(
              build_prompts.read_prompt('prompts.json')['instruction_few_shot'],
              few_shot_examples.examples[key]
          ).replace('<i>', str(i+1))
  # print(few_shot_prompt)

  for path, dirs, files in os.walk(rt_path):
        # print(path,dir,files)
        if 'problem' not in path and path!=rt_path and '113996609' not in path:
                # all([id not in path for id in ['114905535','114756331','115230790','114994170']]): # 113996609
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
                action_steps=read_files.read_txt_file(os.path.join(path, 'action_step_map.txt'))
                components['action_text_pairs']=build_prompts.process_action_text_pair(components['text'], action_steps)

                # need below in only keep relevant actions in text:
                # action_steps=read_files.read_txt_file(os.path.join(path, 'action_step_map.txt'))
                # components['text'] = build_prompts.process_action_text_whole(components['text'], action_steps)

                pddl_prompt = build_prompts.compose_prompt(pddl_prompt,components)
                # print(f'prompt:\n{prompt}')

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
                    messages.extend([{"role": "assistant", "content": completion_extend}]) # ,{"role": "user", "content":"continue"}
                    try:
                        completion_extend = get_gpt_response(messages, model=model)
                    except:
                        print('wait...')
                        time.sleep(20)
                        completion_extend = get_gpt_response(messages, model=model)
                    completion+='\n'+completion_extend
                    print(f'continue {i+1} time')
                    if last_action in completion_extend:
                        print('reach end')
                        break
                else:
                    print('reach end')
                # print(f'comp:\n{completion}')

                # # re-write post processing file:
                # file_name=path.split('/')[-1]+'.txt'
                # # print(path)
                # completion = read_files.read_txt_file(os.path.join(pred_raw_path,file_name))

                comp_post = postprocess_completion_whole_domain(completion)
                # comp_post = postprocess_completion(completion)
                # print(f'post_comp:\n{comp_post}')
                file_name=path.split('/')[-1]+'.txt'
                if pred_raw_path:
                  save_output(pred_raw_path,file_name,completion)
                save_output(pred_path,file_name,comp_post)
                print(f'save {file_name}')


main()
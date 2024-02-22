import os
import re
import openai
import build_prompts
import read_files
import time
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
def get_gpt_response(messages, gpt_model=model):
    response = openai.ChatCompletion.create(
    model=gpt_model,
    messages=messages,
    # temperature=1,
    max_tokens=10000 # 32768, # 8192
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
        if not re.findall(r'^(\(:action|:parameters|:precondition|:effect|\?|\(|\))',line.strip()) or 'Note:' in line:
          continue
      if lines[-1].strip() or line.strip():
        lines.append(line)

  lines='\n'.join(lines).strip()
  lines+='\n\n)'
  return lines

def save_output(folder_name, file_name, text):
  parent_dir = '../pddl_evaluation/pred'
  path = os.path.join(parent_dir, folder_name)

  if not os.path.exists(path):
    os.mkdir(path)

  with open(os.path.join(path,file_name), 'w') as f:
    f.write(text)

def main():
  prompt_instruction=build_prompts.read_prompt('prompts.json')[prompt]
  rt_path='../pddl_data'
  pred_path=f'{model}_{prompt}'
  pred_raw_path=f'{model}_{prompt}_raw'
  for path, dirs, files in os.walk(rt_path):
        # print(path,dir,files)
        if 'problem' not in path and path!=rt_path:
            print(path)
            components={}
            for file in files:
                if file=='domain.pddl':
                    components.update(read_files.read_parse_pddl_domain_file(os.path.join(path, file),remove_desc=True)) # ,remove_desc=True
                    last_action = components['action_names'][-1].split(';')[0].strip()
                    components['action_names']='\n'.join(components['action_names'])
                    components['goal']=re.sub(r'(\(define|\(domain|how_to_|\)|_)',' ',components['domain']).strip()
                    # topic_set.add(components['goal'])
                elif file[-4:]==".txt" and "wikihow" in file:
                    components['text'] = read_files.read_wikihow_file(os.path.join(path, file))
                    
            # print(components)

            if components:
                # prompt_instruction=build_prompts.read_prompt('prompts.json')["basic_instruction_no_text"]
                
                # need below if action_step pair:
                action_steps=read_files.read_txt_file(os.path.join(path, 'action_step_map.txt'))
                components['action_text_pairs']=build_prompts.process_action_text_pair(components['text'], action_steps)
                # components['text'] = build_prompts.process_action_text_whole(components['text'], action_steps)
                
                prompt = build_prompts.compose_prompt(prompt_instruction,components)
                # print(f'prompt:\n{prompt}')
                messages = [
                    {"role": "system", "content": "You are a helpful assistant."},
                    {"role": "user", "content": prompt}
                ]
                # try:
                #   completion = get_gpt_response(messages)
                # except:
                #    print('wait...')
                #    time.sleep(20)
                #    completion = get_gpt_response(messages)
                completion = get_gpt_response(messages)
                if not last_action in completion:
                  completion_extend = completion
                  for i in range(7):
                    messages.extend([{"role": "assistant", "content": completion_extend},{"role": "user", "content":"continue"}])
                    completion_extend=get_gpt_response(messages)
                    completion+='\n'+completion_extend
                    print(f'continue {i+1} time')
                    if last_action in completion_extend:
                        print('reach end')
                        break
                    
                comp_post = postprocess_completion(completion)
                # print(f'post_comp:\n{comp_post}')
                file_name=path.split('/')[-1]+'.txt'
                if args.cot:
                  save_output(pred_raw_path,file_name,completion) 
                save_output(pred_path,file_name,comp_post)
                print(f'save {file_name}')


main()   
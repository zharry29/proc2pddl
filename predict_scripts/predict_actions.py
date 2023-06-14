import os
import re
import openai
import build_prompts
import read_files

os.environ["OPENAI_API_KEY"]= ''
openai.api_key = os.getenv("OPENAI_API_KEY")

# setup function
def get_gpt_response(prompt, gpt_model="gpt-4"):
    response = openai.ChatCompletion.create(
    model=gpt_model,
    messages=[
          {"role": "system", "content": "You are a helpful assistant."},
          {"role": "user", "content": prompt}
      ],
    # temperature=1,
    max_tokens=3000 # 32768, # 8192
    # top_p=1,
    # frequency_penalty=0,
    # presence_penalty=0
    )
    return response['choices'][0]['message']['content']

def postprocess_completion(completion):
  lines=[]
  # print(completion.split('\n'))
  for line in completion.split('\n'):
      if line:
        if '(' not in line and ')' not in line or line[0]==';' or line[-1]==':' or (line[-1]=='.' and ';' not in line):
          continue
      lines.append(line)

  lines='\n'.join(lines).strip()
  # lines+='\n\n)'
  return lines

def save_output(folder_name, file_name, text):
  parent_dir = '.'
  path = os.path.join(parent_dir, folder_name)

  if not os.path.exists(path):
    os.mkdir(path)

  with open(os.path.join(path,file_name), 'w') as f:
    f.write(text)
    f.write('\n\n)')

def main():
  # saved=['114756331', '115230790', '114994170', '114905535', '114934221', '114971046', '114394848', '114741230']
  # prompt_instruction=build_prompts.read_prompt('prompts.json')["basic_instruction_action_text_pair"]
  prompt_instruction=build_prompts.read_prompt('prompts.json')["basic_instruction"]
  # prompt_instruction=build_prompts.read_prompt('prompts.json')["basic_instruction_no_text"]
  rt_path='/Users/zhangtianyi/Documents/GitHub/wikihow-to-pddl/pddl_annotation'
  for path, dirs, files in os.walk(rt_path):
        # print(path,dir,files)
        # if 'submission_' in path:
        # if 'problem' not in path and not any([s in path for s in saved]): # and '115237120' in path:
        if 'problem' not in path and '114975402' in path:
            components={}
            for file in files:
                # if file[-5:]==".pddl" and "domain" in file:
                if file=='domain.pddl':
                    components.update(read_files.read_parse_pddl_domain_file(os.path.join(path, file)))
                    components['action_names']='\n'.join(components['action_names'])
                    components['goal']=re.sub(r'(\(define|\(domain|how_to_|\)|_)',' ',components['domain']).strip()
                elif file[-4:]==".txt" and "wikihow" in file:
                    components['text'] = read_files.read_wikihow_file(os.path.join(path, file))
            # print(components)
            if components:
                # prompt_instruction=build_prompts.read_prompt('prompts.json')["basic_instruction_no_text"]
                # action_steps=read_files.read_txt_file(os.path.join(path, 'action_steps.txt'))
                # components['action_text_pairs']=build_prompts.process_step_action(components['text'], action_steps)
                
                prompt = build_prompts.compose_prompt(prompt_instruction,components)
                # print(f'prompt:\n{prompt}')
                completion = get_gpt_response(prompt)
                # print(f'comp:\n{completion}')
                comp_post = postprocess_completion(completion)
                # print(f'post_comp:\n{comp_post}')
                file_name=path.split('/')[-1]+'.txt'
                save_output('basic',file_name,comp_post)
                print(f'save {file_name}')


main()   

# predict_script/basic/114975402.txt
# predict_script/basic/114756331.txt
# 114975402 missing ['<insert_text>'] make_a_detective_kit
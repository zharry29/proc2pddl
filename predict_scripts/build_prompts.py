
import re
import os
import json

def process_step_action(wikihow_text, actions_steps):
  action_text_pairs = []

  wikihow_text=wikihow_text.split('\n\n')
  wiki_step = {re.findall(r'^\d+', step)[0]: step for step in wikihow_text}
  # print(wiki_step)

  actions_steps=actions_steps.split('\n')
  for act_step in actions_steps:
    # print(act_step.split(';'))
    act, step_ids = act_step.split(';')[0].strip(), act_step.split(';')[1].replace(' ', '').split(',')
    step = '\n'.join([wiki_step[s_id] for s_id in step_ids if s_id])
    if step:
      step= '\n'+step
    action_text_pairs.append(f'action name:\n{act}\ntext:{step}')
  
  return '\n\n'.join(action_text_pairs)

def compose_prompt(prompt_structure, components):
  # actions, types, predicates, text, goal, action_text_pairs
  for key in components.keys():
    prompt_structure = prompt_structure.replace(f'<insert_{key}>', components[key])
  if '<insert_' in prompt_structure:
    inserts = re.findall(r'<insert_\w+>',prompt_structure)
    print(f'missing {inserts}')
  return prompt_structure

def write_prompt(file_path, prompt):
  with open(file_path, 'r') as f:
    prompts = json.load(f)
  for key,val in prompt.items():
      if key in prompts.keys():
        print(f'{key} already in prompts, fail to add, please check again')
      else:
        prompts[key]=val
  with open(file_path, 'w') as f:
    json.dump(prompts, f, indent=4)

def read_prompt(file_path):
  # print(os.getcwd())
  with open(file_path, 'r') as f:
    prompts = json.load(f)
    return prompts

basic_instruction_no_text = \
f'''could you fill out the below pddl actions with the predicates? All fields: parameters, precondition and effect, should not be empty.

here are the actions I want:
insert_actions

here are the requirements I have:
insert_requirements

here are the types I have:
insert_types

here are the predicates I have:
insert_predicates'''

prompt_basic_instruction = \
f'''could you fill out the below pddl actions with the predicates based on the text? All fields: parameters, precondition and effect, should not be empty.

here are the actions I want:
insert_actions

here are the requirements I have:
insert_requirements

here are the types I have:
insert_types

here are the predicates I have:
insert_predicates

here are the texts containing steps to insert_goal:
insert_text'''

prompt_basic_instruction_action_text_pair = \
f'''could you fill out the below pddl actions with the predicates based on the text? All fields: parameters, precondition and effect, should not be empty.

here are the action-text pairs I have to insert_goal:
insert_action_text_pairs

here are the requirements I have:
insert_requirements

here are the types I have:
insert_types

here are the predicates I have:
insert_predicates'''

# write_prompt('prompts.json', {'basic_instruction_no_text': basic_instruction_no_text})
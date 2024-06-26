
import re
import os
import json

def process_action_text_pair(wikihow_text, actions_steps):
  action_text_pairs = []

  wikihow_text=wikihow_text.split('\n\n')
  wiki_step = {re.findall(r'^\d+', step)[0]: step for step in wikihow_text}
  # print(wiki_step)

  actions_steps=actions_steps.split('\n')
  for act_step in actions_steps:
    # print(act_step.split(';'))
    act = act_step.split(';')[0].strip()
    if len(act_step.strip().split(';'))>1:
      step_ids = act_step.split(';')[1].replace(' ', '').split(',')
      step = '\n'+'\n'.join([wiki_step[s_id] for s_id in step_ids if s_id.isdigit()])
    else:
      step=''
    # action_text_pairs.append(f'action name:\n{act}\ntext:{step}')
    action_text_pairs.append(f'{act}\n{step}\n------')
  
  return '\n\n'.join(action_text_pairs)

def process_action_text_whole(wikihow_text, actions_steps):
  step_ids = set()

  wikihow_text=wikihow_text.split('\n\n')
  wiki_step = {re.findall(r'^\d+', step)[0]: step for step in wikihow_text}
  # print(wiki_step)

  actions_steps=actions_steps.split('\n')
  for act_step in actions_steps:
    # print(act_step.split(';'))
    act = act_step.split(';')[0].strip()
    if len(act_step.strip().split(';'))>1:
      for step_id in act_step.split(';')[1].replace(' ', '').split(','):
        step_ids.add(step_id)
  
  return '\n\n'.join([v for k,v in wiki_step.items() if k in step_ids])

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
        # print(f'{key} already in prompts, fail to add, please check again')
        prompts[key]=val
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
f'''could you fill out ALL the pddl actions orderly with the predicates based on the text?
All fields: parameters, precondition and effect, should have predicates.
For each action, do NOT change the name and do NOT drop the action and do NOT add more actions.
The output should be in correct pddl format.

here are the actions I want to <insert_goal>:
<insert_action_names>

here are the requirements I have:
<insert_requirements>

here are the types I have:
<insert_types>

here are the predicates I have:
<insert_predicates>'''

basic_instruction_action_text_pair = \
f'''could you fill out ALL the pddl actions orderly with the predicates based on the text?
All fields: parameters, precondition and effect, should have predicates.
For each action, do NOT change the name and do NOT drop the action and do NOT add more actions.
The output should be in correct pddl format.

here are the actions I want to <insert_goal>:
<insert_action_text_pairs>

here are the requirements I have:
<insert_requirements>

here are the types I have:
<insert_types>

here are the predicates I have:
<insert_predicates>'''

instruction_action_text_pair_CoT = \
f'''could you fill out the below pddl actions with the predicates based on the text? All fields: parameters, precondition and effect, should not be empty.
First, list the entities involved in the action
Then, tell its states before and after the action
Last, translate it into pddl format

here are the action-text pairs I have to <in-sert_goal>:
<insert_action_step_pairs>

here are the requirements I have:
<insert_requirements>

here are the types I have:
<insert_types>

here are the predicates I have:
<insert_predicates>'''

instruction_action_text_pair_CoT_1 = \
f'''could you fill out the below pddl actions with the predicates based on the text?
All fields: parameters, precondition and effect, should have predicates.
For each action, do NOT change the name and do NOT drop the action and do NOT add more actions and:
First, summarize the action in a few sentences based on the text and provide its requirements and its aims if it has.
Next, identify ALL the entities involved in the action and describe whether it changed, unchanged, added, removed in the action in natural language.
Last, translate it into pddl format. Check all the related entities are in the 'parameters'.

Please use this output format:
- action name: ...
- summarize action: ...
- what is needed to do the action: ...
- what is the result: ...

- entities:
  - entity name: ... 
  - before: ... 
  - after: ...
  ...

- convert the above information to pddl using relevant predicates step by step:
1. ...
2. ...
3. ...

pddl:

here are the action-text pairs I have to <insert_goal>:
<insert_action_text_pairs>

here are the requirements I have:
<insert_requirements>

here are the types I have:
<insert_types>

here are the predicates I have:
<insert_predicates>'''

instruction_text_CoT = \
f'''could you fill out ALL the pddl actions with the predicates based on the text?
All fields: parameters, precondition and effect, should have predicates.
For each action, do NOT change the name and do NOT drop the action and do NOT add more actions and:
First, summarize the action in a few sentences based on the text and provide its requirements and its aims if it has.
Next, identify ALL the entities involved in the action and describe whether it changed, unchanged, added, removed in the action in natural language.
Last, translate it into pddl format. Check all the related entities are in the 'parameters'.

Please use this output format:
- action name: ...
- summarize action: ...
- what is needed to do the action: ...
- what is the result: ...

- entities:
  - entity name: ... 
  - before: ... 
  - after: ...
  ...

- describe how to match it to pddl relevant predicates step by step:
1. ...
2. ...

pddl:

here are the actions I want:
<insert_action_names>

here are the requirements I have:
<insert_requirements>

here are the types I have:
<insert_types>

here are the predicates I have:
<insert_predicates>

here are the texts containing steps to <insert_goal>:
<insert_text>'''

instruction_no_text_CoT = \
f'''could you fill out ALL the pddl actions orderly with the predicates based on the text?
All fields: parameters, precondition and effect, should have predicates.
For each action, do NOT change the name and do NOT drop the action and do NOT add more actions and:
First, summarize the action in a few sentences based on the text and provide its requirements and its aims if it has.
Next, identify ALL the entities involved in the action and describe whether it changed, unchanged, added, removed in the action in natural language.
Last, translate it into pddl format. Check all the related entities are in the 'parameters'.

Please use this output format:
- action name: ...
- summarize action: ...
- what is needed to do the action: ...
- what is the result: ...

- entities:
  - entity name: ... 
  - before: ... 
  - after: ...
  ...

- describe how to match it to pddl relevant predicates step by step:
1. ...
2. ...

pddl:

here are the actions I want for <insert_goal>:
<insert_action_names>

here are the requirements I have:
<insert_requirements>

here are the types I have:
<insert_types>

here are the predicates I have:
<insert_predicates>'''

basic_instruction_CoT_simple = \
f'''could you fill out ALL the pddl actions orderly with the predicates based on the text?
All fields: parameters, precondition and effect, should have predicates.
For each action, do NOT change the name and do NOT drop the action and do NOT add more actions.

Please tell how to create the pddl action step by step.

here are the actions I want:
<insert_action_names>

here are the requirements I have:
<insert_requirements>

here are the types I have:
<insert_types>

here are the predicates I have:
<insert_predicates>

here are the texts containing steps to <insert_goal>:
<insert_text>'''

instruction_no_text_CoT_simple = \
f'''could you fill out ALL the pddl actions orderly with the predicates based on the text?
All fields: parameters, precondition and effect, should have predicates.
For each action, do NOT change the name and do NOT drop the action and do NOT add more actions.
Please tell how to create the pddl action step by step and create it in correct pddl format.

here are the actions I want for <insert_goal>:
<insert_action_names>

here are the requirements I have:
<insert_requirements>

here are the types I have:
<insert_types>

here are the predicates I have:
<insert_predicates>'''

basic_instruction = \
f'''could you fill out ALL the pddl actions orderly with the predicates based on the text?
All fields: parameters, precondition and effect, should have predicates.
For each action, do NOT change the name and do NOT drop the action and do NOT add more actions.

here are the actions I want:
<insert_action_names>

here are the requirements I have:
<insert_requirements>

here are the types I have:
<insert_types>

here are the predicates I have:
<insert_predicates>

here are the texts containing steps to <insert_goal>:
<insert_text>'''


'''
Please be aware of the coherence of precondition and effect between actions.
- convert the above information to pddl using relevant predicates step by step:
  1. add to parameters ...
  2. precondition ...
  3. effect ...'''

# write_prompt('prompts.json', {'basic_instruction_no_text': basic_instruction_no_text})
# write_prompt('prompts.json', {'instruction_action_text_pair_CoT_1': instruction_action_text_pair_CoT_1})
write_prompt('prompts.json', {'basic_instruction_no_text': basic_instruction_no_text})
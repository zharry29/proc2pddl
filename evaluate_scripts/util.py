import openai
import jsonlines
import json
import time
import os
from datetime import datetime
import pandas as pd


# from baseline import *
from env import api_key_fp

def captialize_each_word(input):
    try:
        return ' '.join(word[0].upper() + word[1:] for word in input.strip().split(' '))
    except:
        return input

# def make_prompt(category, name, notes, contexts=[], max_contexts=5):
#     prompt =  "{category}: {name}\nTags: {notes}\n".format(category=get_singular(category), name=captialize_each_word(name), notes=notes)
#     if max_contexts > 0:
#         prompt = "\n\n".join(contexts[-max_contexts:])  + "\n\n" + prompt
#     prompt += "Scene: "
#     return prompt

# def generate_description(category, name, notes, contexts=[], max_contexts=5, finetuned_model="davinci:ft-ccb-lab-members-2022-03-05-17-10-05", wait_time=1):
#     response = openai.Completion.create(
#         model=finetuned_model,
#         prompt=make_prompt(category, name, notes, contexts, max_contexts),
#         temperature=0.7,
#         max_tokens=250,
#         top_p=1,
#         frequency_penalty=0,
#         presence_penalty=0,
#         stop=["###", "\n"]
#     )
#     time.sleep(wait_time)
#     description = response['choices'][0]['text'].strip()
#     return description


# def predict_category(name, finetuned_model='curie:ft-ccb-lab-members-2022-04-07-02-16-46', wait_time=1):
#     response = openai.Completion.create(
#         model=finetuned_model,
#         prompt="name: " + name + "\ncategory: ",
#         temperature=0.7,
#         max_tokens=25,
#         top_p=1,
#         frequency_penalty=0,
#         presence_penalty=0,
#         stop=["###", "\n"]
#     )
#     time.sleep(wait_time)
#     return response['choices'][0]['text'].strip()

def load_txt_prompt(filename):
    """
    Load a prompt from local txt file
    """
    prompt = ''.join(open(filename, 'r').readlines())
    return prompt

def load_json(filename):
    """
    Load a JSON file given a filename
    If the file doesn't exist, then return an empty dictionary instead
    """
    try:
        with open(filename, 'r') as f:
            return json.load(f)
    except FileNotFoundError:
        return {}

def write_json(data, filepath):
    assert isinstance(data, dict), '[ERROR] Expect dictionary data!'
    json_string = json.dumps(data, indent = 4)
    with open(filepath, 'w') as outfile:
        outfile.write(json_string)
    # return 0

def load_jsonl(filename):
    file_content = []
    try:
        with jsonlines.open(filename) as reader:
            for obj in reader:
                file_content.append(obj)
            return file_content
    except FileNotFoundError:
        return []

def write_jsonl(data, filepath):
    with open(filepath, 'w') as jsonl_file:
        for line in data:
            jsonl_file.write(json.dumps(line))
            jsonl_file.write('\n')

def load_all_data(data_dir, data = ['proscript'], format = 'jsonl'):
    all_data = {}
    if format == 'jsonl':
        for d in data:
            all_data[d] = {}
            for file in os.listdir(data_dir + d):
                if 'jsonl' in file:
                    dataset = file.replace('.jsonl', '')
                    all_data[d][dataset] = load_jsonl(data_dir + d + '/' + file)
    else:
        print('[ERROR] File format not supported!')
    return all_data
        
def universal_gpt_call(prompt, config = {}):
    # api_key
    if 'api_key' in config:
        api_key = config['api_key']
    else:
        # pass
        api_key = load_json(api_key_fp)['ccb_group']
    # print(api_key)
    openai.api_key = api_key
    os.environ['OPENAI_API_KEY'] = api_key

    # set parameters
    temperature = config['temperature'] if 'temperature' in config else 0.75
    max_tokens = config['max_tokens'] if 'max_tokens' in config else 250
    stop_tokens = config['stop_tokens'] if 'stop_tokens' in config else ['###'] 
    frequency_penalty = config['frequency_penalty'] if 'frequency_penalty' in config else 0
    presence_penalty = config['presence_penalty'] if 'presence_penalty' in config else 0
    wait_time = config['wait_time'] # if 'wait_time' in config else 0
    model = config['model'] if 'model' in config else 'curie'
    return_logprobs = config['return_logprobs'] if 'return_logprobs' in config else False
    logprobs = 1 if return_logprobs else None

    # wait for codex model
    # if 'code' in model:
    #     max_sleep_gap = 12
    #     with open('../log/codex.log', 'r') as codex_log:
    #         lines = [line for line in codex_log.readlines()]
    #         last_gap = (datetime.now() - pd.to_datetime(lines[-1].strip())).seconds
    #         sleep_time = max_sleep_gap - last_gap
    #         if sleep_time > 0:
    #             sleep_time = int(sleep_time) + 1
    #             print('[Utils.universal_gpt_call()] Sleep for {}s...'.format(sleep_time))
    #             time.sleep(sleep_time)
    #     with open('../log/codex.log', 'a') as codex_log:
    #         codex_log.write(str(datetime.now()) + '\n')
    
    # call openai

    while True:
        try:
            response = openai.Completion.create(
                model=model,
                prompt=prompt,
                temperature=temperature,
                max_tokens=max_tokens,
                top_p=1,
                frequency_penalty=frequency_penalty,
                presence_penalty=presence_penalty,
                logprobs=logprobs,
                stop=stop_tokens
            )
            time.sleep(wait_time)
            break
        except:
            print('[Utils.universal_gpt_call()] Rate limit error. Sleep for 20s...')
            time.sleep(wait_time)
            continue

    completion = response['choices'][0]['text'].strip()
    if not return_logprobs:
        return completion
    
    # get log-prabability
    token_logprobs = list(zip(
        response["choices"][0]["logprobs"]['tokens'], 
        response["choices"][0]["logprobs"]['token_logprobs']
    ))
    return completion, token_logprobs

def get_current_timestamp():
    return str(datetime.now()).split('.')[0].replace('-', '').replace(':', '').replace(' ', '_')[4:]
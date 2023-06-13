import sys
sys.path.insert(1, '../src/')
sys.path.insert(1, '../src/pddl-parser')
from pddl_parser.action import action_equal
import pickle
import os
import numpy as np
import re
from pathlib import Path
import collections

import argparse
parser = argparse.ArgumentParser()
parser.add_argument('--model', type=str, default='gpt4')
parser.add_argument('--prompt', type=str, default='')
parser.add_argument('--id', type=str, default='')
args = parser.parse_args()

prompt_str = "_" + args.prompt if args.prompt != "" else ""
gold_dir = f'../data/evaluation/actions_generation/pred/gold/'
pred_dir = f'../data/evaluation/actions_generation/pred/{args.model}{prompt_str}/'

def compare_actions(pred_actions, gold_actions):
    assert(len(pred_actions) == len(gold_actions))
    correct = []
    for pred_action, gold_action in zip(pred_actions, gold_actions):
        correct.append(action_equal(pred_action, gold_action))
    print(correct)
    return sum(correct) / len(correct)
            

with open(os.path.join(pred_dir, f"{args.id}_actions.pkl"), 'rb') as f:
    pred_actions = pickle.load(f)
with open(os.path.join(gold_dir, f"{args.id}_actions.pkl"), 'rb') as f:
    gold_actions = pickle.load(f)
accuracy = compare_actions(pred_actions, gold_actions)
print(accuracy)
#print(f"Precision: {precision}, Recall: {recall}, F1: {f1}")
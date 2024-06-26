import sys

sys.path.insert(1, "../src/")
sys.path.insert(1, "../src/pddl-parser")
from pddl_parser.action import action_equal
from pddl_parser.action import action_dist
import pickle
import os
import numpy as np
import re
from pathlib import Path
import collections

import argparse

parser = argparse.ArgumentParser()
parser.add_argument('--model', type=str, default="gpt4", help="gpt model name")
parser.add_argument('--prompt', type=str, default="whole", help="the type of prompt to use")
parser.add_argument('--cot', action="store_true", help="whether to use cot prompt")
parser.add_argument("--id", type=str, default="")
args = parser.parse_args()

model = args.model
prompt = args.prompt
if args.cot:
    prompt += "_CoT"
folder_name = f"{model}_{prompt}"

gold_dir = '../pddl_evaluation/true/'
pred_dir = f'../pddl_evaluation/pred/{folder_name}/'


def compare_actions(pred_actions, gold_actions):
    # assert len(pred_actions) == len(gold_actions)
    correct = []
    for i, gold_action in enumerate(gold_actions):
        try:
            pred_action = pred_actions[i]
        except IndexError:
            correct.append(False)
            continue
        correct.append(action_equal(pred_action, gold_action))
        print(action_equal(pred_action, gold_action))
    # print(correct)
    return correct

def calculate_edit_distance(pred_actions, gold_actions):
    r_correct = []
    c_correct = []
    e_correct = []
    for i, gold_action in enumerate(gold_actions):
        try:
            pred_action = pred_actions[i]
        except IndexError:
            r_correct.append(False)
            c_correct.append(False)
            e_correct.append(False)
            continue
        r_dist, c_dist, e_dist = action_dist(pred_action, gold_action)
        if r_dist < 0.01:
            r_correct.append(True)
        else:
            r_correct.append(False)
        if c_dist < 0.01:
            c_correct.append(True)
        else:
            c_correct.append(False)
        if e_dist < 0.01:
            e_correct.append(True)
        else:
            e_correct.append(False)
    return r_correct, c_correct, e_correct

all_r_correct = []
all_c_correct = []
all_e_correct = []
all_outcome = []
num_actions_in_gold_df = []
for fname in os.listdir(pred_dir):
    if fname.startswith(args.id) and fname.endswith("_actions.pkl"):
        print(fname)
        with open(os.path.join(pred_dir, fname), "rb") as f:
            pred_actions = pickle.load(f)
            if pred_actions is None:
                pred_actions = []
        with open(os.path.join(gold_dir, fname), "rb") as f:
            gold_actions = pickle.load(f)
            num_actions_in_gold_df.append(len(gold_actions))
        # print(pred_actions)
        # print(gold_actions)
        outcome = compare_actions(pred_actions, gold_actions)
        all_outcome += outcome
        r_correct, c_correct, e_correct = calculate_edit_distance(pred_actions, gold_actions)
        all_r_correct += r_correct
        all_c_correct += c_correct
        all_e_correct += e_correct
accuracy = sum(all_outcome) / len(all_outcome)
r_accuracy = sum(all_r_correct) / len(all_r_correct)
c_accuracy = sum(all_c_correct) / len(all_c_correct)
e_accuracy = sum(all_e_correct) / len(all_e_correct)

print(f"Action Accuracy: {accuracy}")
print(f"Parameter Accuracy: {r_accuracy}")
print(f"Precondition Accuracy: {c_accuracy}")
print(f"Effect Accuracy: {e_accuracy}")
#print(f"Average number of actions in gold: {np.mean(num_actions_in_gold_df)}")
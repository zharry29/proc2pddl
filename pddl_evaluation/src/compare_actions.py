import sys

sys.path.insert(1, "../src/")
sys.path.insert(1, "../src/pddl-parser")
from pddl_parser.action import action_equal
import pickle
import os
import numpy as np
import re
from pathlib import Path
import collections

import argparse

parser = argparse.ArgumentParser()
parser.add_argument("--model", type=str, default="gpt4")
parser.add_argument("--prompt", type=str, default="")
parser.add_argument("--id", type=str, default="")
args = parser.parse_args()

prompt_str = "_" + args.prompt if args.prompt != "" else ""
gold_dir = f"../data/evaluation/actions_generation/pred/gold/"
pred_dir = f"../data/evaluation/actions_generation/pred/{args.model}{prompt_str}/"
print(pred_dir)


def compare_actions(pred_actions, gold_actions):
    #assert len(pred_actions) == len(gold_actions)
    correct = []
    for i, gold_action in enumerate(gold_actions):
        try:
            pred_action = pred_actions[i]
        except IndexError:
            correct.append(False)
            continue
        correct.append(action_equal(pred_action, gold_action))
    #print(correct)
    return correct

all_outcome = []
for fname in os.listdir(pred_dir):
    if fname.startswith(args.id) and fname.endswith("_actions.pkl"):
        print(fname)
        with open(os.path.join(pred_dir, fname), "rb") as f:
            pred_actions = pickle.load(f)
            if pred_actions is None:
                 pred_actions = []
        with open(os.path.join(gold_dir, fname), "rb") as f:
            gold_actions = pickle.load(f)
        #print(pred_actions)
        #print(gold_actions)
        outcome = compare_actions(pred_actions, gold_actions)
        all_outcome += outcome
accuracy = sum(all_outcome) / len(all_outcome)
print(accuracy)
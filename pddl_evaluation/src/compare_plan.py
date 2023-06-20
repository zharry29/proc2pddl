import sys
sys.path.insert(1, '../src/')
sys.path.insert(1, '../src/pddl-parser')
from pddl_parser.action import *
import json
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
gold_dir = '../data/evaluation/plan/gold/'
pred_dir = f'../data/evaluation/plan/{args.model}{prompt_str}/'

def parse_action(action_str):
    # get ('npc', 'shell', 'garage')
    action_name = action_str.split(" ('")[0]
    #print(action_str)
    arguments = action_str.split(" ('")[1].split("')")[0].split("', '")
    return action_name, arguments

def action_instance_comp(action_instance1, action_instance2):
    return action_instance1[0] == action_instance2[0] and collections.Counter(action_instance1[1]) == collections.Counter(action_instance2[1])

def compare_actions_f1(pred_actions, gold_actions):
    pred_actions = [parse_action(action) for action in pred_actions if action != ""]
    gold_actions = [parse_action(action) for action in gold_actions if action != ""]
    correct_pred, correct_gold = 0, 0
    all_pred, all_gold = len(pred_actions), len(gold_actions)
    for pred_action in pred_actions:
        for gold_action in gold_actions:
            if action_instance_comp(pred_action, gold_action):
                correct_pred += 1
                break
    for gold_action in gold_actions:
        for pred_action in pred_actions:
            if action_instance_comp(pred_action, gold_action):
                correct_gold += 1
                break
    precision = correct_pred / all_pred
    recall = correct_gold / all_gold
    f1 = 2 * precision * recall / (precision + recall)
    return precision, recall, f1

def compare_actions_em(pred_actions, gold_actions):
    #print(pred_actions)
    pred_actions = [parse_action(action) for action in pred_actions if action != ""]
    gold_actions = [parse_action(action) for action in gold_actions if action != ""]
    for pred_action,gold_action in zip(pred_actions, gold_actions):
        if not action_instance_comp(pred_action, gold_action):
            return False
    return True

has_solution = []
exact_match = []
for problem_fname in os.listdir(pred_dir):
    #print(problem_fname)
    #for proc_id in  ["114406878"]:
    if not problem_fname.startswith(args.id):
        continue
    with open(os.path.join(pred_dir, problem_fname), 'r') as f:
        pred_action_str = f.read()
    with open(os.path.join(gold_dir, problem_fname), 'r') as f:
        gold_action_str = f.read()
    #print(pred_action_str)
    if "No solution" in gold_action_str or gold_action_str.startswith("Error: "):
        continue
    if "No solution" in pred_action_str:
        #print("No solution")
        has_solution.append(0)
        pred_action_str = ""
    elif pred_action_str.startswith("Error: "):
        #print("Error")
        has_solution.append(0)
        pred_action_str = ""
    else:
        has_solution.append(1)
    if pred_action_str == "":
        exact_match.append(0)
    else:
        pred_actions = pred_action_str.split("\n")
        gold_actions = gold_action_str.split("\n")
        #precision, recall, f1 = compare_actions(pred_actions, gold_actions)
        #print(f"Precision: {precision}, Recall: {recall}, F1: {f1}")
        #print(pred_actions)
        if compare_actions_em(pred_actions, gold_actions):
            exact_match.append(1)
        else:
            exact_match.append(0)

#print(has_solution)
#print(exact_match)
#print(sum(has_solution) / len(has_solution))
#print(sum(exact_match) / len(exact_match))
print(sum(exact_match))
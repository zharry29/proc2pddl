import sys
sys.path.insert(1, '../src/')
sys.path.insert(1, '../src/pddl-parser')
from pddl_parser.PDDL import PDDL_Parser
import json
import os
import numpy as np
import re

import argparse
parser = argparse.ArgumentParser()
parser.add_argument('--model', type=str, default='gpt4')
parser.add_argument('--prompt', type=str, default='basic_instructions')
args = parser.parse_args()

class Planner:

    # -----------------------------------------------
    # Solve
    # -----------------------------------------------

    def solve(self, parser):
        # Parser
        # parser = PDDL_Parser()
        # parser.parse_domain(domain)
        # parser.parse_problem(problem)
        # Parsed data
        state = parser.state
        goal_pos = parser.positive_goals
        goal_not = parser.negative_goals
        # Do nothing
        if self.applicable(state, goal_pos, goal_not):
            return []
        # Grounding process
        ground_actions = []
        for action in parser.actions:
            for act in action.groundify(parser.objects, parser.types):
                ground_actions.append(act)
        # Search
        visited = set([state])
        fringe = [state, None]
        while fringe:
            state = fringe.pop(0)
            plan = fringe.pop(0)
            for act in ground_actions:
                if self.applicable(state, act.positive_preconditions, act.negative_preconditions):
                    new_state = self.apply(state, act.add_effects, act.del_effects)
                    if new_state not in visited:
                        if self.applicable(new_state, goal_pos, goal_not):
                            full_plan = [act]
                            while plan:
                                act, plan = plan
                                full_plan.insert(0, act)
                            return full_plan
                        visited.add(new_state)
                        fringe.append(new_state)
                        fringe.append((act, plan))
        return None

    # -----------------------------------------------
    # Applicable
    # -----------------------------------------------

    def applicable(self, state, positive, negative):
        return positive.issubset(state) and negative.isdisjoint(state)

    # -----------------------------------------------
    # Apply
    # -----------------------------------------------

    def apply(self, state, positive, negative):
        return state.difference(negative).union(positive)
    
true_dir = '../data/evaluation/actions_generation/true/'
pred_dir = f'../data/evaluation/actions_generation/pred/{args.model}/{args.prompt}/'
cache_dir = '../data/evaluation/cache/'

class Tester:
    def __init__(self, cache_dir = '../data/evaluation/cache/'):
        self.cache_dir = cache_dir
    
    def check_action_list(self, true_dir, test_case, output_actions):
        ground_truth_actions = ''.join(open('{true_dir}{test_case}/actions.txt'.format(
                                    true_dir = true_dir,
                                    test_case = test_case
                                )).readlines())
        all_action_texts = [
            ac[:-1].replace(':action', '').strip()
            for ac in re.findall(':action\s+.+;', ground_truth_actions)
        ]
        found = 0
        for ac in all_action_texts:
            if re.search(':action\s+{}'.format(ac), output_actions):
                found += 1
        return found, len(all_action_texts)

    def eval_summary_stat(self, case_results_raw):
        summary = {}

        summary['intrinsic'] = {
            'pass': 0,
            'parsing_error': 0,
            'action_incomplete': 0
        }   
        for output_action_file in case_results_raw:
            summary['intrinsic'][case_results_raw[output_action_file]['intrinsic']] += 1

        summary['extrinsic'] = {}
        for output_action_file in case_results_raw:
            if case_results_raw[output_action_file]['extrinsic'] is None:
                continue
            
            for problem in case_results_raw[output_action_file]['extrinsic']:
                if problem not in summary['extrinsic']:
                    summary['extrinsic'][problem] = {'solved': 0, 'unsolved': 0}
                if case_results_raw[output_action_file]['extrinsic'][problem] == 'solved':
                    summary['extrinsic'][problem]['solved'] += 1
                else:
                    summary['extrinsic'][problem]['unsolved'] += 1
        
        for problem in summary['extrinsic']:
            summary['extrinsic'][problem]['succ_rate'] = summary['extrinsic'][problem]['solved'] / sum(summary['extrinsic'][problem].values())

        return summary

    def eval_action_generation(self, true_dir, pred_dir):
        self.true_dir = true_dir
        self.pred_dir = pred_dir
        #self.meta_data = json.load(open(pred_dir + 'meta_data.json'))
        
        eval_results = {}
        #for output_action_file in self.meta_data[test_case]:
        case_results_raw = {}
        for proc_id in range(1):
            proc_id += 1

            domain_header_fp = '{true_dir}/{test_case}/domain_header.pddl'.format(
                true_dir = true_dir,
                test_case = proc_id
            )
            domain_header = ''.join(open(domain_header_fp).readlines())
            output_action_file = f"gpt4_p1_{proc_id}.txt"
            case_results_raw[output_action_file] = {
                'intrinsic': 'pass',
                'extrinsic': None
            }
            # 0. getting the domain file
            output_actions = ''.join(open('{pred_dir}/{action_file}'.format(
                pred_dir = pred_dir,
                action_file = output_action_file
            )).readlines())
            pred_domain = domain_header + output_actions
            
            # 1. Intrinsic check domain file
            tmp_domain_file = cache_dir + 'tmp_action_generation.pddl'
            with open(cache_dir + 'tmp_action_generation.pddl', 'w') as file:
                file.write(pred_domain)
            # 1.1 check if parse-able
            parser = PDDL_Parser()
            intrinsic_done = False
            try:
                parser.parse_domain(tmp_domain_file)
            except:
                case_results_raw[output_action_file]['intrinsic'] = 'parsing_error'
                #continue
                intrinsic_done = True
            # 1.2 check if actions are all found
            if not intrinsic_done:
                action_found, action_total = self.check_action_list(true_dir, proc_id, output_actions)
                if action_total > action_found:
                    case_results_raw[output_action_file]['intrinsic'] = 'action_incomplete'
                    #continue
            # 2. Extrinsic evaluations
            case_results_raw[output_action_file]['extrinsic'] = {}
            problem_dir = '{true_dir}/{test_case}/problems/'.format(
                true_dir = true_dir,
                test_case = proc_id
            )
            for problem in os.listdir(problem_dir):
                if '.pddl' not in problem:
                    continue
                problem_file = '{true_dir}/{test_case}/problems/{problem}'.format(
                    true_dir = true_dir,
                    test_case = proc_id,
                    problem = problem
                )

                plan = self.eval_unit_action_generation(tmp_domain_file, problem_file)
                if plan:
                        case_results_raw[output_action_file]['extrinsic'][problem] = 'solved'
                else:
                    case_results_raw[output_action_file]['extrinsic'][problem] = 'unsolved'
            
            #summary = self.eval_summary_stat(case_results_raw)
            #eval_results[proc_id] = {
            #    'summary': summary,
            #    'raw': case_results_raw
            #}
            
        return case_results_raw


    def eval_unit_action_generation(self, domain_file, problem_file):
        parser = PDDL_Parser()
        parser.parse_domain(domain_file)
        parser.parse_problem(problem_file)
        planner = Planner()
        plan = planner.solve(parser)
        return plan
        
T = Tester(cache_dir)

eval_results = T.eval_action_generation(true_dir, pred_dir)#['1']
print(eval_results)
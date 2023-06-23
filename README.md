# wikihow-to-PDDL
 The project of translating wikiHow procedures to PDDL using language models.

## Dataset
The raw Proc2PDDL dataset can be found at `pddl_data/`, while the cleaned one can be found at`/pddl_annotation`.

## Predict Actions
Code for runninng prediction is in `predict_scripts/`

First, in `predict_actions.py`, specify the prompt (**prompt_instruction**) you want to use, see options in `prompts.json`, the prediction output dir (**pred_path**, **pred_raw_path**)

Then running
> python predict_actions.py

## Evaluation
In `pddl_evaluation/`, we assume that the model predictions are already in `data/evaluation/actions_generation/pred/`, named as `[MODEL]_[PROMPT]`. 

From `src/`, first, running
> python evaluate.py --model MODEL --prompt PROMPT

attempts to solve each PF with the generated DF. In the process, two files are created:
- In `data/evaluation/plan/`, the predicted plan, if any, is stored
- In `data/evaluation/actions_generation/pred/`, the action objects are stored as pickle

Next, running
> python compare_plan.py --model MODEL --prompt PROMPT

prints to stdout the number of predicted plans that exactly match the gold plan.

> python compare_actions.py --model MODEL --prompt PROMPT

prints to stdout the accuracy of actions, parameters, preconditions, and effects.

# Proc2PDDL
**Proc2PDDL** is a dataset of paired open-domain procedural texts and PDDL representations. 

## Dataset
The cleaned and processed Proc2PDDL dataset can be found at `/pddl_data`. Though likely not to be used, the raw dataset produced by the annotators can be found at `pddl_data_raw/`.

In `/pddl_data`, there are 27 folders named by the domain ID each containing:
- a procedural article from wikihow (`wikihow-*.txt`) containing some steps
- an annotated domain file (`domain.pddl`)
- the header, including types and predicates but excluding the names of actions, of the above domain file (`domain_header.pddl`)
- the name and description of actions of the above domain file (`actions.txt`)
- an annotated mapping between each action and a step from the procedural article (`action_step_map.txt`), only used in certain settings
- a folder of annotated problem files (`problem-*.pddl`)

## The Action Modeling Task
While the above dataset can enable many possible tasks, we exemplify the task of action modeling, where:
- the input is the domain file header (types, predicates, and names of actions)
- the output is the definitions of actions (parameters, preconditions, and effects)

### Prediction
Code for runninng model prediction with OpenAI API is in `predict_scripts/`.

Then run:
> python predict_actions.py --model MODEL --prompt PROMPT [--cot]
where
- `MODEL` is either gpt3.5 (`gpt-3.5-turbo-16k`) or gpt4 (`gpt-4-32k`)
- `PROMPT` is defaulted to `whole`, meaning using all the text from the procedural article, but can also be set to `pair` including only relevant paired steps and the actions, or `no_text` including no text at all as an ablation
- `--cot` can be specified to use chain-of-thought prompting

The output is at `pddl_evaluation/pred/MODEL_PROMPT_[COT]/DOMAIN_ID.txt`, eachc containing the definitions of actions (parameters, preconditions, and effects).

### Evaluation
Code for evaluating model prediction is in `predict_scripts/`.

Then run
> python evaluate.py --model MODEL --prompt PROMPT [--cot]

The arguments are the same as before. This attempts to solve each problem with the generated domain file. In the process, two files are created:
- In `pddl_evaluation/plan/`, the predicted plan, if any, is stored
- In `pddl_evaluation/pred/`, the action objects are stored as pickle

Next, running
> python compare_plan.py --model MODEL --prompt PROMPT

prints to stdout the number of predicted plans that exactly match the gold plan.

> python compare_actions.py --model MODEL --prompt PROMPT

prints to stdout the accuracy of actions, parameters, preconditions, and effects.

## Citation
If you use our work, please cite (TODO)
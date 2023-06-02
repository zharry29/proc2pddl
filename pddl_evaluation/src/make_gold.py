import os
from pathlib import Path

def get_domain_header(domain):
    return domain.split("(:action")[0].strip()

for folder_name in os.listdir("../../pddl_data"):
    # Copy domain files
    with open(f"../../pddl_data/{folder_name}/domain.pddl", "r") as f:
        domain = f.read()
    stripped_folder_name = folder_name.strip("submission_")
    Path(f"../data/evaluation/actions_generation/true/{stripped_folder_name}").mkdir(parents=True, exist_ok=True)
    with open(f"../data/evaluation/actions_generation/true/{stripped_folder_name}/domain.pddl", "w") as f:
        f.write(domain)
    with open(f"../data/evaluation/actions_generation/true/{stripped_folder_name}/domain_header.pddl", "w") as f:
        f.write(get_domain_header(domain))
    # Copy problem files
    Path(f"../data/evaluation/actions_generation/true/{stripped_folder_name}/problems").mkdir(parents=True, exist_ok=True)
    for fname in os.listdir(f"../../pddl_data/{folder_name}"):
        if fname.startswith("problem-"):
            with open(f"../../pddl_data/{folder_name}/{fname}", "r") as f:
                problem = f.read()
            with open(f"../data/evaluation/actions_generation/true/{stripped_folder_name}/problems/{fname}", "w") as f:
                f.write(problem)
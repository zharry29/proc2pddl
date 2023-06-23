from pddl_parser import PDDL_Component_Parser

def read_wikihow_file(file_path):
  with open(file_path,'r') as f:
    wiki_article=f.read()
  return wiki_article.strip()

def read_txt_file(file_path):
  with open(file_path,'r') as f:
    data=f.read()
  return data.strip()

def read_parse_pddl_domain_file(file_path, remove_desc=False):
  pddl_component_parser=PDDL_Component_Parser()
  pddl_component_parser.parse_components(file_path,remove_desc)
  # print(pddl_component_parser.actions)
  # print(pddl_component_parser.action_names)
  # print(pddl_component_parser.domain)
  # print(pddl_component_parser.types)
  # print(pddl_component_parser.requirements)
  return {'domain': pddl_component_parser.domain,'requirements': pddl_component_parser.requirements,
          'types': pddl_component_parser.types, 'predicates': pddl_component_parser.predicates,
          'action_names': pddl_component_parser.action_names}

# read_parse_pddl_domain_file('../pddl_data/submission_113996609/domain.pddl')
import os
import re
import read_files

rt_path = '../pddl_data'
pred_path = 'gold_actions'

def save_output(folder_name, file_name, text):
  parent_dir = '.'
  path = os.path.join(parent_dir, folder_name)

  if not os.path.exists(path):
    os.mkdir(path)

  with open(os.path.join(path,file_name), 'w') as f:
    f.write(text)

def postprocess_completion_whole_domain(completion):
  lines=['']
  for line in completion.split('\n'):
      if line:
        line = line.replace('```','')
        # remove (To be continued upon request)
        if not re.findall(r'^(\(:action|:parameters|:precondition|:effect|\?|\(|\))',line.strip()) or \
               any([t in line for t in ['Note', 'actions']]):
          continue
      if lines[-1].strip() or line.strip():
        lines.append(line)
  lines='\n'.join(lines).strip()
  s_idx = re.search(r' *\(:action', lines, ).start() #, flags=re.MULTILINE
  lines = lines[s_idx:]
  if s_idx==0: # start with action
      lines += '\n\n)'
  return lines

def process_gold():
    for path, dirs, files in os.walk(rt_path):
        # print(path,dir,files)
        if 'problem' not in path and path != rt_path and not '113996609' in path:
            # all([id not in path for id in ['114905535','114756331','115230790','114994170']]): # 113996609
            print(path)
            # components = {}
            for file in files:
                if file == 'domain.pddl':
                    pddl = read_files.read_txt_file(os.path.join(path, file))
                    actions = postprocess_completion_whole_domain(pddl)

                    file_name = path.split('/')[-1] + '.txt'
                    save_output(pred_path, file_name, actions)

process_gold()
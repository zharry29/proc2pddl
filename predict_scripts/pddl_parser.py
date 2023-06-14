import re

class PDDL_Component_Parser:
    def read_document(self, file_path):
        with open(file_path, 'r') as f:
            # file=f.read().strip('\n').split('\n\n')
            file = f.readlines()
        return file

    def _add_pddl_components(self, lines,new_line):
        line = lines[0]
        if '(define (domain ' in line:
            self.domain = ''.join(lines).strip('\n')
        elif '(:requirements' in line:
            self.requirements = ''.join(lines).strip('\n')
        elif '(:types' in line:
            self.types = ''.join(lines).strip('\n')
        elif '(:predicates' in line:
            self.predicates = ''.join(lines).strip('\n')
        elif '(:action' in line:
            text = ''.join(lines).strip('\n')
            if new_line=='END':
                text = re.sub(r'\)$','', text).strip()
            self.actions.append(text) if any(span in text for span in [':parameters', ':precondition', ':effect']) \
                else print(f'missing all action components')
            self.action_names.append(lines[0].strip('\n'))
        else:
            print(f'parser: cannot match any type in pddl domain: {line}')


    def parse_components(self,file_path):
        file = self.read_document(file_path)
        file.append('END')
        # print(file)

        self.domain=''
        self.requirements =''
        self.types=''
        self.predicates=''
        self.actions=[]
        self.action_names=[]
        # self.pddl_components={'domain':self.domain,'requirements':self.requirements, 
        #                  'types':self.types, 'predicates':self.predicates,
        #                  'actions':self.actions}

        lines=[]
        for new_line in file:
            if new_line.strip()=='' or new_line.strip()[0]==';':
                continue
            # meet new start mark
            if any(span in new_line for span in ['(define (domain ','(:requirements','(:types','(:predicates','(:action','END']):
                # check already have (lines)
                if lines:
                    self._add_pddl_components(lines, new_line)
                lines=[new_line]
            else:
                lines.append(new_line)
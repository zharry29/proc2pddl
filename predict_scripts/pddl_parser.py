import re

class PDDL_Component_Parser:
    def read_document(self, file_path,remove_desc):
        with open(file_path, 'r') as f:
            # file=f.read().strip('\n').split('\n\n')
            file = f.readlines()
            if remove_desc:
                file = [re.sub(r';.*$', '', line, flags=re.MULTILINE) for line in file ]
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
            # return 'error'


    def parse_components(self,file_path, remove_desc=False):
        file = self.read_document(file_path,remove_desc)
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
    
    def scan_tokens(self, string):
        str = re.sub(r';.*$', '', string, flags=re.MULTILINE).lower()
        # print(string)
        # Tokenize
        stack = []
        list = []
        # print(re.findall(r'[()]|[^\s()]+', str))
        for t in re.findall(r'[()]|[^\s()]+', str):
            if t == '(':
                stack.append(list)
                list = []
            elif t == ')':
                if stack:
                    li = list
                    list = stack.pop()
                    list.append(li)
                else:
                    print('Missing open parentheses')
                    # raise Exception('Missing open parentheses')
            else:
                list.append(t)
        while stack:
            # raise Exception('Missing close parentheses')
            li = list
            list = stack.pop()
            list.append(li)
        if len(list) != 1:
            # print(stack)
            # print(list)
            # raise Exception('Malformed expression')
            print('Malformed expression')
            return []
        # print(string)
        # print(list)
        # print('---')、
        # if 'action' not in list[0][0]:
        #     print(list)
        return list[0]
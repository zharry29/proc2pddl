#!/usr/bin/env python
# Four spaces as indentation [no tabs]

# This file is part of PDDL Parser, available at <https://github.com/pucrs-automated-planning/pddl-parser>.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>

import itertools
from collections import defaultdict

class Action:

    # -----------------------------------------------
    # Initialize
    # -----------------------------------------------

    def __init__(self, name, parameters, positive_preconditions, negative_preconditions, add_effects, del_effects):
        def frozenset_of_tuples(data):
            return frozenset([tuple(t) for t in data])
        self.name = name
        self.parameters = tuple(parameters)  # Make parameters a tuple so we can hash this if need be
        self.positive_preconditions = frozenset_of_tuples(positive_preconditions)
        self.negative_preconditions = frozenset_of_tuples(negative_preconditions)
        self.add_effects = frozenset_of_tuples(add_effects)
        self.del_effects = frozenset_of_tuples(del_effects)

    # -----------------------------------------------
    # to String
    # -----------------------------------------------

    def __str__(self):
        return 'action: ' + self.name + \
               '\n  parameters: ' + str(list(self.parameters)) + \
               '\n  positive_preconditions: ' + str([list(i) for i in self.positive_preconditions]) + \
               '\n  negative_preconditions: ' + str([list(i) for i in self.negative_preconditions]) + \
               '\n  add_effects: ' + str([list(i) for i in self.add_effects]) + \
               '\n  del_effects: ' + str([list(i) for i in self.del_effects]) + '\n'

    # -----------------------------------------------
    # Equality
    # -----------------------------------------------

    def __eq__(self, other):
        return self.__dict__ == other.__dict__

    # -----------------------------------------------
    # Groundify
    # -----------------------------------------------

    def groundify(self, objects, types):
        if not self.parameters:
            yield self
            return
        type_map = []
        variables = []
        for var, type in self.parameters:
            type_stack = [type]
            items = []
            while type_stack:
                t = type_stack.pop()
                if t in objects:
                    items += objects[t]
                if t in types:
                    type_stack += types[t]
            type_map.append(items)
            variables.append(var)
        for assignment in itertools.product(*type_map):
            positive_preconditions = self.replace(self.positive_preconditions, variables, assignment)
            negative_preconditions = self.replace(self.negative_preconditions, variables, assignment)
            add_effects = self.replace(self.add_effects, variables, assignment)
            del_effects = self.replace(self.del_effects, variables, assignment)
            yield Action(self.name, assignment, positive_preconditions, negative_preconditions, add_effects, del_effects)

    # -----------------------------------------------
    # Replace
    # -----------------------------------------------

    def replace(self, group, variables, assignment):
        new_group = []
        for pred in group:
            pred = list(pred)
            for i, p in enumerate(pred):
                if p in variables:
                    pred[i] = assignment[variables.index(p)]
            new_group.append(pred)
        return new_group

def action_equal(Action1,Action2):
    p1 = Action1.parameters
    p2 = Action2.parameters
    pp1 = Action1.positive_preconditions
    pp2 = Action2.positive_preconditions
    np1 = Action1.negative_preconditions
    np2 = Action2.negative_preconditions
    ae1 = Action1.add_effects
    ae2 = Action2.add_effects
    de1 = Action1.del_effects
    de2 = Action2.del_effects
    if len(p1)!=len(p2) or len(pp1)!=len(pp2) or len(np1) != len(np2) or len(ae1) != len(ae2) or len(de1) != len(de2):
        return False
    p1 = sorted(p1, key=lambda x: x[1])
    p2 = sorted(p2, key=lambda x: x[1])
    d1 = defaultdict(list)
    d2 = defaultdict(list)
    paradict1 = {}
    paradict2 = {}
    for i in range(len(p1)):
        if p1[i][1] != p2[i][1]:
            return False
        paradict1[p1[i][0]] = p1[i][1]
        if p1[i][0] not in d1[p1[i][1]]:
            d1[p1[i][1]].append(p1[i][0])
        else:
            return False
        paradict2[p2[i][0]] = p2[i][1]
        if p2[i][0] not in d2[p2[i][1]]:
            d2[p2[i][1]].append(p2[i][0])
        else:
            return False
    pp1 = sorted(pp1, key=lambda x: x[0])
    pp2 = sorted(pp2, key=lambda x: x[0])
    #print(d1,paradict1,d2,paradict2)
    count1 = 0 
    count2 = 0
    countdict1={}
    countdict2={}
    for i in range(len(pp1)):
        if pp2[i][0] != pp1[i][0] or len(pp2[i]) != len(pp1[i]):
            return False
        for j in range(1,len(pp2[i])):
            if paradict2[pp2[i][j]] != paradict1[pp1[i][j]]:
                return False
            if pp1[i][j] not in countdict1 and pp2[i][j] not in countdict2:
                countdict1[pp1[i][j]]=count1
                countdict2[pp2[i][j]]=count2
                count1+=1
                count2+=1
            elif pp1[i][j] in countdict1 and pp2[i][j] in countdict2:
                if countdict1[pp1[i][j]] != countdict2[pp2[i][j]]:
                    print("not equal")
                    return False
            else:
                return False
    for i in range(len(np1)):
        np2=list(np2)
        np1=list(np1)
        if np2[i][0] != np1[i][0] or len(np2[i]) != len(np1[i]):
            return False
        for j in range(1,len(np2[i])):
            if paradict2[np2[i][j]] != paradict1[np1[i][j]]:
                return False
            if np1[i][j] not in countdict1 and np2[i][j] not in countdict2:
                countdict1[np1[i][j]]=count1
                countdict2[np2[i][j]]=count2
                count1+=1
                count2+=1
            elif np1[i][j] in countdict1 and np2[i][j] in countdict2:
                if countdict1[np1[i][j]] != countdict2[np2[i][j]]:
                    print("not equal")
                    return False
            else:
                return False
    for i in range(len(ae1)):
        ae2=list(ae2)
        ae1=list(ae1)
        if ae2[i][0] != ae1[i][0] or len(ae2[i]) != len(ae1[i]):
            return False
        for j in range(1,len(ae2[i])):
            if paradict2[ae2[i][j]] != paradict1[ae1[i][j]]:
                return False
            if ae1[i][j] not in countdict1 and ae2[i][j] not in countdict2:
                countdict1[ae1[i][j]]=count1
                countdict2[ae2[i][j]]=count2
                count1+=1
                count2+=1
            elif ae1[i][j] in countdict1 and ae2[i][j] in countdict2:
                if countdict1[ae1[i][j]] != countdict2[ae2[i][j]]:
                    print("not equal")
                    return False
            else:
                return False
    for i in range(len(de1)):
        de2=list(de2)
        de1=list(de1)
        if de2[i][0] != de1[i][0] or len(de2[i]) != len(de1[i]):
            return False
        for j in range(1,len(de2[i])):
            if paradict2[de2[i][j]] != paradict1[de1[i][j]]:
                return False
            if de1[i][j] not in countdict1 and de2[i][j] not in countdict2:
                countdict1[de1[i][j]]=count1
                countdict2[de2[i][j]]=count2
                count1+=1
                count2+=1
            elif de1[i][j] in countdict1 and de2[i][j] in countdict2:
                if countdict1[de1[i][j]] != countdict2[de2[i][j]]:
                    print("not equal")
                    return False
            else:
                return False
    return True
            
            
# -----------------------------------------------
# Main
# -----------------------------------------------
if __name__ == '__main__':
    a = Action('move', [['?ag', 'agent'], ['?from', 'pos'], ['?to', 'pos']],
                       [['at', '?ag', '?from'], ['adjacent', '?from', '?to']],
                       [['at', '?ag', '?to']],
                       [['at', '?ag', '?to']],
                       [['at', '?ag', '?from']])
    
    b = Action('move1', [['?aga', 'agent'], ['?toa', 'pos'], ['?froma', 'pos']],
                       [['adjacent', '?froma', '?toa'],['at', '?aga', '?froma']],
                       [['at', '?aga', '?toa']],
                       [['at', '?aga', '?toa']],
                       [['at', '?aga', '?froma']])
    print("a")
    print(a)
    print("b")
    print(b)
    print("is same?",action_comp(a,b))
    objects = {
        'agent': ['ana', 'bob'],
        'pos': ['p1', 'p2']
    }
    types = {'object': ['agent', 'pos']}
    for act in a.groundify(objects, types):
        print(act)

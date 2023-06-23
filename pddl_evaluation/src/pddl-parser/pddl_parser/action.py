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

    def __init__(
        self,
        name,
        parameters,
        positive_preconditions,
        negative_preconditions,
        add_effects,
        del_effects,
    ):
        def frozenset_of_tuples(data):
            return frozenset([tuple(t) for t in data])

        self.name = name
        self.parameters = tuple(
            parameters
        )  # Make parameters a tuple so we can hash this if need be
        self.positive_preconditions = frozenset_of_tuples(positive_preconditions)
        self.negative_preconditions = frozenset_of_tuples(negative_preconditions)
        self.add_effects = frozenset_of_tuples(add_effects)
        self.del_effects = frozenset_of_tuples(del_effects)

    # -----------------------------------------------
    # to String
    # -----------------------------------------------

    def __str__(self):
        return (
            "action: "
            + self.name
            + "\n  parameters: "
            + str(list(self.parameters))
            + "\n  positive_preconditions: "
            + str([list(i) for i in self.positive_preconditions])
            + "\n  negative_preconditions: "
            + str([list(i) for i in self.negative_preconditions])
            + "\n  add_effects: "
            + str([list(i) for i in self.add_effects])
            + "\n  del_effects: "
            + str([list(i) for i in self.del_effects])
            + "\n"
        )

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
            positive_preconditions = self.replace(
                self.positive_preconditions, variables, assignment
            )
            negative_preconditions = self.replace(
                self.negative_preconditions, variables, assignment
            )
            add_effects = self.replace(self.add_effects, variables, assignment)
            del_effects = self.replace(self.del_effects, variables, assignment)
            yield Action(
                self.name,
                assignment,
                positive_preconditions,
                negative_preconditions,
                add_effects,
                del_effects,
            )

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


def action_equal(Action1, Action2):
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
    if (
        len(p1) != len(p2)
        or len(pp1) != len(pp2)
        or len(np1) != len(np2)
        or len(ae1) != len(ae2)
        or len(de1) != len(de2)
    ):
        return False
    try:
        p1 = sorted(p1, key=lambda x: x[1])
        p2 = sorted(p2, key=lambda x: x[1])
    except TypeError:
        return False
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

    def entry_equal(pp1, pp2):
        pp1 = list(pp1)
        pp2 = list(pp2)
        count1 = 0
        count2 = 0
        countdict1 = {}
        countdict2 = {}
        for i in range(len(pp1)):
            flag = 0
            for j in range(len(pp2)):
                if pp2[j][0] == pp1[i][0] and len(pp2[j]) == len(pp1[i]):
                    for k in range(1, len(pp1[i])):
                        if pp2[j][k] not in paradict2 and pp1[i][k] not in paradict1:
                            if pp2[j][k] != pp1[i][k]:
                                return False
                        elif pp2[j][k] not in paradict2 or pp1[i][k] not in paradict1:
                            return False
                        elif paradict2[pp2[j][k]] != paradict1[pp1[i][k]]:
                            break
                        elif (
                            pp1[i][k] not in countdict1 and pp2[j][k] not in countdict2
                        ):
                            countdict1[pp1[i][k]] = count1
                            countdict2[pp2[j][k]] = count2
                            count1 += 1
                            count2 += 1
                        elif pp1[i][j] in countdict1 and pp2[i][j] in countdict2:
                            if countdict1[pp1[i][j]] != countdict2[pp2[i][j]]:
                                break
                        else:
                            break
                    flag = 1
                    pp2.pop(j)
                    break
                else:
                    continue
            if flag == 0:
                return False
        return True

    try:
        if (
            (entry_equal(pp1, pp2) == True)
            and (entry_equal(ae1, ae2) == True)
            and (entry_equal(np1, np2) == True)
            and (entry_equal(de1, de2) == True)
        ):
            return True
    except IndexError:
        return False
    return False


def action_dist(Action1, Action2):
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
    try:
        p1 = sorted(p1, key=lambda x: x[1])
        p2 = sorted(p2, key=lambda x: x[1])
    except TypeError:
        return -1, -1, -1
    n1 = 0
    d1 = defaultdict(list)
    d2 = defaultdict(list)
    paradict1 = {}
    paradict2 = {}
    lengthp1 = len(p1)
    lengthp2 = len(p2)
    for i in range(len(p1)):
        for j in range(len(p2)):
            if p1[i][1] == p2[j][1]:
                if p1[i][0] not in d1[p1[i][1]]:
                    d1[p1[i][1]].append(p1[i][0])
                else:
                    print("duplicate parameter")
                    return -1, -1, -1
                if p2[j][0] not in d2[p2[j][1]]:
                    d2[p2[j][1]].append(p2[j][0])
                else:
                    print("duplicate parameter")
                    return -1, -1, -1
                paradict1[p1[i][0]] = p1[i][1]
                paradict2[p2[j][0]] = p2[j][1]
                n1 += 1
                # print(p1[i][0], p2[j][0])
                p2.pop(j)
                break
            else:
                continue
    distpara = abs(lengthp1 - n1) + abs(lengthp2 - n1)

    def entry_distance(pp1, pp2):
        pp1 = list(pp1)
        pp2 = list(pp2)
        lengthp1 = len(pp1)
        lengthp2 = len(pp2)
        count1 = 0
        count2 = 0
        countdict1 = {}
        countdict2 = {}
        n = 0
        for i in range(len(pp1)):
            for j in range(len(pp2)):
                if pp2[j][0] == pp1[i][0] and len(pp2[j]) == len(pp1[i]):
                    for k in range(1, len(pp1[i])):
                        try:
                            if pp2[j][k] not in paradict2 or pp1[i][k] not in paradict1:
                                if pp2[j][k] != pp1[i][k]:
                                    break
                            elif paradict2[pp2[j][k]] != paradict1[pp1[i][k]]:
                                break
                            elif (
                                pp1[i][k] not in countdict1 and pp2[j][k] not in countdict2
                            ):
                                countdict1[pp1[i][k]] = count1
                                countdict2[pp2[j][k]] = count2
                                count1 += 1
                                count2 += 1
                            elif pp1[i][j] in countdict1 and pp2[i][j] in countdict2:
                                if countdict1[pp1[i][j]] != countdict2[pp2[i][j]]:
                                    break
                            else:
                                break
                        except IndexError:
                            break
                    n += 1
                    pp2.pop(j)
                    break
                else:
                    continue
        return abs(lengthp1 - n) + abs(lengthp2 - n)

    distprecondition = entry_distance(pp1, pp2) + entry_distance(np1, np2)
    disteffect = entry_distance(ae1, ae2) + entry_distance(de1, de2)
    return distpara, distprecondition, disteffect


# -----------------------------------------------
# Main
# -----------------------------------------------
if __name__ == "__main__":
    a = Action(
        "cut_stalks",
        [
            ["?player", "player"],
            ["?from", "location"],
            ["?to", "location"],
        ],
        [["at", "?player", "?from"]],
        [],
        [["at", "?player", "?to"]],
        [["at", "?player", "?from"]],
    )

    b = Action(
        "cut_stalks",
        [
            ["?player", "player"],
            ["?l1", "location"],
            ["?l2", "location"],
        ],
        [["at", "?player", "?l1"]],
        [],
        [["at", "?player", "?l2"]],
        [["at", "?player", "?l1"]],
    )

    print("a")
    print(a)
    print("b")
    print(b)
    print("is same?", action_equal(a, b))
    objects = {"agent": ["ana", "bob"], "pos": ["p1", "p2"]}
    types = {"object": ["agent", "pos"]}
    for act in a.groundify(objects, types):
        print(act)


#  (:action cut_stalks; cut papyrus plant into stalks
#  :parameters (?p - player ?knife - knife ?papyrus_plant - papyrus_plant ?papyrus_stalks - papyrus_stalks)
#  :precondition (and (inventory ?p ?knife) (inventory  ?p ?papyrus_plant))
#  :effect (and (inventory ?p ?papyrus_stalks) (not (inventory ?p ?papyrus_plant)))
#   )
# pred的第5个是
# (:action cut_stalks
#     :parameters (?player - player ?papyrus_plant - papyrus_plant ?papyrus_stalks - papyrus_stalks ?knife - knife)
#     :precondition (and (inventory ?player ?papyrus_plant) (inventory ?player ?knife))
#     :effect (and (not (inventory ?player ?papyrus_plant)) (inventory ?player ?papyrus_stalks))
# )


def action_dist(Action1, Action2):
    # Parameter distance
    match_count = 0
    paradict1 = {}
    paradict2 = {}
    para_number1 = len(Action1.parameters)
    para_number2  = len(Action2.parameters)
    for i in Action1.parameters:
        for j in Action2.parameters:
            if i[1] == j[1]:
                paradict1[i[0]] = i[1]
                paradict2[j[0]] = j[1]
                match_count += 1
                try:
                    Action2.parameters.pop(j)
                except AttributeError:
                    break
                break
            else:
                continue
    para_dist = abs(para_number1 - match_count) + abs(para_number2 - match_count)

    # Precondition/effect distance
    def entry_distance(condition1, condition2):
        cond_number1 = len(condition1)
        cond_number2 = len(condition2)
        index = 0
        countdict1 = {}
        countdict2 = {}
        match_count = 0
        for i in condition1:
            for j in condition2:
                if i[0] == j[0] and len(i) == len(j):
                # If two conditions have the same predicate and the same number of parameters, they may match.
                    for k in range(1, len(i)):
                        if j[k] not in paradict2 or i[k] not in paradict1:
                        #If neither of the two current parameters has appeared before, i and j cannot match if these parameters are not identical.
                            if j[k] != i[k]:
                                break
                        elif paradict2[j[k]] != paradict1[i[k]]:
                        #If the two parameters have different categories, then i j do not match
                            break
                        elif i[k] not in countdict1 and j[k] not in countdict2:
                        #If the two parameters have same categories and don't have index, then regard them as same parameter entity and give them same index.
                            countdict1[i[k]] = index
                            countdict2[j[k]] = index
                            index += 1
                        elif i[k] in countdict1 and j[k] in countdict2:
                        #If the two parameters already have indexs, if their indexs are not equal, then i and j cannot match.
                            if countdict1[i[k]] != countdict2[j[k]]:
                                break
                        else:
                            break
                    match_count += 1
                    try:
                        condition2.pop(j)
                    except AttributeError:
                        break
                    break
                else:
                    continue
        return abs(cond_number1 - match_count) + abs(cond_number2 - match_count)

    precondition_dist = entry_distance(Action1.positive_preconditions, Action2.positive_preconditions) + entry_distance(Action1.negative_preconditions, Action2.negative_preconditions)
    
    effect_dist = entry_distance(Action1.add_effects,Action2.add_effects) + entry_distance(Action1.del_effects, Action2.del_effects)

    return para_dist, precondition_dist, effect_dist
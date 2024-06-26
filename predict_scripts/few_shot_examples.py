pddl='''(define (domain candle_making)
  (:requirements :strips :typing)
  
  (:types 
    wax container pot heat_source water
  )
  
  (:predicates 
    (solid ?w - wax)
    (liquid ?w - wax)
    (in ?x - container ?y - pot)
    (in ?x - wax ?y - container)
    (heatproof ?x - container)
    (off ?h - heat_source)
    (on ?h - heat_source)
    (cold ?w - water)
    (heated ?w - water)
  )
  
  (:action melt_wax
    :parameters (?w - wax ?c - container ?p - pot ?h - heat_source ?wtr - water)
    :precondition (and 
                    (solid ?w) 
                    (in ?w ?c) 
                    (heatproof ?c) 
                    (in ?c ?p) 
                    (in ?wtr ?p) 
                    (off ?h) 
                    (cold ?wtr))
    :effect (and 
              (liquid ?w) 
              (heated ?wtr) 
              (on ?h))
  )
)'''

examples = {} # action_name: {text, pddl_action, entity_state_infer}
examples['melt_wax'] = {
    'text': 'Melt candle wax flakes or cubes in a double boiler. Set a can, jar, or another heat-proof container in a pot, and place your solid candle wax (soy or paraffin are most common) inside. Surround the container with water, filling the pot about halfway up the container, then heat the pot on medium heat to double boil the wax to melt it completely, stirring every minute or so to make sure it melts evenly.',
    'pddl_action': '''(:action melt_wax
  :parameters (?wax ?container ?pot ?heat_source ?water)
  :precondition (and (solid ?wax) (in ?wax ?container) (heatproof ?container) (in ?container ?pot) (in ?water ?pot) (cold ?water))
  :effect (and (liquid ?wax) (heated ?water))
)''',
    'entity_state_inference': '''- action name: melt_wax
- summarize action: This action involves melting solid candle wax using a double boiler method. The solid wax is placed in a heat-proof container, which is then placed in a pot filled with water. The pot is heated, and the wax is stirred until it melts completely.
- what is needed to do the action: The action requires solid wax, a heat-proof container, a pot, water, and a heat source.
- what is the result: The solid wax is melted into liquid wax.

- entities:
    - entity name: wax
        - before: solid
        - after: liquid
    - entity name: container
        - before: empty or containing solid wax
        - after: containing liquid wax
    - entity name: pot
        - before: empty or containing water and container with solid wax
        - after: containing water and container with liquid wax
    - entity name: water
        - before: cold or room temperature
        - after: heated
    - entity name: heat_source
        - before: off
        - after: on'''
                        }

examples['mix_sand_with_color'] = {
    'text': 'Close the bags tightly, then shake and squeeze them to mix the sand. Zip the bags shut tightly first. Next, shake the bags to help distribute the food coloring. You can also gently squeeze and massage the sand through the bags. Keep doing this until the color is even. Add more food coloring if the color is too light for you. Keep in mind that the sand will dry lighter.',
    'pddl_action': '''(:action mix_sand_with_color 
:parameters (?bag - bag ?sand - sand ?color - food_coloring) 
:precondition (and (sealed ?bag) (contains ?bag ?sand) (contains ?bag ?color) (not (evenly_colored ?sand))) 
:effect (evenly_colored ?sand))''',
    'entity_state_inference': '''- action name: mix_sand_with_color
- summarize action: This action involves mixing colored sand by sealing bags containing sand and food coloring, then shaking, squeezing, and massaging the bags until the sand color is evenly distributed. More food coloring may be added if the color is too light, with the understanding that the sand will dry lighter.
- what is needed to do the action: Sealed bags containing sand and food coloring, ability to shake and squeeze the bags.
- what is the result: The sand inside the bags is evenly colored.
- entities:
    - entity name: bags
        - before: contains uncolored or unevenly colored sand and food coloring
        - after: contains evenly colored sand
    - entity name: sand
        - before: uncolored or unevenly colored
        - after: evenly colored
    - entity name: food_coloring
        - before: present in the bags
        - after: mixed evenly with the sand'''
}

examples['slide_straw_over_skewer'] = {
    'text': 'Slide a segment of plastic straw over the 2 skewers. Cut a segment of a plastic straw that is equal to the width between the wheel wells on your car. Then, slide it onto 1 of the skewers that’s attached to a wheel. Do the same with the other skewer.',
    'pddl_action': '''(:action slide_straw_over_skewer
 :parameters (?straw1 - straw ?straw2 - straw ?skewer1 - skewer ?skewer2 - skewer ?wheel1 - wheel ?wheel2 - wheel)
 :precondition (and 
                (attached ?skewer1 ?wheel1)
                (attached ?skewer2 ?wheel2)
                (equal_width ?straw1 ?skewer1)
       	        (equal_width ?straw2 ?skewer2))
 :effect (and 
          (over ?straw1 ?skewer1)
          (over ?straw2 ?skewer2)))''',
    'entity_state_inference': '''- action name: slide_straw_over_skewer
- summarize action: The action involves cutting a segment of a plastic straw and sliding it over two skewers attached to wheels. The straw segments should be equal to the width between the wheel wells on a car.
- what is needed to do the action: A segment of a plastic straw, two skewers attached to wheels.
- what is the result: The straw segments are slid over the skewers, which helps in maintaining the structure of the car and providing stability to the wheels.
- entities:
    - entity name: plastic straw segment
        - before: Not cut and not on skewers
        - after: Cut and slid onto skewers
    - entity name: skewer
        - before: Without straw segments
        - after: With straw segments slid onto them
    - entity name: wheel
        - before: Attached to skewers, without straw segments on the skewers
        - after: Attached to skewers, with straw segments on the skewers'''
}

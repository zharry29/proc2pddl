
(define (problem drink_water)
   (:domain survive_in_jungle)

   (:objects
      npc - player
      camp stream clearing grove thicket - location
      in out north south east west up down - direction
      water - water
      fruit - food
      mushrooms - food
      lighter - igniter
      bottle - container
      sticks - sticks
      leaves - leaves
   )

   (:init
      (connected camp north grove)
      (connected grove south camp)
      (connected camp east stream)
      (connected stream west camp )
      (connected camp south thicket)
      (connected thicket north camp)
      (connected camp west clearing)
      (connected clearing east camp)
      (at npc camp)
      (at bottle camp)
      (at lighter camp)
      (at sticks grove)
      (at leaves thicket)
      (at fruit thicket)
      (has_water_source stream)
      (has_tree grove)
      (is_hungry npc)
      (is_thirsty npc)
      (is_tired npc)
      (at mushrooms clearing)
      (is_poisonous mushrooms)
      (is_contaminated fruit)
   )

   (:goal (and (not (is_thirsty npc))))

)

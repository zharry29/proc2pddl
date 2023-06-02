
(define (problem drink_water)
   (:domain survive_in_the_jungle)

   (:objects
      npc - player
      camp path riverside rainforest cave - location
      in out north south east west up down - direction
      water - water
      wood - wood
      container - container
      drill - drill
      spear - spear
      fish - fish
      foliage - foliage
   )

   (:init
      (connected camp east path)
      (connected path west camp)
      (connected path east riverside)
      (connected riverside west path)
      (connected riverside north rainforest)
      (connected rainforest south riverside)
      (connected rainforest east cave)
      (connected cave west rainforest)
      (at npc camp)
      (at container camp)
      (has_tree rainforest)
      (has_water riverside)
      (has_fish riverside)
      (thirsty npc)
      (hungry npc)
   )

   (:goal (and (not (thirsty npc))))
)


(define (problem process_papyrus_plant_strips)
   (:domain make_papyrus)

   (:objects
      npc - player
      garage nursery work_station  - location
      in out north south east west - direction
      plant - plant
      stalk - stalk
      strip - strip
      sheet - sheet
      papyrus - papyrus
      scissors - scissors
      wooden_board - wooden_board
      shell - shell
   )

   (:init
      (connected garage west nursery)
      (connected nursery east garage)
      (connected garage in work_station)
      (connected work_station out garage)
      (at npc garage)
      (at scissors garage)
      (at shell garage)
      (at wooden_board garage)
      (inventory npc strip)
      (inventory npc scissors)
      (has_water work_station)
      (has_hard_surface work_station)
   )

   (:goal (and (inventory npc sheet) (flat sheet)))
)


(define (problem obtain_papyrus)
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
      (at shell garage)
      (inventory npc scissors)
      (inventory npc sheet)
      (flat sheet)
      (has_hard_surface work_station)
   )

   (:goal (inventory npc papyrus))
)

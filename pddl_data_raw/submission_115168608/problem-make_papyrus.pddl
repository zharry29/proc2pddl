
(define (problem make_papyrus)
   (:domain make_papyrus)

   (:objects
      npc - player
      papyrus_plant - papyrus_plant 
      papyrus_stalks - papyrus_stalks
      papyrus_strips - papyrus_strips
      water - water
      linen_sheets - linen_sheets
      wooden_boards - wooden_boards
      rolling_pin - rolling_pin
      knife - knife
      papyrus - papyrus
   )

   (:init
      (inventory npc knife)
      (inventory npc water)
      (inventory npc rolling_pin)
      (inventory npc wooden_boards)
      (inventory npc linen_sheets)
      (inventory npc papyrus_plant)
   )

   (:goal (and (inventory npc papyrus)))
)

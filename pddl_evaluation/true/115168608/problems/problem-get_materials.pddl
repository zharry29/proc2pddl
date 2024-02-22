
(define (problem get_materials)
   (:domain make_papyrus)

   (:objects
      npc - player
      water - water
      linen_sheets - linen_sheets
      wooden_boards - wooden_boards
      rolling_pin - rolling_pin
      knife - knife
      home - location
   )

   (:init
      (at npc home)
      (at water home)
      (at linen_sheets home)
      (at rolling_pin home)
      (at knife home)
      (at wooden_boards home)
   )

   (:goal (and (inventory npc knife) (inventory npc rolling_pin) (inventory npc water) (inventory npc wooden_boards) (inventory npc linen_sheets)))
)

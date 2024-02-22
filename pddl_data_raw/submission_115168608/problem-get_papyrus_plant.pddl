
(define (problem get_papyrus_plant)
   (:domain make_papyrus)

   (:objects
      npc - player
      home river - location
      papyrus_plant - papyrus_plant

   )

   (:init
      (at npc home)
      (at papyrus_plant river)
      (not_gettable papyrus_plant)
   )

   (:goal (and (at npc home) (inventory npc papyrus_plant)))
)

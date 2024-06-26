
(define (problem serve-drinks)
   (:domain anime-party)

   (:objects
      npc - player
      kitchen livingroom bedroom closet cupboard - location
      in out north south east west up down - direction
      soymilk soda sake beer tea - drink
      money phone teabag - item
   )

   (:init
      (connected kitchen east livingroom)
      (connected livingroom west kitchen)
      (connected bedroom west livingroom)
      (connected livingroom east bedroom)
      (connected bedroom south closet)
      (connected closet north bedroom)
      (connected cupboard south kitchen)
      (connected kitchen north cupboard)
      (has_kitchen kitchen)
      (has_fridge bedroom)
      (at npc bedroom)
      (at phone bedroom)
      (inventory npc money)
      (at soymilk kitchen)
      (opened soymilk)
      (at soda cupboard)
      (at wine kitchen)
      (at teabag cupboard)
   )

   (:goal (and
      (at soymilk livingroom)
      (at soda livingroom)
      (at sake livingroom)
      (at tea livingroom)
      (at beer livingroom)
    )) 
)

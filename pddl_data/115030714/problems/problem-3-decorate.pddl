
(define (problem decorate)
   (:domain anime-party)

   (:objects
      npc - player
      kitchen livingroom bedroom closet cupboard - location
      in out north south east west up down - direction
      money phone balloon tv lantern - item
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
      (at npc bedroom)
      (at tv livingroom)
      (at balloon closet)
      (at lantern closet)
   )

   (:goal (and
    (on tv)
    (inflated balloon)
    (hung lantern)
   ))
)

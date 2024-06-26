
(define (problem cook-food)
   (:domain anime-party)

   (:objects
      npc - player
      kitchen livingroom bedroom closet cupboard - location
      in out north south east west up down - direction
      stirfry sushi soup clams teriyaki - food
      money phone - item
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
      (at npc bedroom)
      (at phone bedroom)
      (inventory npc money)
      (orderable sushi)
   )

   (:goal (and
      (at stirfry livingroom)
      (at sushi livingroom)
      (at soup livingroom)
      (at clams livingroom)
      (at teriyaki livingroom)
    )) 
)

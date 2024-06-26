
(define (problem onboard)
   (:domain survive_shark_attack)

   (:objects
      npc - player
      shark - shark
      ship - ship
      stone spear - item
      shore open_sea deep_sea shallow_sea - location
      in out up down - direction
      eye gill snout skin - part
      fist knee teeth - body
   )

   (:init
      (connected shore out shallow_sea)
      (connected shallow_sea in shore)
      (connected shallow_sea out open_sea)
      (connected open_sea in shallow_sea)
      (connected open_sea out deep_sea)
      (connected deep_sea in open_sea)
      (vulnerable eye)
      (vulnerable gill)
      (vulnerable snout)
      (heavy stone)
      (at stone shallow_sea)
      (sharp spear)
      (at spear deep_sea)
      (at npc open_sea)
      (at shark open_sea)
      (at ship deep_sea)
      (visible shark)
   )


   (:goal (and (on npc ship)))
)

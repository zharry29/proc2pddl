
(define (problem collect_water)
   (:domain survive_emp_attack)

   (:objects
      npc - player
      bathtub bottles purification_tablets - item
      basement kitchen bedroom bathroom - location
      up down in out - direction
   )

   (:init
      (connected basement up kitchen)
      (connected kitchen down basement)
      (connected kitchen up bedroom)
      (connected bedroom down kitchen)
      (connected bedroom in bathroom)
      (connected bathroom out bedroom)

      (can_be_filled bottles)
       (can_be_sealed bottles)
      (has_stopper bathtub)

      (at npc basement)
      (at bottles kitchen)
      (at bathtub bathroom)
      (at purification_tablets bathroom)
   )
  (:goal (and (full bathtub) (purified bottles) (sealed bottles)))
   
)

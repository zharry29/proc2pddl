
(define (problem turn_on_radio)
   (:domain survive_emp_attack)

   (:objects
      npc - player
      bedroom basement kitchen - location
      up down - direction
      batteries - item
      radio - radio
   )

   (:init
      (connected kitchen up bedroom)
      (connected bedroom down kitchen)
      (connected kitchen down basement)
      (connected basement up kitchen)
      (at npc kitchen)
      (at radio basement)
      (at batteries bedroom)
   )
  (:goal (on radio))
   
)

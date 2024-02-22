
(define (problem prepare_for_attack)
   (:domain survive_emp_attack)

   (:objects
      npc - player
      trashcan trashlid aluminum_foil phone ipad laptop nintendo_switch  - item
      basement kitchen bedroom - location
      up down in out - direction
   )

   (:init
      (connected basement up kitchen)
      (connected kitchen down basement)
      (connected kitchen up bedroom)
      (connected bedroom down kitchen)

      (at npc bedroom)
      (at aluminum_foil kitchen)
      (at trashcan basement)
      (at trashlid basement)
      (at phone bedroom)
      (at laptop kitchen)
      (at ipad bedroom)
      (at nintendo_switch basement)

   )
  
  (:goal (and (in_cage phone) (in_cage ipad) (in_cage laptop) (in_cage nintendo_switch)  (cage_closed farraday_cage)))
   
)


(define (problem shelter_in_place)
   (:domain survive_emp_attack)

   (:objects
      npc - player
      home work park highway backroads - location
      east west north south - direction
   )

   (:init
      (connected work south highway)
      (connected highway south home)
      (connected home north highway)
      (connected highway north work)

      (connected work east backroads)
      (connected backroads west work)

      (connected backroads south park)
      (connected park north backroads)
      (connected park west home)
      (connected home east park)

      (at npc work)
   )
  (:goal (on radio))
   
)

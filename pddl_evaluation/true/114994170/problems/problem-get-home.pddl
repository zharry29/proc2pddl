
(define (problem shelter_in_place)
   (:domain survive_emp_attack)

   (:objects
      npc - player
      kids - item
      home work highway backroads basement school - location
      east west north south down - direction
   )

   (:init
      (connected work south highway)
      (connected highway south home)
      (connected home north highway)
      (connected highway north work)

      (connected work east backroads)
      (connected backroads west work)

      (connected backroads south school)
      (connected school north backroads)
      (connected school west home)
      (connected home east school)

      (connected home down basement)
      (connected basement up home)

      (blocked work south highway)
      (blocked home north highway)
      (blocked work east backroads)
      (blocked school north backroads)
      (blocked school west home)
      (blocked home east school)

      (at npc work)
      (at kids school)
   )
  (:goal (and (at npc basement) (at kids basement)))
   
)

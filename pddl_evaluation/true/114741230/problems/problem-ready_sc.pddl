
(define (problem ready_sc)
   (:domain create_secret_society)

   (:objects
      npc - player
      ss - secret_society
   )

   (:init
      (in npc ss)
      (is_trusted npc ss)
      (equals npc npc)
   )

   (:goal (and (society_is_ready ss)))
)

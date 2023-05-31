(define (problem collect_water)
   (:domain survive_in_the_woods)

   (:objects
      npc - player
      waterfall camp path cliff - location
      in out north south east west up down - direction
      water - water
   )

   (:init
      (connected camp west path)
      (connected path east camp)
      (connected path west cliff)
      (connected cliff east path)
      (connected cliff up waterfall)
      (connected waterfall down cliff)
      (at npc camp)
      (at canteen camp)
      (has_water_source waterfall)
   )

   (:goal (and (inventory npc water)))
)
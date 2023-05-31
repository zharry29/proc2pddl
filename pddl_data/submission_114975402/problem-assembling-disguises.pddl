
(define (problem assembling_disguises)
   (:domain how_to_make_a_detective_kit)

   (:objects
      npc - player
      costume_store house train_station bus_stop - location
      in out north south east west up down - direction
      costume - costume
   )

   (:init
      (connected house west bus_stop)
      (connected bus_stop east house)
      (connected house east train_station)
      (connected train_station west house)
      (connected train_station east staples)
      (connected staples west train_station)
      (connected bus_stop north costume_store)
      (connected costume_store south bus_stop)
      (at npc house)
      (at costume costume_store)
      (sells_costume costume_store)
   )

   (:goal (and (inventory npc costume)))
)

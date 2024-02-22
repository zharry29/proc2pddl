
(define (problem get_all_stationery)
   (:domain how_to_make_a_detective_kit)

   (:objects
      npc - player
      staples house train_station bus_stop - location
      in out north south east west up down - direction
      cardboard - cardboard
      pen - pen
      notebook - notebook
      chalk - chalk
   )

   (:init
      (connected house west bus_stop)
      (connected bus_stop east house)
      (connected house east train_station)
      (connected train_station west house)
      (connected train_station east staples)
      (connected staples west train_station)
      (connected bus_stop north staples)
      (connected staples south bus_stop)
      (at npc house)
      (at pen staples)
      (at chalk staples)
      (at cardboard staples)
      (at notebook staples)
      (sells_stationery staples)
   )

   (:goal (and (inventory npc cardboard) (inventory npc pen) (inventory npc notebook) (inventory npc chalk)))
)

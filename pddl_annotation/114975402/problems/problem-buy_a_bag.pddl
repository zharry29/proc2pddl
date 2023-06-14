
(define (problem buy_a_bag)
   (:domain how_to_make_a_detective_kit)

   (:objects
      npc - player
      target house market bus_stop - location
      in out north south east west up down - direction
      bag - bag
   )

   (:init
      (connected house west bus_stop)
      (connected bus_stop east house)
      (connected bus_stop north market)
      (connected market south bus_stop)
      (connected market in target)
      (connected target out market)
      (at target bag)
      (at npc house)
      (sells_bag target)
   )

   (:goal (and (inventory npc bag)))
)

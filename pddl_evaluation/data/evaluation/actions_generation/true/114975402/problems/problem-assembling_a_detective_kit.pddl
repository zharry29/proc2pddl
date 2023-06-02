
(define (problem assembling_a_detective_kit)
   (:domain how_to_make_a_detective_kit)

   (:objects
      npc - player
      costume_store target market house train_station bus_stop staples electronics_store garage - location
      in out north south east west up down - direction
      costume - costume
      bag - bag
      cardboard - cardboard
      pen - pen
      notebook - notebook
      paper - paper
      aluminium_foil - aluminium_foil
      badge - badge
      detective_notebook - detective_notebook
      wigs sunglasses fake_mustaches yellow_raincoat black_boots paintbrush feather_boa - disguise
      walkie_talkies - walkie_talkies
      detective_kit - detective_kit
   )

   (:init
      (connected house west bus_stop)
      (connected bus_stop east house)
      (connected house east train_station)
      (connected train_station west house)
      (connected train_station east staples)
      (connected staples west train_station)
      (connected train_station north costume_store)
      (connected costume_store south train_station)
      (connected bus_stop north market)
      (connected market south bus_stop)
      (connected market in target)
      (connected target out market)
      (connected house in garage)
      (connected garage out house)
      (connected bus_stop west electronics_store)
      (connected electronics_store east bus_stop)
      (at npc house)
      (at bag target)
      (at costume costume_store)
      (at pen staples)
      (at paper staples)
      (at cardboard staples)
      (at notebook staples)
      (at aluminium_foil staples)
      (at walkie_talkies electronics_store)
      (at wigs garage)
      (at sunglasses garage)
      (at fake_mustaches garage)
      (at yellow_raincoat garage)
      (at black_boots garage)
      (at paintbrush garage)
      (at feather_boa garage)
      (sells_stationery staples)
      (sells_costume costume_store)
      (sells_bag target)
      (sells_electronics electronics_store)
   )
   (:goal (and (inventory npc detective_kit) (wear npc costume)))
)

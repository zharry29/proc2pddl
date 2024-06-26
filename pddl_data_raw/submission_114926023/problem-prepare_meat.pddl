
(define (problem prepare_meat)
   (:domain survive_on_a_deserted_island_with_nothing)

   (:objects
      npc - player
      beach root_of_tree top_of_tree jungle hills cliff - location
      in out north south east west up down - direction
      sharp_stone - sharp_stone
      animal - animal
   )

   (:init
      (connected beach north root_of_tree)
      (connected root_of_tree south beach)
      (connected root_of_tree up top_of_tree)
      (connected top_of_tree down root_of_tree)
      (connected root_of_tree north jungle)
      (connected jungle south root_of_tree)
      (connected jungle east hills)
      (connected hills west jungle)
      (at npc beach)
      (at animal jungle)
      (at sharp_stone hills)
   )

   (:goal (and (inventory npc animal) (treated animal)))
)

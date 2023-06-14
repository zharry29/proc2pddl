(define (problem get_food) (:domain survive_on_a_deserted_island_with_nothing)
(:objects 
    npc - player
    in out north south east west up down - direction
    shore forest_edge forest river - location
    softwood - softwood
    stick1 stick2 - hardwood_stick
    tinder - tinder
    campfire - campfire
    stone - sharp_stone
    fish - fish
)

(:init
    ;todo: put the initial state's facts and numeric values here
    (connected shore east forest_edge)
    (connected forest_edge west shore)
    (connected forest_edge east forest)
    (connected forest west forest_edge)
    (connected forest north river)
    (connected south river forest)
    (at npc shore)
    (has_tinder forest)
    (has_fish shore)
    (has_fish river)
    (at softwood forest)
    (at stick1 forest)
    (at stick2 forest)
    (at stone shore)
)

(:goal (and
   (inventory npc fish)
   (cooked fish)
))

)

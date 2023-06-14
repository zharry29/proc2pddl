(define (problem find_drinkable_water) 
    (:domain survive_on_a_deserted_island_with_nothing)
    (:objects 
        npc - player
        in out north south east west up down - direction
        shore forest_edge forest river - location
        water - freshwater
        plant - plant
        bag - bag
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
        (at plant forest)
        (has_freshwater_source river)
        (inventory npc bag)
    )

    (:goal (and
        (inventory npc water);todo: put the goal condition here
    ))

)

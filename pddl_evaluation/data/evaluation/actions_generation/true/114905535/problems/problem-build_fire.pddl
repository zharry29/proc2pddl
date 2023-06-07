(define (problem build_fire) 
    (:domain survive_on_a_deserted_island_with_nothing)

    (:objects 
    npc - player
    in out north south east west up down - direction
    shore forest_edge forest river - location
    softwood - softwood
    hardwood_stick - hardwood_stick
    campfire - campfire
    tinder - tinder
    )

    (:init
        ;todo: put the initial state's facts and numeric values here
        (connected shore east forest_edge)
        (connected forest_edge west shore)
        (connected forest_edge east forest)
        (connected forest west forest_edge)
        (at npc shore)
        (has_tinder forest)
        (at softwood forest)
        (at hardwood_stick forest)
    )

    (:goal (and (lit campfire) ) )
)


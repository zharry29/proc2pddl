
    (define (problem avoid_quicksand)
        (:domain get_out_of_quicksand)

        (:objects
            npc - player
            l1 - location
            l2 - location
            l3 - location
            home - location
            qsand - quicksand
            in out north south east west up down - direction
            stick - stick
        )

        (:init
            (connected l1 east l2)
            (connected l2 east l3)
            (connected home north l1)
            (has_ripples l1)
            (has_ripples l2)
            (at npc home)
            (at qsand l2)
            (at stick l1)
            (aware npc home)
        )

        (:goal (and (not (stuck npc qsand)) (at npc l3)))
    
    )

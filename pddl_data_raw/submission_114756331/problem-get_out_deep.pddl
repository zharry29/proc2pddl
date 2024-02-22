
    (define (problem get_out_deep)
        (:domain get_out_of_quicksand)

        (:objects
            npc - player
            here - location
            qsand - quicksand
            stick - stick
        )

        (:init 
            (stuck npc qsand)
            (at npc here)
            (at stick here)
            (at qsand here)
            (has_ripples here)
            (deep qsand)
        )

        (:goal (and (not (stuck npc qsand))))

    )

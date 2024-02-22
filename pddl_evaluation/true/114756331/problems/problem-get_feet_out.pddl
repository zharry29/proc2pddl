
  (define (problem get_feet_out)
      (:domain get_out_of_quicksand)

      (:objects 
        npc - player
        here - location
        qs - quicksand
      )


      (:init
          (stuck npc qs) 
          (at npc here)
          (has_ripples here)
      )


      (:goal (and (not (stuck npc qs))))
)

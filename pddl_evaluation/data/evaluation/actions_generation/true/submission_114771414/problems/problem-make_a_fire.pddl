
(define (problem make_a_fire)
  (:domain survive_on_a_desert_island)
 
  (:objects
     npc - player
     camp path cliff beach clifftop bushwood - location
     in out north south east west up down - direction
     stick - stick
  )
 
  (:init
     (connected camp west path)
     (connected path east camp)
     (connected camp north beach)
     (connected beach south camp)
     (connected path west cliff)
     (connected cliff east path)
     (connected cliff up clifftop)
     (connected clifftop east bushwood)
     (connected bushwood east clifftop)
     (connected clifftop down cliff)
     (at npc camp)
     (at canteen camp)
     (at stick bushwood)
  )
 
  (:goal (and (has_fire camp)))
)

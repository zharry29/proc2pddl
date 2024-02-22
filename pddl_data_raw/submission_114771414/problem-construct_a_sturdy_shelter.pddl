
(define (problem construct_a_sturdy_shelter)
  (:domain survive_on_a_desert_island)
 
  (:objects
     npc - player
     camp path cliff beach clifftop bushwood - location
     in out north south east west up down - direction
     stick - stick
     tarp - tarp
     leave - leave
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
 
  (:goal (and (sheltered camp)))
)


(define (problem hunt_animal_for_food)
  (:domain survive_on_a_desert_island)
 
  (:objects
     npc - player
     camp path cliff beach clifftop bushwood - location
     in out north south east west up down - direction
     fish - fish
     bird - bird
     stick stick2 - stick
     insect - insect
     shellfish - shellfish
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
     (at stick2 camp)
     (has_fish beach)
     (has_bird clifftop)
     (has_insect bushwood)
     (has_insect path)
     (has_shellfish beach)
  )

  (:goal (and (inventory npc fish) (edible fish) (inventory npc bird) (edible bird) (inventory npc insect) (edible insect) (inventory npc shellfish) (edible shellfish)))

  
)

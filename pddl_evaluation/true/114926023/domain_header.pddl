(define (domain survive_on_a_deserted_island_with_nothing)
   (:requirements :strips :typing)
   (:types
       sharp_stone log small_sticks leaves vines raft_draft raft_finished - item
       player direction location roof wall shelter animal
   )

   (:predicates
      (at ?obj - object ?loc - location) ; an object is at a location 
      (inventory ?player ?item) ; an item is in the player's inventory
      (connected ?loc1 - location ?dir - direction ?loc2 - location) ; location 1 is connected to location 2 in the direction
      (treated ?animal - animal) ; True if the animal has been treated and is safe to eat
   )
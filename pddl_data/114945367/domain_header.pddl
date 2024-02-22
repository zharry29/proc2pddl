(define (domain survive_in_the_woods)
   (:requirements :strips :typing)
   (:types
       water - item 
       player direction location
       cloth
       container
       long_branch propped_branches
       logs
       twigs_leaves
       teepee
   )

   (:predicates
      (has_water_source ?loc - location) ; this location has a source of fresh water.
      (has_branches ?loc - location) ; this locations has a bunch of branches.
      (has_twigs_leaves ?loc - location) ; this locations has a twigs and leaves.
      (has_logs ?loc - location); this locations has logs.
      (has_shelter ?p - player); the player has built the shelter.
      (has_fire ?p - player); the player has started a fire.
      (strained ?water - water) ; True if the water has been strained by using cloth
      (treated ?water - water) ; True if the water has been decontaimated by boiling it
      (at ?obj - object ?loc - location) ; an object is at a location 
      (inventory ?player ?item) ; an item is in the player's inventory
      (connected ?loc1 - location ?dir - direction ?loc2 - location) ; location 1 is connected to location 2 in the direction
      (blocked ?loc1 - location ?dir - direction ?loc2 - location) ; the connection between location 1 and 2 in currently blocked
   )
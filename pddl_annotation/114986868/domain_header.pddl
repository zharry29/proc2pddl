(define (domain survive_in_the_jungle)
   (:requirements :strips :typing)
   (:types
       water wood container drill spear fish foliage - item 
       player direction location
   )

   (:predicates
      (has_water ?loc - location) ; this location has a source of fresh water
      (has_tree ?loc - location) ; this location has trees
      (has_fish ?loc - location) ; this location has fish
      (has_fire ?loc - location) ; True if fire is created by the player at this location
      (has_shelter ?loc - location) ; True if shelter is created by the player at this location
      (boiled ?water - water) ; True if the water has been decontaimated by boiling it
      (filtered ?water - water) ; True if the water has been filtered
      (cooked ?fish - fish) ; True if the fish has been cooked
      (thirsty ?player) ; True if the player is thirsty
      (hungry ?player) ; True if the player is hungry
      (safe ?player ?loc - location) ; True if the player is safely living in shelter with weapon and fire on at this location
      (at ?obj - object ?loc - location) ; an object is at a location 
      (inventory ?player ?item) ; an item is in the player's inventory
      (connected ?loc1 - location ?dir - direction ?loc2 - location) ; location 1 is connected to location 2 in the direction
      (blocked ?loc1 - location ?dir - direction ?loc2 - location) ; the connection between location 1 and 2 in currently blocked
   )
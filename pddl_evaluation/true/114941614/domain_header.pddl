(define (domain survive_in_jungle)
   (:requirements :strips :typing)
   (:types
      eatable container igniter leaves fuel - item
      sticks - fuel
      water food - eatable
      player location direction
   )

   (:predicates
      (has_water_source ?loc - location) ; this location has a source of fresh water.
      (has_fire ?loc - location); this location has a man-made fire
      (has_tree ?loc - location); there is a tree at this location
      (has_sticks ?loc - location); there are sticks on the ground to be picked up, an infinite supply
      (has_shelter ?loc - location); there is a man-made shelter of sticks and leaves at this location
      (contains ?container - container ?water - water) ; links a container to the water that fills it
      (is_full ?container - container) ; True if the container is full
      (is_contaminated  ?eatable - eatable) ; True if the food is contaminated with bacteria in a way removable by cooking
      (is_poisonous ?eatable - eatable) ; True if the food is poisonous in a way not helped by cooking or killing "live" bacteria
      (is_sick ?p - player) ; True if the player is poisoned by consuming something contaminated or poisonous
      (is_hungry ?p - player) ; True if the player has not consumed a food
      (is_thirsty ?p - player) ; True if the player has not consumed water
      (is_tired ?p - player) ; True if the player has not slept
      (at ?obj - object ?loc - location) ; an object is at a location 
      (inventory ?player ?item) ; an item is in the player's inventory
      (connected ?loc1 - location ?dir - direction ?loc2 - location) ; location 1 is connected to location 2 in the direction
      (blocked ?loc1 - location ?dir - direction ?loc2 - location) ; the connection between location 1 and 2 in currently blocked
   )
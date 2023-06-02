(define (domain survive_on_a_desert_island)
  (:requirements :strips :typing)
  (:types
      water stick tarp leave - item
      player direction location
	  fish bird insect shellfish - animal
  )
 
  (:predicates
     (has_water_source ?loc - location) ; this location has a source of fresh water.
     (treated ?water - water) ; True if the water has been decontaminated by boiling it
     (at ?obj - object ?loc - location) ; an object is at a location
     (inventory ?player - player ?item - item) ; an item is in the player's inventory
     (connected ?loc1 - location ?dir - direction ?loc2 - location) ; location 1 is connected to location 2 in the direction
     (blocked ?loc1 - location ?dir - direction ?loc2 - location) ; the connection between location 1 and 2 in currently blocked
     (edible ?item); an item is edible
     (has_fish ?loc - location) ; this location has fish.
     (has_bird ?loc - location) ; this location has bird.
     (has_insect ?loc - location) ; this location has insect.
     (has_shellfish ?loc - location) ; this location has shellfish.
     (has_fire ?loc - location) ; this location has fire.
     (sheltered ?loc - location) ; this location is sheltered.
  )
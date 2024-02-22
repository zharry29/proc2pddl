(define (domain survive_deserted_island)
   (:requirements :strips :typing)
   (:types
       water wood fire rock leaves tinder raft vines spear fish - item
       beach jungle ocean treetop - location 
       player survivor - human
   )

   (:predicates
      (treated ?water - water) ; True if the water has been decontaimated by boiling it
      (groove ?wood - wood) ; True if a small groove is made in wood to start a fire
      (at ?obj - object ?loc - location) ; an object is at a location 
      (inventory ?player ?item) ; an item is in the player's inventory
      (connected ?loc1 - location ?dir - direction ?loc2 - location) ; location 1 is connected to location 2 in the direction
      (has_water_source ?loc - location) ; this location has a source of fresh water.
      (has_wood ?loc - location) ; this location has a wood
      (can_light_fire ?loc - location); this location is safe for lighting a fire
      (has_fire ?loc - location); this location has a fire going
      (has_shelter ?loc - location); this location has a shelter
      (drank ?water - water); the player drinks water
      (has_friend ?survivor - survivor); the player has found a survivor
      (has_escaped ?player - player) ; the player has built a raft and left with his fellow survivors
      (at_ocean ?loc - location) ; see if a location has access to the ocean
      (is_safe ?loc -location) ; see if a location is safe to make shelter on 
      (has_fish ?loc - location) ; see if location has fish to catch
      (cooked ?item - item) ; see if item is cooked
   )
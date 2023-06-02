(define (domain survive_in_the_jungle)
   (:requirements :strips :typing)
   (:types
       stone wood bamboo_container water fire sos_sign fruit - item 
       basecamp - location
       ill dehydrated hungry - condition
       player
       direction 
   )

   (:predicates
      (has_bamboo ?loc - location) ; this location has bamboo to create a container
      (has_rainfall ?loc - location) ; this location has received rainfall to collect water
      (has_fruit ?loc - location) ; this location has fruits to pick
      (treated ?water - water) ; True if the water has been decontaimated by boiling it
      (is ?c - condition ?p - player) ; True if the player is under the specified condition
      (at ?obj - object ?loc - location) ; an object is at a location 
      (inventory ?player ?item) ; an item is in the player's inventory
      (connected ?loc1 - location ?dir - direction ?loc2 - location) ; location 1 is connected to location 2 in the direction
      (blocked ?loc1 - location ?dir - direction ?loc2 - location) ; the connection between location 1 and 2 in currently blocked
   )
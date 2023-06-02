(define (domain survive_nuclear_attack)
   (:requirements :strips :typing)
   (:types player location direction item plan)

   (:predicates
      (is_supermarket ?loc - location) ; this location sells grocery
      (is_nonperishable ?obj - item) ; an item is a non-perishable food 
      (is_medicine ?obj - item) ; an item is a medicine
      (is_construction_material ?obj - item) ; an item can be used to reinforce a location 
      (is_home ?l1- location) ; this location is player's home
      (is_pharmacy ?l1 - location) ; this location is a pharmacy
      (is_car ?obj - item) ; an item is a vehicle to move through blockade
      (is_underground ?l1 -location) ;  
      (sheltered ?p -player) ; the player is in a sheltered place
      (driving ?p - player) ; the player is driving
      (at ?obj - item ?loc - location) ; an item is at a location 
      (inventory ?player ?item) ; an item is in the player's inventory
      (has_plan ?p - player); the player has made a plan to survive
      (connected ?loc1 - location ?dir - direction ?loc2 - location) ; location 1 is connected to location 2 in the direction
      (blocked ?loc1 - location ?dir - direction ?loc2 - location) ; the connection between location 1 and 2 in currently blocked
   )
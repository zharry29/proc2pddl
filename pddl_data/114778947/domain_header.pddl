(define (domain lock_picking)
   (:requirements :strips :typing)
   (:types
       player direction location item
   )

   (:predicates
      (has_easy_lock ?loc - location) ; this location has an easy lock.
      (has_hard_lock ?loc - location) ; this location has a hard lock.
      (wrench_in_lock ?loc - location) ; there is a wrench in the lock 
      (pick_in_lock ?loc - location) ; there is a pick in the lock 
      (weatherstripping_removed ?loc - location) ; there is no weatherstripping 
      (coathanger_inserted ?loc - location) ; coathanger is inserted
      (latch_hooked ?loc - location) ; latch is hooked
      (locked_car ?loc - location) ; this location is locked a car.
      (at ?obj - object ?loc - location) ; an object is at a location 
      (inventory ?player ?item) ; an item is in the player's inventory
      (connected ?loc1 - location ?dir - direction ?loc2 - location) ; location 1 is connected to location 2 in the direction
      (blocked ?loc1 - location ?dir - direction ?loc2 - location) ; the connection between location 1 and 2 in currently blocked
   )
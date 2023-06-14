
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

   (:action drive
      :parameters (?dir - direction ?p - player ?l1 - location ?l2 - location) 
      :precondition (and (at ?p ?l1) (connected ?l1 ?dir ?l2) (driving ?p) )
      :effect (and (at ?p ?l2) (not (at ?p ?l1)))
   )

   (:action walk
      :parameters (?dir - direction ?p - player ?l1 - location ?l2 - location) 
      :precondition (and (at ?p ?l1) (connected ?l1 ?dir ?l2) (not (blocked ?l1 ?dir ?l2)) )
      :effect (and (at ?p ?l2) (not (at ?p ?l1)))
   )

   (:action get_food
      :parameters (?obj - item ?p - player ?l1 - location) 
      :precondition (and (at ?p ?l1) (at ?obj ?l1) (is_supermarket ?l1) (is_nonperishable ?obj) (has_plan ?p))
      :effect (and (inventory ?p ?obj))
   )

   (:action get
      :parameters (?obj - item ?p - player ?l1 - location) 
      :precondition (and (at ?p ?l1) (at ?obj ?l1) (not (is_supermarket ?l1)))
      :effect (and (inventory ?p ?obj))
   )

   (:action drop
      :parameters (?obj - item ?p - player ?l1 - location) 
      :precondition (and (inventory ?p ?obj) (at ?p ?l1))
      :effect (and (at ?obj ?l1))
   )
  
  (:action make_plan
      :parameters (?p - player ?l1 - location) 
      :precondition (and (at ?p ?l1) (is_home ?l1))
      :effect (and (has_plan ?p))
   )

  (:action get_medicine
      :parameters (?obj -item ?p - player ?l1 - location) 
      :precondition (and (at ?p ?l1) (is_pharmacy ?l1) (has_plan ?p))
      :effect (and (inventory ?p ?obj))
  )

  (:action reinforce
      :parameters (?p - player ?l1 - location ?obj - item) 
      :precondition (and (at ?p ?l1) (has_plan ?p) (inventory ?p ?obj) (is_construction_material ?obj))
      :effect (and (reinforced ?l1) )
  )

  (:action stay_in_shelter
      :parameters (?p - player ?l1 - location ?obj1 - item ) 
      :precondition (and (at ?p ?l1) (has_plan ?p) (inventory ?p ?obj1) (is_nonperishable ?obj1) (reinforced ?l1) (is_underground ?l1))
      :effect (and (sheltered ?p) )
  )

  (:action get_in_car
      :parameters (?p - player ?l1 - location ?obj - item)
      :precondition (and (at ?p ?l1) (inventory ?p ?obj) (is_car ?obj))
      :effect (and (driving ?p) (inventory ?p ?obj))
  )

)

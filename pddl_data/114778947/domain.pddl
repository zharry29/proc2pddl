
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

   (:action go ; navigate to an adjacent location 
      :parameters (?dir - direction ?p - player ?l1 - location ?l2 - location) 
      :precondition (and (at ?p ?l1) (connected ?l1 ?dir ?l2) (not (blocked ?l1 ?dir ?l2)))
      :effect (and (at ?p ?l2) (not (at ?p ?l1)))
   )

   (:action get ; pick up an item and put it in the inventory
      :parameters (?item - item ?p - player ?l1 - location) 
      :precondition (and (at ?p ?l1) (at ?item ?l1))
      :effect (and (inventory ?p ?item) (not (at ?item ?l1)))
   )

   (:action pick_lock_with_card ; pick lock
      :parameters (?p - player ?loc - location) 
      :precondition (and (at ?p ?loc) (has_easy_lock ?loc) (inventory ?p credit_card)) 
      :effect (not (has_easy_lock ?loc))
   )
   
   (:action file_key_into_wrench ; make wrench from allen key
      :parameters (?p - player) 
      :precondition (and (inventory ?p allen_key) (inventory ?p file)) 
      :effect (and (not (inventory ?p allen_key)) (inventory ?p wrench)) 
   )

   (:action bend_paperclip_into_pick  ; bend paperclip into pick 
      :parameters (?p - player) 
      :precondition (and (inventory ?p paper_clip)) 
      :effect (and (not (inventory ?p paper_clip)) (inventory ?p pick)) 
   )

   (:action insert_wrench ; insert wrench 
      :parameters (?p - player ?loc - location) 
      :precondition (and (at ?p ?loc) (has_hard_lock ?loc) (inventory ?p wrench)) 
      :effect (and (wrench_in_lock ?loc))
   )

   (:action insert_pick ; insert pick
      :parameters (?p - player ?loc - location) 
      :precondition (and (at ?p ?loc) (has_hard_lock ?loc) (inventory ?p pick) (wrench_in_lock ?loc)) 
      :effect (and (pick_in_lock ?loc))
   )

   (:action push_pins_out_of_tumblers ; pick lock with wrench and pick
      :parameters (?p - player ?loc - location) 
      :precondition (and (at ?p ?loc) (has_hard_lock ?loc) (wrench_in_lock ?loc) (pick_in_lock ?loc))
      :effect (not (has_hard_lock ?loc))
   )
    
   (:action straighten_coathanger ; straighten coathanger
      :parameters (?p - player) 
      :precondition (and (inventory ?p coathanger)) 
      :effect (and (not (inventory ?p coathanger)) (inventory ?p straightened_coathanger)) 
   )

   (:action lift_weatherstripping ;    lift weatherstripping 
      :parameters (?p - player ?loc - location) 
      :precondition (and (at ?p ?loc) (locked_car ?loc)) 
      :effect (and (weatherstripping_removed ?loc))
   )

  (:action insert_hanger ;    insert hanger 
      :parameters (?p - player ?loc - location) 
      :precondition (and (at ?p ?loc) (locked_car ?loc) (inventory ?p straightened_coathanger)) 
      :effect (and (coathanger_inserted ?loc))
   )

  (:action hook_latch ;    hook onto car latch  
      :parameters (?p - player ?loc - location) 
      :precondition (and (at ?p ?loc) (locked_car ?loc) (coathanger_inserted ?loc) (inventory ?p straightened_coathanger)) 
      :effect (and (latch_hooked ?loc))
   )

  (:action pull_coathanger ;  unlock the car
      :parameters (?p - player ?loc - location) 
      :precondition (and (at ?p ?loc) (locked_car ?loc) (coathanger_inserted ?loc) (inventory ?p straightened_coathanger) (latch_hooked ?loc)) 
      :effect (not (locked_car ?loc))
   )

)

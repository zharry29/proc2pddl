
(define (domain survive_shark_attack)
   (:requirements :strips :typing)
   (:types
       body - item 
       player direction location
       part shark ship
   )

   (:predicates
      (is_water ?loc - location) ; this location is water
      (visible ?obj - object) ; if object is visible (shark, ship)
      (wounded ?player) ; if player is wounded
      (defending ?player) ; if player is in defensive position
      (attacked ?player ?shark) ; if the shark is attacking the person
      (at ?obj - object ?loc - location) ; an object is at a location 
      (inventory ?player ?item) ; an item is in the player's inventory
      (connected ?loc1 - location ?dir - direction ?loc2 - location) ; location 1 is connected to location 2 in the direction
      (on ?player ?ship) ; be on an object (here, the ship)
      (vulnerable ?part) ; if the body part of the shark is vulnerable
      (sharp ?obj - object) ; if the object is sharp enough (the tool)
      (heavy ?obj - object) ; if the object is heavy enough (the tool)
      (fleed ?shark) ; if the shark has fleed
      (dizzy ?shark) ; if the shark is dizzy
   )

   (:action splash_swim ; swim with loud sounds - you don't get to monitor the shark!
      :parameters (?dir - direction ?p - player ?l1 - location ?l2 - location ?s - shark) 
      :precondition (and (at ?p ?l1) (connected ?l1 ?dir ?l2))
      :effect (and (at ?p ?l2) (not (at ?p ?l1)) (at ?s ?l2) (not (visible ?s)) (attacked ?p ?s))
   )
   
   (:action swim ; swim normally till you reach safety!
      :parameters (?dir - direction ?p - player ?l1 - location ?l2 - location ?s - shark) 
      :precondition (and (at ?p ?l1) (connected ?l1 ?dir ?l2) (not (attacked ?p ?s)))
      :effect (and (at ?p ?l2) (not (at ?p ?l1)) (at ?s ?l2) (not (visible ?s)))
   )

   (:action get ; pick up an item and put it in the inventory
      :parameters (?item - item ?p - player ?l1 - location) 
      :precondition (and (at ?p ?l1) (at ?item ?l1))
      :effect (and (inventory ?p ?item) (not (at ?item ?l1)))
   )

   (:action onboard ; get on to the ship
      :parameters (?p - player ?shp - ship ?loc - location) 
      :precondition (and (at ?p ?loc) (at ?shp ?loc) (visible ?shp))
      :effect (and (on ?p ?shp))
   )
   
   (:action defend ; defend yourself
      :parameters (?p - player ?s - shark) 
      :precondition (and (attacked ?p ?s))
      :effect (and (not (attacked ?p ?s)) (wounded ?p) (defending ?p))
   )

   (:action spot_ship ; spot ships that are nearby
      :parameters (?p - player ?loc - location ?shp - ship) 
      :precondition (and (at ?p ?loc) (at ?shp ?loc))
      :effect (and (visible ?shp))
   )

   (:action spot_shark ; spot shark nearby
      :parameters (?p - player ?loc - location ?s - shark) 
      :precondition (and (at ?p ?loc) (at ?s ?loc))
      :effect (and (visible ?s))
   )

   (:action self_mobilize ; use your own body as weapons!
      :parameters (?p - player ?body - body)
      :effect (and (inventory ?p ?body))
   )

   (:action medicare ; get help from medicare, to deal with your wounds
      :parameters (?p - player ?sh - ship)
      :precondition (and (on ?p ?sh) (wounded ?p))
      :effect (and (not (wounded ?p)))
   )
   
   (:action attack_vulnerable ; attack shark on its eyes / gill / snout
      :parameters (?p - player ?s - shark ?tool - item ?pt - part ?loc - location ?sh - ship) 
      :precondition (and (at ?p ?loc) (at ?s ?loc) (inventory ?p ?tool) (vulnerable ?pt) (sharp ?tool) (not (on ?p ?sh)))
      :effect (and (fleed ?s) (not (attacked ?p ?s)))
   )

   (:action knockout ; attack shark on its eyes / gill / snout
      :parameters (?p - player ?s - shark ?tool - item ?pt - part ?loc - location ?sh - ship) 
      :precondition (and (at ?p ?loc) (at ?s ?loc) (inventory ?p ?tool) (vulnerable ?pt) (heavy ?tool) (not (on ?p ?sh)))
      :effect (and (dizzy ?s) (not (attacked ?p ?s)))
   )
   
)

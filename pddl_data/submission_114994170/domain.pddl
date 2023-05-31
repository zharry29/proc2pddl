
(define (domain survive_emp_attack)
   (:requirements :strips :typing)
   (:types
       item player direction location radio farraday_cage
   )

   (:predicates
      (has_batteries ?radio - radio) ; Returns true if the radio has batteries in it.
      (on ?radio - radio) ; Returns true if the radio is on
      (full ?it - item) ; Returns true if the item is filled with water
      (can_be_filled ?it - item) ; Returns true if the item can be filled with water
      (has_stopper ?it - item) ; Returns true if the item has a stopper 
      (cage_closed ?cage - farraday_cage)
      (in_cage ?it - item)
      (purified ?it - item); Returns true if the water in the item is purified
      (can_be_sealed ?it - item)
      (sealed ?it)

      (at ?obj - object ?loc - location) ; an object is at a location 
      (inventory ?player ?item) ; an item is in the player's inventory
      (connected ?loc1 - location ?dir - direction ?loc2 - location) ; location 1 is connected to location 2 in the direction
      (blocked ?loc1 - location ?dir - direction ?loc2 - location) ; the connection between location 1 and 2 in currently blocked
   )

   (:action get
      :parameters (?it - item ?l - location ?p - player)
      :precondition (and (at ?it ?l) (at ?p ?l))
      :effect (and (inventory ?p ?it) (not (at ?it ?l)))
   )

   (:action drop
      :parameters (?it - item ?l - location ?p - player)
      :precondition (and (inventory ?p ?it) (at ?p ?l))
      :effect (and (not (inventory ?p ?it)) (at ?it ?l))
   )

   (:action put_in_stopper
      :parameters (?it - item ?l - location ?p - player)
      :precondition (and (has_stopper ?it) (not (full ?it)) (at ?it ?l) (at ?p ?l))
      :effect (can_be_filled ?it)
   )

  (:action fill
      :parameters (?it - item ?l - location ?p - player)
      :precondition (and (can_be_filled ?it) (at ?p ?l) (at ?it ?l))
      :effect (full ?it)
   )

    (:action purify
      :parameters (?it - item ?l - location ?p - player)
      :precondition (and (at ?it ?l) (at ?p ?l) (full ?it) (inventory ?p purification_tablets) (not (sealed ?it)))
      :effect (and (purified ?it) (not (inventory ?p purification_tablets)))
   )

   (:action seal
      :parameters (?it - item ?l - location ?p - player)
      :precondition (and (can_be_sealed ?it) (at ?p ?l) (at ?it ?l))
      :effect (sealed ?it)
   )

   (:action wait
      :parameters (?p - player)
      :precondition (not (at ?p home))
      :effect (and (not (blocked work east backroads)) (not (blocked school north backroads)) 
              (not (blocked school west home)) (not (blocked home east school)))
   )


   (:action go
      :parameters (?dir - direction ?p - player ?l1 - location ?l2 - location) 
      :precondition (and (at ?p ?l1) (connected ?l1 ?dir ?l2) (not (blocked ?l1 ?dir ?l2)))
      :effect (and (at ?p ?l2) (not (at ?p ?l1)))
   )

   (:action put_batteries_in ; pick up an item and put it in the inventory
      :parameters (?p - player ?l1 - location ?radio - radio) 
      :precondition (and (at ?p ?l1) (inventory ?p batteries) (not (has_batteries ?radio)))
      :effect (has_batteries ?radio)
   )


   (:action turn_on_radio ; turn on the radio
      :parameters (?p - player ?loc - location ?radio - radio) 
      :precondition (and (at ?p ?loc) (at ?radio ?loc) (has_batteries ?radio))
      :effect (on ?radio)
   )

   (:action create_cage ; create a farraday cage
      :parameters (?p - player ?loc - location)
      :precondition (and (inventory ?p trashcan) (inventory ?p aluminum_foil))
      :effect (and (at farraday_cage ?loc) (not (inventory ?p trashcan)) (not (inventory ?p aluminum_foil)))
   )

   (:action close_cage ; Close the farraday cage
      :parameters (?p - player ?loc - location)
      :precondition (and (at farraday_cage ?loc) (inventory ?p trashlid))
      :effect (cage_closed farraday_cage)
   )


   (:action put_in_cage ; put item in the farraday cage
      :parameters (?p - player ?loc - location ?it - item)
      :precondition (and (at farraday_cage ?loc) (inventory ?p ?it))
      :effect (and (in_cage ?it) (not (inventory ?p ?it))  (not (cage_closed farraday_cage)))
   )

)

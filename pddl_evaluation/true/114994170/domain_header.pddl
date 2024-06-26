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
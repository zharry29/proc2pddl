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
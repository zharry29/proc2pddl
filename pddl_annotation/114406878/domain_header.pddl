(define (domain survive_in_the_woods)
   (:requirements :strips :typing)
   (:types
       grass branch log tinder kindling fuel teepee wood water pot - item
       player direction location
   )

   (:predicates
      (has_large_dry_branch ?loc - location) ; this location has large and dry branches that can be broken off as kindling material.
      (has_dry_oak ?loc - location)          ; this location has dry oak trees that can be logged for fuel.
      (has_dry_even_area ?loc - location)    ; this location has a dry, even area without things that could catch on fire.
      (has_pond ?loc - location)             ; this location has a pond with water
      (dry ?item)                            ; True if the item is try
      (ignited ?item)                        ; True if the item is ignited
      (boiled ?item)                         ; True if the item (namely water) has been boiled
      (at ?obj - object ?loc - location)     ; an object is at a location 
      (inventory ?player ?item)              ; an item is in the player's inventory
      (connected ?loc1 - location ?dir - direction ?loc2 - location) ; location 1 is connected to location 2 in the direction
      (blocked ?loc1 - location ?dir - direction ?loc2 - location)   ; the connection between location 1 and 2 in currently blocked
   )
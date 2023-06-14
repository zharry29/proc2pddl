(define (domain make_papyrus)
   (:requirements :strips :typing)
   (:types
       plant stalk strip sheet papyrus scissors wooden_board shell - item 
       player direction location
   )

   (:predicates
      (peeled ?stalk - stalk) ; True if the outer layer of the stalk has been removed
      (clean ?strip - strip) ; True if the strips have been soaked
      (flat ?sheet - sheet) ; True if the papyrus sheet has been pressed
      (very_flat ? sheet - sheet) ; True if the papyrus sheet has been flattened really hard
      (smooth ?sheet - sheet) ; True if the papyrus sheet has been polished
      (dry ?item - item) ; True if the object been dried out
      (has_water ?loc - location); True if location has water
      (has_hard_surface ?loc - location); True if location has hard surface
      (at ?obj - object ?loc - location) ; an object is at a location 
      (inventory ?player ?item) ; an item is in the player's inventory
      (connected ?loc1 - location ?dir - direction ?loc2 - location) ; location 1 is connected to location 2 in the direction
   )
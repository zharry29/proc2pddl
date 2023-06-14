(define (domain open_a_coconut)
   (:requirements :strips :typing)
   (:types
       appliance - location
       item player direction
   )

   (:predicates
      (on ?appliance); this appliance is on
      (at ?obj - object ?loc - location) ; an object is at a location 
      (inventory ?player ?item) ; an item is in the player's inventory
      (connected ?loc1 - location ?dir - direction ?loc2 - location) ; location 1 is connected to location 2 in the direction
      (wrapped ?item - item); item is wrapped
      (wrapped_with ?item1 - item ?item2 - item); item1 inside item 2
      (burnt ?item); item is burnt
      (pierced ?item); item is pierced
      (smashed ?item); item is smashed
      (empty ?item); item is empty
      (peeled ?item); item is peeled
      (test); a test stage for debugging
   )
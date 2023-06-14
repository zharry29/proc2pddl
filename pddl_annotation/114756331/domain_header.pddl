(define (domain get_out_of_quicksand)
    (:requirements :strips :typing)
    (:types
        stick - item
        player direction location quicksand
    )

   (:predicates
      (at ?obj - object ?loc - location) ; an object is at a location 
      (inventory ?player ?item) ; an item is in the player's inventory
      (connected ?loc1 - location ?dir - direction ?loc2 - location) ; location 1 is connected to location 2 in the direction
      (blocked ?loc1 - location ?dir - direction ?loc2 - location) ; the connection between location 1 and 2 in currently blocked
      (calm ?p - player) ; player is calm
      (laying ?p - player) ; player is laying on their back
      (tired ?p - player) ; player is tired
      (stuck ?p - player ?q - quicksand) ; player is in quicksand
      (deep ?q - quicksand) ; is the quicksand deep
      (has_ripples ?l - location) ; does this location have ripples 
      (aware ?p - player ?l - location) ; player is aware of possible quicksand in a location
      (has_quicksand ?l - location) ; does a location have quicksand 
   )
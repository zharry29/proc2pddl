
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

   (:action go ; navigate to an adjacent location 
      :parameters (?dir - direction ?p - player ?l1 - location ?l2 - location) 
      :precondition (and (at ?p ?l1) (connected ?l1 ?dir ?l2) (not (blocked ?l1 ?dir ?l2)) (aware ?p ?l1))
      :effect (and (at ?p ?l2) (not (at ?p ?l1)))
   )


   (:action get ; pick up an item and put it in the inventory
      :parameters (?i - item ?p - player ?l1 - location) 
      :precondition (and (at ?p ?l1) (at ?i ?l1))
      :effect (and (inventory ?p ?i) (not (at ?i ?l1)))
   )

   (:action breathe ; breathe in to fill your lungs with air
      :parameters (?p - player)
      :precondition (not (calm ?p))
      :effect (calm ?p)
   )

   (:action liedown ; player gets on their back
      :parameters (?p - player)
      :precondition (not (laying ?p))
      :effect (laying ?p)
   )

   (:action swim ; player starts to swim through the sand
      :parameters (?p - player ?q - quicksand)
      :precondition (and (laying ?p) (not (tired ?p)) (not (deep ?q)))
      :effect (and (tired ?p) (not (stuck ?p ?q)))
   )

   (:action usestick ; player uses the stick to help get out of sand
      :parameters (?p - player ?s - stick ?q - quicksand)
      :precondition (and (inventory ?p ?s) (laying ?p) (calm ?p))
      :effect (and (not (stuck ?p ?q)) (not (inventory ?p ?s)))
   )

   (:action rest ;player rests
      :parameters (?p - player)
      :precondition (tired ?p)
      :effect (not (tired ?p))
   )

   (:action drop ; player drops item
      :parameters (?p - player ?i - item)
      :precondition (inventory ?p ?i)
      :effect (not (inventory ?p ?i))
   )

   (:action check_ripples ; player checks the location for ripples
      :parameters (?p - player ?l - location)
      :precondition (and (at ?p l) (has_ripples ?l) (not (aware ?p)))
      :effect (aware ?p ?l)
   )

   (:action test_ground
      :parameters (?p - player ?l - location ?s - stick)
      :precondition (inventory ?p ?s)
      :effect (aware ?p ?l)
   )

   (:action research
      :parameters (?p - player ?l - location)
      :precondition (not (at ?p ?l))
      :effect (aware ?p ?l)
   )

   (:action move_horizontally
      :parameters (?p - player ?q - quicksand)
      :precondition (and (stuck ?p ?q) (not (deep ?q)) (calm ?p) (not (tired ?p)))
      :effect (not (stuck ?p ?q))
   )

)


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

   (:action drop
      :parameters (?i - item ?p - player ?l - location)
      :precondition (and (at ?p ?l) (inventory ?p ?i))
      :effect (and (at ?i ?l) (not (inventory ?p ?i)))
   )

   (:action pierce ; pierce the coconut
      :parameters (?p - player)
      :precondition (and (inventory ?p coconut) (not(pierced coconut)) (inventory ?p knife))
      :effect (pierced coconut)
   )

   (:action drain
      :parameters (?p - player ?l - location)
      :precondition (and (inventory ?p coconut) (pierced coconut) (not(smashed coconut)) (not(burnt coconut)) (at glass ?l) (at ?p ?l))
      :effect (and (inventory ?p coconut_juice) (empty coconut))
   )

   (:action turn_on_oven
      :parameters (?p - player)
      :precondition (and (at ?p oven) (not (on oven)))
      :effect (on oven)
   )

   (:action burn_item
      :parameters (?p - player)
      :precondition (and (at ?p oven) (on oven) (inventory ?p coconut) (empty coconut) (not(burnt coconut)) (not(smashed coconut)))
      :effect (burnt coconut)
   )

   (:action turn_off_oven
      :parameters (?p - player)
      :precondition (and (at ?p oven) (on oven))
      :effect (not (on oven))
   )

   (:action wrap_coconut
      :parameters (?p - player ?w - wrappable)
      :precondition (and (inventory ?p coconut) (not(wrapped coconut)) (not(smashed coconut)) (inventory ?p ?w))
      :effect (and (wrapped coconut) (wrapped_with coconut ?w) (not(inventory ?p ?w)))
   )

   (:action unwrap_coconut
      :parameters (?p - player ?w - wrappable)
      :precondition (and (inventory ?p coconut) (wrapped coconut) (wrapped_with coconut ?w))
      :effect (and (not (wrapped coconut)) (not(wrapped_with coconut ?w)) (inventory ?p ?w))
   )

   (:action smash_with_hands
      :parameters (?p - player)
      :precondition (and (inventory ?p coconut) (wrapped_with coconut bag) (not(smashed coconut)) (not(on oven)) (burnt coconut) (at ?p counter))
      :effect (smashed coconut)
   )

   (:action separate
      :parameters (?p - player ?w - wrappable)
      :precondition (and (inventory ?p coconut) (inventory ?p knife) (not (wrapped coconut)) (smashed coconut) (at towel counter) (at ?p counter))
      :effect (and (not (inventory ?p coconut)) (inventory ?p coconut_shell) (inventory ?p coconut_meat))
   )

   (:action peel
      :parameters (?p - player)
      :precondition (and (inventory ?p coconut_meat) (inventory ?p knife) (not(peeled coconut_meat)) (at towel counter) (at ?p counter))
      :effect (peeled coconut_meat)
   )

   (:action smash_with_mallet
      :parameters (?p - player)
      :precondition (and (inventory ?p coconut) (inventory ?p mallet) (wrapped_with coconut towel) (empty coconut) (not(burnt coconut)) (not(smashed coconut)) (at ?p counter))
      :effect (smashed coconut)
   )
)

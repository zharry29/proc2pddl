
(define (domain how_to_make_a_detective_kit)
   (:requirements :strips :typing)
   (:types
       bag - item 
       gloves - item
       tape - item
       chalk - item
       magnifying_glass - item
       costume - item
       flashlights - item
       pen - item
       notebook - item
       paper - item
       detective_notebook - item
       aluminium_foil - item
       cardboard - item
       badge - item
       walkie_talkies - item
       detective_kit - item
       player direction location disguise
   )

   (:predicates
      (sells_bags ?loc - location) ; this location sells bags.
      (sells_stationery ?loc - location) ; this location sells stationery.
      (sells_costume ?loc - location) ; this location sells costumes.
      (sells_electronics ?loc - location) ; this location sells electronics.
      (at ?obj - item ?loc - location) ; an object is at a location 
      (inventory ?player ?item) ; an item is in the player's inventory
      (connected ?loc1 - location ?dir - direction ?loc2 - location) ; location 1 is connected to location 2 in the direction
      (blocked ?loc1 - location ?dir - direction ?loc2 - location) ; the connection between location 1 and 2 in currently blocked
      (wear ?player ?costume) ; player wears his uniform
   )

   (:action go ; navigate to an adjacent location 
      :parameters (?dir - direction ?p - player ?l1 - location ?l2 - location) 
      :precondition (and (at ?p ?l1) (connected ?l1 ?dir ?l2) (not (blocked ?l1 ?dir ?l2)))
      :effect (and (at ?p ?l2) (not (at ?p ?l1)))
   )

   (:action get_bag ; get bag from a store.
      :parameters (?p - player ?loc - location ?bag - bag) 
      :precondition (and (at ?p ?loc) (sells_bag ?loc))
      :effect (and (inventory ?p ?bag))
   )

   (:action get_stationery ; get stationery from a store.
      :parameters (?p - player ?loc - location ?cardboard - cardboard ?pen - pen ?notebook - notebook ?paper - paper ?a - aluminium_foil) 
      :precondition (and (at ?p ?loc) (sells_stationery ?loc))
      :effect (and (inventory ?p ?cardboard) (inventory ?p ?pen) (inventory ?p ?notebook) (inventory ?p ?paper) (inventory ?p ?a))
   )

   (:action get_costume ; get costume from a store.
      :parameters (?p - player ?loc - location ?costume - costume) 
      :precondition (and (at ?p ?loc) (sells_costume ?loc))
      :effect (and (inventory ?p ?costume))
   )

   (:action wear_detective_gear ; wear a uniform to get ready for the detective job
      :parameters (?p - player ?costume - costume) 
      :precondition (and (inventory ?p ?costume))
      :effect (and (wear ?p ?costume))
   )

   (:action find_supplies_for_disguise ; find supplies to be an alias for an undercover mission
      :parameters (?p - player ?loc - location ?d1 - disguise ?d2 - disguise) 
      :precondition (and (at ?p ?loc) (at ?d1 ?loc) (at ?d2 ?loc))
      :effect (and (inventory ?p ?d1) (inventory ?p ?d2))
   )

   (:action wear_disguise ; wear a disguise to get ready for an undercover mission
      :parameters (?p - player ?d1 - disguise ?d2 - disguise) 
      :precondition (and (inventory ?p ?d1) (inventory ?p ?d2))
      :effect (and (wear ?p ?d1) (wear ?p ?d2))
   )

   (:action make_badge ; make a detective badge
      :parameters (?p - player ?p1 - paper ?c - cardboard ?a - aluminium_foil ?b - badge) 
      :precondition (and (inventory ?p ?p1) (inventory ?p ?c) (inventory ?p ?a))
      :effect (and (inventory ?p ?b))
   )

   (:action prepare_detective_notebook ; convert a notebook to a detective notebook
      :parameters (?p - player ?n - notebook ?dn - detective_notebook ?pen - pen) 
      :precondition (and (inventory ?p ?pen) (inventory ?p ?n))
      :effect (and (inventory ?p ?dn) (not (inventory ?p ?n)))
   )

   (:action get_walkie_talkies ; get walkie-talkies from the store
      :parameters (?p - player ?loc - location ?w - walkie_talkies) 
      :precondition (and (at ?p ?loc) (sells_electronics ?loc))
      :effect (and (inventory ?p ?w))
   )

   (:action prepare_detective_kit ; put everything in the detective kit
      :parameters (?p - player ?n - detective_notebook ?bag - bag ?b - badge ?w - walkie_talkies ?kit - detective_kit) 
      :precondition (and (inventory ?p ?n) (inventory ?p ?bag) (inventory ?p ?b) (inventory ?p ?w))
      :effect (and (inventory ?p ?kit))
   )

)

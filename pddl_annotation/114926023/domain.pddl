
(define (domain survive_on_a_deserted_island_with_nothing)
   (:requirements :strips :typing)
   (:types
       sharp_stone log small_sticks leaves vines raft_draft raft_finished - item
       player direction location roof wall shelter animal
   )

   (:predicates
      (at ?obj - object ?loc - location) ; an object is at a location 
      (inventory ?player ?item) ; an item is in the player's inventory
      (connected ?loc1 - location ?dir - direction ?loc2 - location) ; location 1 is connected to location 2 in the direction
      (treated ?animal - animal) ; True if the animal has been treated and is safe to eat
   )

   (:action go ; navigate to an adjacent location 
      :parameters (?dir - direction ?p - player ?l1 - location ?l2 - location) 
      :precondition (and (at ?p ?l1) (connected ?l1 ?dir ?l2))
      :effect (and (at ?p ?l2) (not (at ?p ?l1)))
   )

   (:action get ; pick up an item and put it in the inventory
      :parameters (?item - item ?p - player ?l1 - location) 
      :precondition (and (at ?p ?l1) (at ?item ?l1))
      :effect (and (inventory ?p ?item) (not (at ?item ?l1)))
   )

   (:action build_roof ; build roof with log.
      :parameters (?p - player ?loc - location ?i - log ?r - roof) 
      :precondition (and (at ?p ?loc) (inventory ?p ?i) (not (at ?r ?loc)))
      :effect (and (at ?r ?loc) (not (inventory ?p ?i)))
   )

   (:action build_wall ; build wall with small sticks.
      :parameters (?p - player ?loc - location ?i - small_sticks ?w - wall) 
      :precondition (and (at ?p ?loc) (inventory ?p ?i) (not (at ?w ?loc)))
      :effect (and (at ?w ?loc) (not (inventory ?p ?i)))
   )

   (:action build_bed ; build bed with leaves.
      :parameters (?p - player ?loc - location ?i - leaves ?b - bed) 
      :precondition (and (at ?p ?loc) (inventory ?p ?i) (not (at ?b ?loc)))
      :effect (and (at ?b ?loc) (not (inventory ?p ?i)))
   )

   (:action complete_shelter ; complete shelter with roof, wall and bed.
      :parameters (?p - player ?loc - location ?r - roof ?w - wall ?b - bed ?s - shelter) 
      :precondition (and (at ?p ?loc) (at ?b ?loc) (at ?r ?loc) (at ?w ?loc) (at ?b ?loc))
      :effect (and (at ?s ?loc))
   )

   (:action hunt_animal ; hunt animals with a sharp stone.
      :parameters (?p - player ?loc - location ?s - sharp_stone ?a - animal) 
      :precondition (and (at ?p ?loc) (at ?a ?loc) (inventory ?p ?s))
      :effect (and (inventory ?p ?a) (not (treated ?a)))
   )

   (:action prepare_animal ; prepare animals with a sharp stone before eating it.
      :parameters (?p - player ?loc - location ?s - sharp_stone ?a - animal) 
      :precondition (and (at ?p ?loc) (inventory ?p ?s) (inventory ?p ?a))
      :effect (and (treated ?a))
   )

    (:action build_raft ; build a raft.
      :parameters (?p - player ?l - log ?v - vines ?r - raft_draft) 
      :precondition (and (inventory ?p ?l) (inventory ?p ?v))
      :effect (and (inventory ?p ?r))
   )

   (:action test_raft ; test a raft before riding it.
      :parameters (?p - player ?loc - location ?rd - raft_draft ?rf - raft_finished) 
      :precondition (and (at ?p ?loc) (haswater ?loc) (inventory ?p ?rd))
      :effect (and (inventory ?p ?rf))
   )



)


(define (domain how_to_make_papyrus)
   (:requirements :strips :typing)
   (:types
      papyrus papyrus_tree papyrus_stalks papyrus_strips pruner scissors knife water bowl roller linen_cloth wooden_boards shell ivory smooth_stone bowl_of_water - item
      player direction location
   )

   (:predicates
      (at ?obj - object ?loc - location) ; an object is at a location 
      (inventory ?player ?item) ; an item is in the player's inventory
      (connected ?loc1 - location ?dir - direction ?loc2 - location) ; location 1 is connected to location 2 in the direction
      (strips_between_boards) ; papyrus strips are between two wooden boards
      (strips_woven) ; papyrus strips are woven together
      (polished ?papyrus) ; papyrus is polished
      (flattened ?papyrus) ; papyrus is flat
      (cut ?papyrus) ; papyrus is cut correctly
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

   (:action pour_water ; pour water into bowl
      :parameters (?p - player) 
      :precondition (and (inventory ?p water) (inventory ?p bowl))
      :effect (and (inventory ?p bowl_of_water) (not (inventory ?p water)) (not (inventory ?p bowl)))
   )

   (:action place_strips_between_boards ; place papyrus strips between two wooden boards
      :parameters (?p - player) 
      :precondition (and (inventory ?p wooden_boards) (inventory ?p papyrus_strips) (strips_woven))
      :effect (and (strips_between_boards ?item))
   )

   (:action cut_stalks ; cut stalks
      :parameters (?p - player ?tree - papyrus_tree ?l1 - location ?s - papyrus_stalks) 
      :precondition (and  (at ?p ?l1) (at ?tree ?l1) (inventory ?p scissors))
      :effect (and (inventory ?p ?s))
   )

    (:action papyrus_strips ; cut strips from stalks
      :parameters (?p - player ?tree - papyrus_tree ?l1 - location ?pst - papyrus_stalks ?strip - papyrus_strips) 
      :precondition (and  (at ?p ?l1) (at ?tree ?l1) (inventory ?p scissors) (inventory ?p ?pst))
      :effect (and (inventory ?p ?strip) (not (inventory ?p ?pst)))
   )

     (:action polish_papyrus ; Use a stone to polish the papyrus.
      :parameters (?p - player ?pap - papyrus) 
      :precondition (and (inventory ?p ?pap) (inventory ?p smooth_stone))
      :effect  (polished ?pap)
   )

    (:action flatten_papyrus ; Use a roller to make the papyrus flat.
      :parameters (?p - player ?pap - papyrus ?r - roller) 
      :precondition (and (inventory ?p ?pap) (inventory ?p ?r))
      :effect  (flattened ?pap)
   )

    (:action cut_papyrus ; Use a scissor to cut the papryus.
      :parameters (?p - player ?pap - papyrus ?s - scissors) 
      :precondition (and (inventory ?p ?pap) (inventory ?p ?s))
      :effect  (cut ?pap)
   )





)

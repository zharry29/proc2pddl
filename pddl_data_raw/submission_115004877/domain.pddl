
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


   (:action cut_plant ;
      :parameters (?p - player ?scissors - scissors ?plant - plant ?stalk - stalk) 
      :precondition  (and (inventory ?p ?scissors) (inventory ?p ?plant))
      :effect (and (inventory ?p ?stalk) (not (inventory ?p ?plant)) (not (peeled ?stalk)))
   )

   (:action peel_stalk ; 
      :parameters (?p - player ?stalk - stalk) 
      :precondition (and (not (peeled ?stalk)) (inventory ?p ?stalk))
      :effect (peeled ?stalk)
   )

   (:action cut_stalk_into_strips ; 
      :parameters (?p - player ?scissors - scissors ?stalk - stalk ?strip - strip) 
      :precondition (and (inventory ?p ?stalk) (inventory ?p ?scissors) (peeled ?stalk))
      :effect (and (inventory ?p ?strip) (not (inventory ?p ?stalk)) (not (clean ?strip)))
   )

   (:action soak_strips ; 
      :parameters (?p - player ?loc - location ?strip - strip) 
      :precondition (and (at ?p ?loc) (has_water ?loc) (inventory ?p ?strip))
      :effect (and (clean ?strip) (not (dry ?strip)))
   )

   (:action dry_out_strips ; 
      :parameters (?p - player ?strip - strip) 
      :precondition (and (inventory ?p ?strip) (clean ?strip))
      :effect (dry ?strip)
   )

   (:action weave_strips_into_sheet ; 
      :parameters (?p - player ?loc - location ?strip - strip ?sheet - sheet) 
      :precondition (and (at ?p ?loc) (has_hard_surface ?loc) (inventory ?p ?strip) (dry ?strip))
      :effect (and (inventory ?p ?sheet) (not (inventory ?p ?strip)) (not (flat ?sheet)))
   )

   (:action press_sheet ; 
      :parameters (?p - player ?loc - location ?wooden_board - wooden_board ?sheet - sheet) 
      :precondition (and (at ?p ?loc) (has_hard_surface ?loc) (inventory ?p ?wooden_board) (inventory ?p ?sheet))
      :effect (and (flat ?sheet) (not (very_flat ?sheet)))
   )

   (:action flatten_sheet ; 
      :parameters (?p - player ?loc - location ?sheet - sheet) 
      :precondition (and (at ?p ?loc) (has_hard_surface ?loc) (inventory ?p ?sheet) (flat ?sheet))
      :effect (and (very_flat ?sheet) (not (smooth ?sheet)))
   )

   (:action polish_sheet ; 
      :parameters (?p - player ?loc - location ?sheet - sheet ?shell - shell) 
      :precondition (and (at ?p ?loc) (has_hard_surface ?loc) (inventory ?p ?sheet) (inventory ?p ?shell) (very_flat ?sheet))
      :effect (and (not (inventory ?p ?shell)) (smooth ?sheet))
   )

   (:action cut_sheet ; 
      :parameters (?p - player ?loc - location ?sheet - sheet ?scissors - scissors ?papyrus - papyrus) 
      :precondition (and (inventory ?p ?scissors) (smooth ?sheet))
      :effect (inventory ?p ?papyrus)
   )
)


(define (domain open_a_coconut)
   (:requirements :strips :typing)
   (:types
       coconut coconut_wrapped coconut_broken coconut_meat coconut_meat_peeled tool container_without_water container_with_water towel mallet peeler - item
   )

   (:predicates
      (inventory ?item) ; a item is in the inventory
      (has_eyes_poked ?c - coconut) ; True if the coconut has its eyes poked 
      (is_item_container_with_water ?cow - container_with_water) ; True if the item is the container with water filled
      (is_item_wrapped_coconut ?c - coconut_wrapped) ; True if the item is a coconut wrapped in towel
      (is_item_broken_coconut ?c - coconut_broken) ; True if the item is a broken coconut
      (is_item_coconut_meat ?c - coconut_meat) ; True if the item is a the coconut meat
      (is_item_coconut_meat_peeled ?c - coconut_meat_peeled) ; True if the item is a the peeled coconut meat
   )

   (:action get ; pick up a item and put it in the inventory
      :parameters (?item - item) 
      :precondition (and (not (is_item_container_with_water ?item)) (not (is_item_wrapped_coconut ?item)) (not (is_item_broken_coconut ?item)) (not (is_item_coconut_meat_peeled ?item)) (not (is_item_coconut_meat ?item)) (not (inventory ?item)))
      :effect (and (inventory ?item))
   )

   (:action poke ; poke a hole in the top of the coconut
      :parameters (?c - coconut ?tool - tool) 
      :precondition (and (inventory ?tool) (inventory ?c) (not (has_eyes_poked ?c)))
      :effect (and (has_eyes_poked ?c))
   )

   (:action flip ; turn the coconut upside down
      :parameters (?c - coconut ?co - container_without_water ?cow - container_with_water) 
      :precondition (and (inventory ?co) (inventory ?c) (has_eyes_poked ?c))
      :effect (and (not (inventory ?co)) (inventory ?cow))
   )

   (:action wrap ; wrap the coconut
      :parameters (?c - coconut ?cow - container_with_water ?cw - coconut_wrapped ?t - towel) 
      :precondition (and (inventory ?c) (inventory ?t) (inventory ?cow))
      :effect (and (not (inventory ?c)) (inventory ?cw))
   )

   (:action hit ; hit the wrapped coconut with a mallet
      :parameters (?cw - coconut_wrapped ?m - mallet ?cb - coconut_broken) 
      :precondition (and (inventory ?m) (inventory ?cw))
      :effect (and (not (inventory ?cw)) (inventory ?cb))
   )
   
   (:action free ; run a knife between the shell and the meat to free it
      :parameters (?cm - coconut_meat ?t - tool ?cb - coconut_broken) 
      :precondition (and (inventory ?t) (inventory ?cb))
      :effect (and (not (inventory ?cb)) (inventory ?cm))
   )

   (:action remove_fiber ; remove the fiber from the meat
      :parameters (?cm - coconut_meat ?p - peeler ?cp - coconut_meat_peeled) 
      :precondition (and (inventory ?p) (inventory ?cm))
      :effect (and (not (inventory ?cm)) (inventory ?cp))
   )
)

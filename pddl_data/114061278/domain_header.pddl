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
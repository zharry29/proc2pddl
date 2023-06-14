
(define (problem free_the_meat_from_coconut)
   (:domain open_a_coconut)

   (:objects
      coconut - coconut
      coconut_wrapped - coconut_wrapped
      coconut_broken - coconut_broken
      coconut_meat - coconut_meat
      coconut_meat_peeled - coconut_meat_peeled
      knife screwdriver - tool
      glass - container_without_water
      glass_filled - container_with_water
      towel - towel
      mallet - mallet
      peeler - peeler
   )

   (:init
      (is_item_container_with_water glass_filled)
      (is_item_wrapped_coconut coconut_wrapped)
      (is_item_broken_coconut coconut_broken)
      (is_item_coconut_meat coconut_meat)
      (is_item_coconut_meat_peeled coconut_meat_peeled)
   )

   (:goal (and (inventory coconut_meat)))
)

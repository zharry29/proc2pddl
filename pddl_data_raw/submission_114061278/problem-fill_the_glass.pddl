
(define (problem fill_the_glass)
   (:domain open_a_coconut)

   (:objects
      coconut - coconut
      knife screwdriver - tool
      glass - container_without_water
      glass_filled - container_with_water
   )

   (:init
      (is_item_container_with_water glass_filled)
   )

   (:goal (and (inventory glass_filled)))
)

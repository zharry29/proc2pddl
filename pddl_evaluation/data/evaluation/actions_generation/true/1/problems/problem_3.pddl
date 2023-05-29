
(define (problem soak_and_flatten_papyrus_strips)
   (:domain how_to_make_papyrus)

   (:objects
      npc - player
      kitchen refrigerator cabinet drawer - location
      north south east west open close - direction
      papyrus_strips - papyrus_strips
      bowl - bowl
      water - water
      bowl_of_water - bowl_of_water
      roller - roller
      wooden_boards - wooden_boards
      linen_cloth - linen_cloth
   )

   (:init
      (inventory npc papyrus_strips)
      (is_flat_surface table)
      (connected kitchen east refrigerator)
      (connected refrigerator west kitchen)
      (connected kitchen north cabinet)
      (connected cabinet south kitchen)
      (connected cabinet open drawer)
      (connected drawer close cabinet)
      (at npc kitchen)
      (at water refrigerator)
      (at bowl cabinet)
      (at roller drawer)
      (at linen_cloth drawer)
      (at wooden_boards cabinet)
   )

   (:goal (strips_between_boards))
)


(define (problem finishing_papyrus)
   (:domain how_to_make_papyrus)

   (:objects
      npc - player
      kitchen refrigerator cabinet living_room - location
      east west north south - direction
      papyrus_tree - papyrus_tree
      bowl - bowl
      water - water
      bowl_of_water - bowl_of_water
      refrigerator - item
      scissors - scissors
      papyrus_stalks - papyrus_stalks
      papyrus_strips - papyrus_strips
      smooth_stone - smooth_stone
      papyrus - papyrus
      roller - roller
      
   )
   (:init
      (connected kitchen east refrigerator)
      (connected refrigerator west kitchen)
      (connected kitchen north cabinet)
      (connected cabinet south kitchen)
      (connected living_room north kitchen)
      (connected kitchen south living_room)
      (at npc kitchen)
      (at papyrus kitchen)
      (at water refrigerator)
      (at bowl cabinet)
      (at roller cabinet)
      (at papyrus_tree kitchen)
      (at scissors kitchen)
      (at smooth_stone living_room)
   )

   (:goal (and (cut papyrus) (polished papyrus) (flattened papyrus)))
)

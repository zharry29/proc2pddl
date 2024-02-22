
(define (problem preparing_papyrus)
   (:domain how_to_make_papyrus)

   (:objects
      npc - player
      kitchen refrigerator cabinet - location
      east west north south - direction
      papyrus_tree - papyrus_tree
      bowl - bowl
      water - water
      bowl_of_water - bowl_of_water
      refrigerator - item
      scissors - scissors
      papyrus_stalks - papyrus_stalks
      papyrus_strips - papyrus_strips
      
   )
   (:init
      (connected kitchen east refrigerator)
      (connected refrigerator west kitchen)
      (connected kitchen north cabinet)
      (connected cabinet south kitchen)
      (at npc kitchen)
      (at water refrigerator)
      (at bowl cabinet)
      (at papyrus_tree kitchen)
      (at scissors kitchen)
   )

   (:goal (and (inventory npc papyrus_strips)))
)

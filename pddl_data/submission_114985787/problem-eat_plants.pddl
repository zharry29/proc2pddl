
(define (problem eat_plants)
   (:domain survive_in_the_woods)

   (:objects
      npc - player
      waterfall camp path cliff mountain east_plain west_plain - location
      in out north south east west up down - direction
      water - water
      leaves - leaves
      flowers - flowers
   )

   (:init
      (connected camp west path)
      (connected path east camp)
      (connected path west cliff)
      (connected cliff east path)
      (connected cliff up waterfall)
      (connected waterfall down cliff)
      (connected waterfall east mountain)
      (connected mountain west waterfall)
      (connected mountain east west_plain)
      (connected west_plain west mountain)
      (connected west_plain east east_plain)
      (connected east_plain west west_plain)
      (at npc camp)
      (at canteen camp)
      (has_water_source waterfall)
      (at flowers mountain)
      (at leaves east_plain)
      (edible leaves) 
      (edible flowers) 
      (unwashed leaves)
      (unwashed flowers)
      (hungry npc)     
   )

   (:goal (and (not (hungry npc))))
)

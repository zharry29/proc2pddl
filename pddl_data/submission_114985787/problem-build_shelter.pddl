
(define (problem build_shelter)
   (:domain survive_in_the_woods)

   (:objects
      npc - player
      waterfall camp path cliff mountain east_plain west_plain - location
      in out north south east west up down - direction
      water - water
      branch - branch
      branches - branches
      twigs - twigs
      leaves - leaves
      tree - tree
      beam -  beam
      frame - frame
      shelter - shelter
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
      (at branch mountain)
      (long branch)
      (thick branch)
      (at branches east_plain)
      (at twigs east_plain)
      (at leaves east_plain)
      (has_bug leaves)
      (at tree west_plain)
      (has_split_in_trunk tree)
      (dry west_plain)
      (flat west_plain)
      
   )

   (:goal (and (at shelter west_plain) (at npc west_plain)))
)

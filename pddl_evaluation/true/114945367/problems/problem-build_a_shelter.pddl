(define (problem build_a_shelter)
   (:domain survive_in_the_woods)

   (:objects
      npc - player
      waterfall camp path cliff - location
      in out north south east west up down - direction
      long_branch - long_branch
      propped_branches - propped_branches
      twigs_leaves - twigs_leaves
   )

   (:init
      (connected camp west path)
      (connected path east camp)
      (connected path west cliff)
      (connected cliff east path)
      (connected cliff up waterfall)
      (connected waterfall down cliff)
      (at npc camp)
      (at canteen camp)
      (has_branches path)
      (has_twigs_leaves path)
   )

   (:goal (and (has_shelter npc)))
)
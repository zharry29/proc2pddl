(define (problem start_a_fire)
   (:domain survive_in_the_woods)

   (:objects
      npc - player
      waterfall camp path cliff - location
      in out north south east west up down - direction
      logs - logs
      twigs_leaves - twigs_leaves
      dry_materials - dry_materials
      teepee - teepee
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
      (has_logs path)
      (has_branches path)
      (has_twigs_leaves path)
      (has_dry_materials path)
   )

   (:goal (and (has_fire ?p)))
)
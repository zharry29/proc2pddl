
(define (problem build_snare)
   (:domain survive_in_the_woods)

   (:objects
      npc - player
      waterfall camp path cliff mountain east_plain west_plain footpath - location
      in out north south east west up down - direction
      branch - branch
      wire - wire
      snare - snare
      bar - bar
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
      (connected waterfall west footpath)
      (connected footpath east waterfall)
      (at npc camp)
      (at canteen camp)
      (has_water_source waterfall)
      (at flowers mountain)
      (at leaves east_plain)
      (at branch mountain)
      (at wire path)
      (made_by_animal footpath)
   )

   (:goal (and (hanged snare) (at snare footpath)))
)


(define (problem boil_water)
   (:domain survive_in_the_woods)

   (:objects
      npc - player
      camp path grassland bush oaks wilderness - location
      in out north south east west up down - direction
      axe - item
      grass dry_grass - grass
      branch - branch
      oak_log - log
      grass_tinder - tinder
      branch_piece - kindling
      log_stack - fuel
      teepee_structure - teepee
      flat_wood - wood
      pot - pot
      water - water
   )

   (:init
      (connected camp west path)
      (connected path east camp)
      (connected path north grassland)
      (connected grassland south path)
      (connected grassland north bush)
      (connected bush south grassland)
      (connected path west wilderness)
      (connected wilderness east path)
      (connected path south oaks)
      (connected oaks north path)
      (at npc camp)
      (at pot camp)
      (at axe camp)
      (at grass grassland)
      (at flat_wood oaks)
      (has_large_dry_branch bush)
      (has_dry_oak oaks)
      (has_dry_even_area camp)
      (has_pond grassland)
   )

   (:goal (and (inventory npc water) (boiled water)))
)

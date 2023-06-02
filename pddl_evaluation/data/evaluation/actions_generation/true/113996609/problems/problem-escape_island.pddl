
(define (problem escape_island)
   (:domain survive_deserted_island)

   (:objects
      person - player
      river beach jungle ocean - location
      in out north south east west up down - direction
      water - water
      wood - wood
      tinder - tinder
      rock - rock
      fire - fire
      survivor - survivor
      vines - vines
   )

   (:init
      (connected beach west ocean)
      (connected ocean east beach)
      (connected beach east jungle)
      (connected river west jungle)
      (connected jungle east river)
      (connected jungle north cave)
      (connected jungle west beach)
      (at person beach)
      (at rock ocean)
      (at tinder beach)
      (at vines jungle)
      (at survivor river)
      (has_wood jungle)
      (has_water_source river)
      (can_light_fire beach)
      (at_ocean beach)
   )

   (:goal (and (has_escaped person)))
)

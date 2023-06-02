
(define (problem start_fire)
   (:domain survive_deserted_island)

   (:objects
      person - player
      beach jungle ocean - location
      in out north south east west up down - direction
      wood - wood
      tinder - tinder
      rock - rock
      fire - fire
   )

   (:init
      (connected beach west ocean)
      (connected ocean east beach)
      (connected beach east jungle)
      (connected jungle north cave)
      (connected jungle west beach)
      (at person beach)
      (at rock ocean)
      (at tinder beach)
      (has_wood jungle)
      (can_light_fire beach)
   )

   (:goal (and (at fire beach)))
)

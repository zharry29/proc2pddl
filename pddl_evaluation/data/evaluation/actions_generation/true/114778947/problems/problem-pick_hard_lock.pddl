
(define (problem pick_hard_lock)
   (:domain lock_picking)

   (:objects
      npc - player
      garage bathroom kitchen bedroom hallway office living_room - location
      in out north south east west up down - direction
      allen_key file credit_card paper_clip bobby_pin - item
   )

   (:init
      (connected garage up kitchen)
      (connected kitchen down garage)
      (connected kitchen west office)
      (connected office east kitchen)
      (connected office west living_room)
      (connected living_room east office)
      (connected living_room up hallway)
      (connected hallway down living_room)
      (connected hallway east bathroom)
      (connected bathroom west hallway)
      (connected bathroom east bedroom)
      (connected bedroom west bathroom)
      (at npc living_room)
      (at credit_card kitchen)
      (at paper_clip office)
      (at allen_key garage)
      (at file garage)
      (at bobby_pin bathroom)
      (has_hard_lock bedroom)
   )

   (:goal (not (has_hard_lock bedroom) ) )
)

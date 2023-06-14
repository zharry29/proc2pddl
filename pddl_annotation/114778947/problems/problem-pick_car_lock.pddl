
(define (problem pick_car_lock)
   (:domain lock_picking)

   (:objects
      npc - player
      car garage bathroom kitchen bedroom hallway office living_room - location
      in out north south east west up down - direction
      coathanger credit_card paper_clip bobby_pin - item
   )

   (:init
      (connected garage out car)
      (connected car in garage)
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
      (at bobby_pin bathroom)
      (at coathanger bedroom)
      (locked_car car)
   )

   (:goal (not (locked_car car) ) )
)

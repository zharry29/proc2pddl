
(define (problem hunger)
   (:domain survive_in_the_jungle)

   (:objects
      npc - player
      jungle bamboo_forrest basecamp - location
      in out north south east west up down - direction
      stone wood sos_sign - item
      ill dehydrated hungry - condition
   )

   (:init
      (at npc basecamp)
      (connected basecamp west bamboo_forrest)
      (connected bamboo_forrest east basecamp)
      (connected basecamp east jungle)
      (connected jungle west basecamp)

      (has_bamboo bamboo_forrest)
      (has_fruit jungle)
      (has_rainfall jungle)

      (at stone bamboo_forrest)
      (at stone basecamp)
      (at wood jungle)
      
      (is dehydrated npc)
      (is hungry npc)
   )

   (:goal (not (is hungry npc)))
)

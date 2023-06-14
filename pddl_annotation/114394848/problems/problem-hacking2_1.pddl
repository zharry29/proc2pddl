
(define (problem hacking1)
   (:domain how_to_hack)

   (:objects
      npc - player
      next - direction
      securing_machine knowing_target - location
      white_permission - permission
   )

   (:init
     (connected securing_machine next knowing_target)
     (blocked securing_machine next knowing_target)
     
     (at npc securing_machine)
     (at white_permission securing_machine)
   )
   (:goal  (at npc knowing_target) ); 
)

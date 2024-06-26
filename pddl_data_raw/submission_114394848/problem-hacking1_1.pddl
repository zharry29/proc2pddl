
(define (problem build_foundation)
   (:domain how_to_hack)

   (:objects
       npc  - player
       next - direction

       ; NEW --------------------------------------------
       ; new hacking states
       rookie   - location
       skilled  - location

       ; concepts
       c_hacking - hacking
       c_ethics  - ethics
       
       ; skills
       s_html   - html
       s_search - search

       s_cpp    - cpp
       s_php    - php
       s_py     - py
       s_bash   - bash
       s_asb    - assembly

       s_unix   - unix
   )

   (:init
       (at npc rookie)


       (connected rookie next skilled)
       (blocked   rookie next skilled)
   )
   
   ; (:goal (learned npc s_cpp))
   (:goal (at npc skilled))
)

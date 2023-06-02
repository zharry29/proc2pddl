
(define (problem move_to_bunker)
   (:domain survive_comet_hitting_earth)

   (:objects
      npc - player
      home market weapon_market - location
      in out north south east west up down - direction
      water - water 
      food - food 
      medicine - medicine
      pistol ammunition - weapon
      bunker1 bunker2 - bunker

   )

   (:init
      (connected home west market)
      (connected market east home)
      (connected market west weapon_market)
      (connected weapon_market east market)
      (connected home north bunker1)
      (connected bunker1 south home)
      (connected bunker1 north bunker2)
      (connected bunker2 south bunker1)
      (has_air_filtration_system bunker1)
      (has_air_filtration_system bunker2) 
      (has_strong_material bunker2)
      (at npc home)
      (at food market)
      (at water market)
      (at medicine market)
      (at pistol weapon_market)
      (at ammunition weapon_market)
   )

   (:goal (and (outfit_bunker_with_heat bunker2) (enough_supplies) (enough_weapons) ))
)

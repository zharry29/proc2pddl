
(define (problem final)
   (:domain survive_comet_hitting_earth)

   (:objects
      npc family - player
      market - market
      weapon_market - weapon_market
      home - location
      Philly Salt_Lake Beijing - city
      in out north south east west up down - direction
      water - water 
      food - food 
      medicine - medicine
      heat - energy_source
      pistol - pistol 
      ammunition - ammunition
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
      (in family Beijing)
      (at npc home)
      (has_pc npc)
      (in npc Philly)
      (coastal Philly)
      (inland Salt_Lake)
      (at food market)
      (at water market)
      (at medicine market)
      (at pistol weapon_market)
      (at ammunition weapon_market)
      (at heat market)
   )

   (:goal (and (in npc Salt_Lake) (enjoylife npc bunker2) (family_memebers_know_you_are_safe) ))
)

(define (domain survive_comet_hitting_earth)
   (:requirements :strips :typing)
   (:types

       food water medicine energy_source - item 
       weapon - item
       pistol ammunition - weapon
       bunker city market weapon_market - location
       player direction
   )

   (:predicates
      (inventory ?it - item) ; an item in the player's inventory
      (at ?obj - object ?loc - location) ; an object is at a location
      (in ?obj - object ?c - city) ; an object is in a city
      (enough_supplies)      
      (connected ?loc1 - location ?dir - direction ?loc2 - location) ; location 1 is connected to location 2 in the direction
      (has_air_filtration_system ?bk - bunker) ; bunker has air filtration system
      (has_strong_material ?bk - bunker) ; bunker has strong material
      (has_pc ?p) ; has a pc to listen to broadcast
      (listen_to_broadcast ?p - player ?l - location); listen to astronomers predictions on collision with earth
      (coastal ?c - city) ; coastal area
      (inland ?c - city) ;  inland area
      
   )
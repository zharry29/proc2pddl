
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
      (enough_weapons)   
      (connected ?loc1 - location ?dir - direction ?loc2 - location) ; location 1 is connected to location 2 in the direction
      (has_air_filtration_system ?bk - bunker) ; bunker has air filtration system
      (has_strong_material ?bk - bunker) ; bunker has strong material
      (has_pc ?p - player) ; has a pc to listen to broadcast
      (find_good_bunker ?bk - bunker) ;
      (outfit_bunker_with_heat ?bk - bunker) ;
      (enjoylife ?p - player ?bk - bunker) ;
      (family_memebers_know_you_are_safe)
      (listen_to_broadcast ?p - player ?l - location); listen to astronomers’ predictions on collision with earth
      (coastal ?c - city) ; coastal area
      (inland ?c - city) ;  inland area
   )  

   (:action listen_to_astronomers_predictions ; listen to astronomers predictions on collision with earth
      :parameters (?p - player ?l1 - location) 
      :precondition (and (at ?p ?l1) (has_pc ?p))
      :effect (and (listen_to_broadcast ?p ?l1))
   )

   (:action move_away ; flight from coastal area to inland area 
      :parameters (?p - player ?c1 - city ?c2 - city ?l1 - location) 
      :precondition (and (in ?p ?c1) (coastal ?c1) (inland ?c2) (listen_to_broadcast ?p ?l1))
      :effect (and (in ?p ?c2) (not (in ?p ?c1)))
   )

   (:action go ; navigate to an adjacent location 
      :parameters (?dir - direction ?p - player ?l1 - location ?l2 - location) 
      :precondition (and (at ?p ?l1) (connected ?l1 ?dir ?l2) (not (blocked ?l1 ?dir ?l2)))
      :effect (and (at ?p ?l2) (not (at ?p ?l1)))
   )

   (:action buy_supplies ; buy supplies and put it in the inventory
      :parameters (?item - item ?p - player ?l1 - market) 
      :precondition (and (at ?p ?l1) (at ?item ?l1))
      :effect (and (inventory ?item))
   )

   (:action check_supplies ; check enough supplies in the inventory
      :parameters (?fd - food ?wt - water ?md - medicine) 
      :precondition (and (inventory ?fd) (inventory ?wt) (inventory ?md))
      :effect (and (enough_supplies))
   )

   (:action buy_weapons ; buy weapons and put it in the inventory (after buy_supplies)
      :parameters (?wp - weapon ?p - player ?l1 - weapon_market) 
      :precondition (and (at ?p ?l1) (at ?wp ?l1) (enough_supplies))
      :effect (and (inventory ?wp))
   )

   (:action check_weapons ; check enough supplies in the inventory
      :parameters (?ps - pistol ?am - ammunition) 
      :precondition (and (inventory ?ps) (inventory ?am))
      :effect (and (enough_weapons))
   )

   (:action check_bunker ; check if the bunker is good for sheiding
      :parameters (?bk - bunker ?p - player) 
      :precondition (and (at ?p ?bk) (enough_supplies) (enough_weapons) (has_air_filtration_system ?bk) (has_strong_material ?bk))
      :effect (and (find_good_bunker ?bk))
   )

   (:action outfit_bunker_with_energy_source ; outfit your bunker with an energy source for heat
      :parameters (?bk - bunker ?p - player ?es - energy_source) 
      :precondition (and (at ?p ?bk) (find_good_bunker ?bk) (inventory ?es))
      :effect (and (outfit_bunker_with_heat ?bk))
   )

   (:action enjoylife ; after all preparation, enjoy life in a bunker
      :parameters (?bk - bunker ?p - player ) 
      :precondition (and (at ?p ?bk) (outfit_bunker_with_heat ?bk))
      :effect (and (enjoylife ?p ?bk))
   )

   (:action connect_through_social_media_with_family ; let other family members know you are safe
      :parameters (?bk - bunker ?p - player ?f - player ?c - city) 
      :precondition (and (at ?p ?bk) (has_pc ?p) (enjoylife ?p ?bk) (not(at ?f ?bk)) (in ?p ?c) (not (in ?f ?c)) )
      :effect (and (family_memebers_know_you_are_safe))
   )
   

)

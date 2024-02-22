
(define (domain survive_in_the_jungle)
   (:requirements :strips :typing)
   (:types
       stone wood bamboo_container water fire sos_sign fruit - item 
       basecamp - location
       ill dehydrated hungry - condition
       player
       direction 
   )

   (:predicates
      (has_bamboo ?loc - location) ; this location has bamboo to create a container
      (has_rainfall ?loc - location) ; this location has received rainfall to collect water
      (has_fruit ?loc - location) ; this location has fruits to pick
      (treated ?water - water) ; True if the water has been decontaimated by boiling it
      (is ?c - condition ?p - player) ; True if the player is under the specified condition
      (at ?obj - object ?loc - location) ; an object is at a location 
      (inventory ?player ?item) ; an item is in the player's inventory
      (connected ?loc1 - location ?dir - direction ?loc2 - location) ; location 1 is connected to location 2 in the direction
      (blocked ?loc1 - location ?dir - direction ?loc2 - location) ; the connection between location 1 and 2 in currently blocked
   )

   (:action go ; navigate to an adjacent location 
      :parameters (?dir - direction ?p - player ?l1 - location ?l2 - location) 
      :precondition (and (at ?p ?l1) (connected ?l1 ?dir ?l2) (not (blocked ?l1 ?dir ?l2)))
      :effect (and (at ?p ?l2) (not (at ?p ?l1)))
   )

   (:action get ; pick up an item and put it in the inventory
      :parameters (?item - item ?p - player ?l1 - location) 
      :precondition (and (at ?p ?l1) (at ?item ?l1))
      :effect (and (inventory ?p ?item) (not (at ?item ?l1)))
   )

   (:action get_bamboo_container; get a bamboo container using surrounding bamboo
      :parameters (?p - player ?loc - location)
      :precondition (and (at ?p ?loc) (has_bamboo ?loc))
      :effect (inventory ?p bamboo_container)
   )

   (:action collect_rain_water
      :parameters (?p - player ?loc - location)
      :precondition (and (at ?p ?loc) (inventory ?p bamboo_container) (has_rainfall ?loc))
      :effect (and (inventory ?p water) (not (treated water)))
   ) 

   (:action create_fire
      :parameters (?p - player ?loc - location)
      :precondition (and (at ?p ?loc) (inventory ?p stone) (inventory ?p wood))
      :effect (and (at fire ?loc) (not (inventory ?p stone)) (not (inventory ?p wood)))
   )

   (:action treat_water
      :parameters (?p - player ?loc - location)
      :precondition (and (inventory ?p water) (not (treated water)) (at fire ?loc))
      :effect (and (treated water))
   )

   (:action drink_water
      :parameters (?p - player)
      :precondition (and (inventory ?p water) (treated water))
      :effect (not (is dehydrated ?p))
   )

   (:action drink_untreated_water
      :parameters (?p - player)
      :precondition (and (inventory ?p water) (not (treated water)))
      :effect (is ill ?p)
   )

   (:action create_sos_sign
      :parameters (?p - player)
      :precondition (and (inventory ?p stone) (at ?p basecamp))
      :effect (and (not (inventory ?p stone)) (at sos_sign basecamp))
   )

   (:action pick_fruit
      :parameters (?p - player ?loc - location)
      :precondition (and (at ?p ?loc) (has_fruit ?loc))
      :effect (inventory ?p fruit)
   )

   (:action eat_fruit
      :parameters (?p - player)
      :precondition (and (is hungry ?p) (inventory ?p fruit))
      :effect (and (not (inventory ?p fruit)) (not (is hungry ?p)))
   )

   (:action escape
      :parameters (?p - player)
      :precondition (and (at ?p basecamp) (at sos_sign basecamp) (not (is hungry ?p)) (not (is dehydrated ?p)) (not (is ill ?p)))
      :effect (not (at ?p basecamp))
   )
)

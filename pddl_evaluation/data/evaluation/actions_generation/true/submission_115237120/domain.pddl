
(define (domain survive_a_war)
   (:requirements :strips :typing)
   (:types 
      player direction 
      food bandage rock pot fishingpole fish water - item 
      car - location
   )
   
   (:predicates
      (is_injured ?player - player) ; player is injured
      (in_shelter ?player - player) ; player is in a location with a basement
      (outdoors ?loc - location) ; this location outdoors.
      (has_water_source ?loc - location) ; this location has a source of fresh water.
      (treated ?water - water) ; True if the water has been decontaimated by boiling it
      (has_basement ?location - location) ; this location has a basement.
      (has_windows ?car - car) ; this location has a basement.
      (is_occupied ?location - location) ; this location already has occupants.
      (at ?obj - object ?loc - location) ; an object is at a location 
      (inventory ?player ?item) ; an item is in the player's inventory
      (haslake ?location)
      (gettable ?item)
      (connected ?loc1 - location ?dir - direction ?loc2 - location) ; location 1 is connected to location 2 in the direction
      (blocked ?loc1 - location ?dir - direction ?loc2 - location) ; the connection between location 1 and 2 in currently blocked
   )

   (:action go
      :parameters (?dir - direction ?p - player ?l1 - location ?l2 - location) 
      :precondition (and (at ?p ?l1) (connected ?l1 ?dir ?l2) (not (blocked ?l1 ?dir ?l2)))
      :effect (and (at ?p ?l2) (not (at ?p ?l1)))
   )

   (:action get
      :parameters (?p - player ?l - location ?i - item)
      :precondition (and (at ?p ?l) (at ?i ?l) (gettable ?i))
      :effect (and (not (at ?i ?l)) (inventory ?p ?i))
   )

   (:action drop
      :parameters (?p - player ?l - location ?i - item)
      :precondition (and (inventory ?p ?i) (at ?p ?l))
      :effect (and (not (inventory ?p ?i)) (at ?i ?l))
   )

   (:action get_water ; get water from a location that has a water source like a lake.
      :parameters (?p - player ?loc - location ?water - water) 
      :precondition (and (at ?p ?loc) (has_water_source ?loc))
      :effect (and (inventory ?p ?water) (not (treated ?water)))
   )

   (:action boil_water ; boil water that has not been treated.
      :parameters (?p - player ?loc - location ?water - water ?pot - pot) 
      :precondition (and (inventory ?p ?water) (inventory ?p ?pot) (not (treated ?water)))
      :effect (and (treated ?water))
   )

   (:action collect_rain_water ; collect rain water to be treated.
      :parameters (?p - player ?loc - location ?pot - pot ?water - water) 
      :precondition (and (inventory ?p ?pot) (at ?p ?loc) (outdoors ?loc))
      :effect (and (inventory ?p ?water) (not (treated ?water)))
   )

   (:action loot_shelter ; steal food from location that is occupied.
      :parameters (?p - player ?loc - location ?food - food) 
      :precondition (and (at ?food ?loc) (at ?p ?loc) (is_occupied ?loc))
      :effect (and (inventory ?p ?food) (not (at ?food ?loc)))
   )

   (:action break_car_window ; steal food from car.
      :parameters (?p - player ?car - car ?rock - rock ?item - item) 
      :precondition (and (at ?p ?car) (inventory ?p ?rock) (has_windows ?car) (at ?item ?car))
      :effect (and (gettable ?item) (not (inventory ?p ?rock)) (not (has_windows ?car)))
   )

   (:action gofish 
      :parameters (?p - player ?l - location ?fp - fishingpole ?f - fish)
      :precondition (and (at ?p ?l) (inventory ?p ?fp) (haslake ?l) (at ?f ?l))
      :effect (and (gettable ?f) )
   )

   (:action find_shelter 
      :parameters (?p - player ?l - location)
      :precondition (and (at ?p ?l) (has_basement ?l) (not (is_occupied ?l)) )
      :effect (and (in_shelter ?p))
   )
   
   (:action clean_wound ; heal injury.
      :parameters (?p - player ?water - water ?bandage - bandage) 
      :precondition (and (inventory ?p ?water) (treated ?water) (inventory ?p ?bandage) (is_injured ?p))
      :effect (and (not (is_injured ?p)) (not (inventory ?p ?water)) (not (inventory ?p ?bandage)) )
   )

   (:action clean_others_wound ; heal injury.
      :parameters (?p - player ?p_inj - player ?water - water ?bandage - bandage) 
      :precondition (and (inventory ?p ?water) (treated ?water) (inventory ?p ?bandage) (is_injured ?p_inj))
      :effect (and (not (is_injured ?p_inj)) (not (inventory ?p ?water)) (not (inventory ?p ?bandage)) )
   )

   (:action barter_food_for_healing ; get food in exchange for healing.
      :parameters (?p - player ?p_inj - player ?water - water ?bandage - bandage ?food - food ?l -location) 
      :precondition (and (inventory ?p ?water) (inventory ?p ?bandage) (is_injured ?p_inj) (at ?p ?l) (at ?p_inj ?l))
      :effect (and (not (is_injured ?p_inj)) (gettable ?food)  )
   )

   
)

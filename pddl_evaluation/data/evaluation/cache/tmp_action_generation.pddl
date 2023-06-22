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
   )(:action go
 :parameters (?player - player ?dir - direction ?loc1 - location ?loc2 - location)
 :precondition (and (at ?player ?loc1) (connected ?loc1 ?dir ?loc2) (not (blocked ?loc1 ?dir ?loc2)))
 :effect (and (not (at ?player ?loc1)) (at ?player ?loc2))
)

(:action get
 :parameters (?player - player ?item - item ?loc - location)
 :precondition (and (at ?player ?loc) (at ?item ?loc) (gettable ?item))
 :effect (and (not (at ?item ?loc)) (inventory ?player ?item))
)

(:action drop
 :parameters (?player - player ?item - item ?loc - location)
 :precondition (and (at ?player ?loc) (inventory ?player ?item))
 :effect (and (not (inventory ?player ?item)) (at ?item ?loc))
)

(:action get_water
 :parameters (?player - player ?loc - location ?water - water)
 :precondition (and (at ?player ?loc) (has_water_source ?loc))
 :effect (inventory ?player ?water)
)

(:action boil_water
 :parameters (?player - player ?water - water)
 :precondition (and (inventory ?player ?water) (not (treated ?water)))
 :effect (treated ?water)
)

(:action collect_rain_water
 :parameters (?player - player ?loc - location ?water - water)
 :precondition (and (at ?player ?loc) (outdoors ?loc))
 :effect (inventory ?player ?water)
)

(:action loot_shelter
 :parameters (?player - player ?loc - location ?supplies - item)
 :precondition (and (at ?player ?loc) (not (is_occupied ?loc)))
 :effect (inventory ?player ?supplies)
)

(:action break_car_window
 :parameters (?player - player ?loc - location ?car - car ?item - item)
 :precondition (and (at ?player ?loc) (has_windows ?car))
 :effect (and (not (has_windows ?car)) (inventory ?player ?item))
)

(:action gofish
 :parameters (?player - player ?loc - location ?fishingpole - fishingpole ?fish - fish)
 :precondition (and (at ?player ?loc) (haslake ?loc) (inventory ?player ?fishingpole))
 :effect (inventory ?player ?fish)
)

(:action find_shelter
 :parameters (?player - player ?loc - location)
 :precondition (and (at ?player ?loc) (has_basement ?loc))
 :effect (in_shelter ?player)
)

(:action clean_wound
 :parameters (?player - player ?water - water)
 :precondition (and (is_injured ?player) (inventory ?player ?water) (treated ?water))
 :effect (not (is_injured ?player))
)

(:action clean_others_wound
 :parameters (?player - player ?other - player ?water - water)
 :precondition (and (is_injured ?other) (inventory ?player ?water) (treated ?water))
 :effect (not (is_injured ?other))
)

(:action barter_food_for_healing
 :parameters (?player - player ?food - food)
 :precondition (and (is_injured ?player) (inventory ?player ?food))
 :effect (and (not (is_injured ?player)) (not (inventory ?player ?food)))
)

)
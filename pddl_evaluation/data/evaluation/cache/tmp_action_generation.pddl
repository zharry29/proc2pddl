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
    :parameters (?player - player ?current_loc ?destination_loc - location ?dir - direction)
    :precondition (and
        (at ?player ?current_loc)
        (connected ?current_loc ?dir ?destination_loc)
        (not (blocked ?current_loc ?dir ?destination_loc))
    )
    :effect (and
        (not (at ?player ?current_loc))
        (at ?player ?destination_loc)
    )
)

(:action get
    :parameters (?player - player ?item - item ?loc - location)
    :precondition (and
        (at ?player ?loc)
        (at ?item ?loc)
        (gettable ?item)
    )
    :effect (and
        (not (at ?item ?loc))
        (inventory ?player ?item)
    )
)

(:action drop
    :parameters (?player - player ?item - item ?loc - location)
    :precondition (and
        (inventory ?player ?item)
        (at ?player ?loc)
    )
    :effect (and
        (not (inventory ?player ?item))
        (at ?item ?loc)
    )
)

(:action get_water
    :parameters (?player - player ?container - pot ?loc - location)
    :precondition (and
        (at ?player ?loc)
        (has_water_source ?loc)
        (inventory ?player ?container)
    )
    :effect (and
        (not (inventory ?player ?container))
        (inventory ?player (filled_container ?container))
    )
)

(:action boil_water
    :parameters (?player - player ?fire ?filled_container ?treated_container)
    :precondition (and
        (inventory ?player ?filled_container)
        (inventory ?player ?fire)
    )
    :effect (and
        (not (inventory ?player ?filled_container))
        (inventory ?player ?treated_container)
        (treated ?treated_container)
    )
)

(:action collect_rain_water
    :parameters (?player - player ?container - pot ?loc - location)
    :precondition (and
        (at ?player ?loc)
        (inventory ?player ?container)
        (rainy ?loc)
    )
    :effect (and
        (not (inventory ?player ?container))
        (inventory ?player (filled_container ?container))
    )
)

(:action loot_shelter
    :parameters (?player - player ?loc - location ?item - item)
    :precondition (and
        (at ?player ?loc)
        (not (is_occupied ?loc))
        (at ?item ?loc)
    )
    :effect
        (and
            (not (at ?item ?loc))
            (inventory ?player ?item)
        )
)

(:action break_car_window
    :parameters (?player - player ?car - car)
    :precondition (and
        (at ?player ?car)
        (has_windows ?car)
        (not (is_blocked ?car))
    )
    :effect (not (has_windows ?car))
)

(:action gofish
    :parameters (?player - player ?loc - location)
    :precondition (and
        (at ?player ?loc)
        (haslake ?loc)
        (inventory ?player fishingpole)
    )
    :effect (inventory ?player - fish)
)

(:action find_shelter
    :parameters (?player - player ?loc - location)
    :precondition (and
        (at ?player ?loc)
        (has_shelter ?loc)
    )
    :effect (is_occupied ?loc)
)

(:action clean_wound
    :parameters (?player - player)
    :precondition (and
        (inventory ?player - bandage)
        (inventory ?player - disinfectant)
        (is_injured ?player)
    )
    :effect (and
        (not (is_injured ?player))
        (not (inventory ?player - bandage))
        (not (inventory ?player - disinfectant))
    )
)

(:action clean_others_wound
    :parameters (?player ?other_player - player)
    :precondition (and
        (inventory ?player - bandage)
        (inventory ?player - disinfectant)
        (is_injured ?other_player)
    )
    :effect (and
        (not (is_injured ?other_player))
        (not (inventory ?player - bandage))
        (not (inventory ?player - disinfectant))
    )
)

(:action barter_food_for_healing
    :parameters (?player ?other_player - player ?food - food)
    :precondition (and
        (is_injured ?player)
        (inventory ?player ?food)
    )
    :effect (and
        (not (is_injured ?player))
        (not (inventory ?player ?food))
        (inventory ?other_player ?food)
    )
)

)
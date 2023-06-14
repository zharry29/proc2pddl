;Header and description

(define (domain survive_on_a_deserted_island_with_nothing)

    ;remove requirements that are not needed
    (:requirements :strips :typing :negative-preconditions)

    (:types ;todo: enumerate types and their hierarchy here, e.g. car truck bus - vehicle
        water wood sharp_stone weapon - item
        saltwater freshwater - water
        softwood hardwood_stick tinder - wood
        spear - weapon
        plant campfire - scenery
        bag canteen - container
        fish - food
        player direction location
        
    )

    ; un-comment following line if constants are needed
    ;(:constants )

    (:predicates ;todo: define predicates here
        (has_water ?loc - location) ; This location is a source of water (possibly saltwater)
        (has_freshwater_source ?loc - location) ; this location has a source of fresh water.
        (treated ?water - water) ; True if the water has been decontaimated by boiling it
        (at ?obj - object ?loc - location) ; an object is at a location 
        (inventory ?player ?item) ; an item is in the player's inventory
        (connected ?loc1 - location ?dir - direction ?loc2 - location) ; location 1 is connected to location 2 in the direction
        (blocked ?loc1 - location ?dir - direction ?loc2 - location) ; the connection between location 1 and 2 in currently blocked
        (bagged ?plant - plant) ;True if plant is bagged
        (has_tinder ?loc -location) ;this location has gatherable tinder
        (lit ?campfire -campfire) ;True if campfire is lit
        (has_fish ?loc - location) ;this location has fish to catch
        (cooked ?food -food) ;True if food is cooked
        (wet ?tinder -tinder) ;True if tinder is wet (to make smoke)
        (signaling ?campfire - campfire) ;True if campfire is acting as a smoke signal
    )

    ; (:functions ;todo: define numeric functions here
    ; )

    ;define actions here

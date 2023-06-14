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
    (:action get_water ; get water from a location that has a water source like a lake.
        :parameters (?p - player ?loc - location ?water - water) 
        :precondition (and (at ?p ?loc) (has_freshwater_source ?loc))
        :effect (and (inventory ?p ?water) (not (treated ?water)))
    )
    (:action bag_plant
        :parameters (?plant - plant ?p - player ?bag - bag ?loc - location)
        :precondition (and (at ?p ?loc) (at ?plant ?loc) (inventory ?p ?bag))
        :effect (and (bagged ?plant)(not (inventory ?p ?bag)))
    )
    (:action wait_and_gather_bagged_plant
        :parameters (?plant - plant ?p - player ?loc - location ?water - freshwater)
        :precondition (and (at ?p ?loc) (at ?plant ?loc) (bagged ?plant))
        :effect (and (not (bagged ?plant)) (inventory ?p ?water) (not (treated ?water)))
    )
    (:action gather_tinder
        :parameters (?p - player ?loc - location ?tinder - tinder)
        :precondition (and (at ?p ?loc) (has_tinder ?loc))
        :effect (and (inventory ?p ?tinder))
    )
    (:action build_campfire
        :parameters (?p -player ?loc - location ?tinder - tinder ?campfire - campfire)
        :precondition (and (at ?p ?loc) (inventory ?p ?tinder))
        :effect (and (at ?campfire ?loc) (not (inventory ?p ?tinder)))
    )
    (:action light_campfire
        :parameters (?p -player ?loc - location ?softwood - softwood ?hardwood - hardwood_stick ?campfire - campfire)
        :precondition (and (at ?p ?loc) (at ?campfire ?loc) (not (lit ?campfire)) (inventory ?p ?softwood) (inventory ?p ?hardwood))
        :effect (and (lit ?campfire))
    )
    (:action make_spear
        :parameters (?p -player ?stick - hardwood_stick ?stone - sharp_stone ?spear - spear) 
        :precondition (and (inventory ?p ?stick) (inventory ?p ?stone))
        :effect (and (inventory ?p ?spear) (not(inventory ?p ?stick)) (not (inventory ?p ?stone)))
    )
    
    (:action spear_fish
        :parameters (?p - player ?loc - location ?spear - spear ?fish - fish)
        :precondition (and (at ?p ?loc) (has_fish ?loc) (inventory ?p ?spear))
        :effect (and (inventory ?p ?fish))
    )
    (:action cook_fish
        :parameters (?p -player ?loc - location ?fish - fish ?campfire - campfire )
        :precondition (and (at ?p ?loc)(at ?campfire ?loc)(inventory ?p ?fish))
        :effect (and (cooked ?fish))
    )
    (:action wet_tinder
        :parameters (?p - player ?loc - location ?tinder - tinder)
        :precondition (and (at ?p ?loc)(has_water ?loc)(inventory ?p ?tinder))
        :effect (and (wet ?tinder))
    )
    (:action make_smoke_signal
        :parameters (?p - player ?loc - location ?campfire - campfire ?tinder - tinder)
        :precondition (and (at ?p ?loc)(at ?campfire ?loc)(inventory ?p ?tinder)(wet ?tinder))
        :effect (and (signaling ?campfire)(not (wet ?tinder))(not (inventory ?p ?tinder)))
    )
    
    
    
    
    
)
(define (domain anime-party)
  (:requirements :strips :typing)
  (:types
    player location direction
    food drink - item
  )

  (:predicates
    (at ?obj - object ?loc - location) ; an object is at a location 
    (inventory ?player ?item) ; an item is in the player's inventory
    (has_kitchen ?l - location) ; a location has a kitchen
    (has_fridge ?l - location) ; a location has a fridge
    (connected ?loc1 - location ?dir - direction ?loc2 - location) ; location 1 is connected to location 2 in the direction
    (inflated ?balloon - item) ; the balloon is blown up
    (hung ?lamp - item) ; the lamp is hung
    (opened ?drink - drink) ; the drink is uncorked
    (on ?tv - item) ; the tv is turned on
  )(:action go
    :parameters (?player - player ?dir - direction ?loc1 - location ?loc2 - location)
    :precondition (and
        (at ?player ?loc1)
        (connected ?loc1 ?dir ?loc2))
    :effect (and
        (not (at ?player ?loc1))
        (at ?player ?loc2)))

(:action get
    :parameters (?player - player ?item - item ?loc - location)
    :precondition (and
        (at ?player ?loc)
        (at ?item ?loc))
    :effect (and
        (not (at ?item ?loc))
        (inventory ?player ?item)))

(:action drop
    :parameters (?player - player ?item - item ?loc - location)
    :precondition (and
        (at ?player ?loc)
        (inventory ?player ?item))
    :effect (and
        (not (inventory ?player ?item))
        (at ?item ?loc)))

(:action cook
    :parameters (?player - player ?food - food ?loc - location)
    :precondition (and
        (at ?player ?loc)
        (has_kitchen ?loc))
    :effect (prepared ?food))

(:action order_sushi
    :parameters (?player - player)
    :precondition (at ?player ?loc)
    :effect (prepared ?sushi - food))

(:action buy_sake
    :parameters (?player - player)
    :precondition (at ?player ?loc)
    :effect (inventory ?player ?sake - drink))

(:action serve
    :parameters (?player - player ?item - item ?loc - location)
    :precondition (and
        (at ?player ?loc)
        (prepared ?item)
        (inventory ?player ?item))
    :effect (served ?item))

(:action brew
    :parameters (?player - player ?drink - drink ?loc - location)
    :precondition (and
        (at ?player ?loc)
        (has_fridge ?loc))
    :effect (prepared ?drink))

(:action get_beer
    :parameters (?player - player ?beer - drink ?loc - location)
    :precondition (and
        (at ?player ?loc)
        (has_fridge ?loc)
        (prepared ?beer))
    :effect (and
        (not (prepared ?beer))
        (inventory ?player ?beer)))

(:action open
    :parameters (?player - player ?drink - drink)
    :precondition (and
        (inventory ?player ?drink)
        (not (opened ?drink)))
    :effect (opened ?drink))

(:action hang_lantern
    :parameters (?player - player ?lamp - item ?loc - location)
    :precondition (and
        (at ?player ?loc)
        (inventory ?player ?lamp))
    :effect (hung ?lamp))

(:action blow_balloon
    :parameters (?player - player ?balloon - item)
     :precondition (inventory ?player ?balloon)
     :effect (inflated ?balloon))

(:action turn_on_tv
    :parameters (?player - player ?tv - item ?loc - location)
    :precondition (and
        (at ?player ?loc)
        (not (on ?tv))
        (at ?tv ?loc))
    :effect (on ?tv))

)

(define (domain anime-party)
  (:requirements :strips :typing)
  (:types
    player location direction
    food drink tea sushi balloon lantern - item
    phone money -item
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
  )

  (:action go
    :parameters (?dir - direction ?p - player ?l1 - location ?l2 - location) 
    :precondition (and (at ?p ?l1) (connected ?l1 ?dir ?l2) (not (blocked ?l1 ?dir ?l2)))
    :effect (and (at ?p ?l2) (not (at ?p ?l1)))
  )

  (:action get
    :parameters (?obj - item ?p - player ?l - location)
    :precondition (and (at ?p ?l) (at ?obj ?l))
    :effect (and (inventory ?p ?obj) (not (at ?obj ?l)))
  )

  (:action drop
    :parameters (?obj - item ?p - player ?l - location)
    :precondition (and (at ?p ?l) (inventory ?p ?obj))
    :effect (and (at ?obj ?l) (not (inventory ?p ?obj)))
  )

  (:action cook
    :parameters (?p - player ?l - location ?f - food)
    :precondition (and (has_kitchen ?l) (at ?p ?l))
    :effect (inventory ?p ?f)
  )

  (:action order_sushi
    :parameters (?p - player)
    :precondition (and (inventory ?p phone) (inventory ?p money))
    :effect (and (inventory ?p sushi) (not (inventory ?p money)))
  )

  (:action buy_sake
    :parameters (?p - player)
    :precondition (and (inventory ?p phone) (inventory ?p money))
    :effect (and (inventory ?p sake) (not (inventory ?p money)))
  )

  (:action serve
    :parameters (?p - player ?d - drink ?l - location)
    :precondition (and (inventory ?p ?d) (opened ?d) (at ?p ?l))
    :effect (and (not (inventory ?p ?d)) (at ?d ?l))
  )

  (:action brew
    :parameters (?p - player ?l - location)
    :precondition (and (has_kitchen ?l) (at ?p ?l) (inventory ?p teabag))
    :effect (and (inventory ?p tea) (not (inventory ?p teabag)) (opened tea))
  )

  (:action get_beer
    :parameters (?p - player ?l - location)
    :precondition (and (has_fridge ?l) (at ?p ?l))
    :effect (and (inventory ?p beer) (opened beer))
  )

  (:action open
    :parameters (?p - player ?i - drink)
    :precondition (and (inventory ?p ?i))
    :effect (and (inventory ?p ?i) (opened ?i))
  )

  (:action hang_lantern
    :parameters (?p - player)
    :precondition (and (inventory ?p lantern))
    :effect (and (hung lantern) (not (inventory ?p lantern)))
  )

  (:action blow_balloon
    :parameters (?p - player)
    :precondition (and (inventory ?p balloon))
    :effect (and (inflated balloon) (not (inventory ?p balloon)))
  )

  (:action turn_on_tv
    :parameters (?p - player ?l - location)
    :precondition (and (at ?p ?l) (at tv ?l))
    :effect (on tv)
  )
)

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
  )
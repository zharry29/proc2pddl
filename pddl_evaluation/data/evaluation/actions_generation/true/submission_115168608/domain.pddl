
(define (domain make_papyrus)
   (:requirements :strips :typing)
   (:types

       papyrus_plant - item
       papyrus_stalks - item
       papyrus_strips - item
       water - item
       linen_sheets - item
       wooden_boards - item
       rolling_pin - item
       knife - item
       papyrus - item
       player location
   )

   (:predicates
      (inventory ?player ?item) ; an item is in the player's inventory
      (soaked ?papyrus_strips - papyrus_strips) ; the papyrus strips have been soaked in water
      (dried ?papyrus_strips - papyrus_strips) ; the soaked papyrus strips have been dried by the rolling pin
      (woven ?papyrus_strips - papyrus_strips) ; the dried papyrus strips have been woven together into a lattice
      (at ?obj - object ?loc - location) ; an object is at a location
      (finished ?papyrus_strips - papyrus_strips) ; the woven papyrus were bundled between linen_sheets and wooden boards to finish
      (searched ?location - location) ; we've searched the location for interesting things
      (not_gettable ?item) ; true if cannot get item with normal get
      
   )

  (:action get ; pick up an item and put it in the inventory
      :parameters (?item - item ?p - player ?l - location)
      :precondition (and (at ?p ?l) (at ?item ?l) (not (not_gettable ?item)))
      :effect (and (inventory ?p ?item))
  )
  (:action travel ; travel from one location to another
    :parameters (?p - player ?l1 - location ?l2 - location)
    :precondition (at ?p ?l1)
    :effect (and (at ?p ?l2) (not (at ?p ?l1)))
  )

  (:action search_location; search location
    :parameters (?p - player ?l - location)
    :precondition (at ?p ?l)
    :effect (searched ?l)
  )

  (:action pluck_river_reeds; obtain the papyrus plant
    :parameters (?p - player ?papyrus_plant - papyrus_plant ?l - location)
    :precondition (and (searched ?l) (at ?papyrus_plant ?l) (at ?p ?l))
    :effect (inventory ?p ?papyrus_plant)
  )

  (:action cut_stalks; cut papyrus plant into stalks
    :parameters (?p - player ?knife - knife ?papyrus_plant - papyrus_plant ?papyrus_stalks - papyrus_stalks)
    :precondition (and (inventory ?p ?knife) (inventory ?p ?papyrus_plant))
    :effect (and (inventory ?p ?papyrus_stalks) (not (inventory ?p ?papyrus_plant)))
  )

  (:action cut_strips; cut papyrus stalks into strips
    :parameters (?p - player ?papyrus_strips - papyrus_strips ?papyrus_stalks - papyrus_stalks ?knife - knife)
    :precondition (and (inventory ?p ?knife) (inventory ?p ?papyrus_stalks))
    :effect (and (inventory ?p ?papyrus_strips) (not (inventory ?p ?papyrus_stalks)))
  )

  (:action soak_strips; place papyrus strips in water and let them soak
    :parameters (?p - player ?water - water ?papyrus_strips - papyrus_strips)
    :precondition (and (inventory ?p ?water) (inventory ?p ?papyrus_strips))
    :effect (soaked ?papyrus_strips)
  )

  (:action roll_strips; roll the excess water and sugar out of the strips to dry them
    :parameters (?p - player ?rolling_pin - rolling_pin ?papyrus_strips - papyrus_strips)
    :precondition (and (inventory ?p ?rolling_pin) (inventory ?p ?papyrus_strips) (soaked ?papyrus_strips))
    :effect (dried ?papyrus_strips)
  )

  (:action weave_strips; weave the dried papyrus strips into a lattice
    :parameters (?p - player ?papyrus_strips - papyrus_strips)
    :precondition (and (inventory ?p ?papyrus_strips) (dried ?papyrus_strips))
    :effect (woven ?papyrus_strips)
  )

  (:action bundle_strips; bundle the woven strips between linen sheets and wooden boards
    :parameters (?p - player ?papyrus_strips - papyrus_strips ?wooden_boards - wooden_boards ?linen_sheets - linen_sheets)
    :precondition (and (inventory ?p ?papyrus_strips) (woven ?papyrus_strips) (inventory ?p ?wooden_boards) (inventory ?p ?linen_sheets))
    :effect (finished ?papyrus_strips)
  )

  (:action cut_sheet; the finished sheet is cut to size to complete the papyrus
    :parameters (?p - player ?papyrus_strips - papyrus_strips ?knife - knife ?papyrus - papyrus)
    :precondition (and (inventory ?p ?papyrus_strips) (finished ?papyrus_strips) (inventory ?p ?knife))
    :effect (and (inventory ?p ?papyrus) (not (inventory ?p ?papyrus_strips)))
  )
)

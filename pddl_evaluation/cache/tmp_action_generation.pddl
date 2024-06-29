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
      
   )(:action get
  :parameters (?player - player ?item - item ?loc - location)
  :precondition (and (at ?player ?loc) (at ?item ?loc) (not (not_gettable ?item)))
  :effect (and (inventory ?player ?item) (not (at ?item ?loc)))
)

(:action travel
  :parameters (?player - player ?loc_from - location ?loc_to - location)
  :precondition (at ?player ?loc_from)
  :effect (and (at ?player ?loc_to) (not (at ?player ?loc_from)))
)

(:action search_location
  :parameters (?player - player ?loc - location)
  :precondition (at ?player ?loc)
  :effect (searched ?loc)
)

(:action pluck_river_reeds
  :parameters (?player - player ?papyrus_plant - papyrus_plant ?loc - location)
  :precondition (and (at ?player ?loc) (at ?papyrus_plant ?loc))
  :effect (and (inventory ?player ?papyrus_plant) (not (at ?papyrus_plant ?loc)))
)

(:action cut_stalks
  :parameters (?player - player ?papyrus_plant - papyrus_plant ?knife - knife ?papyrus_stalks - papyrus_stalks)
  :precondition (and (inventory ?player ?papyrus_plant) (inventory ?player ?knife))
  :effect (and (inventory ?player ?papyrus_stalks) (not (inventory ?player ?papyrus_plant)))
)

(:action cut_strips
  :parameters (?player - player ?papyrus_stalks - papyrus_stalks ?knife - knife ?papyrus_strips - papyrus_strips)
  :precondition (and (inventory ?player ?papyrus_stalks) (inventory ?player ?knife))
  :effect (and (inventory ?player ?papyrus_strips) (not (inventory ?player ?papyrus_stalks)))
)

(:action soak_strips
  :parameters (?player - player ?papyrus_strips - papyrus_strips ?water - water)
  :precondition (and (inventory ?player ?papyrus_strips) (inventory ?player ?water))
  :effect (soaked ?papyrus_strips)
)

(:action roll_strips
  :parameters (?player - player ?papyrus_strips - papyrus_strips ?rolling_pin - rolling_pin)
  :precondition (and (inventory ?player ?papyrus_strips) (inventory ?player ?rolling_pin) (soaked ?papyrus_strips))
  :effect (and (dried ?papyrus_strips) (not (soaked ?papyrus_strips)))
)

(:action weave_strips
  :parameters (?player - player ?papyrus_strips - papyrus_strips)
  :precondition (and (inventory ?player ?papyrus_strips) (dried ?papyrus_strips))
  :effect (woven ?papyrus_strips)
)

(:action bundle_strips
  :parameters (?player - player ?papyrus_strips - papyrus_strips ?linen_sheets - linen_sheets ?wooden_boards - wooden_boards)
  :precondition (and (inventory ?player ?papyrus_strips) (woven ?papyrus_strips) (inventory ?player ?linen_sheets) (inventory ?player ?wooden_boards))
  :effect (finished ?papyrus_strips)
)

(:action cut_sheet
  :parameters (?player - player ?papyrus_strips - papyrus_strips ?knife - knife ?papyrus - papyrus)
  :precondition (and (inventory ?player ?papyrus_strips) (finished ?papyrus_strips) (inventory ?player ?knife))
  :effect (and (inventory ?player ?papyrus) (not (inventory ?player ?papyrus_strips)))
)

)
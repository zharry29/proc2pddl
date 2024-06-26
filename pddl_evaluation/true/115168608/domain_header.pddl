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
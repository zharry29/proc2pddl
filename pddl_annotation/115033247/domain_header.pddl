(define (domain how_to_make_papyrus)
   (:requirements :strips :typing)
   (:types
      papyrus papyrus_tree papyrus_stalks papyrus_strips pruner scissors knife water bowl roller linen_cloth wooden_boards shell ivory smooth_stone bowl_of_water - item
      player direction location
   )

   (:predicates
      (at ?obj - object ?loc - location) ; an object is at a location 
      (inventory ?player ?item) ; an item is in the player's inventory
      (connected ?loc1 - location ?dir - direction ?loc2 - location) ; location 1 is connected to location 2 in the direction
      (strips_between_boards) ; papyrus strips are between two wooden boards
      (strips_woven) ; papyrus strips are woven together
      (polished ?papyrus) ; papyrus is polished
      (flattened ?papyrus) ; papyrus is flat
      (cut ?papyrus) ; papyrus is cut correctly
   )
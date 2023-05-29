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
   )(:action cut_stalks
:parameters (?plant - papyrus_tree ?knife - knife ?player - player ?loc - location)
:precondition (and
(at ?plant ?loc)
(inventory ?player ?knife)
)
:effect (and
(not (at ?plant ?loc))
(at ?papyrus_stalks ?loc)
)
)

(:action papyrus_strips
:parameters (?stalks - papyrus_stalks ?strips - papyrus_strips ?knife - knife ?player - player ?loc - location)
:precondition (and
(at ?stalks ?loc)
(inventory ?player ?knife)
)
:effect (and
(not (at ?stalks ?loc))
(at ?strips ?loc)
)
)

(:action flatten_papyrus
:parameters (?strips - papyrus_strips ?boards - wooden_boards ?player - player ?loc - location)
:precondition (and
(at ?strips ?loc)
(at ?boards ?loc)
(strips_between_boards)
)
:effect (flattened ?strips)
)

(:action place_strips_between_boards
:parameters (?strips - papyrus_strips ?boards - wooden_boards ?player - player ?loc - location)
:precondition (and
(at ?strips ?loc)
(at ?boards ?loc)
(not (strips_between_boards))
)
:effect (strips_between_boards)
)

(:action cut_papyrus
:parameters (?papyrus - papyrus ?scissors - scissors ?player - player ?loc - location)
:precondition (and
(at ?papyrus ?loc)
(inventory ?player ?scissors)
)
:effect (and
(not (at ?papyrus ?loc))
(at ?smaller_papyrus ?loc)
)
)

(:action polish_papyrus
:parameters (?papyrus - papyrus ?stone - smooth_stone ?player - player ?loc - location)
:precondition (and
(at ?papyrus ?loc)
(inventory ?player ?stone)
)
:effect (polished ?papyrus)
)


)
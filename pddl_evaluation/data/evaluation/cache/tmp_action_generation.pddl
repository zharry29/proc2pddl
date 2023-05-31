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
:parameters (?player - player ?knife - knife ?papyrus_tree - papyrus_tree)
:precondition (and (inventory ?player ?knife) (at ?player ?papyrus_tree))
:effect (and (not (at ?player ?papyrus_tree)) (at ?player ?papyrus_stalks))
)

(:action papyrus_strips
:parameters (?player - player ?knife - knife ?papyrus_stalks - papyrus_stalks)
:precondition (and (inventory ?player ?knife) (at ?player ?papyrus_stalks))
:effect (and (not (at ?player ?papyrus_stalks)) (at ?player ?papyrus_strips))
)

(:action place_strips_between_boards
:parameters (?player - player ?wooden_boards - wooden_boards ?papyrus_strips - papyrus_strips)
:precondition (and (inventory ?player ?wooden_boards) (at ?player ?papyrus_strips))
:effect (strips_between_boards)
)

(:action flatten_papyrus
:parameters (?player - player ?roller - roller ?wooden_boards - wooden_boards)
:precondition (and (inventory ?player ?roller) (strips_between_boards))
:effect (and (not (strips_between_boards)) (flattened ?papyrus))
)

(:action polish_papyrus
:parameters (?player - player ?smooth_stone - smooth_stone ?papyrus - papyrus)
:precondition (and (inventory ?player ?smooth_stone) (at ?player ?papyrus) (flattened ?papyrus))
:effect (polished ?papyrus)
)

(:action cut_paprus
:parameters (?player - player ?scissors - scissors ?papyrus - papyrus)
:precondition (and (inventory ?player ?scissors) (at ?player ?papyrus) (flattened ?papyrus) (polished ?papyrus))
:effect (cut ?papyrus)
)


)
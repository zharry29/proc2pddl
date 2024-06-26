(define (domain how_to_make_a_detective_kit)
   (:requirements :strips :typing)
   (:types
       bag - item 
       gloves - item
       tape - item
       chalk - item
       magnifying_glass - item
       costume - item
       flashlights - item
       pen - item
       notebook - item
       paper - item
       detective_notebook - item
       aluminium_foil - item
       cardboard - item
       badge - item
       walkie_talkies - item
       detective_kit - item
       player direction location disguise
   )

   (:predicates
      (sells_bags ?loc - location) ; this location sells bags.
      (sells_stationery ?loc - location) ; this location sells stationery.
      (sells_costume ?loc - location) ; this location sells costumes.
      (sells_electronics ?loc - location) ; this location sells electronics.
      (at ?obj - item ?loc - location) ; an object is at a location 
      (inventory ?player ?item) ; an item is in the player's inventory
      (connected ?loc1 - location ?dir - direction ?loc2 - location) ; location 1 is connected to location 2 in the direction
      (blocked ?loc1 - location ?dir - direction ?loc2 - location) ; the connection between location 1 and 2 in currently blocked
      (wear ?player ?costume) ; player wears his uniform
   )
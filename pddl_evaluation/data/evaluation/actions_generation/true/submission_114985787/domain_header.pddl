(define (domain survive_in_the_woods)
   (:requirements :strips :typing)
   (:types
       water - item 
       tree - item
       branch - item 
       branches - item
       twigs - item
       leaves - item
       beam - item
       frame - item
       shelter - item
       flowers - item
       wire - item
       snare - item
       bar - item
       player direction location
   )

   (:predicates
      (has_water_source ?loc - location) ; this location has a source of fresh water.
      (treated ?water - water) ; True if the water has been decontaimated by boiling it
      (at ?obj - object ?loc - location) ; an object is at a location 
      (inventory ?player - player ?item - item) ; an item is in the player's inventory
      (connected ?loc1 - location ?dir - direction ?loc2 - location) ; location 1 is connected to location 2 in the direction
      (blocked ?loc1 - location ?dir - direction ?loc2 - location) ; the connection between location 1 and 2 in currently blocked
      (dry ?loc - location) ; this location is dry
      (flat ?loc - location) ; this location is flat
      (has_split_in_trunk ?tree - tree) ; True if this tree has split in its trunk
      (long ?b - branch) ; True if the branch is 10 feet long
      (thick ?b - branch) ; True if the branch is 6 inches thick
      (has_bug ?item - item) ; True if the branch or leaves has bugs
      (edible ?item - item) ; True if the item is edible
      (unwashed ?item - item) ; True if the item has not been washed off 
      (hungry ?p - player) ; True if the player is hungry
      (made_by_animal ?l - location) ; True if this is a small, beaten path that made by an animal
      (hanged ?s - snare) ; True if this snare is hanged


   )
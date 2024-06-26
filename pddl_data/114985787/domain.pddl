
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

   (:action go ; navigate to an adjacent location 
      :parameters (?dir - direction ?p - player ?l1 - location ?l2 - location) 
      :precondition (and (at ?p ?l1) (connected ?l1 ?dir ?l2) (not (blocked ?l1 ?dir ?l2)))
      :effect (and (at ?p ?l2) (not (at ?p ?l1)))
   )

   (:action get ; pick up an item and put it in the inventory
      :parameters (?item - item ?p - player ?l1 - location) 
      :precondition (and (at ?p ?l1) (at ?item ?l1))
      :effect (and (inventory ?p ?item) (not (at ?item ?l1)))
   )

   (:action get_water ; get water from a location that has a water source like a lake.
      :parameters (?p - player ?loc - location ?water - water) 
      :precondition (and (at ?p ?loc) (has_water_source ?loc))
      :effect (and (inventory ?p ?water) (not (treated ?water)))
   )

   (:action drop ; drop down an item and remove it from the inventory
      :parameters (?item - item ?p - player ?l1 - location) 
      :precondition (and (at ?p ?l1) (inventory ?p ?item) (not (at ?item ?l1)))
      :effect (and (not (inventory ?p ?item)) (at ?item ?l1))
   )

   (:action clear_spider ; clear off any critters or spiders that may be on the branch or leaves
      :parameters (?item - item ?p - player) 
      :precondition (and (inventory ?p ?item) (has_bug ?item))
      :effect (and (not (has_bug ?item)) (inventory ?p ?item))
   )

   (:action insert_beam ; insert end(s) of the branch into the split(s) of the tree(s)
      :parameters (?b - branch ?t - tree ?p - player ?l1 - location ?beam - beam) 
      :precondition (and (at ?p ?l1) (dry ?l1) (flat ?l1) (at ?t ?l1) (has_split_in_trunk ?t) (inventory ?p ?b) (not (has_bug ?b)) (long ?b) (thick ?b) )
      :effect (and (at ?p ?l1) (not (inventory ?p ?b)) (at ?beam ?l1))
   )

   (:action lean_branches ; Lean branches against the main branch to form the structure of your shelter.
      :parameters (?branches - branches ?p - player ?l1 - location ?beam - beam ?frame - frame) 
      :precondition (and (at ?p ?l1) (inventory ?p ?branches) (at ?beam ?l1))
      :effect (and (at ?p ?l1) (not (inventory ?p ?branches)) (at ?frame ?l1))
   )

   (:action layer ; Lay twigs and leaves
      :parameters (?twigs - twigs ?leaves - leaves ?p - player ?l1 - location ?frame - frame ?shelter - shelter) 
      :precondition (and (at ?p ?l1) (inventory ?p ?twigs) (inventory ?p ?leaves) (not (has_bug ?leaves)) (at ?frame ?l1))
      :effect (and (at ?p ?l1) (not (inventory ?p ?twigs)) (not (inventory ?p ?leaves)) (at ?shelter ?l1))
   )

   (:action wash ; Wash off plants that you find.
      :parameters (?i - item ?p - player ?water - water) 
      :precondition (and (inventory ?p ?i) (inventory ?p ?water) (unwashed ?i))
      :effect (and (inventory ?p ?i) (not (unwashed ?i)))
   )

   (:action eat ; Eat anything you find edible
      :parameters (?i - item ?p - player) 
      :precondition (and (hungry ?p) (inventory ?p ?i) (not (unwashed ?i)) (edible ?i))
      :effect (and (not (inventory ?p ?i)) (not (hungry ?p)))
   )

   (:action make_snare ; Take a piece of wire and make a large circle
      :parameters (?w - wire ?p - player ?s - snare) 
      :precondition (and (inventory ?p ?w))
      :effect (and (not (inventory ?p ?w)) (inventory ?p ?s) (not (hanged ?s)))
   )

   (:action make_horizontal_bar ; Make a horizontal bar with a branch to hang your snare
      :parameters (?b - branch ?p - player ?bar - bar) 
      :precondition (and (inventory ?p ?b))
      :effect (and (not (inventory ?p ?b)) (inventory ?p ?bar))
   )

   (:action hang_snare ; Hang the circle of the snare over a path
      :parameters (?s - snare ?bar - bar ?p - player ?l - location) 
      :precondition (and (inventory ?p ?s) (inventory ?p ?bar) (not (hanged ?s)) (at ?p ?l) (made_by_animal ?l))
      :effect (and (hanged ?s) (at ?s ?l))
   )

)

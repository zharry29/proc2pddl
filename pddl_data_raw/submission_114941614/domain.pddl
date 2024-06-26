
(define (domain survive_in_jungle)
   (:requirements :strips :typing)
   (:types
      eatable container igniter leaves fuel - item
      sticks - fuel
      water food - eatable
      player location direction
   )

   (:predicates
      (has_water_source ?loc - location) ; this location has a source of fresh water.
      (has_fire ?loc - location); this location has a man-made fire
      (has_tree ?loc - location); there is a tree at this location
      (has_sticks ?loc - location); there are sticks on the ground to be picked up, an infinite supply
      (has_shelter ?loc - location); there is a man-made shelter of sticks and leaves at this location
      (contains ?container - container ?water - water) ; links a container to the water that fills it
      (is_full ?container - container) ; True if the container is full
      (is_contaminated  ?eatable - eatable) ; True if the food is contaminated with bacteria in a way removable by cooking
      (is_poisonous ?eatable - eatable) ; True if the food is poisonous in a way not helped by cooking or killing "live" bacteria
      (is_sick ?p - player) ; True if the player is poisoned by consuming something contaminated or poisonous
      (is_hungry ?p - player) ; True if the player has not consumed a food
      (is_thirsty ?p - player) ; True if the player has not consumed water
      (is_tired ?p - player) ; True if the player has not slept
      (at ?obj - object ?loc - location) ; an object is at a location 
      (inventory ?player ?item) ; an item is in the player's inventory
      (connected ?loc1 - location ?dir - direction ?loc2 - location) ; location 1 is connected to location 2 in the direction
      (blocked ?loc1 - location ?dir - direction ?loc2 - location) ; the connection between location 1 and 2 in currently blocked
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

   (:action collect_water ; get water from a location that has a water source like a lake.
      :parameters (?p - player ?loc - location ?c - container ?water - water)
      :precondition (and (at ?p ?loc) (has_water_source ?loc) (inventory ?p ?c))
      :effect (and (inventory ?p ?water) (is_contaminated ?water))
   )

  (:action gather_sticks ; get sticks from the ground
      :parameters (?p - player ?loc - location ?s - sticks)
      :precondition (and (at ?p ?loc) (has_sticks ?loc))
      :effect (and (inventory ?p ?sticks))
   )

   (:action make_fire ; creates a fire at the current location
      :parameters (?p - player ?loc - location ?fuel - fuel ?igniter - igniter)
      :precondition (and (at ?p ?loc) (inventory ?p ?fuel) (inventory ?p ?igniter))
      :effect (and (not (inventory ?p ?fuel)) (has_fire ?loc))
   )

   (:action boil_water ; boils water that is inside a container.
      :parameters (?p - player ?c - container ?loc - location ?w - water)
      :precondition (and (is_full ?c ?w) (has_fire ?loc) (inventory ?p ?c))
      :effect (and (not (is_contaminated ?w)))
   )

   (:action cook_food ; boils water that is inside a container.
      :parameters (?p - player ?loc - location ?f - food)
      :precondition (and (inventory ?p ?f) (has_fire ?loc))
      :effect (and (not (is_contaminated ?f)))
   )

   
  (:action eat_poisoned_food ; eat food that is harmful to a human
    :parameters (?p - player ?f - food) 
    :precondition (and (inventory ?p ?f) (is_poisonous ?f))
    :effect (and (is_sick ?p) (not (is_hungry ?p)))
   )
   

  (:action eat_contaminated_food ; eat food that is harmful to a human
    :parameters (?p - player ?f - food) 
    :precondition (and (inventory ?p ?f) (is_contaminated ?f))
    :effect (and (is_sick ?p) (not (is_hungry ?p)))
   )

   (:action eat_food ; eat food that isn't harmful
      :parameters (?p - player ?f - food) 
      :precondition (and (inventory ?p ?f) (not (is_contaminated ?f)) (not (is_poisonous ?f)))
      :effect (and (not (is_hungry ?p)))
   )

   (:action drink_contaminated_water ; drink contaminated water
    :parameters (?p - player ?c - container ?w - water) 
    :precondition (and (contains ?c ?w) (is_contaminated ?w))
    :effect (and (is_sick ?p) (not (is_thirsty ?p)))
   )


   (:action drink_water ; drink clean water from container
      :parameters (?p - player ?c - container ?w - water) 
      :precondition (and (contains ?c ?w) (not (is_contaminated ?w))  (not (is_poisonous ?w)))
      :effect (and (not (is_thirsty ?p)))
   )


   (:action build_shelter ; build a shelter of sticks and leaves
      :parameters (?p - player ?s - sticks ?l - leaves ?loc - location)
      :precondition (and (inventory ?p ?s) (has_tree ?loc))
      :effect (and (has_shelter ?loc) (not (inventory ?p ?l)) (not (inventory ?p ?s)))
   )

   (:action sleep_in_shelter ; sleep in shelter and become un-tired
      :parameters (?p - player ?loc - location)
      :precondition (and (has_shelter ?loc) (is_tired ?p))
      :effect (and (not (is_tired ?p)))
   )


)


(define (domain survive_on_a_desert_island)
  (:requirements :strips :typing)
  (:types
      water stick tarp leave - item
      player direction location
	  fish bird insect shellfish - animal
  )
 
  (:predicates
     (has_water_source ?loc - location) ; this location has a source of fresh water.
     (treated ?water - water) ; True if the water has been decontaminated by boiling it
     (at ?obj - object ?loc - location) ; an object is at a location
     (inventory ?player - player ?item - item) ; an item is in the player's inventory
     (connected ?loc1 - location ?dir - direction ?loc2 - location) ; location 1 is connected to location 2 in the direction
     (blocked ?loc1 - location ?dir - direction ?loc2 - location) ; the connection between location 1 and 2 in currently blocked
     (edible ?item); an item is edible
     (has_fish ?loc - location) ; this location has fish.
     (has_bird ?loc - location) ; this location has bird.
     (has_insect ?loc - location) ; this location has insect.
     (has_shellfish ?loc - location) ; this location has shellfish.
     (has_fire ?loc - location) ; this location has fire.
     (sheltered ?loc - location) ; this location is sheltered.
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
 
 
  (:action sharpen_stick ; sharpen stick to hunt fish or bird or to use it to make a fire
     :parameters (?p - player ?stick - stick)
     :precondition (and (inventory ?p ?stick) (not (sharpened ?stick)))
     :effect (and (inventory ?p ?stick) (sharpened ?stick))
  )
 
  (:action catch_fish ; catch fish from a location that has fish.
     :parameters (?p - player ?loc - location ?fish - fish ?stick - stick)
     :precondition (and (at ?p ?loc) (has_fish ?loc) (inventory ?p ?stick) (sharpened ?stick))
     :effect (and (inventory ?p ?fish) (edible ?fish))
  )
 
  (:action hunt_bird ; catch a bird from a location that has birds.
     :parameters (?p - player ?loc - location ?bird - bird ?stick - stick)
     :precondition (and (at ?p ?loc) (has_bird ?loc) (inventory ?p ?stick) (sharpened ?stick))
     :effect (and (inventory ?p ?bird) (edible ?bird))
  )
 
  (:action hunt_insect ; catch an insect from a location that has insects.
     :parameters (?p - player ?loc - location ?insect - insect)
     :precondition (and (at ?p ?loc) (has_insect ?loc))
     :effect (and (inventory ?p ?insect) (edible ?insect))
  )
 
  (:action get_shellfish ; catch shellfish from a location that has fish.
     :parameters (?p - player ?loc - location ?shellfish - shellfish)
     :precondition (and (at ?p ?loc) (has_shellfish ?loc))
     :effect (and (inventory ?p ?shellfish) (not (edible ?shellfish)))
  )
 
  (:action cook ; cook to make animal edible
     :parameters (?p - player ?loc - location ?animal - animal)
     :precondition (and (at ?p ?loc) (inventory ?p ?animal) (has_fire ?loc))
     :effect (and (inventory ?p ?animal) (edible ?animal))
  )

  (:action get_stick ; get a stick from bosk
     :parameters (?p - player ?loc - location ?stick - stick)
     :precondition (and (at ?p ?loc) (at ?stick ?loc))
     :effect (and (inventory ?p ?stick) (not (sharpened ?stick)))
  )
 
  (:action start_fire ; start a fire at a location
     :parameters (?p - player ?loc - location ?stick - stick)
     :precondition (and (at ?p ?loc) (inventory ?p ?stick) (sharpened ?stick))
     :effect (and (has_fire ?loc))
  )
 

  (:action get_tarp ; get tarp for shelter construction
     :parameters (?p - player ?loc - location ?tarp - tarp)
     :precondition (and (at ?p ?loc) )
     :effect (and (inventory ?p ?tarp))
  )
 
  (:action get_leave ; get leaves for shelter construction
     :parameters (?p - player ?loc - location ?leave - leave)
     :precondition (and (at ?p ?loc) )
     :effect (and (inventory ?p ?leave))
  )
  
  (:action construct_shelter ; construct a shelter with stick plus either tarp or leaves
     :parameters (?p - player ?loc - location ?stick - stick ?tarp - tarp ?leave - leave)
     :precondition (and (at ?p ?loc) (inventory ?p ?stick) (inventory ?p ?tarp))
     :effect (and (sheltered ?loc))
  )
)

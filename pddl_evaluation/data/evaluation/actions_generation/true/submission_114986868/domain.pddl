
(define (domain survive_in_the_jungle)
   (:requirements :strips :typing)
   (:types
       water wood container drill spear fish foliage - item 
       player direction location
   )

   (:predicates
      (has_water ?loc - location) ; this location has a source of fresh water
      (has_tree ?loc - location) ; this location has trees
      (has_fish ?loc - location) ; this location has fish
      (has_fire ?loc - location) ; True if fire is created by the player at this location
      (has_shelter ?loc - location) ; True if shelter is created by the player at this location
      (boiled ?water - water) ; True if the water has been decontaimated by boiling it
      (filtered ?water - water) ; True if the water has been filtered
      (cooked ?fish - fish) ; True if the fish has been cooked
      (thirsty ?player) ; True if the player is thirsty
      (hungry ?player) ; True if the player is hungry
      (safe ?player ?loc - location) ; True if the player is safely living in shelter with weapon and fire on at this location
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

   (:action drop ; drop an item in the inventory
      :parameters (?item - item ?p - player ?l1 - location) 
      :precondition (and (at ?p ?l1) (inventory ?p ?item))
      :effect (and (not (inventory ?p ?item)) (at ?item ?l1))
   )

   (:action collect_water ; use container to collect water from a location that has water
      :parameters (?p - player ?container - container ?water - water ?loc - location) 
      :precondition (and (at ?p ?loc) (has_water ?loc) (inventory ?p ?container) (not (inventory ?p ?water)))
      :effect (and (inventory ?p ?water) (not (filtered ?water)) (not (boiled ?water)))
   )

   (:action filter_water ; filter water to remove any particles
      :parameters (?p - player ?water - water) 
      :precondition (and (inventory ?p ?water) (not (filtered ?water)))
      :effect (and (filtered ?water))
   )

   (:action boil_water ; boil water to kill any bacteria
      :parameters (?p - player ?water - water ?loc - location) 
      :precondition (and (inventory ?p ?water) (at ?p ?loc) (filtered ?water) (not (boiled ?water)) (has_fire ?loc))
      :effect (and (boiled ?water))
   )

   (:action drink_water ; drink boiled water 
      :parameters (?p - player ?water - water) 
      :precondition (and (inventory ?p ?water) (boiled ?water))
      :effect (and (not (thirsty ?p)))
   )

   (:action get_wood ; get wood from a location that has trees
      :parameters (?p - player ?wood - wood ?loc - location) 
      :precondition (and (at ?p ?loc) (has_tree ?loc) (not (inventory ?p ?wood)))
      :effect (and (inventory ?p ?wood))
   )

   (:action make_drill ; make a drill using wood to create fire
      :parameters (?p - player ?wood - wood ?drill - drill) 
      :precondition (and (inventory ?p ?wood) (not (inventory ?p ?drill)))
      :effect (and (inventory ?p ?drill))
   )

   (:action make_fire ; make fire at a location
      :parameters (?p - player ?drill - drill ?loc - location) 
      :precondition (and (inventory ?p ?drill) (at ?p ?loc) (not (has_fire ?loc)))
      :effect (and (has_fire ?loc))
   )

   (:action make_spear ; make a spear using wood to catch fish or defend against predators
      :parameters (?p - player ?spear - spear ?wood - wood) 
      :precondition (and (inventory ?p ?wood) (not (inventory ?p ?spear)))
      :effect (and (inventory ?p ?spear))
   )

   (:action catch_fish ; catch a fish using spear
      :parameters (?p - player ?spear - spear ?fish - fish ?loc - location) 
      :precondition (and (at ?p ?loc) (inventory ?p ?spear) (has_fish ?loc) (not (inventory ?p ?fish)))
      :effect (and (inventory ?p ?fish))
   )

   (:action cook_fish ; grill fish using fire
      :parameters (?p - player ?fish - fish ?loc - location) 
      :precondition (and (inventory ?p ?fish) (at ?p ?loc) (has_fire ?loc) (not (cooked ?fish)))
      :effect (and (cooked ?fish))
   )

   (:action eat_fish ; eat cooked fish 
      :parameters (?p - player ?fish - fish) 
      :precondition (and (inventory ?p ?fish) (cooked ?fish))
      :effect (and (not (hungry ?p)))
   )  

   (:action get_foliage ; get foliage from a location that has trees
      :parameters (?p - player ?foliage - foliage ?loc - location) 
      :precondition (and (at ?p ?loc) (has_tree ?loc) (not (inventory ?p ?foliage)))
      :effect (and (inventory ?p ?foliage))
   )

   (:action build_shelter ; build a shelter using wood and foliage
      :parameters (?p - player ?wood - wood ?foliage - foliage ?loc - location) 
      :precondition (and (at ?p ?loc) (inventory ?p ?wood) (inventory ?p ?foliage) (not (has_shelter ?loc)))
      :effect (and (has_shelter ?loc))
   )

   (:action survive ; live safely in the shelter with weapon and fire on
      :parameters (?p - player ?spear - spear ?loc - location) 
      :precondition (and (at ?p ?loc) (has_shelter ?loc) (has_fire ?loc) (inventory ?p ?spear) (not (safe ?p ?loc)))
      :effect (and (safe ?p ?loc))
   )
)

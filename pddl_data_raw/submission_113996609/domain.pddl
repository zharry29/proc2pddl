
(define (domain survive_deserted_island)
   (:requirements :strips :typing)
   (:types
       water wood fire rock leaves tinder raft vines spear fish - item
       beach jungle ocean treetop - location 
       player survivor - human
   )

   (:predicates
      (treated ?water - water) ; True if the water has been decontaimated by boiling it
      (groove ?wood - wood) ; True if a small groove is made in wood to start a fire
      (at ?obj - object ?loc - location) ; an object is at a location 
      (inventory ?player ?item) ; an item is in the player's inventory
      (connected ?loc1 - location ?dir - direction ?loc2 - location) ; location 1 is connected to location 2 in the direction
      (has_water_source ?loc - location) ; this location has a source of fresh water.
      (has_wood ?loc - location) ; this location has a wood
      (can_light_fire ?loc - location); this location is safe for lighting a fire
      (has_fire ?loc - location); this location has a fire going
      (has_shelter ?loc - location); this location has a shelter
      (drank ?water - water); the player drinks water
      (has_friend ?survivor - survivor); the player has found a survivor
      (has_escaped ?player - player) ; the player has built a raft and left with his fellow survivors
      (at_ocean ?loc - location) ; see if a location has access to the ocean
      (is_safe ?loc -location) ; see if a location is safe to make shelter on 
      (has_fish ?loc - location) ; see if location has fish to catch
      (cooked ?item - item) ; see if item is cooked
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

   (:action chop_wood ; chop down wood from a nearby tree.
      :parameters (?p - player ?loc - location ?wood - wood) 
      :precondition (and (at ?p ?loc) (has_wood ?loc))
      :effect (and (inventory ?p ?wood) (not (groove ?wood)))
   )

   (:action carve_groove ; create a grove in wood to light flint.
      :parameters (?p - player ?wood - wood ?rock - rock) 
      :precondition (and (inventory ?p ?wood) (inventory ?p ?rock) (not (groove ?wood)))
      :effect (and (groove ?wood))
   )

   (:action light_fire ; light a fire
      :parameters (?p - player ?wood - wood ?loc - location ?tinder - tinder ?fire - fire) 
      :precondition (and (inventory ?p ?wood) (inventory ?p ?tinder) (can_light_fire ?loc) (groove ?wood))
      :effect (and (at ?fire ?loc) (not (inventory ?wood)) (not (groove ?wood)))
   )

   (:action build_shelter ; create a grove in wood to light flint.
      :parameters (?p - player ?wood - wood ?loc - location ?leaves - leaves) 
      :precondition (and (inventory ?p ?wood) (inventory ?p ?leaves) (is_safe ?loc))
      :effect (and (has_shelter ?loc))
   )

   (:action clean_water ; boil water to clean it
      :parameters (?p - player ?loc - location ?water - water ?fire - fire) 
      :precondition (and (inventory ?p ?water) (at ?fire ?loc))
      :effect (and (treated ?water))
   )

   (:action drink_water ; drink water
      :parameters (?p - player ?water - water) 
      :precondition (and (inventory ?p ?water) (treated ?water))
      :effect (and (drank ?water))
   )

   (:action find_other_survivors ; find other survivors on the deserted island 
      :parameters (?loc - location ?survivor - survivor ?p - player) 
      :precondition (and (at ?survivor ?loc) (at ?p ?loc))
      :effect (and (has_friend ?p))
   )

   (:action build_raft ; build a raft to escape the deserted island 
      :parameters (?loc - location ?vines - vines ?p - player ?wood - wood) 
      :precondition (and (at ?p ?loc) (at_ocean ?loc) (inventory ?p ?wood) (inventory ?p ?vines) (has_friend ?p))
      :effect (and (has_escaped ?p))
   )

   (:action make_weapon ; create a spear to hunt fish 
      :parameters (?rock - rock ?p - player ?wood - wood ?vines - vines ?spear - spear) 
      :precondition (and (inventory ?p ?rock) (inventory ?p ?vines) (inventory ?p ?wood))
      :effect (and (inventory ?p ?spear))
   )

   (:action hunt_fish ; catch fish with spear
      :parameters (?p - player ?loc - location ?spear - spear ?fish - fish) 
      :precondition (and (inventory ?p ?spear) (has_fish ?loc))
      :effect (and (inventory ?p ?fish))
   )

   (:action cook_fish ; cook fish 
      :parameters (?p - player ?fish - fish ?fire - fire ?loc - location) 
      :precondition (and (inventory ?p ?fish) (at ?fire ?loc))
      :effect (and (cooked ?fish))
   )   
)

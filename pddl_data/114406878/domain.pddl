
(define (domain survive_in_the_woods)
   (:requirements :strips :typing)
   (:types
       grass branch log tinder kindling fuel teepee wood water pot - item
       player direction location
   )

   (:predicates
      (has_large_dry_branch ?loc - location) ; this location has large and dry branches that can be broken off as kindling material.
      (has_dry_oak ?loc - location)          ; this location has dry oak trees that can be logged for fuel.
      (has_dry_even_area ?loc - location)    ; this location has a dry, even area without things that could catch on fire.
      (has_pond ?loc - location)             ; this location has a pond with water
      (dry ?item)                            ; True if the item is try
      (ignited ?item)                        ; True if the item is ignited
      (boiled ?item)                         ; True if the item (namely water) has been boiled
      (at ?obj - object ?loc - location)     ; an object is at a location 
      (inventory ?player ?item)              ; an item is in the player's inventory
      (connected ?loc1 - location ?dir - direction ?loc2 - location) ; location 1 is connected to location 2 in the direction
      (blocked ?loc1 - location ?dir - direction ?loc2 - location)   ; the connection between location 1 and 2 in currently blocked
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

   (:action get_grass ; gather grass that is not dry at the first time
      :parameters (?p - player ?loc - location ?grass - grass)
      :precondition (and (at ?p ?loc) (at ?grass ?loc))
      :effect (and (inventory ?p ?grass) (not (dry ?grass)))
   )

   (:action dry_grass ; dry grass so that it can used as tinder
      :parameters (?p - player ?grass - grass ?dry_grass - grass) 
      :precondition (and (inventory ?p ?grass) (not (dry ?grass)))
      :effect (and (inventory ?p ?dry_grass) (not (inventory ?p ?grass)))
   )

   (:action cluster_grass ; cluster gatherd dry grass to make tinder
      :parameters (?p - player ?dry_grass - grass ?grass_tinder - tinder) 
      :precondition (and (inventory ?p ?dry_grass))
      :effect (and (inventory ?p ?grass_tinder) (not (inventory ?p ?dry_grass)))
   )

   (:action break_branch ; break larger branches into smaller pieces
      :parameters (?p - player ?loc - location ?branch_piece - kindling) 
      :precondition (and (at ?p ?loc) (has_large_dry_branch ?loc))
      :effect (and (at ?branch_piece ?loc))
   )

   (:action log_oak ; log oak trees
      :parameters (?p - player ?loc - location ?axe - item ?oak_log - log) 
      :precondition (and (at ?p ?loc) (has_dry_oak ?loc) (inventory ?p ?axe))
      :effect (and (at ?oak_log ?loc) (dry ?oak_log))
   )

   (:action get_log ; log oak trees
      :parameters (?p - player ?loc - location ?oak_log - log) 
      :precondition (and (at ?p ?loc) (at ?oak_log ?loc) (dry ?oak_log))
      :effect (and (inventory ?p ?oak_log))
   )

   (:action stack_log ; stack dry logs to make enough fuel 
      :parameters (?p - player ?oak_log - log ?log_stack - fuel) 
      :precondition (and (inventory ?p ?oak_log))
      :effect (and (inventory ?p ?log_stack) (not (inventory ?p ?oak_log)))
   )

   (:action build_teepee ; build a teepee structure with tinder, kindling, and fuel logs
      :parameters (?p - player ?loc - location ?tinder - tinder ?kindling - kindling ?fuel_logs - fuel ?teepee - teepee)
      :precondition (and (inventory ?p ?tinder) (inventory ?p ?kindling) (inventory ?p ?fuel_logs) (has_dry_even_area ?loc) (at ?p ?loc))
      :effect (and (at ?teepee ?loc) (not (inventory ?p ?tinder)) (not (inventory ?p ?kindling)) (not (inventory ?p ?fuel_logs)))
   )

   (:action get_wood ; gather a flat piece of solid wood to start fire
      :parameters (?p - player ?loc - location ?wood - wood)
      :precondition (and (at ?p ?loc) (at ?wood ?loc))
      :effect (and (inventory ?p ?wood))
   )

   (:action get_branch ; gather a solid branch to start fire
      :parameters (?p - player ?loc - location ?branch - branch)
      :precondition (and (at ?p ?loc) (has_large_dry_branch ?loc))
      :effect (and (inventory ?p ?branch))
   )

   (:action ignite_wood ; ignite wood by plough it to create heat via friction
      :parameters (?p - player ?loc - location ?wood - wood ?branch - branch ?teepee - teepee)
      :precondition (and (at ?p ?loc) (at ?teepee ?loc) (inventory ?p ?wood) (inventory ?p ?branch))
      :effect (and (ignited ?wood))
   )

   (:action ignite_teepee ; ignite teepe with ignited wood to start fire
      :parameters (?p - player ?loc - location ?wood - wood ?teepee - teepee)
      :precondition (and (at ?p ?loc) (at ?teepee ?loc) (inventory ?p ?wood) (ignited ?wood))
      :effect (and (ignited ?teepee))
   )

   (:action get_pot ; retrieve a pot to hold water
      :parameters (?p - player ?loc - location ?pot - pot)
      :precondition (and (at ?p ?loc) (at ?pot ?loc))
      :effect (and (inventory ?p ?pot))
   )

   (:action get_water ; retrieve some natural but possibly contaminated water
      :parameters (?p - player ?loc - location ?water - water ?pot - pot)
      :precondition (and (at ?p ?loc) (has_pond ?loc) (inventory ?p ?pot))
      :effect (and (inventory ?p ?water))
   )

   (:action boil_water ; boil water using a started fire pit
      :parameters (?p - player ?loc - location ?teepee - teepee ?water - water)
      :precondition (and (at ?p ?loc) (at ?teepee ?loc) (ignited ?teepee) (inventory ?p ?water))
      :effect (and (boiled ?water))
   )
)

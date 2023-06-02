(define (domain survive_in_the_woods)
   (:requirements :strips :typing)
   (:types
       water - item 
       player direction location
       cloth
       container
       long_branch propped_branches
       logs
       twigs_leaves
       teepee
   )

   (:predicates
      (has_water_source ?loc - location) ; this location has a source of fresh water.
      (has_branches ?loc - location) ; this locations has a bunch of branches.
      (has_twigs_leaves ?loc - location) ; this locations has a twigs and leaves.
      (has_logs ?loc - location); this locations has logs.
      (has_shelter ?p - player); the player has built the shelter.
      (has_fire ?p - player); the player has started a fire.
      (strained ?water - water) ; True if the water has been strained by using cloth
      (treated ?water - water) ; True if the water has been decontaimated by boiling it
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

   (:action get_water ; get water from a location that has a water source like a lake.
      :parameters (?p - player ?loc - location ?water - water) 
      :precondition (and (at ?p ?loc) (has_water_source ?loc))
      :effect (and (inventory ?p ?water) (not (treated ?water)) (not (strained ?water)))
   )

   (:action strain_water ; strain water using cloth
      :parameters (?p - player ?loc - location ?water - water ?cloth - cloth)
      :precondition (and (at ?p ?loc) (inventory ?p ?water) (inventory ?p ?cloth) (not (strained ?water)) (not (treated ?water)))
      :effect (and (strained ?water))
   )

   (:action boil_water ; boil water using container
      :parameters (?p - player ?loc - location ?container - container ?water - water)
      :precondition (and (at ?p ?loc) (inventory ?p ?container) (inventory ?p ?water) (strained ?water))
      :effect (and (not (strained ?water)) (treated ?water))
   )

   (:action purify_in_sunlight ; purify water in sunlight
      :parameters (?p - player ?loc - location ?water - water)
      :precondition (and (at ?p ?loc) (not (inventory ?p ?container)) (inventory ?p ?bottle) (inventory ?p ?water) (strained ?water))
      :effect (and (not (strained ?water)) (treated ?water))
   )

   (:action get_long_branch ; get long branch for shelter
      :parameters (?p - player ?loc - location ?long_branch - long_branch)
      :precondition (and (at ?p ?loc) (has_branches ?loc))
      :effect (and (inventory ?p ?long_branch))
   )

   (:action get_propped_branches ; get branches to prop up the main one
      :parameters (?p - player ?loc - location ?propped_branches - propped_branches)
      :precondition (and (at ?p ?loc) (has_branches ?loc))
      :effect (and (inventory ?p ?propped_branches))
   )

   (:action get_twigs_leaves ; get twigs and leaves
      :parameters (?p - player ?loc - location ?twigs_leaves - twigs_leaves)
      :precondition (and (at ?p ?loc) (has_twigs_leaves ?loc))
      :effect (and (inventory ?p ?twigs_leaves))
   )

   (:action build_shelter ; built shelter
      :parameters (?p - player ?loc - location ?twigs_leaves - twigs_leaves ?long_branch - long_branch ?propped_branches - propped_branches)
      :precondition (and (at ?p ?loc) (has_twigs_leaves ?loc) (has_branches ?loc) (has_branches ?loc))
      :effect (and (has_shelter ?p))
   )

   (:action get_logs ; get logs
      :parameters (?p - player ?loc - location ?logs - logs)
      :precondition (and (at ?p ?loc) (has_logs ?loc))
      :effect (and (inventory ?p ?logs))
   )

   (:action get_dry_materials ; get dry materials
      :parameters (?p - player ?loc - location ?dry_materials - dry_materials)
      :precondition (and (at ?p ?loc) (has_dry_materials ?loc))
      :effect (and (inventory ?p ?dry_materials))
   )

   (:action build_teepee ; build teepee structure
      :parameters (?p - player ?loc - location ?dry_materials - dry_materials ?twigs_leaves - twigs_leaves ?teepee - teepee)
      :precondition (and (at ?p ?loc) (inventory ?p ?dry_materials) (inventory ?p ?twigs_leaves))
      :effect (and (inventory ?p ?teepee))
   )

   (:action start_fire ; start_fire
      :parameters (?p - player ?loc - location ?teepee - teepee ?logs - logs)
      :precondition (and (at ?p ?loc) (inventory ?p ?teepee) (inventory ?p ?logs))
      :effect (and (has_fire ?p))
   )
)

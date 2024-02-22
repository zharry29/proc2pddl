
(define (domain calculate_pi_by_throwing_frozen_hot_dogs)
   (:requirements :strips :typing)
   (:types
       items masking_tape paper pen player direction location - object
   )

   (:predicates
      (is_gettable ?object - object) ; this object is gettable.
      (is_food_item ?object - object) ; this object is a food item.
      (is_long ?object - object) ; this object is between 6-8 inches.
      (is_thin ?object - object) ; this object is thin.
      (is_hard ?object - object) ; this object is hard.
      (is_straight ?object - object) ; this object is straight.
      (is_stiff ?object - object) ; this object is stiff.
      (has_throwing_distance ?object - object) ; this object has 6-10 feet of throwing distance.
      (is_clear ?object - object) ; this object is clear.
      (are_same_size ?object - object) ; these objects are the same size (always true if there is only 1 item).
      (has_ten_strips ?object - object) ; this object has ten strips of masking tape
      (at ?obj - object ?loc - location) ; an object is at a location 
      (inventory ?player ?item) ; an item is in the player's inventory
      (connected ?loc1 - location ?dir - direction ?loc2 - location) ; location 1 is connected to location 2 in the direction
      (blocked ?loc1 - location ?dir - direction ?loc2 - location) ; the connection between location 1 and 2 in currently blocked
      (thrown_food_items ?loc - location) ; food items were thrown at this location
      (tosses_column ?paper - paper) ; the paper has a tosses column
      (crosses_column ?paper - paper) ; the paper has a crosses column
      (tosses_recorded ?paper - paper) ; the paper has tosses recorded
      (crosses_recorded ?paper - paper) ; the paper has crosses recorded
      (crosses_divided ?paper - paper) ; the paper has crosses divided
      (calculated_pi ?player - player) ; the paper has calculated pi
      (amazed ?player - player) ; the player is amazed
      (frozen ?object - object) ; the object is frozen
   )

   (:action go ; navigate to an adjacent location 
      :parameters (?dir - direction ?p - player ?l1 - location ?l2 - location) 
      :precondition (and (at ?p ?l1) (connected ?l1 ?dir ?l2) (not (blocked ?l1 ?dir ?l2)))
      :effect (and (at ?p ?l2) (not (at ?p ?l1)))
   )

   (:action get ; pick up an item and put it in the inventory
      :parameters (?object - object ?p - player ?l1 - location) 
      :precondition (and (at ?p ?l1) (at ?object ?l1) (is_gettable ?object))
      :effect (and (inventory ?p ?object) (not (at ?object ?l1)))
   )

   (:action lay_masking_tape ; lay masking tape
      :parameters (?object - masking_tape ?p - player ?l1 - location) 
      :precondition (and (at ?p ?l1) (inventory ?p ?object) (has_ten_strips ?object))
      :effect (and (not (has_ten_strips ?object)) (has_ten_strips ?l1))
   )

   (:action make_tosses_column ; make tosses column
      :parameters (?object - paper ?p - player)
      :precondition (and (inventory ?p ?object) (not (tosses_column ?object)))
      :effect (tosses_column ?object)
   )

   (:action make_crosses_column ; make crosses column
      :parameters (?object - paper ?p - player)
      :precondition (and (inventory ?p ?object) (not (crosses_column ?object)))
      :effect (crosses_column ?object)
   )

   (:action thaw_food ; thaw food items
      :parameters (?object - items ?p - player)
      :precondition (and (inventory ?p ?object) (is_food_item ?object) (frozen ?object))
      :effect (not (frozen ?object))
   )

   (:action throw ; throw food items
      :parameters (?object - items ?p - player ?l1 - location) 
      :precondition (and 
      (at ?p ?l1)
      (has_throwing_distance ?l1) 
      (is_clear ?l1) 
      (is_food_item ?object) 
      (is_long ?object) 
      (is_thin ?object) 
      (is_hard ?object) 
      (is_straight ?object) 
      (is_stiff ?object) 
      (has_ten_strips ?l1) 
      (not (frozen ?object))
      )
      :effect (thrown_food_items ?l1)
   )

   (:action record_tosses ; record tosses
      :parameters (?object - paper ?p - player ?l1 - location)
      :precondition (and (inventory ?p ?object) (not (tosses_recorded ?object)) (at ?p ?l1) (thrown_food_items ?l1))
      :effect (tosses_recorded ?object)
   )

   (:action record_crosses ; record crosses
      :parameters (?object - paper ?p - player ?l1 - location)
      :precondition (and (inventory ?p ?object) (not (crosses_recorded ?object)) (at ?p ?l1) (thrown_food_items ?l1))
      :effect (crosses_recorded ?object)
   )

   (:action divide_crosses ; divide crosses
      :parameters (?object - paper ?p - player)
      :precondition (and (inventory ?p ?object) (crosses_recorded ?object) (not (crosses_divided ?object)))
      :effect (crosses_divided ?object)
   )

   (:action calculate_pi ; divide tosses
      :parameters (?object - paper ?p - player)
      :precondition (and (inventory ?p ?object) (crosses_recorded ?object) (tosses_recorded ?object) (crosses_divided ?object) (not (calculated_pi ?p)))
      :effect (calculated_pi ?p)
   )

   (:action be_amazed ; divide tosses
      :parameters (?p - player)
      :precondition (and (calculated_pi ?p) (not (amazed ?p)))
      :effect (amazed ?p)
   )

)

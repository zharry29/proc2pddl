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
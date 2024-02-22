
(define (problem get_materials)
   (:domain calculate_pi_by_throwing_frozen_hot_dogs)

   (:objects
      npc - player
      foyer hallway kitchen study - location
      north south east west - direction
      paper - paper
      pen - pen
      masking_tape - masking_tape
      items - items
   )

   (:init
      (is_gettable paper)
      (is_gettable pen)
      (is_gettable masking_tape)
      (is_gettable items)
      (is_food_item items)
      (is_long items)
      (is_thin items)
      (is_hard items)
      (is_straight items)
      (is_stiff items)
      (has_throwing_distance hallway)
      (is_clear hallway)
      (are_same_size items)
      (has_ten_strips masking_tape)
      (at npc foyer)
      (at items kitchen)
      (at paper study)
      (at pen study)
      (at masking_tape study)
      (connected foyer north hallway)
      (connected hallway south foyer)
      (connected hallway west kitchen)
      (connected kitchen east hallway)
      (connected hallway east study)
      (connected study west hallway)
      (frozen items)

   )

   (:goal (and (inventory npc paper) (inventory npc pen) (inventory npc items) (not (frozen items))))
)


(define (problem get_coconut_meat_without_oven)
   (:domain open_a_coconut)

   (:objects
      npc - player
      counter fridge rack oven - location
      oven - appliance
      in out north south east west up down - direction
      coconut towel bag knife glass coconut_juice coconut_meat coconut_shell mallet - item
      bag towel - wrappable
   )

   (:init
      (connected counter west fridge)
      (connected fridge east counter)
      (connected counter north rack)
      (connected rack south counter)
      (connected counter south oven)
      (connected oven north counter)
      (at towel rack)
      (at knife rack)
      (at bag counter)
      (at mallet counter)
      (at glass rack)
      (at coconut fridge)
      (at npc counter)
   )

   (:goal (and (inventory npc coconut_meat) (peeled coconut_meat) (not (burnt coconut))))
)

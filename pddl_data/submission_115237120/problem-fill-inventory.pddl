
(define (problem get-supplies)

   (:domain survive_a_war)

   (:objects 
      old_man npc - player 
      in out north south east west up down - direction 
      brickhouse church stonehouse church pond parkinglot park store - location 
      food - food 
      water - water
      car - car
      fishingpole - fishingpole
      fish - fish
      pot - pot
      rock - rock 
      bandage - bandage
   )

   (:init
      (connected parkinglot south pond)
      (connected pond north parkinglot)
      (connected parkinglot north park)
      (connected park south parkinglot)
      (connected store west park)
      (connected park east store)
      (connected church north park)
      (connected park south church)
      (connected car east park)
      (connected park west car)
      (connected stonehouse south car)
      (connected car north stonehouse)
      (connected brickhouse east car)
      (connected car west brickhouse)
      (at npc parkinglot)
      (is_injured npc)
      (is_injured old_man)
      (has_water_source pond)
      (haslake pond)
      (at rock park)
      (gettable rock)
      (at bandage store)
      (gettable bandage)
      (at pot church)
      (gettable pot)
      (at fishingpole car)
      (at old_man brickhouse)
      (at food brickhouse)
      (at fish pond)
      (is_occupied brickhouse)
      (has_windows car)
      (has_basement brickhouse)
      (has_basement stonehouse)
      (outdoors car)
      (outdoors park)
      (outdoors parkinglot)
   )

   (:goal (and  (inventory npc water) (inventory npc food) (inventory npc bandage)  ))
)


(define (problem reinforce_basement)
   (:domain survive_nuclear_attack)

   (:objects
      npc - player
      car canned_food medicine kongpao_chicken water wood paper steel concrete medical_supplies bandaid - item
      home highway homedepot pharmacy wholefoods garage basement mall - location
      in out north south east west up down - direction
   )

   (:init
      (connected home north garage)
      (connected garage south home)
      (connected basement out home)
      (connected home in basement)
      (connected garage east highway)
      (connected highway west garage)
      (connected highway down mall)
      (connected mall up highway)
      (connected mall east homedepot)
      (connected homedepot west mall)
      (connected mall south pharmacy)
      (connected pharmacy north mall)
      (connected mall north wholefoods)
      (connected wholefoods south mall)
      (blocked garage east highway)
      (at car garage)
      (is_car car)
      (is_supermarket wholefoods)
      (at canned_food wholefoods)
      (at kongpao_chicken wholefoods)
      (at water wholefoods)
      (is_nonperishable canned_food)
      (is_nonperishable water)
      (at wood homedepot)
      (at paper homedepot)
      (at steel homedepot)
      (at concrete homedepot)
      (is_construction_material wood)
      (is_construction_material steel)
      (is_construction_material concrete)
      (at medical_supplies pharmacy)
      (at bandaid pharmacy)
      (is_medicine medical_supplies)
      (is_home home)
      (is_underground basement)
      (at npc home)
      
   )

   (:goal (and (reinforced basement) ))
)

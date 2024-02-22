
(define (problem listen_to_astronomers_predictions_and_move)
   (:domain survive_comet_hitting_earth)

   (:objects
      npc - player
      Philly Salt_Lake - city
      home market - location
      in out north south east west up down - direction
      water food medicine - item
   )

   (:init
      (at npc home)
      (has_pc npc)
      (in npc Philly)
      (coastal Philly)
      (inland Salt_Lake)

   )

   (:goal (and (listen_to_broadcast npc home) (in npc Salt_Lake)))
)


(define (problem remove_players)
   (:domain create_secret_society)

   (:objects
      npc anish adrian chris lara - player
      ss - secret_society
   )

   (:init
      (in npc ss)
      (in anish ss)
      (friends npc adrian)
      (friends npc chris)
      (friends npc lara)
      (is_trusted npc ss)
      (is_trusted adrian ss)
      (is_trusted chris ss)
      (is_trusted lara ss)
      (equals npc npc)
      (equals anish anish)
      (equals adrian adrian)
      (equals chris chris)
      (equals lara lara)
   )

   (:goal (and (not (in anish ss)) (is_cult ss)))
)

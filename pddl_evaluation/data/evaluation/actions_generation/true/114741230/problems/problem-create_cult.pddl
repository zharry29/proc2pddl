
(define (problem create_cult)
   (:domain create_secret_society)

   (:objects
      npc anish adrian chris lara liam artemis neervannan binkley fiction - player
      ss - secret_society
   )

   (:init
      (in npc ss)
      (friends npc anish)
      (friends npc adrian)
      (friends anish chris)
      (friends anish binkley)
      (friends adrian lara)
      (friends adrian liam)
      (friends lara neervannan)
      (friends liam artemis)
      (friends artemis fiction)
      (is_trusted npc ss)
      (is_trusted anish ss)
      (is_trusted adrian ss)
      (is_trusted lara ss)
      (is_trusted liam ss)
      (is_trusted artemis ss)
      (is_trusted fiction ss)
      (equals npc npc)
      (equals anish anish)
      (equals adrian adrian)
      (equals chris chris)
      (equals lara lara)
      (equals liam liam)
      (equals artemis artemis)
      (equals neervannan neervannan)
      (equals binkley binkley)
      (equals fiction fiction)
   )

   (:goal (and (is_cult ss)))
)

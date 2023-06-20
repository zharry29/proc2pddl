(define (domain create_secret_society)
   (:requirements :strips :typing)
   (:types
       player secret_society
   )

   (:predicates
      (has_secret ?sc - secret_society) ; this secret_society has a secret
      (has_info ?p - player) ; has this player done the respective reading?
      (has_name ?sc - secret_society) ; this secret_society has a name
      (has_location ?sc - secret_society) ; does this secret_society have a set meeting location?
      (has_dress_code ?sc - secret_society) ; does this secret society have a dress code?
      (society_is_ready ?sc - secret_society) ; is the secret society ready to add people?
      (in ?p - player ?sc - secret_society) ; a player is in a secret society
      (is_trusted ?p - player ?sc - secret_society) ; is this player trusted to join the secret society?
      (equals ?p1 - player ?p2 - player) ; are two players the same?
      (friends ?p1 - player ?p2 - player) ; are two players friends?
      (knows_secret ?p - player ?sc - secret_society) ; does the player know the society's secret?
      (is_cult ?sc - secret_society) ; is the secret society a cult?
   )(:action gather_info
 :parameters (?self - player ?close_friend - player)
 :precondition (and
                (not (has_info ?self))
                (not (has_info ?close_friend))
                (friends ?self ?close_friend))
 :effect (and
          (has_info ?self)
          (has_info ?close_friend)))

(:action create_secret
 :parameters (?society - secret_society)
 :precondition (not (has_secret ?society))
 :effect (has_secret ?society))

(:action set_meeting_location
 :parameters (?society - secret_society)
 :precondition (not (has_location ?society))
 :effect (has_location ?society))

(:action set_dress_code
 :parameters (?society - secret_society)
 :precondition (not (has_dress_code ?society))
 :effect (has_dress_code ?society))

(:action create_name
 :parameters (?society - secret_society ?self - player ?close_friend - player)
 :precondition (and
                (not (has_name ?society))
                (has_info ?self)
                (has_info ?close_friend)
                (friends ?self ?close_friend))
 :effect (has_name ?society))

(:action secret_society_is_ready
 :parameters (?society - secret_society)
 :precondition (and
                (has_secret ?society)
                (has_name ?society)
                (has_location ?society)
                (has_dress_code ?society))
 :effect (society_is_ready ?society))

(:action initiate_new_member
 :parameters (?player - player ?society - secret_society)
 :precondition (and
                (society_is_ready ?society)
                (not (in ?player ?society)))
 :effect (in ?player ?society))

(:action teach_new_member_secret
 :parameters (?player - player ?society - secret_society)
 :precondition (and
                (in ?player ?society)
                (not (knows_secret ?player ?society)))
 :effect (knows_secret ?player ?society))

(:action remove_member
 :parameters (?player - player ?society - secret_society)
 :precondition (and
                (in ?player ?society)
                (knows_secret ?player ?society))
 :effect (and
          (not (in ?player ?society))
          (not (knows_secret ?player ?society))
          (has_secret ?society)))

(:action check_if_cult
 :parameters (?society - secret_society)
 :precondition (some_cult_criteria ?society)
 :effect (is_cult ?society))

)
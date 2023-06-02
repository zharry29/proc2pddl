
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
   )

   (:action gather_info ; read books to gather information on how to create a secret society
      :parameters (?p - player ?sc - secret_society)
      :precondition (and (in ?p ?sc) (not (has_info ?p)))
      :effect (and (has_info ?p))
   )

   (:action create_secret ; create secret for a secret society
      :parameters (?p - player ?sc - secret_society) 
      :precondition (and (has_info ?p) (in ?p ?sc) (not (has_secret ?sc)))
      :effect (and (has_secret ?sc) (knows_secret ?p ?sc))
   )

   (:action set_meeting_location ; determine a regular secret meeting location for the society
      :parameters (?p - player ?sc - secret_society)
      :precondition (and (has_info ?p) (not (has_location ?sc)))
      :effect (and (has_location ?sc))
   )

   (:action set_dress_code ; determines the dress code for the secret society
      :parameters (?p - player ?sc - secret_society)
      :precondition (and (has_info ?p) (not (has_dress_code ?sc)))
      :effect (and (has_dress_code ?sc))
   )

   (:action create_name ; create name for a secret society
      :parameters (?p - player ?sc - secret_society) 
      :precondition (and (has_info ?p) (in ?p ?sc) (not (has_name ?sc)))
      :effect (and (has_name ?sc))
   )

   (:action secret_society_is_ready ; check that all prequisites of the secret society are complete
      :parameters (?p - player ?sc - secret_society) 
      :precondition (and (not (society_is_ready ?sc)) (has_name ?sc) (has_dress_code ?sc) (has_location ?sc) (has_info ?p) (has_secret ?sc))
      :effect (and (society_is_ready ?sc))
   )

   (:action initiate_new_member ; add a new member to secret society
      :parameters (?p1 - player ?p2 - player ?sc - secret_society)
      :precondition (and (society_is_ready ?sc) (in ?p1 ?sc) (is_trusted ?p2 ?sc) (friends ?p1 ?p2) (not (in ?p2 ?sc)))
      :effect (and (in ?p2 ?sc))
   )

   (:action teach_new_member_secret ; once a new member becomes trustworthy, teach them the secret
      :parameters (?p1 - player ?p2 - player ?sc - secret_society)
      :precondition (and (in ?p1 ?sc) (in ?p2 ?sc) (is_trusted ?p1 ?sc) (is_trusted ?p2 ?sc) (knows_secret ?p1 ?sc) (not (knows_secret ?p2 ?sc)))
      :effect (and (knows_secret ?p2 ?sc))
   )

   (:action remove_member ; remove an existing society member due to untrustworthiness
      :parameters (?p - player ?sc - secret_society)
      :precondition (and (in ?p ?sc) (not (is_trusted ?p ?sc)))
      :effect (and (not (in ?p ?sc)))
   )

   (:action check_if_cult ; check if the group is large enough for a cult
      :parameters (?p1 - player ?p2 - player ?p3 - player ?p4 - player ?sc - secret_society)
      :precondition (and (society_is_ready ?sc) (not (equals ?p1 ?p2)) (not (equals ?p1 ?p3)) (not (equals ?p1 ?p4)) (not (equals ?p2 ?p3)) (not (equals ?p2 ?p4)) (not (equals ?p3 ?p4)) (in ?p1 ?sc) (in ?p2 ?sc) (in ?p3 ?sc) (in ?p4 ?sc) (is_trusted ?p1 ?sc) (is_trusted ?p2 ?sc) (is_trusted ?p3 ?sc) (is_trusted ?p4 ?sc) (knows_secret ?p1 ?sc) (knows_secret ?p2 ?sc) (knows_secret ?p3 ?sc) (knows_secret ?p4 ?sc))
      :effect (and (is_cult ?sc))
   )
)

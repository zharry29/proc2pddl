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
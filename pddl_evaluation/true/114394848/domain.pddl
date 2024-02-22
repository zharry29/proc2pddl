
(define (domain how_to_hack)
   (:requirements :strips :typing)
   (:types
       computer mobile_phone tablet network - digital_system 
       player direction location concept skill 
       all_information permission ping_succeed server_checked network_scanner TCP_UDP_ports password memory_layout malware track usernames hostnames network IP settings applications SNMP_and_DNS - item
        
        ; NEW -----------------------------------------------
        search   - skill
        html     - skill

        cpp      - skill
        py       - skill
        php      - skill
        bash     - skill
        assembly - skill
       
        unix     - skill

        hacking  - concept
        ethics   - concept
   )
   (:predicates
      (at ?obj - object ?loc - location) ; an object is at a location 
      (connected ?loc1 - location ?dir - direction ?loc2 - location) ; location 1 is connected to location 2 in the direction
      (blocked ?loc1 - location ?dir - direction ?loc2 - location) ; the connection between location 1 and 2 in currently blocked
      (inventory ?player ?item) ; an item is in the player's inventory
      (know ?player ?concept) ; an concept is understood by player
      (learned ?player ?skill) ; an skill is learned by player
      (authorized ?player); player is authorized
      (collected_all_info ?player)
      (port_scanned ?player); already run a scan on port
      (password_cracked ?player); cracked the password by brute force, social, Phishing, or ARP Spoofing
      (tricked_user_password ?player)
      (user_trusted_fake_email ?player)
      (people_use_unencrypted_connection ?player)
      (is_root_user ?player)
      (administrator_know_compromised ?player)
      (website_unchanged ?player)
      (create_more_file_than_need ?player)
      (additional_users ?player)
      (hardcoded_secret_password ?player)
      
      ; NEW ------------------------------------------------
      (know_programming ?p - player)
      (know_hacking     ?p - player)
      (know_ethics      ?p - player)
      (know_unix        ?p - player)
      (know_internet    ?p - player)
   )
   (:action go ; navigate to an adjacent location 
      :parameters (?dir - direction ?p - player ?l1 - location ?l2 - location) 
      :precondition (and (at ?p ?l1) (connected ?l1 ?dir ?l2) (not (blocked ?l1 ?dir ?l2)))
      :effect (and (at ?p ?l2) (not (at ?p ?l1)))
   )
   (:action understand ; understand some concept
      :parameters (?p - player ?c1 - concept)
      :precondition (not (know ?p ?c1))
      :effect (know ?p ?c1)
   )
   (:action learn ; learn a skill
      :parameters (?p - player ?k1 - skill)
      :precondition (not (learned ?p ?k1))
      :effect (learned ?p ?k1)
   )
   (:action get ; get a item
      :parameters (?p - player ?t - item ?l - location)
      :precondition (and (not (inventory ?p ?t)) (at ?t ?l) (at ?p ?l)) ; 
      :effect (inventory ?p ?t)
   )
   (:action machine_secured ; onward to step2
      :parameters (?p - player ?permission - permission ?l1 - location ?dir - direction ?l2 - location)
      :precondition (and (inventory ?p ?permission) (at ?p ?l1) (at ?permission ?l1))
      :effect (not (blocked ?l1 ?dir ?l2))
   )
   (:action enumeration;
      :parameters (?p - player ?info - all_information ?l - location ?usernames - usernames ?hostnames - hostnames ?network - network ?IP - IP ?settings - settings ?applications - applications ?SNMP_and_DNS - SNMP_and_DNS)
      :precondition (and (not (inventory ?p ?info)) (at ?info ?l) (at ?p ?l) (inventory ?p ?usernames) (inventory ?p ?hostnames) (inventory ?p ?network) (inventory ?p ?IP) (inventory ?p ?settings) (inventory ?p ?applications) (inventory ?p ?SNMP_and_DNS)) ; 
      :effect (collected_all_info ?p)
   )
   (:action got_all_info ; onward to step 3 
      :parameters (?p - player ?info - all_information ?l1 - location ?dir - direction ?l2 - location)
      :precondition (and (collected_all_info ?p) (at ?p ?l1) (at ?info ?l1))
      :effect (not (blocked ?l1 ?dir ?l2))
   )
   (:action ping;
      :parameters (?p - player ?ping_succeed - ping_succeed ?l1 - location ?info - all_information)
      :precondition (and (not (inventory ?p ?ping_succeed)) (at ?p ?l1) (collected_all_info ?p));
      :effect (inventory ?p ?ping_succeed)
   )
   (:action check_email_server;
      :parameters (?p - player ?server_checked - server_checked ?l1 - location ?info - all_information)
      :precondition (and (not (inventory ?p ?server_checked)) (at ?p ?l1) (collected_all_info ?p)); 
      :effect (inventory ?p ?server_checked)
   )

   (:action reached_the_remote_system;
      :parameters (?p - player ?l1 - location ?dir - direction ?l2 - location ?ping_succeed - ping_succeed ?server_checked - server_checked)
      :precondition (and (at ?p ?l1) (inventory ?p ?server_checked) (inventory ?p ?ping_succeed) (blocked ?l1 ?dir ?l2) (at ?ping_succeed ?l1))
      :effect (not (blocked ?l1 ?dir ?l2)) 
   ); onward to step 4
   (:action run_port_scan
      :parameters (?p - player ?l1 - location ?dir - direction ?l2 - location ?network_scanner - network_scanner)
      :precondition (and (at ?p ?l1) (not (port_scanned ?p)) (blocked ?l1 ?dir ?l2) (inventory ?p ?network_scanner))
      :effect (and (port_scanned ?p) (not (blocked ?l1 ?dir ?l2)))
   ); onward to step 5
   (:action found_path_in_system
      :parameters (?p - player ?l1 - location ?dir - direction ?l2 - location ?TCP_UDP_ports - TCP_UDP_ports)
      :precondition (and (at ?p ?l1) (blocked ?l1 ?dir ?l2) (inventory ?p ?TCP_UDP_ports) (at ?TCP_UDP_ports ?l1))
      :effect (and (not (blocked ?l1 ?dir ?l2)))
   ); onward to step 6

   (:action contact_and_trick_a_user
      :parameters (?p - player ?l1 - location ?password - password)
      :precondition (and (at ?p ?l1) (at ?password ?l1) (not (tricked_user_password ?p)))
      :effect (tricked_user_password ?p)
   )
   (:action crack_password_by_social_engineering
      :parameters (?p - player ?l1 - location ?password - password)
      :precondition (and (at ?p ?l1) (at ?password ?l1) (tricked_user_password ?p))
      :effect (password_cracked ?p)
   )

   (:action send_fake_email
      :parameters (?p - player ?l1 - location ?password - password)
      :precondition (and (at ?p ?l1) (at ?password ?l1) (not (user_trusted_fake_email ?p)))
      :effect (user_trusted_fake_email ?p)
   )
   (:action crack_password_by_phishing
      :parameters (?p - player ?l1 - location ?password - password)
      :precondition (and (at ?p ?l1) (at ?password ?l1) (user_trusted_fake_email ?p))
      :effect (password_cracked ?p)
   )

   (:action create_fake_wifi_access
      :parameters (?p - player ?l1 - location ?password - password)
      :precondition (and (at ?p ?l1) (at ?password ?l1) (not (people_use_unencrypted_connection ?p)))
      :effect (people_use_unencrypted_connection ?p)
   )
   (:action crack_password_by_arp_spoofing
      :parameters (?p - player ?l1 - location ?password - password)
      :precondition (and (at ?p ?l1) (at ?password ?l1) (people_use_unencrypted_connection ?p))
      :effect (password_cracked ?p)
   )
   (:action crack_password_by_brute_force
      :parameters (?p - player ?l1 - location ?password - password)
      :precondition (and (at ?p ?l1) (at ?password ?l1) )
      :effect (password_cracked ?p)
   )

   (:action gain_access_with_password
      :parameters (?p - player ?l1 - location ?dir - direction ?l2 - location ?password - password)
      :precondition (and (password_cracked ?p) (blocked ?l1 ?dir ?l2) (at ?password ?l1))
      :effect (and (not (blocked ?l1 ?dir ?l2)) (not (password_cracked ?p)))
   ); ; onward to step 7

   (:action create_buffer_overflow
      :parameters (?p - player ?memory_layout - memory_layout)
      :precondition (and (inventory ?p ?memory_layout) )
      :effect (is_root_user ?p)
   )
   
   (:action take_control_of_system
      :parameters (?p - player ?l1 - location ?dir - direction ?l2 - location ?memory_layout - memory_layout)
      :precondition (and (is_root_user ?p) (blocked ?l1 ?dir ?l2) (at ?memory_layout ?l1))
      :effect (and (not (blocked ?l1 ?dir ?l2)) (not (is_root_user ?p)))
   ); ; onward to step 8
   
   (:action install_malware
      :parameters (?p - player ?malware - malware ?l1 - location)
      :precondition (and (inventory ?p ?malware) (at ?malware ?l1) (at ?p ?l1))
      :effect (malware_installed ?p)
   )

   (:action bypass_standard_authentication_system
      :parameters (?p - player ?l1 - location ?dir - direction ?l2 - location ?malware - malware)
      :precondition (and (malware_installed ?p) (blocked ?l1 ?dir ?l2) (at ?malware ?l1))
      :effect (and (not (blocked ?l1 ?dir ?l2)) (not (malware_installed ?p)))
   ); ; onward to step 9

   (:action not_let_administrator_know
      :parameters (?p - player ?l1 - location ?track - track)
      :precondition (and (at ?p ?l1) (at ?track ?l1)); 
      :effect (not (administrator_know_compromised ?p))
   )
   (:action make_no_change_to_website
      :parameters (?p - player ?l1 - location ?track - track)
      :precondition (and (at ?p ?l1) (at ?track ?l1)); 
      :effect (website_unchanged ?p)
   )
   (:action create_fewest_file
      :parameters (?p - player ?l1 - location ?track - track)
      :precondition (and (at ?p ?l1) (at ?track ?l1)); 
      :effect (not (create_more_file_than_need ?p))
   )
   (:action delete_additional_users
      :parameters (?p - player ?l1 - location ?track - track)
      :precondition (and (at ?p ?l1) (at ?track ?l1)); 
      :effect (not (additional_users ?p))
   )
   (:action hardcode_password
      :parameters (?p - player ?l1 - location ?track - track)
      :precondition (and (at ?p ?l1) (at ?track ?l1)); 
      :effect (hardcoded_secret_password ?p)
   )
   (:action track_covered
      :parameters (?p - player ?l1 - location ?dir - direction ?l2 - location ?track - track)
      :precondition (and (not (administrator_know_compromised ?p)) (not (create_more_file_than_need ?p)) (not (additional_users ?p)) (hardcoded_secret_password ?p) (website_unchanged ?p) (blocked ?l1 ?dir ?l2) (at ?track ?l1))
      :effect (and (not (blocked ?l1 ?dir ?l2)) )
   ); ; onward to end


  ; NEW ----------------------------------------------------
  (:action learn_concepts
      :parameters (
          ?p  - player
          ?hk - hacking
          ?et - ethics
      )
      :precondition (and 
          (know ?p ?hk)
          (know ?p ?et))
      :effect (and (know_hacking ?p) (know_ethics ?p))
  )

  (:action learn_internet
      :parameters (
          ?p      - player
          ?html   - html 
          ?search - search
      )
      :precondition (and 
          (learned ?p ?html)
          (learned ?p ?search))
      :effect (know_internet ?p)
  )

  (:action learn_programming
      :parameters (
          ?p    - player
          ?cp   - cpp
          ?php  - php
          ?py   - py
          ?bash - bash
          ?asb  - assembly
      )
      :precondition (and 
          (learned ?p ?cp)
          (learned ?p ?php)
          (learned ?p ?py)
          (learned ?p ?asb))
      :effect (know_programming ?p)
  )

  (:action learn_unix
      :parameters (
          ?p    - player
          ?u    - unix
      )
      :precondition (and 
          (learned ?p ?u))
      :effect (know_unix ?p)
  )

  (:action become_skilled
          :parameters (
              ?p      - player
              ?l1     - location 
              ?dir    - direction 
              ?l2     - location)
          :precondition (and 
              (know_programming ?p)
              (know_hacking     ?p)
              (know_ethics      ?p)
              (know_internet    ?p)
              (know_unix        ?p))
          :effect (not (blocked ?l1 ?dir ?l2))
  )
  ; -----------------------------------------------------------------------

)

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
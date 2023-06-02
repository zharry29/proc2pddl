
(define (problem hacking2)
   (:domain how_to_hack)

   (:objects
      npc - player
      next - direction
      securing_machine knowing_target testing_target running_port_scan finding_path cracking_password getting_superuser_privileges creating_back_door covering_tracks end_hacking - location
      white_permission - permission
      usernames - usernames 
      hostnames - hostnames
      network - network
      IP - IP
      settings - settings 
      applications - applications 
      SNMP_and_DNS - SNMP_and_DNS
      info - all_information
      ping_succeed - ping_succeed
      server_checked - server_checked
      network_scanner - network_scanner
      TCP_UDP_ports - TCP_UDP_ports
      password - password
      memory_layout - memory_layout
      malware - malware
      track - track
   )

   (:init
     (connected securing_machine next knowing_target)
     (blocked securing_machine next knowing_target)
     (connected knowing_target next testing_target)
     (blocked knowing_target next testing_target)
     (connected testing_target next running_port_scan)
     (blocked testing_target next running_port_scan)
     (connected running_port_scan next finding_path)
     (blocked running_port_scan next finding_path)
     (connected finding_path next cracking_password)
     (blocked finding_path next cracking_password)
     (connected cracking_password next getting_superuser_privileges)
     (blocked cracking_password next getting_superuser_privileges)

     (connected getting_superuser_privileges next creating_back_door)
     (blocked getting_superuser_privileges next creating_back_door)

     (connected creating_back_door next covering_tracks)
     (blocked creating_back_door next covering_tracks)

     (connected covering_tracks next end_hacking)
     (blocked covering_tracks next end_hacking)
     
     (at npc knowing_target)
     (at white_permission securing_machine)
     (at usernames knowing_target)
     (at hostnames knowing_target)
     (at network knowing_target)
     (at IP knowing_target)
     (at settings knowing_target)
     (at applications knowing_target)
     (at SNMP_and_DNS knowing_target)
     (at info knowing_target)
     (at ping_succeed testing_target)
     (at network_scanner running_port_scan)
     (at TCP_UDP_ports finding_path)
     (at password cracking_password)
     (at memory_layout getting_superuser_privileges)
     (at malware creating_back_door)
     (at track covering_tracks)

     (administrator_know_compromised npc)
     (create_more_file_than_need npc)
     (additional_users npc)
   )
   (:goal  (at npc end_hacking) ); (not(administrator_know_compromised npc)) (at npc covering_tracks)
)

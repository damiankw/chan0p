bind pub f `topic pub_topic
bind msg f topic msg_topic
proc msg_topic {nick host hand varz} {
  global mainchan
  set chan [lindex $varz 0]
  set flags [lrange $varz 1 end]
  if {$chan == "" || ![ischan $chan]} {
    puthelp "NOTICE $nick :Wheres the channel name!?"
    return 0
  }
  if {[string tolower $chan] != [string tolower $mainchan]} {
    puthelp "NOTICE $nick :Wrong channel buddy, try $mainchan ;)"
    return 0
  }
  pub_topic $nick $host $hand $chan $flags
  return 0
}
proc pub_topic {nick host hand chan varz} {
  global mainchan mckeeptopic botnick datapath
  if {[string tolower $chan] != [string tolower $mainchan]} {
    return 0
  }
  if {[authcheck $nick $host $hand $chan] != 1} {
    return 0
  }
  chan0pinfo $chan
  set keeptopic $mckeeptopic
  set what [lrange $varz 0 end]
  if {$keeptopic > [level $hand]} {
    puthelp "NOTICE $nick :Your level of [getuser $hand XTRA level] is lower than the minimum level of $keeptopic required to change topics in $chan"
    return 0
  }
  if {$what == ""} {
    set what [randtopic]
    set topic [open "$datapath$mainchan.topic" "WRONLY CREAT"]
    puts $topic $what
    close $topic
    putserv "TOPIC $chan :$what"
    return 0
  }
  set topic [open "$datapath$mainchan.topic" "WRONLY CREAT"]
  puts $topic $what
  close $topic
  putserv "TOPIC $chan :$what"
}

proc gettopic {chan} {
  global mainchan datapath
  set chan [string tolower $chan]
  set topic [open "$datapath$mainchan.topic" "RDONLY CREAT"]
  set chantopic "[gets $topic]"
  close $topic
  if {$chantopic == ""} {
    return ""
  }
  if {$chantopic != ""} {
    return $chantopic
  }
}

proc curtopic {chan} {
  global datapath
  set curtopic [topic $chan]
  set settopic [gettopic $chan]
  if {$curtopic != "" && $settopic == ""} {
    putserv "TOPIC $chan :to set a topic. type `topic <topic>"
    return 0
  }
  if {$curtopic != "" && $curtopic != $settopic} {
    set topic [open "$datapath$mainchan.topic" "WRONLY CREAT"]
    puts $topic $what
    close $topic
    return 0
  }
}

bind topc - * topc_keeptopic
proc topc_keeptopic {nick host hand chan topc} {
  global mckeeptopic botnick mainchan
  if {[string tolower $chan] != [string tolower $mainchan]} {
    return 0
  } 
  if {$nick == $botnick} { 
    return 0
  }
  if {[validuser $hand] == 0} {
    puthelp "NOTICE $nick :You do not have access to $chan. if you have not identified. please /msg $botnick identify <password>"
    putserv "TOPIC $chan :[gettopic $chan]"
    return 0
  }
  if {[matchattr $hand +A] == 0} {
    puthelp "NOTICE $nick :You do not have access to $chan. if you have not identified. please /msg $botnick identify <password>"
    putserv "TOPIC $chan :[gettopic $chan]"
    return 0
  }
  chan0pinfo $chan
  if {[getuser $hand XTRA level] < $mckeeptopic} {
    puthelp "NOTICE $nick :$chan has topics restricted to level $mckeeptopic and higher"
    putserv "TOPIC $chan :[gettopic $chan]"
    return 0
  }
}

proc randtopic {} {
  global topicstxtpath
  set randtopic "bleh"
  set rndtpc 0
  set randmtpc [rand [getlines $topicstxtpath]]
  set rtpc [open "$topicstxtpath" "RDWR"]
  while {$rndtpc != $randmtpc} {
    incr rndtpc 1
    if {$rndtpc == $randmtpc} {
      set randtopic [gets $rtpc]
      return "$randtopic"
    }
    set nup [gets $rtpc]
  }
  if {$randtopic == ""} {
    return "I have no idea for a topic sowwy, try asking $who"
  }
  return "I have no idea for a topic sowwy, try asking $who"
}


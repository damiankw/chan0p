
bind msg f game msg_game

proc msg_game {nick host hand varz} {
  global hubchan mainchan botnick
  set chan [lindex $varz 0]
  set what [lindex $varz 1]
  set why [lindex $varz 2]
  if {[string tolower $chan] != [string tolower $mainchan]} {
    return 0
  }
  chan0pinfo [string tolower $chan]
  if {[authcheck $nick $host $hand $chan] != 1} {
    return 0
  }
  if {[level $hand] < 190} {
    puthelp "NOTICE $nick :Your level of [level $hand] in $chan is less than the required level of 190 for this command"
    return 0
  }
  if {$what == ""} {
    puthelp "NOTICE $nick :Syntax: GAME <#chan> <8ball> <on|off>"
    return 0
  }
  if {[string tolower $what] != "8ball"} {
    puthelp "NOTICE $nick :Invalid request: $what"
    return 0
  }
  if {[string tolower $why] == "on"} {
    puthelp "NOTICE $nick :Setting for 'game $what' now set to on for $chan"
    pubinfoset $chan game "ON"
    return 0
  }
  if {$why == "off"} {
    puthelp "NOTICE $nick :Setting for 'game $what' now set to off for $chan"
    pubinfoset $chan game OFF
    return 0
  }
  putserv "NOTICE $nick :Bug, report to apocalypse, error code g1"
  return 0
}

bind pub f `8ball pub_8ball

proc pub_8ball {nick host hand chan varz} {
  chan0pinfo [string tolower $chan]
  global mainchan hubchan mcgame
  set what [lrange $varz 0 end]
  if {[string tolower $chan] != [string tolower $mainchan]} {
    return 0
  }
  if {[level $hand] < 25} {
    puthelp "NOTICE $nick :Your level of [level $hand] in $chan is less than the required level of 25 for this command"
    return 0
  }
  if {$what == ""} {
    puthelp "NOTICE $nick :Invalid request: What question did you want to ask? :)"
    return 0
  }
  if {$mcgame != "ON"} {
    puthelp "NOTICE $nick :Error: Channel '$chan' doesn't currently have 8Ball turned on"
    return 0
  }
  set 8banswer [rand8banswer]
  puthelp "PRIVMSG $chan :8ball: $what??, $8banswer"
  return 0
}

proc rand8banswer {} {
  global 8ballpath
  set rndans 0
  set randmans [rand [getlines $8ballpath]]
  set rans [open "$8ballpath" "RDONLY"]
  while {$rndans != $randmans} {
    incr rndans 1
    if {$rndans == $randmans} {
      set randanswer [gets $rans]
      close $rans
      if {$randanswer != ""} { return "$randanswer" }
    }
    set nup [gets $rans]
  }
  if {$randanswer == ""} {
    return "ERROR :D"
  }
  return "ERROR :D~"
}

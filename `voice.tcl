
bind pub f `voice pub_voice
bind msg f voice msg_voice
proc msg_voice {nick host hand varz} {
  global mainchan
  set chan [lindex $varz 0]
  set who1 [lindex $varz 1]
  set who2 [lindex $varz 2]
  set who3 [lindex $varz 3]
  set who4 [lindex $varz 4]
  set who5 [lindex $varz 5]
  set who6 [lindex $varz 6]
  if {$chan == "" || ![ischan $chan]} {
    puthelp "NOTICE $nick :Wheres the channel name!?"
    return 0
  }
  if {[string tolower $chan] != [string tolower $mainchan]} {
    puthelp "NOTICE $nick :Wrong channel buddy, try $mainchan ;)"
    return 0
  }
  pub_voice $nick $host $hand $chan "$who1 $who2 $who3 $who4 $who5 $who6"
  return 0
}
#start of `voice

proc pub_voice {nick host hand chan varz} {
  global c0logo botnick mainchan
  set who1 [lindex $varz 0]
  set who2 [lindex $varz 1]
  set who3 [lindex $varz 2]
  set who4 [lindex $varz 3]
  set who5 [lindex $varz 4]
  set who6 [lindex $varz 5]
  if {[string tolower $chan] != [string tolower $mainchan]} {
    return 0
  }
  if {[authcheck $nick $host $hand $chan] != 1} {
    return 0
  }
  if {[getuser $hand XTRA level] < 50} {
    puthelp "NOTICE $nick :Your level of [getuser $hand XTRA level] is lower then the required level of 50 for this command"
    return 0
  }
  if {![botisop $chan]} {
    puthelp "NOTICE $nick :I am Not Oped on $chan" 
    return 0
  } 
  if {$who1 == ""} {
    putserv "MODE $chan +v $nick"
    putlog "($nick!$host) !$hand! VOICE ($chan) - $c0logo"
    return 0
  } 
  if {$who1 == $botnick} {
    putserv "MODE $chan +vvvvv $who2 $who3 $who4 $who5 $who6"
    return 0
  }
  if {$who2 == $botnick} {
    putserv "MODE $chan +vvvvv $who1 $who3 $who4 $who5 $who6"
    return 0
  }
  if {$who3 == $botnick} {
    putserv "MODE $chan +vvvvv $who1 $who2 $who4 $who5 $who6"
    return 0
  }
  if {$who4 == $botnick} {
    putserv "MODE $chan +vvvvv $who1 $who2 $who3 $who5 $who6"
    return 0
  }
  if {$who5 == $botnick} {
    putserv "MODE $chan +vvvvv $who1 $who2 $who3 $who4 $who6"
    return 0
  }
  if {$who6 == $botnick} {
    putserv "MODE $chan +vvvvv $who1 $who2 $who3 $who4 $who5"
    return 0
  }
  putserv "MODE $chan +vvvvvv $who1 $who2 $who3 $who4 $who5 $who6"
  putlog "($nick!$host) !$hand! VOICE [lrange $varz 0 end] ($chan). - $c0logo"
  return 0
}
# end of `voice

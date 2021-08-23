
bind pub n `secure pub_secure

proc pub_secure {nick host hand chan varz} {
  global mainchan hubchan botnick
  if {[string tolower $chan] != [string tolower $mainchan]} {
    return 0
  }
  if {[authcheck $nick $host $hand $chan] != 1} {
    return 0
  }
  if {[getuser $hand XTRA level] < 190} {
    puthelp "NOTICE $nick :Your level of [getuser $hand XTRA level] is lower then the required level of 195 for this command."
    return 0
  }
  if {[string tolower $varz] == "on"} {
    hubchanmsg "WARNING!! $nick has set $mainchan to secure mode, mass deop/voice'ing and setting secure channel modes"
    foreach user [chanlist $chan] {
      if {[isop $user $chan]} {
        if {[getuser [nick2hand $user $chan] XTRA level] < 190 && $user != $botnick} {
          pushmode $chan -o $user
        }
      }
    }
    foreach user [chanlist $chan] {
      if {[isvoice $user $chan]} {
        if {[getuser [nick2hand $user $chan] XTRA level] < 190 && $user != $botnick} {
          pushmode $chan -v $user
        }
      }
    }
    putserv "MODE $chan +lik [chanlimnum $chan] secure"
    putserv "MODE $chan +res"
    putserv "MODE $chan +m"
    return 0
  }
  if {[string tolower $varz] == "off"} {
    foreach user [chanlist $chan] {
      if {![isop $user $chan]} {
        if {[matchattr [nick2hand $user $chan] +A] == 1 && [matchattr [nick2hand $user $chan] |+o] == 1} {
          pushmode $chan +o $user
        }
      }
    }
    putserv "MODE $chan -lim"
    putserv "MODE $chan -res"
    putserv "MODE $chan -k secure"
    putserv "MODE $chan -mp"
    return 0
  }
}

proc chanlimnum {chan} {
  set num 0
  foreach user [chanlist $chan] {
    incr num 1
  }
  return [expr $num + 1]
}

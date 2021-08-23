
bind pub f `kick pub_kick
bind msg f kick msg_kick
proc msg_kick {nick host hand varz} {
  global mainchan
  set chan [lindex $varz 0]
  set who [lindex $varz 1]
  set reason [lrange $varz 2 end]
  if {$chan == "" || ![ischan $chan]} {
    puthelp "NOTICE $nick :Wheres the channel name!?"
    return 0
  }
  if {[string tolower $chan] != [string tolower $mainchan]} {
    puthelp "NOTICE $nick :Wrong channel buddy, try $mainchan ;)"
    return 0
  }
  pub_kick $nick $host $hand $chan "$who $reason"
  return 0
}
proc pub_kick {nick host hand chan varz} {
  global botnick c0logo mainchan
  if {[string tolower $chan] != [string tolower $mainchan]} {
    return 0
  }
  set who [lindex $varz 0]
  if {[authcheck $nick $host $hand $chan] != 1} {
    return 0
  }
  if {[level $hand] < 50} {
    puthelp "NOTICE $nick :Your level of [level $hand] is lower then the required level of 50 for this command"
    return 0
  }
  if {![onchan $who $chan]} {
    puthelp "NOTICE $nick :$who is not on $chan"
    return 0
  }
  if {![isop $botnick $chan]} {
    puthelp "NOTICE $nick :Sorry, I can't kick $who from $chan: I'm not opped!"
    return 0
  }
  if {$who == $botnick} {
    putserv "KICK $chan $nick :Why would I want to kick myself?!"
    return 0
  }
  if {![validuser $who]} {
    if {[lrange $varz 1 end] == ""} {
      putlog "($nick!$host) !$hand! kick $chan $who - $c0logo"
      putserv "KICK $chan $who :\[$nick\] User Kick Requested"
      return 0
    }
    if {[lrange $varz 1 end] != ""} {
      putlog "($nick!$host) !$hand! kick $chan $who - $c0logo"
      putserv "KICK $chan $who :\[$nick\] [lrange $varz 1 end]"
      return 0
    }
  }
  if {[validuser $who]} {
    set whoh [nick2hand $who $chan]
    if {[level $whoh] >= [level $hand]} {
      puthelp "NOTICE $nick :$who's level of [level $whoh] is higher then or equal to your level of [level $hand]"
      return 0
    }
    if {[lrange $varz 1 end] == ""} {
      putlog "($nick!$host) !$hand! kick $chan $who - $c0logo"
      putserv "KICK $chan $who :\[$nick\] User Kick Requested"
      return 0
    }
    if {[lrange $varz 1 end] != ""} {
      putlog "($nick!$host) !$hand! kick $chan $who - $c0logo"
      putserv "KICK $chan $who :\[$nick\] [lrange $varz 1 end]"
      return 0
    }
  }
}

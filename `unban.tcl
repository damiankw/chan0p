
bind pub f `unban pub_unban
bind msg f unban msg_unban
proc msg_unban {nick host hand varz} {
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
  pub_unban $nick $host $hand $chan $flags
  return 0
}

proc pub_unban {nick host hand chan varz} {
  global botnick c0logo mainchan
  if {[string tolower $chan] != [string tolower $mainchan]} {
    return 0
  }
  set who [lindex $varz 0]
  if {[authcheck $nick $host $hand $chan] != 1} {
    return 0
  }
  if {[getuser $hand XTRA level] < 75} {
    puthelp "NOTICE $nick :Your level of [getuser $hand XTRA level] is lower then the required level of 75 for this command"
    return 0
  }
  if {[isop $botnick $chan] == 0} {
    puthelp "NOTICE $nick :Sorry, I can't unban $who from $chan: I'm not opped!"
    return 0
  }
  if {$who == ""} {
    puthelp "NOTICE $nick :UNBAN Syntax: `unban <nick|host>"
    return 0
  }
  if {$who == "all"} {
    if {[getuser $hand XTRA level] < 125} {
      puthelp "NOTICE $nick :Your level of [level $hand] is lower then the required level of 125 for this command"
      return 0
    }
    foreach ban [userlist &K] {
      if {[getuser $ban XTRA blevel] <= [level $hand]} {
        c0unban $ban
      }
    }
    puthelp "NOTICE $nick :Finished Parsing banlist for $chan"
    return 0
  }
  if {[string match "*!*@*" $who] == 1} {
    set bhand [all2ban $who]
  }
  if {[string match "*!*@*" $who] == 0} {
    set bhand [all2ban $who]
  }
  if {$bhand == ""} {
    puthelp "NOTICE $nick :$who is not in the $chan banlist"
    return 0
  }
  if {[getuser $bhand XTRA blevel] > [getuser $hand XTRA level]} {
    puthelp "NOTICE $nick :$who's ban level of [getuser $bhand XTRA blevel] is higher then your level of [getuser $hand XTRA level]"
    return 0
  }
  if {[string match "*!*@*" $bhand] == 0} {
    pushmode $chan -b [ban2host $bhand]
    c0unban $bhand
    puthelp "NOTICE $nick :Removed $who from the banlist"
    return 0
  }
  if {[string match "*!*@*" $bhand] == 1} {
    pushmode $chan -b $bhand
    c0unban [all2ban $bhand]
    puthelp "NOTICE $nick :Removed $who from the banlist"
    return 0
  }
}

proc ban2hand {who} {
  foreach ban [userlist &K] {
    if {$who == $ban} {
      return "[getuser $ban XTRA realnick]"
    }
  }
  return 0
}
proc hand2ban {who} {
  foreach ban [userlist &K] {
    if {$who == [getuser $ban XTRA realnick]} {
      return $ban
    }
  }
}
proc bhand2host {who} {
  foreach ban [userlist &K] {
    if {$who == [getuser $ban XTRA realnick]} {
      return [getuser $ban XTRA banhost]
    }
  }
}
proc ban2host {who} {
  foreach ban [userlist &K] {
    if {$who == $ban} {
      return [getuser $ban XTRA banhost]
    }
  }
}
proc host2ban {who} {
  foreach ban [userlist &K] {
    if {$who == [getuser $ban XTRA banhost]} {
      return $ban
    }
  }
}
proc all2ban {who} {
  foreach ban [userlist &K] {
    if {$who == [getuser $ban XTRA banhost] || $who == [getuser $ban XTRA realnick]} {
      return $ban
    }
  }
}

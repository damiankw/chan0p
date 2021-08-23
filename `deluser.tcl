
bind pub f `deluser pub_deluser
bind msg f deluser msg_deluser

proc msg_deluser {nick host hand varz} {
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
  pub_deluser $nick $host $hand $chan $flags
  return 0
}
# Start of pub_deluser
proc pub_deluser {nick host hand chan varz} {
  global c0logo hubchan botnick mainchan
  if {[string tolower $chan] != [string tolower $mainchan]} {
    return 0
  }
  set who [lindex $varz 0]
  set usho [maskhost [getchanhost $who $chan]]
  if {[authcheck $nick $host $hand $chan] != 1} {
    return 0
  }
  if {[getuser $hand XTRA level] < 150} {
    puthelp "NOTICE $nick :Your level of [getuser $hand XTRA level] is lower then the required level of 150 for this command"
    return 0
  }
  if {$who == ""} {
    puthelp "NOTICE $nick :Usage: `deluser <User to delete.>"
    return 0
  }
  if {[onchan $who $chan]} {
    set whoh [nick2hand $who $chan]
    if {[getuser $whoh XTRA level] == ""} {
      puthelp "NOTICE $nick :$who is not in the $chan Database"
      return 0
    }
    if {[validuser $who] == 0} {
      puthelp "NOTICE $nick :$who is not in the $chan Database"
      return 0
    }
    if {[getuser $whoh XTRA level] >= [getuser $hand XTRA level]} {
      if {[level $who] > [level $hand]} {
        pushmode "$chan -o $nick"
        suspend $botnick bot@local $nick $chan 10 "Tryed to delete $whoh"
      }
      puthelp "NOTICE $nick :$who's \[$whoh\] level of [getuser $whoh XTRA level] is higher than or equal to your level of [getuser $hand XTRA level]"
      putlog "($nick!$host) ($hand) tryed to deluser $who when $who ($whoh) has higher access!? - $c0logo"
      return 0
    }
    if {[matchattr $whoh +b]} {
      puthelp "NOTICE $nick :$who \[$whoh\] is a bot, use `delbot"
      return 0
    }
    if {$who != $whoh} {
      deluser $whoh
      if {[isop $who $chan]} {
        pushmode "$chan -o $who"
      }
      puthelp "NOTICE $nick :Deleted $who \[$whoh\] from the $chan database."
      hubchanmsg "!$hand! Deleted $who \[$whoh\] from the $chan database."
      putlog "($nick!$host) !$hand! deluser $who ($whoh) - $c0logo"
      notifydeluser $nick $host $hand $chan $who
      return 0
    } {
      deluser $who
      if {[isop $who $chan]} {
        pushmode "$chan -o $who"
      }
      puthelp "NOTICE $nick :Deleted $who from the $chan database."
      hubchanmsg "!$hand! Deleted $who from the $chan database."
      putlog "($nick!$host) !$hand! deluser $who - $c0logo"
      notifydeluser $nick $host $hand $chan $who
      return 0
    }
  }
  if {[getuser $who XTRA level] == ""} {
    puthelp "NOTICE $nick :$who is not in the $chan Database"
    return 0
  }
  if {[validuser $who] == 0} {
    puthelp "NOTICE $nick :$who is not in the $chan Database"
    return 0
  }
  if {[getuser $who XTRA level] >= [getuser $hand XTRA level]} {
    if {[level $who] > [level $hand]} {
      pushmode "$chan -o $nick"
      suspend $botnick bot@local $nick $chan 10 "Tryed to delete $whoh"
    }
    puthelp "NOTICE $nick :$who's level of [getuser $who XTRA level] is higher than or equal to your level of [getuser $hand XTRA level]"
    putlog "($nick!$host) !$hand! tryed to deluser $who when $who has higher access!? - $c0logo"
    return 0
  }
  if {[matchattr $who +b] == 1} {
    puthelp "NOTICE $nick :Bots can only be deleted by using `delbot"
    putlog "($nick!$host) !$hand! tryed to deluser $who when it is a bot!? - $c0logo"
    return 0
  }
  deluser $who
  puthelp "NOTICE $nick :Deleted $who from the $chan database."
  hubchanmsg "!$hand! Deleted $who from the $chan database."
  putlog "($nick!$host) !$hand! deluser $who - $c0logo"
  notifydeluser $nick $host $hand $chan $who
  return 0
}
# End of pub_deluser

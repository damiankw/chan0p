
bind pub n `suspend pub_suspend
bind msg f suspend msg_suspend

proc msg_suspend {nick host hand varz} {
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
  pub_suspend $nick $host $hand $chan $flags
  return 0
}
#start of pub_suspend

proc pub_suspend {nick host hand chan varz} {
  global botnick c0logo debugsu hubchan mainchan suspend suspendtime
  if {[string tolower $chan] != [string tolower $mainchan]} {
    return 0
  }
  set who [lindex $varz 0]
  set whoh [nick2hand $who $chan]
  set what [lindex $varz 1]
  set why [lrange $varz 2 end]
  if {[authcheck $nick $host $hand $chan] != 1} {
    return 0
  }
  if {$who == ""} {
    puthelp "NOTICE $nick :Invalid request: Not enough arguments"
    puthelp "NOTICE $nick :For further assistance: /msg $botnick help SUSPEND"
    return 0
  }
  if {[validuser $who] == 0} {
    puthelp "NOTICE $nick :$who is not in the $chan channel database"
    return 0
  }
  if {[onchan $who chan]} {
    set who [nick2hand $who $chan]
  }
  if {[getuser $hand XTRA level] < 150} {
    puthelp "NOTICE $nick :Your level of [getuser $hand XTRA level] in $chan is less than the required level of 150 for this command"
    return 0
  }
  if {[getuser $hand XTRA level] <= [getuser $whoh XTRA level] && [getuser $whoh XTRA level] != ""} {
    puthelp "NOTICE $nick :$who's level of [getuser $who XTRA level] in $chan is currently higher than or equal to your level of [getuser $hand XTRA level]"
    return 0
  }
  if {$what == ""} {
    suspend $nick $host $who $chan $what
    return 0
  }
  if {[string tolower $what] == "off"} {
    if {[getuser $hand XTRA level] < [getuser $whoh XTRA level]} {
      puthelp "NOTICE $nick :$who's level of [getuser $whoh XTRA level] is higher or equal than your level of [getuser $hand XTRA level]"
      return 0
    }
    if {[matchattr [nick2hand $who $chan] +S] == 1} {
      unsuspend $nick $host $who $nick $host
      return 0
    }
  }
  if {$what != ""} {
    if {![isnum $what]} {
      puthelp "NOTICE $nick :Error, invalid Arguments"
      return 0
    }
    suspend $nick $host $whoh $chan $what
    return 0
  }
}

proc suspend {nick host who chan time reason} {
  global suspend suspendtime
  if {[onchan $who $chan]} {
    set whoh [nick2hand $who $chan]
    set who [hand2nick $whoh $chan]
  } {
    set who $who
    set whoh $who
  }
  if {[validuser $who] == 0 && [validuser $whoh]} {
    putserv "PRIVMSG $nick :error code: (susp01)"
    return 0
  }
  chattr $whoh +S
  setuser $whoh XTRA suspendtime [expr $time * 60]
  setuser $whoh XTRA suspenddata [utimer [expr $time * 60] "unsuspend $nick $host $who $botnick \"console\""]
  if {[isop $who $chan]} {
    putserv "MODE $chan -o $who"
  }
  setuser $whoh XTRA suspend [unixtime]
  setuser $whoh XTRA suspendreason "$reason"
  return 0
}

proc unsuspend {nick host who unset uhost} {
  global hubchan
  if {$unset == ""} { putserv "PRIVMSG $hubchan :Suspend for $who has expired" }
  if {$unset != ""} {
    putserv "PRIVMSG $hubchan :$unset has Un-Suspended $who"
    setuser $who XTRA LM "$unset!$uhost"
  }
  chattr $who -S
  setuser $who XTRA suspendtime ""
  setuser $who XTRA suspend ""
  setuser $who XTRA suspendreason ""
  setuser $who XTRA suspenddata ""
  return 0
}

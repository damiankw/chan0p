
bind pub f `ban pub_ban
bind msg f ban msg_ban
proc msg_ban {nick host hand varz} {
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
  pub_ban $nick $host $hand $chan $flags
  return 0
}
proc pub_ban {nick host hand chan varz} {
  global botnick c0logo hubchan mainchan mcbanquota
  if {[string tolower $chan] != [string tolower $mainchan]} {
    return 0
  }
  set who [lindex $varz 0]
  set what [lindex $varz 1]
  set why [lindex $varz 2]
  set how [lindex $varz 3]
  set where [lindex $varz 4]
  set that [lindex $varz 5]
  set this [lindex $varz 6]
  set them [lindex $varz 7]
  set banadjust "$who $what $why $how $where $that $this $them"
  if {[authcheck $nick $host $hand $chan] != 1} {
    return 0
  }
  if {[level $hand] < 75} {
    puthelp "NOTICE $nick :Your level of [level $hand] is lower then the required level of 75 for this command"
    return 0
  }
  if {![botisop $chan]} {
    puthelp "NOTICE $nick :I can't ban $who from $chan: I'm not opped!"
    return 0
  }
  if {[validuser [nick2hand $who $chan]] == 1 && [level [nick2hand $who $chan]] > [level $hand]} {
     puthelp "NOTICE $nick :You cannot ban someone with higher access then you"
     return 0
  }
  if {$who == $botnick} {
    puthelp "KICK $chan $nick :Why would I want to ban myself?"
    setuser $hand XTRA suspend on
    hubchanmsg "$nick tryed to ban me on $chan. auto-suspending.."
    return 0
  }
  if {$who == ""} {
    puthelp "NOTICE $nick :BAN Syntax: `ban <nick|hostmask> \[-level|-noexpire|-nokick|-mins<mins>|-hours<hours>\] \[reason\]"
    return 0
  }
  chan0pinfo [string tolower $chan]
  if {[countbans *] >= $mcbanquota && $mcbanquota != "Unlimited"} {
    puthelp "NOTICE $nick :You have reached the maximum ban quota for this channel. you may not add anymore bans until the quota is set higher by the owner"
    return
  }
  set banflags [bflagadjust $nick $chan [lrange $varz 0 end]] 
  set who [lindex $banflags 5]
  set reason [lrange $banflags 6 end]
  set flags [lrange $banflags 0 4]
  c0addban $nick $host $hand $chan $flags $who $reason
  return 0
}

proc c0addban {nick host hand chan flags who reason} {
  global botnick c0logo
  if {$flags == 0} {
    puthelp "NOTICE $nick :Error Code \[b1\]"
  }
  if {[lindex $flags 0] == "no"} {
    set nokick "no"
  } { set nokick "yes" }
  if {[lindex $flags 1] == "no"} {
    set noexp "no"
  } { set noexp "yes" }
  if {[lindex $flags 2] == "no"} {
    set mins "no"
  } { set mins [lindex $flags 2] }
  if {[lindex $flags 3] == "no"} {
    set hours "no"
  } { set hours [lindex $flags 3] }
  if {[lindex $flags 4] == "no"} {
    set level "no"
  } { set level [lindex $flags 4] }
  if {$level == "no"} {
    set level [level $hand]
  }
  if {$mins == "no" && $hours == "no"} {
    set time [expr 60 * 60]
  }
  if {$hours != "no"} {
    set time [expr [hours2mins $hours] * 60]
  }
  if {$mins != "no"} {
    if {$hours != "no"} {
      set time [expr [expr $mins * 60] + [expr [hours2mins $hours] * 60]]
    } {
      set time [expr $mins * 60]
    }
  }
  if {$noexp == "yes"} {
    set time "Never"
  }
  if {$level > [level $hand]} {
    puthelp "NOTICE $nick :Requested ban level of $level is higher than or equal to your level of [level $hand]"
    return 0
  }
  if {$level < 1} {
    puthelp "NOTICE $nick :Illegial ban level, defaulting to your level"
    set level [level $hand]
  }
  if {![onchan $who $chan]} {
    if {$who == "*"} { 
      putserv "KICK $chan $nick :bwhaha, i fixed the bug at last =\]"
      return 0
    }
    if {[string match "*!*@*" $who] == 0} {
      if {$reason == ""} {
        set reason "You Are Banned"
        putlog "($nick!$host) !$hand! BAN $who $chan.. - $c0logo"
        puthelp "NOTICE $nick :Added Ban for $who!*@* on $chan with level $level to remove"
        c0ban $nick $host $hand $chan "$noexp $nokick" $who $time $level $reason
        return 0
      }
      putlog "($nick!$host) !$hand! BAN $who $chan.. - $c0logo"
      puthelp "NOTICE $nick :Added Ban for $who on $chan with level $level to remove"
      c0ban $nick $host $hand $chan "$noexp $nokick" $who $time $level $reason
      return 0
    }
    if {[string match [string tolower $who] [string tolower $botnick![getchanhost $botnick $chan]]] == 1} {
      putserv "KICK $chan $nick :Why would I want to ban myself?"
      setuser $hand XTRA suspend on
      hubchanmsg "$nick tryed to ban me on $chan. auto-suspending.."
      return 0
    }
    if {$reason == ""} {
      set reason "You Are Banned"
      putlog "($nick!$host) !$hand! BAN $who $chan.. - $c0logo"
      puthelp "NOTICE $nick :Added Ban for $who on $chan with level $level to remove"
      c0ban $nick $host $hand $chan "$noexp $nokick" $who $time $level $reason
      return 0
    }
    putlog "($nick!$host) !$hand! BAN $who $chan.. - $c0logo"
    puthelp "NOTICE $nick :Added Ban for $who on $chan with level $level to remove"
    c0ban $nick $host $hand $chan "$noexp $nokick" $who $time $level $reason
    return 0
  }
  if {[onchan $who $chan] == 0} {
    puthelp "NOTICE $nick :$who is not on $chan"
    return 0
  }
  if {[level [nick2hand $who $chan]] > [level $hand]} {
    puthelp "NOTICE $nick :$who's level of [getuser [nick2hand $who $chan] XTRA level] is higher or equal than your level of [level $hand]"
    return 0
  }
  if {$who == $botnick} {
    putserv "KICK $chan $who :You cannot ban me slut"
    return 0
  }
  if {$reason == ""} {
    set reason "You Are Banned"
    putlog "($nick!$host) !$hand! BAN $who $chan.. - $c0logo"
    puthelp "NOTICE $nick :Added Ban for $who \[[maskhost $who![getchanhost $who $chan]]\] on $chan with level $level to remove"
    c0ban $nick $host $hand $chan "$noexp $nokick" $who $time $level $reason
    return 0
  }
  putlog "($nick!$host) !$hand! BAN $who $chan.. - $c0logo"
  puthelp "NOTICE $nick :Added Ban for $who on $chan with level $level to remove"
  c0ban $nick $host $hand $chan "$noexp $nokick" $who $time $level $reason
  return 0
}

proc c0ban {nick host hand chan flags who time level reason} {
  set whoh [c0banngen]
  if {$flags != ""} {
    if {[lindex $flags 0] == "yes"} {
      set noexpire "yes"
    } { set noexpire "no" }
    if {[lindex $flags 1] == "yes"} {
      set nokick "yes"
    } { set nokick "no" }
  }
  if {[string length $who] < 7 && [string match "*!*@*" $who] == 1} {
    puthelp "NOTICE $nick :Due to a potentual security risk. you may not ban a mask that broad. please make it more accurate"
    return 0  
  } 
  if {[onchan $who $chan] == 0} {
    if {[string match "*!*@*" $who] == 0} {
      putserv "MODE $chan +b $who!*@*"
      adduser $whoh $who!*@*
      setuser $whoh XTRA banhost $who!*@*
      setuser $whoh XTRA realnick $who
    }
    if {[string match "*!*@*" $who] == 1} {
      putserv "MODE $chan +b $who "
      adduser $whoh $who
      setuser $whoh XTRA banhost $who
      setuser $whoh XTRA realnick $who
    }
  }
  if {$level == ""} { set level [getuser $hand XTRA level] }
  if {[onchan $who $chan] == 1} {
    adduser $whoh [maskhost $who![getchanhost $who $chan]]
    setuser $whoh XTRA realnick $who
    setuser $whoh XTRA banhost [maskhost $who![getchanhost $who $chan]]
    putserv "MODE $chan +b [maskhost $who![getchanhost $who $chan]] "
  }
  chattr $whoh -fh|+dK $chan
  if {$noexpire == "yes"} {
    chattr $whoh +X
  }
  setuser $whoh XTRA ban "yes"
  if {$time == ""} {
    if {$noexpire == "yes"} {
      set time "Never"
    } { set time 60 }
  }
  setuser $whoh XTRA expires "$time"
  setuser $whoh XTRA blevel $level
  if {$noexpire != "yes"} {
    setuser $whoh XTRA btimer [utimer $time "c0unban $whoh"]
  }
  setuser $whoh XTRA breason $reason
  setuser $whoh XTRA bwhoset "$nick!$host \[$hand\]"
  putserv "MODE $chan +b [getuser $whoh XTRA banhost] "
  if {$nokick != "yes"} {
    scanchanban $nick [getuser $whoh XTRA banhost] $chan $reason
  }
}
proc c0unban {who} {
  global mainchan
  putserv "MODE $mainchan -b [getuser $who XTRA banhost] "
  deluser $who
}
proc c0banngen {} {
  set num 1
  foreach user [userlist] {
    if {[string tolower [string range $user 0 2]] == "ban"} {
      if {[string range $user 3 3] == $num || [string range $user 3 4] == $num} {
        incr num 1
      }
    }
  } 
  return ban$num
}

bind join -|K * join_kban

proc join_kban {nick host hand chan} {
  global mainchan
  if {[string tolower $chan] != [string tolower $mainchan]} {
    return 0
  }
  putserv "MODE $chan +b [getuser $hand XTRA banhost] "
  putserv "KICK $chan $nick :[getuser $hand XTRA breason]"
}

proc bflagadjust {nick chan varz} {
  set who [lindex $varz 0]
  set what [lindex $varz 1]
  set why [lindex $varz 2]
  set how [lindex $varz 3]
  set where [lindex $varz 4]
  set that [lindex $varz 5]
  set this [lindex $varz 6]
  set themm [lrange $varz 7 end]
  if {$themm != ""} {
    set them [lindex $themm 0]
    set reason [lrange $themm 0 end]
  }
  if {$themm == ""} {
    set them "-null"
    set reason "You Are Banned"
  }
  set mins "no"
  set hours "no"
  set nokick "no"
  set noexpire "no"
  set level "no"
  set handle 0
  if {$who == ""} { return 0 }
  if {[bflag $who] == 0 && [isnum $who] == 0 && $who != "" && $handle == 0 && $who != "-null"} {
    set handle "$who"
    if {[bflag $what] == 0} {
      set reason "$what $why $how $where $that $this [lrange $themm 0 end]"
      return "no no no no no $handle $reason"
    }
  }
  if {[bflag $what] == 0 && [isnum $what] == 0 && $what != "" && $handle == 0 && $what != "-null"} {
    set handle "$what"
    if {[bflag $why] == 0} {
      set reason "$why $how $where $that $this [lrange $themm 0 end]"
    }
  }
  if {[bflag $why] == 0 && [isnum $why] == 0 && $why != "" && $handle == 0 && $why != "-null"} {
    set handle "$why"
    if {[bflag $how] == 0} {
      set reason "$how $where $that $this [lrange $themm 0 end]"
    }
  }
  if {[bflag $how] == 0 && [isnum $how] == 0 && $how != "" && $handle == 0 && $how != "-null"} {
    set handle "$how"
    if {[bflag $where] == 0} {
      set reason "$where $that $this [lrange $themm 0 end]"
    }
  }
  if {[bflag $where] == 0 && [isnum $where] == 0 && $where != "" && $handle == 0 && $where != "-null"} {
    set handle "$where"
    if {[bflag $that] == 0} {
      set reason "$that $this [lrange $themm 0 end]"
    }
  }
  if {[bflag $that] == 0 && [isnum $that] == 0 && $that != "" && $handle == 0 && $that != "-null"} {
    set handle "$that"
    if {[bflag $this] == 0} {
      set reason "$this [lrange $themm 0 end]"
    }
  }
  if {[bflag $this] == 0 && [isnum $this] == 0 && $this != "" && $handle == 0 && $this != "-null"} {
    set handle "$this"
    if {[bflag $them] == 0} {
      set reason [lrange $themm 0 end]
    }
  }
  if {[bflag $them] == 0 && $them != "" && $handle == 0 && $them != "-null"} {
    set handle "$them"
    if {[bflag [lindex $themm 1]] == 0} {
      set reason [lrange $themm 1 end]
    }
  }
  if {$handle == 0} {
    return 0
  }
  if {[bflag $who] == 0 && [bflag $what] == 0 && [bflag $why] == 0 && [bflag $how] == 0 && [bflag $where] == 0 && [bflag $that] == 0 && [bflag $this] == 0 && [bflag $them] == 0} {
    return "no no no no no $handle $reason"
  }
  if {[string tolower $who] == "-nokick"} { set nokick "yes"
    if {[bflag $what] == 0} {
      set reason "$what $why $how $where $that $this [lrange $themm 0 end]"
    }  
  }
  if {[string tolower $what] == "-nokick"} { set nokick "yes"
    if {[bflag $why] == 0} {
      set reason "$why $how $where $that $this [lrange $themm 0 end]"
    }  
  }
  if {[string tolower $why] == "-nokick"} { set nokick "yes"
    if {[bflag $how] == 0} {
      set reason "$how $where $that $this [lrange $themm 0 end]"
    }  
  }
  if {[string tolower $how] == "-nokick"} { set nokick "yes"
    if {[bflag $where] == 0} {
      set reason "$where $that $this [lrange $themm 0 end]"
    }  
  }
  if {[string tolower $where] == "-nokick"} { set nokick "yes"
    if {[bflag $that] == 0} {
      set reason "$that $this [lrange $themm 0 end]"
    }  
  }
  if {[string tolower $that] == "-nokick"} { set nokick "yes"
    if {[bflag $this] == 0} {
      set reason "$this [lrange $themm 0 end]"
    }  
  }
  if {[string tolower $this] == "-nokick"} { set nokick "yes"
    if {[bflag [lindex $themm 0]] == 0} {
      set reason "[lrange $themm 0 end]"
    }  
  }  
  if {[string tolower $who] == "-noexpire"} {
    if {[bflag $what] == 0} {
      set reason "$what $why $how $where $that $this [lrange $themm 0 end]"
    }  
    set noexpire "yes"
  }
  if {[string tolower $what] == "-noexpire"} {
    if {[bflag $why] == 0} {
      set reason "$why $how $where $that $this [lrange $themm 0 end]"
    }  
    set noexpire "yes"
  }
  if {[string tolower $why] == "-noexpire"} {
    if {[bflag $how] == 0} {
      set reason "$how $where $that $this [lrange $themm 0 end]"
    }  
    set noexpire "yes"
  }
  if {[string tolower $how] == "-noexpire"} {
    if {[bflag $where] == 0} {
      set reason "$where $that $this [lrange $themm 0 end]"
    }  
    set noexpire "yes"
  }
  if {[string tolower $where] == "-noexpire"} {
    if {[bflag $that] == 0} {
      set reason "$that $this [lrange $themm 0 end]"
    }  
    set noexpire "yes"
  }
  if {[string tolower $that] == "-noexpire"} {
    if {[bflag $this] == 0} {
      set reason "$this [lrange $themm 0 end]"
    }  
    set noexpire "yes"
  }
  if {[string tolower $this] == "-noexpire"} {
    if {[bflag [lindex $themm 0]] == 0} {
      set reason "[lrange $themm 0 end]"
    }  
    set noexpire "yes"
  }
  if {[string tolower $who] == "-mins"} { set mins "-mins $what"
    if {[bflag $why] == 0} {
      set reason "$why $how $where $that $this [lrange $themm 0 end]"
    }
  }
  if {[string tolower $what] == "-mins"} { set mins "-mins $why"
    if {[bflag $how] == 0} {
      set reason "$how $where $that $this [lrange $themm 0 end]"
    }
  }
  if {[string tolower $why] == "-mins"} { set mins "-mins $how"
    if {[bflag $where] == 0} {
      set reason "$where $that $this [lrange $themm 0 end]"
    }
  }
  if {[string tolower $how] == "-mins"} { set mins "-mins $where"
    if {[bflag $that] == 0} {
      set reason "$that $this [lrange $themm 0 end]"
    }
  }
  if {[string tolower $where] == "-mins"} { set mins "-mins $that"
    if {[bflag $this] == 0} {
      set reason "$this [lrange $themm 0 end]"
    }
  }
  if {[string tolower $that] == "-mins"} { set mins "-mins $this"
    if {[bflag [lindex $themm 0]] == 0} {
      set reason [lrange $themm 0 end]
    }
  }
  if {[string tolower $this] == "-mins"} { set mins "-mins $them"
    if {[bflag [lindex $themm 1]] == 0} {
      set reason [lrange $themm 1 end]
    }
  }
  if {[string tolower $who] == "-hours"} { set hours "-hours $what"
    if {[bflag $why] == 0} {
      set reason "$why $how $where $that $this [lrange $themm 0 end]"
    }
  }
  if {[string tolower $what] == "-hours"} { set hours "-hours $why"
    if {[bflag $how] == 0} {
      set reason "$how $where $that $this [lrange $themm 0 end]"
    }
  }
  if {[string tolower $why] == "-hours"} { set hours "-hours $how"
    if {[bflag $where] == 0} {
      set reason "$where $that $this [lrange $themm 0 end]"
    }
  }
  if {[string tolower $how] == "-hours"} { set hours "-hours $where"
    if {[bflag $that] == 0} {
      set reason "$that $this [lrange $themm 0 end]"
    }
  }
  if {[string tolower $where] == "-hours"} { set hours "-hours $that"
    if {[bflag $this] == 0} {
      set reason "$this [lrange $themm 0 end]"
    }
  }
  if {[string tolower $that] == "-hours"} { set hours "-hours $this"
    if {[bflag [lindex $themm 0]] == 0} {
      set reason [lrange $themm 0 end]
    }
  }
  if {[string tolower $this] == "-hours"} { set hours "-hours $them"
    if {[bflag [lindex $themm 1]] == 0} {
      set reason [lrange $themm 1 end]
    }
  }
  if {[string tolower $who] == "-level"} { set level "-level $what"
    if {[bflag $why] == 0} {
      set reason "$why $how $where $that $this [lrange $themm 0 end]"
    }
  }
  if {[string tolower $what] == "-level"} { set level "-level $why"
    if {[bflag $how] == 0} {
      set reason "$how $where $that $this [lrange $themm 0 end]"
    }
  }
  if {[string tolower $why] == "-level"} { set level "-level $how"
    if {[bflag $where] == 0} {
      set reason "$where $that $this [lrange $themm 0 end]"
    }
  }
  if {[string tolower $how] == "-level"} { set level "-level $where"
    if {[bflag $that] == 0} {
      set reason "$that $this [lrange $themm 0 end]"
    }
  }
  if {[string tolower $where] == "-level"} { set level "-level $that"
    if {[bflag $this] == 0} {
      set reason "$this [lrange $themm 0 end]"
    }
  }
  if {[string tolower $that] == "-level"} { set level "-level $this"
    if {[bflag [lindex $themm 0]] == 0} {
      set reason [lrange $themm 0 end]
    }
  }
  if {[string tolower $this] == "-level"} { set level "-level [lindex $themm 0]"
    if {[bflag [lindex $themm 1]] == 0} {
      set reason [lrange $themm 1 end]
    }
  }
  if {$nokick != "yes"} { set result "no" }
  if {$nokick == "yes"} { set result "yes" }
  if {$noexpire == "yes"} { set result "$result yes" }
  if {$noexpire != "yes"} { set result "$result no" }
  if {$mins != "no"} { set result "$result [lindex $mins 1]" }
  if {$mins == "no"} { set result "$result no" }
  if {$hours != "no"} { set result "$result [lindex $hours 1]" }
  if {$hours == "no"} { set result "$result no" }
  if {$level != "no"} { set result "$result [lindex $level 1]" }
  if {$level == "no"} { set result "$result no" }
  if {[lindex $result 3] != "no" && [lindex $result 4] != "no"} {
    set result "[lrange $result 0 3] no [lrange $result 5 end]"
  }
  if {[lindex $result 0] != "no" && [lindex $result 1] != "no"} {
    set result "yes no [lrange $result 2 end]"
  }

  if {[lindex $result 1] != "no" && [lrange $result 2 3] != "no no"} {
    set result "[lrange $result 0 1] no no [lrange $result 4 end]"
  }
  return "$result $handle $reason"
}
proc bflag {flag} {
  set flag [string tolower $flag]
  if {$flag == "-nokick" || $flag == "-noexpire" || $flag == "-hours" || $flag == "-mins" || $flag == "-level"} { return 1 }
  return 0
}

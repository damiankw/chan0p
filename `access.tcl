
bind pub f `access pub_access
bind msg f access msg_access
proc msg_access {nick host hand varz} {
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
  pub_access $nick $host $hand $chan $flags
  return 0
}

proc pub_access {nick host hand chan varz} {
  global botnick mainchan
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
  set those [lindex $varz 8]
  set there [lindex $varz 9]
  set flags [flagadjust $nick $who $what $why $how $where $that $this $them $those $there]
  if {$flags != "none" && $flags != 0} {
    if {[countaxslist [lindex $flags 6]] > 10 && [lindex $flags 6] == "*" && [level $hand] < 190} {
      puthelp "NOTICE $nick :Please use a search string for this command. only level 190 and above can view the full access list"
      return 0
    }
    if {[countaxslist [lindex $flags 6]] > 10 && [level $hand] < 190} {
      puthelp "NOTICE $nick :Your query returned more then 10 results. please refine your search"
      return 0
    }
    if {[lindex $flags 0] == "-check"} {
      accesslist $nick $hand $chan "-check" [lindex $flags 1]
      return 0
    }
    if {[lindex $flags 0] == "-checkbots"} {
      accesslist $nick $hand $chan "-checkbots" [lindex $flags 1]
      return 0
    }
    accesslist $nick $hand $chan [lrange $flags 0 5] [lindex $flags 6] 
    return 0
  }
  if {[matchchanattr [nick2hand $who $chan] &B $mainchan]} {
    accesslist $nick $chan "no no no no no yes" $who
    return 0
  }
  if {$who == ""} {
    accesslist $nick $hand $chan "-check" $nick
    return 0
  }
  if {$who == "*"} {
    if {[getuser $hand XTRA level] < 190} {
      puthelp "NOTICE $nick :please use a search string. full access list restricted to level 190 and above"
      return 0
    }
    accesslist $nick $chan "no no no no no no" $who
    return 0
  }
  if {[validuser $who] == 1 && ![matchchanattr [nick2hand $who $chan] &B $mainchan]} {
    accesslist $nick $hand $chan "no no no no no no" $who
    return 0
  }
  if {[checkwho $who $chan] == 0} {
    puthelp "NOTICE $nick :There were no matches for your selected criteria"
    return 0
  }
  accesslist $nick $hand $chan "no no no no no no" $who
}
# end of `access

proc accesslist {nick hand chan flags who} {
  global botnick mainchan
  if {[lindex $flags 0] == "no"} {
    set min 0
  } { set min [lindex $flags 0] }
  if {[lindex $flags 1] == "no"} {
    set max 200
  } { set max [lindex $flags 1] }
  if {[lindex $flags 2] == "no"} {
    set ls 0
  } { set ls 1 }
  if {[lindex $flags 3] == "no"} {
    set lm 0
  } { set lm 1 }
  if {[lindex $flags 4] == "no"} {
    set uh 0
  } { set uh 1 }
  if {[lindex $flags 5] == "no"} {
    set bots 0
  } { set bots 1 }
  if {$flags == "-check"} {
    if {![onchan $who $chan]} {
       puthelp "NOTICE $nick :$who is not currently online"
       return 0
    }
    set chkhand [nick2hand $who $chan]
    if {[matchchanattr $who &B $mainchan] == 1 || [validuser $chkhand] == 0 || $chkhand == "*"} {
      puthelp "NOTICE $nick :There were no matches for your selected criteria"
      return 0
    }
    puthelp "NOTICE $nick :*** $chan Database \[\Check: $who Min: 0   Max: 200\]\ ***"
    puthelp "NOTICE $nick :      NickName          Level  AOP   AOV  Prot"
    set num 0
    foreach user [userlist +f] {
      incr num
      if {[string tolower $chkhand] == [string tolower $user] && ![matchchanattr $user &B $mainchan]} {
        puthelp "NOTICE $nick :[access_align $num $user [getuser $user XTRA level] [getuser $user XTRA aop] [getuser $user XTRA aov] [getuser $user XTRA prot]]"
        if {[matchattr $user +S]} {
          puthelp "NOTICE $nick :Suspend Expires: [lduration [expr [expr [getuser $user XTRA suspend] + [getuser $user XTRA suspendtime]] - [unixtime]] short]"
        }
        if {[getuser $user PASS] == ""} {
	  puthelp "NOTICE $nick :$user has no password set"
        }
      }
    }
    puthelp "NOTICE $nick :*** End of List ***"
    return 0
  }
  if {$flags == "-checkbots"} {
    if {![onchan $who $chan]} {
       puthelp "NOTICE $nick :$who is not currently online"
       return 0
    }
    set chkhand [nick2hand $who $chan]
    if {[matchchanattr $who &B $mainchan] == 1 || [validuser $chkhand] == 0 || $chkhand == "*"} {
      puthelp "NOTICE $nick :There were no matches for your selected criteria"
      return 0
    }
    puthelp "NOTICE $nick :*** $chan Bot Database \[\Check: $who Min: 0   Max: 200\]\ ***"
    puthelp "NOTICE $nick :      BotNick           Level  AOP   AOV  Prot"
    set num 0
    foreach user [userlist b] {
      incr num
      if {[string tolower $chkhand] == [string tolower $user] && [matchchanattr $user &B $mainchan]} {
        puthelp "NOTICE $nick :[access_align $num $user [getuser $user XTRA level] [getuser $user XTRA aop] [getuser $user XTRA aov] [getuser $user XTRA prot]]"
        if {[matchattr $user +S]} {
          puthelp "NOTICE $nick :Suspend Expires: [lduration [expr [expr [getuser $user XTRA suspend] + [getuser $user XTRA suspendtime]] - [unixtime]] short]"
        }
        if {[getuser $user PASS] == ""} {
          puthelp "NOTICE $nick :$user has no password set"
        }
      }
    }
    puthelp "NOTICE $nick :*** End of List ***"
    return 0
  }
  if {$bots} { 
    if {[checkbots $who $chan] == 0 && [validuser $who] == 0 || [matchattr $who b] == 0 && [countbotlist $who] == 0} {
      puthelp "NOTICE $nick :There were no matches for your selected criteria"
      return 0
    }
    puthelp "NOTICE $nick :*** $chan Bot Database \[\Match: $who Min: $min   Max: $max\]\ ***"
    puthelp "NOTICE $nick :      BotNick           Level  AOP   AOV  Prot"
    set num 0
    foreach user [userlist b] {
      incr num
      if {[string match [string tolower $who] [string tolower $user]] == 1 && [getuser $user XTRA level] >= $min && [getuser $user XTRA level] <= $max} {
        puthelp "NOTICE $nick :[access_align $num $user [getuser $user XTRA level] [getuser $user XTRA aop] [getuser $user XTRA aov] [getuser $user XTRA prot]]"
        if {[matchattr $user +S]} {
          puthelp "NOTICE $nick :Suspend Expires: [lduration [expr [expr [getuser $user XTRA suspend] + [getuser $user XTRA suspendtime]] - [unixtime]] short]"
        }
        if {[getuser $user PASS] == ""} {
	  puthelp "NOTICE $nick :$user has no password set"
        }
        if {$ls} {
          if {[getuser $user laston] == ""} {
            puthelp "NOTICE $nick :  LS  Never"
          } {
            puthelp "NOTICE $nick :  LS  [timeago [lindex [getuser $user LASTON] 0]] ago"
          }
        }
        if {$lm} {
          if {[getuser $user XTRA LM] == ""} {
            puthelp "NOTICE $nick :  LM  bot@console"
          } {
            puthelp "NOTICE $nick :  LM  [getuser $user XTRA LM]"
          }
        }
        if {$uh} {
          if {[getuser $user XTRA lasthost] == ""} {
	    puthelp "NOTICE $nick :  UserHost: Never Identified"
          } {
            puthelp "NOTICE $nick :  UserHost: [getuser $user XTRA lasthost]"
          }
        }
      }
    }
    unset num
    puthelp "NOTICE $nick :*** End of List ***"
    return 0
  }
  if {[checkwho $who $chan] == 0 && [validuser $who] == 0 || [matchattr $who f] == 0 && [countaxslist $who] == 0} {
    puthelp "NOTICE $nick :There were no matches for your selected criteria"
    return 0
  }
  puthelp "NOTICE $nick :*** $chan Database \[\Match: $who Min: $min   Max: $max\]\ ***"
  puthelp "NOTICE $nick :      NickName          Level  AOP   AOV  Prot"
  set num 0
  foreach user [userlist +f] {
    incr num
    if {[string match [string tolower $who] [string tolower $user]] == 1 && [getuser $user XTRA level] >= $min && [getuser $user XTRA level] <= $max && ![matchchanattr $user &B $mainchan]} {
      puthelp "NOTICE $nick :[access_align $num $user [getuser $user XTRA level] [getuser $user XTRA aop] [getuser $user XTRA aov] [getuser $user XTRA prot]]"
      if {[matchattr $user +S]} {
        puthelp "NOTICE $nick :Suspend Expires: [lduration [expr [expr [getuser $user XTRA suspend] + [getuser $user XTRA suspendtime]] - [unixtime]] short]"
      }
      if {[getuser $user PASS] == ""} {
        puthelp "NOTICE $nick :$user has no password set"
      }
      if {$ls} {
        if {[getuser $user laston] == ""} {
          puthelp "NOTICE $nick :  LS  Never"
        } {
          puthelp "NOTICE $nick :  LS  [timeago [lindex [getuser $user LASTON] 0]] ago"
        }
      }
      if {$lm} {
        if {[getuser $user XTRA LM] == ""} {
          puthelp "NOTICE $nick :  LM  bot@console"
        } {
          puthelp "NOTICE $nick :  LM  [getuser $user XTRA LM]"
        }
      }
      if {$uh} {
        if {[getuser $user XTRA lasthost] == ""} {
          puthelp "NOTICE $nick :  UserHost: Never Identified"
        } {
          puthelp "NOTICE $nick :  UserHost: [getuser $user XTRA lasthost]"
        }
      }
    }
  }
  unset num
  puthelp "NOTICE $nick :*** End of List ***"
  return 0
}

proc flagadjust {nick who what why how where that this them those there} {
  set who [lindex $who 0]
  set what [lindex $what 0]
  set why [lindex $why 0]
  set how [lindex $how 0]
  set where [lindex $where 0]
  set that [lindex $that 0]
  set this [lindex $this 0]
  set them [lindex $them 0]
  set those [lindex $those 0]
  set there [lindex $there 0]
  set min "-min 0"
  set max "-max 200"
  set lm "no"
  set ls "no"
  set uh "no"
  set bots "no"
  set handle ""
  if {$who == ""} { return 0 }
  if {[axsflag $who] == 0 && [isnum $who] == 0 && $who != ""} { set handle "$who" }
  if {[axsflag $what] == 0 && [isnum $what] == 0 && $what != ""} { set handle "$what" }
  if {[axsflag $why] == 0 && [isnum $why] == 0 && $why != ""} { set handle "$why" }
  if {[axsflag $how] == 0 && [isnum $how] == 0 && $how != ""} { set handle "$how" }
  if {[axsflag $where] == 0 && [isnum $where] == 0 && $where != ""} { set handle "$where" }
  if {[axsflag $that] == 0 && [isnum $that] == 0 && $that != ""} { set handle "$that" }
  if {[axsflag $this] == 0 && [isnum $this] == 0 && $this != ""} { set handle "$this" }
  if {[axsflag $them] == 0 && [isnum $them] == 0 && $them != ""} { set handle "$them" }
  if {[axsflag $those] == 0 && [isnum $those] == 0 && $those != ""} { set handle "$those" }
  if {[axsflag $there] == 0 && [isnum $there] == 0 && $there != ""} { set handle "$there" }
  if {$handle == ""} { set handle $nick }
  if {$handle == "-"} { set handle "*" }
  if {[string tolower $who] == "-bots" || [string tolower $what] == "-bots" || [string tolower $why] == "-bots" || [string tolower $how] == "-bots" || [string tolower $where] == "-bots" || [string tolower $that] == "-bots" || [string tolower $this] == "-bots" || [string tolower $those] == "-bots" || [string tolower $there] == "-bots"} {
    if {[string tolower $who] == "-check" || [string tolower $what] == "-check" || [string tolower $why] == "-check" || [string tolower $how] == "-check" || [string tolower $where] == "-check" || [string tolower $that] == "-check" || [string tolower $this] == "-check" || [string tolower $those] == "-check" || [string tolower $there] == "-check"} {
      return "-checkbots $handle"
    }
    set bots "yes"
  }
  if {[string tolower $who] == "-check" || [string tolower $what] == "-check" || [string tolower $why] == "-check" || [string tolower $how] == "-check" || [string tolower $where] == "-check" || [string tolower $that] == "-check" || [string tolower $this] == "-check" || [string tolower $those] == "-check" || [string tolower $there] == "-check"} {
    return "-check $handle"
  }
  if {[string tolower $who] == "-lm" || [string tolower $what] == "-lm" || [string tolower $why] == "-lm" || [string tolower $how] == "-lm" || [string tolower $where] == "-lm" || [string tolower $that] == "-lm" || [string tolower $this] == "-lm" || [string tolower $those] == "-lm" || [string tolower $there] == "-lm"} {
    set lm "yes"
  }
  if {[string tolower $who] == "-ls" || [string tolower $what] == "-ls" || [string tolower $why] == "-ls" || [string tolower $how] == "-ls" || [string tolower $where] == "-ls" || [string tolower $that] == "-ls" || [string tolower $this] == "-ls" || [string tolower $those] == "-ls" || [string tolower $there] == "-ls"} {
    set ls "yes"
  }
  if {[string tolower $who] == "-userhost" || [string tolower $what] == "-userhost" || [string tolower $why] == "-userhost" || [string tolower $how] == "-userhost" || [string tolower $where] == "-userhost" || [string tolower $that] == "-userhost" || [string tolower $this] == "-userhost" || [string tolower $those] == "-userhost" || [string tolower $there] == "-userhost"} {
    set uh "yes"
  }
  if {[string tolower $who] == "-min"} { set min "-min $what" }
  if {[string tolower $what] == "-min"} { set min "-min $why" }
  if {[string tolower $why] == "-min"} { set min "-min $how" }
  if {[string tolower $how] == "-min"} { set min "-min $where" }
  if {[string tolower $where] == "-min"} { set min "-min $that" }
  if {[string tolower $that] == "-min"} { set min "-min $this" }
  if {[string tolower $this] == "-min"} { set min "-min $them" }
  if {[string tolower $who] == "-max"} { set max "-max $what" }
  if {[string tolower $what] == "-max"} { set max "-max $why" }
  if {[string tolower $why] == "-max"} { set max "-max $how" }
  if {[string tolower $how] == "-max"} { set max "-max $where" }
  if {[string tolower $where] == "-max"} { set max "-max $that" }
  if {[string tolower $that] == "-max"} { set max "-max $this" }
  if {[string tolower $this] == "-max"} { set max "-max $them" }
  if {[string tolower $them] == "-max"} { set max "-max $those" }
  if {[string tolower $those] == "-max"} { set max "-max $there" }
  if {$min != ""} { set result [lindex $min 1] }
  if {$min == ""} { set result "no" }
  if {$max != ""} { set result "$result [lindex $max 1]" }
  if {$max == ""} { set result "$result no" }
  if {$ls == "yes"} { set result "$result yes" }
  if {$ls != "yes"} { set result "$result no" }
  if {$lm == "yes"} { set result "$result yes" } 
  if {$lm != "yes"} { set result "$result no" }
  if {$uh == "yes"} { set result "$result yes" } 
  if {$uh != "yes"} { set result "$result no" }
  if {$bots == "yes"} { set result "$result yes" } 
  if {$bots != "yes"} { set result "$result no" }
  return "$result $handle"
}
proc countaxslist {string} {
  global mainchan
  set num "0"
  foreach user [userlist +f] {
    if {[string match [string tolower $string] [string tolower $user]] == 1 && ![matchchanattr $user &B $mainchan]} {
      incr num
    }
  }
  return $num
}
proc countbotlist {string} {
  global mainchan
  set num "0"
  foreach user [userlist +b] {
    if {[string match [string tolower $string] [string tolower $user]] == 1} {
      incr num
    }
  }
  return $num
}
proc checkwho {who chan} {
  foreach user [userlist +f] {
    if {[string match [string tolower $who] [string tolower $user]] != 0 || [validuser $who] == 1} {
      return 1
    }
  }
  return 0
}
proc checkbots {who chan} {
  foreach user [userlist b] {
    if {[string match [string tolower $who] [string tolower $user]] != 0} {
      return 1
    }
  }
  return 0
}
proc access_align {num who level aop aov prot} {
   if {$who == ""} {
     return 0
   }
   if {[string length $num] == 1} {
      set aan "$num     "
   }
   if {[string length $num] == 2} {
      set aan "$num    "
   }
   if {[string length $num] == 3} {
      set aan "$num   "
   }
   if {[string length $who] == 1} {
                       set aaw "$who                 "
   }
   if {[string length $who] == 2} {
                       set aaw "$who                "
   }
   if {[string length $who] == 3} {
                       set aaw "$who               "
   }
   if {[string length $who] == 4} {
                       set aaw "$who              "
   }
   if {[string length $who] == 5} {
                       set aaw "$who             "
   }
   if {[string length $who] == 6} {
                       set aaw "$who            "
   }
   if {[string length $who] == 7} {
                       set aaw "$who           "
   }
   if {[string length $who] == 8} {
                       set aaw "$who          "
   }
   if {[string length $who] == 9} {
                       set aaw "$who         "
   }
   if {[string length $who] == 10} {
                       set aaw "$who        "
   }
   if {[string length $who] == 11} {
                       set aaw "$who       "
   }
   if {[string length $who] == 12} {
                       set aaw "$who      "
   }
   if {[string length $who] == 13} {
                       set aaw "$who     "
   }
   if {[string length $who] == 14} {
                       set aaw "$who    "
   }
   if {[string length $who] == 15} {
                       set aaw "$who   "
   }
   if {[string length $level] == 3} {
      set aal "$level    "
   }
   if {[string length $level] == 2} {
      set aal "$level     "
   }
   if {[string length $level] == 1} {
      set aal "$level      "
   }
   if {[string length $aop] == 3} {
      set aao "$aop   "
   }
   if {[string length $aop] == 2} {
      set aao "$aop    "
   }
   if {[string length $aov] == 3} {
      set aav "$aov   "
   }
   if {[string length $aov] == 2} {
      set aav "$aov    "
   }
   if {[string length $prot] == 3} {
      set aap "$prot   "
   }
   if {[string length $prot] == 2} {
      set aap "$prot    "
   }
   if {$aal == ""} { set aal "N\\A" }
   if {$aaw == ""} { set aaw "N\\A" }
   if {$aan == ""} { set aan "N\\A" }
   if {$aao == ""} { set aao "N\\A" }
   if {$aav == ""} { set aav "N\\A" }
   if {$aap == ""} { set aap "N\\A" }
   return "$aan$aaw$aal$aao$aav$aap"
}
proc axsflag {flag} {
  set flag [string tolower $flag]
  if {$flag == "-bots" || $flag == "-check" || $flag == "-ls" || $flag == "-lm" || $flag == "-max" || $flag == "-min" || $flag == "-userhost"} { return 1 }
  return 0
}

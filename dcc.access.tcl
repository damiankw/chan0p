bind dcc f access dcc_access
proc dcc_access {hand idx varz} {
  global botnick mainchan
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
  set flags [flagadjust $hand $who $what $why $how $where $that $this $them $those $there]
  if {$flags != "none" && $flags != 0} {
    if {[lindex $flags 0] == "-check"} {
      dccaccesslist $hand $idx "-check" [lindex $flags 1]
      return 0
    }
    if {[lindex $flags 0] == "-checkbots"} {
      dccaccesslist $hand $idx "-checkbots" [lindex $flags 1]
      return 0
    }
    dccaccesslist $hand $idx [lrange $flags 0 5] [lindex $flags 6] 
    return 0
  }
  if {[matchchanattr [nick2hand $who $mainchan] &B $mainchan]} {
    dccaccesslist $hand $idx "no no no no no yes" $who
    return 0
  }
  if {$who == ""} {
    dccaccesslist $hand $idx "no no no no no no" $hand
    return 0
  }
  if {$who == "*"} {
    dccaccesslist $hand $idx "no no no no no no" $who
    return 0
  }
  if {[validuser $who] == 1 && ![matchchanattr [nick2hand $who $chan] &B $mainchan]} {
    dccaccesslist $hand $idx "no no no no no no" $who
    return 0
  }
  if {[checkwho $who $chan] == 0} {
    putdcc $idx "There were no matches for your selected criteria"
    return 0
  }
  accesslist $hand $idx "no no no no no no" $who
}
# end of `access

proc dccaccesslist {hand idx flags who} {
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
    if {![onchan $who $mainchan]} {
       putdcc $idx "$who is not currently online"
       return 0
    }
    set chkhand [nick2hand $who $mainchan]
    if {[matchchanattr $who &B $mainchan] == 1 || [validuser $chkhand] == 0 || $chkhand == "*"} {
      putdcc $idx "There were no matches for your selected criteria"
      return 0
    }
    putdcc $idx "*** $mainchan Database \[\Check: $who Min: 0   Max: 200\]\ ***"
    putdcc $idx "      NickName          Level  AOP   AOV  Prot"
    set num 0
    foreach user [userlist +f] {
      incr num
      if {[string tolower $chkhand] == [string tolower $user] && ![matchchanattr $user &B $mainchan]} {
        putdcc $idx "[access_align $num $user [getuser $user XTRA level] [getuser $user XTRA aop] [getuser $user XTRA aov] [getuser $user XTRA prot]]"
        if {[matchattr $user +S]} {
          putdcc $idx "Suspend Expires: [lduration [expr [expr [getuser $user XTRA suspend] + [getuser $user XTRA suspendtime]] - [unixtime]] short]"
        }
        if {[getuser $user PASS] == ""} {
          putdcc $idx "$user has no password set"
        }
      }
    }
    putdcc $idx "*** End of List ***"
    return 0
  }
  if {$flags == "-checkbots"} {
    if {![onchan $who $mainchan]} {
       putdcc $idx "$who is not currently online"
       return 0
    }
    set chkhand [nick2hand $who $mainchan]
    if {[matchchanattr $who &B $mainchan] == 1 || [validuser $chkhand] == 0 || $chkhand == "*"} {
      putdcc $idx "There were no matches for your selected criteria"
      return 0
    }
    putdcc $idx "*** $mainchan Bot Database \[\Check: $who Min: 0   Max: 200\]\ ***"
    putdcc $idx "      BotNick           Level  AOP   AOV  Prot"
    set num 0
    foreach user [userlist b] {
      incr num
      if {[string tolower $chkhand] == [string tolower $user] && [matchchanattr $user &B $mainchan]} {
        putdcc $idx "[access_align $num $user [getuser $user XTRA level] [getuser $user XTRA aop] [getuser $user XTRA aov] [getuser $user XTRA prot]]"
        if {[matchattr $user +S]} {
          putdcc $idx "Suspend Expires: [lduration [expr [expr [getuser $user XTRA suspend] + [getuser $user XTRA suspendtime]] - [unixtime]] short]"
        }
      }
    }
    putdcc $idx "*** End of List ***"
    return 0
  }
  if {$bots} { 
    if {[checkbots $who $mainchan] == 0 && [validuser $who] == 0 || [matchattr $who b] == 0 && [countbotlist $who] == 0} {
      putdcc $idx "There were no matches for your selected criteria"
      return 0
    }
    putdcc $idx "*** $mainchan Bot Database \[\Match: $who Min: $min   Max: $max\]\ ***"
    putdcc $idx "      BotNick           Level  AOP   AOV  Prot"
    set num 0
    foreach user [userlist b] {
      incr num
      if {[string match [string tolower $who] [string tolower $user]] == 1 && [getuser $user XTRA level] >= $min && [getuser $user XTRA level] <= $max} {
        putdcc $idx "[access_align $num $user [getuser $user XTRA level] [getuser $user XTRA aop] [getuser $user XTRA aov] [getuser $user XTRA prot]]"
        if {[matchattr $user +S]} {
          putdcc $idx "Suspend Expires: [lduration [expr [expr [getuser $user XTRA suspend] + [getuser $user XTRA suspendtime]] - [unixtime]] short]"
        }
        if {$ls} {
          if {[getuser $user LASTON] == ""} {
            putdcc $idx "  LS  Never"
          } {
            putdcc $idx "  LS  [timeago [lindex [getuser $user LASTON] 0]] ago"
          }
        }
        if {$lm} {
          if {[getuser $user XTRA LM] == ""} {
            putdcc $idx "  LM  bot@console"
          } {
            putdcc $idx "  LM  [getuser $user XTRA LM]"
          }
        }
        if {$uh} {
          if {[getuser $user XTRA lasthost] == ""} {
            putdcc $idx "  UserHost: Never Identified"
          } {
            putdcc $idx "  UserHost: [getuser $user XTRA lasthost]"
          }
        }
      }
    }
    unset num
    putdcc $idx "*** End of List ***"
    return 0
  }
  if {[checkwho $who $mainchan] == 0 && [validuser $who] == 0 || [matchattr $who f] == 0 && [countaxslist $who] == 0} {
    putdcc $idx "There were no matches for your selected criteria"
    return 0
  }
  putdcc $idx "*** $mainchan Database \[\Match: $who Min: $min   Max: $max\]\ ***"
  putdcc $idx "      NickName          Level  AOP   AOV  Prot"
  set num 0
  foreach user [userlist +f] {
    incr num
    if {[string match [string tolower $who] [string tolower $user]] == 1 && [getuser $user XTRA level] >= $min && [getuser $user XTRA level] <= $max} {
      putdcc $idx "[access_align $num $user [getuser $user XTRA level] [getuser $user XTRA aop] [getuser $user XTRA aov] [getuser $user XTRA prot]]"
      if {[matchattr $user +S]} {
        putdcc $idx "Suspend Expires: [lduration [expr [expr [getuser $user XTRA suspend] + [getuser $user XTRA suspendtime]] - [unixtime]] short]"
      }
      if {$ls} {
        if {[getuser $user LASTON] == ""} {
          putdcc $idx "  LS  Never"
        } {
          putdcc $idx "  LS  [timeago [lindex [getuser $user LASTON] 0]] ago"
        }
      }
      if {$lm} {
        if {[getuser $user XTRA LM] == ""} {
          putdcc $idx "  LM  bot@console"
        } {
          putdcc $idx "  LM  [getuser $user XTRA LM]"
        }
      }
      if {$uh} {
        if {[getuser $user XTRA lasthost] == ""} {
          putdcc $idx "  UserHost: Never Identified"
        } {
          putdcc $idx "  UserHost: [getuser $user XTRA lasthost]"
        }
      }
    }
  }
  unset num
  putdcc $idx "*** End of List ***"
  return 0
}
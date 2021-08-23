
bind pub f `listban pub_listban
bind msg f listban msg_listban

proc msg_listban {nick host hand varz} {
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
  pub_listban $nick $host $hand $chan $flags
  return 0
}
proc pub_listban {nick host hand chan varz} {
  global mainchan botnick
  set who [lindex $varz 0]
  set what [lindex $varz 1]
  set where [lindex $varz 2]
  set why [lindex $varz 3]
  set how [lindex $varz 4]
  set xtra [lrange $varz 5 end]
  if {[string tolower $chan] != [string tolower $mainchan]} {
    return 0
  }
  if {$who == ""} {
    puthelp "NOTICE $nick :LISTBAN Syntax: `listban <search string> \[-whoset\] \[-whenset\] \[-reason\]"
    return 0
  }
  if {[level $hand] < 75} {
    puthelp "NOTICE $nick :Your level of [level $hand] is less then the required level of '75' for this command"
    return 0
  }
  if {[string tolower $who] == "all"} { set who "*" }
  if {$where == ""} { set where "-null" }
  if {$how == ""} { set how "-null" }
  if {$xtra == ""} { set xtra "-null" }
  set lbflags [lbflagsort "$who $what $where $how $xtra"]
  set who [lindex $lbflags 3]
  if {[lrange $lbflags 0 2] != "no no no"} {
    listban $nick $chan $hand [lrange $lbflags 0 2] $who
    return 0
  }
  if {[lrange $lbflags 0 2] == "no no no"} {
    listban $nick $chan $hand "noflags" $who
    return 0
  }
}

# <reason> <whenset> <whoset> <search>

proc lbflagsort {varz} {
  set who [string tolower [lindex $varz 0]]
  set what [string tolower [lindex $varz 1]]
  set where [string tolower [lindex $varz 2]]
  set why [string tolower [lindex $varz 3]]
  set how [string tolower [lindex $varz 4]]
  set lbreason "no"
  set lbwhoset "no"
  set lbwhenset "no"
  set lbstring "*"
  if {$who == "-reason" || $what == "-reason" || $where == "-reason" || $why == "-reason" || $how == "-reason"} {
    set lbreason "yes"
  }
  if {$who == "-whenset" || $what == "-whenset" || $where == "-whenset" || $why == "-whenset" || $how == "-whenset"} {
    set lbwhenset "yes"
  }
  if {$who == "-whoset" || $what == "-whoset" || $where == "-whoset" || $why == "-whoset" || $how == "-whoset"} {
    set lbwhoset "yes"
  }
  if {$how != "-null" && [lbflag $how] == 0 || $how != ""} { set lbstring $how }
  if {$why != "-null" && [lbflag $why] == 0 || $why != ""} { set lbstring $why }
  if {$where != "-null" && [lbflag $where] == 0 || $where != ""} { set lbstring $where }
  if {$what != "-null" && [lbflag $what] == 0 || $what != ""} { set lbstring $what }
  if {$who != "-null" && [lbflag $who] == 0 || $who != ""} { set lbstring $who }
  if {[string tolower $lbstring] == "all"} { set lbstring "*" }
  set result "$lbreason $lbwhenset $lbwhoset $lbstring"
  return $result
}
proc lbflag {string} {
  set string [string tolower $string]
  if {$string == "-whoset" || $string == "-whenset" || $string == "-reason"} {
    return 1
  }
  if {$string != "-whoset" || $string != "-whenset" || $string != "-reason"} {
    return 0
  }
  return some-thing-is-wrong-here
}

proc listban {nick chan hand flags who} {
  if {[countbans $who] > 10 && [getuser $hand XTRA level] < 190} {
    puthelp "NOTICE $nick :Your search returned more then 10 results. please refine your search"
    return 0
  }
  if {[userlist &K] == ""} {
    puthelp "NOTICE $nick :There are channel Bans on $chan"
    return 0
  }
  if {[countbans $who] == 0} {
    puthelp "NOTICE $nick :Your search query returned no results
    return 0
  }
  if {$flags != "noflags"} {
    if {[lindex $flags 0] == "yes"} {
      set re 1
    } { set re 0 }
    if {[lindex $flags 1] == "yes"} {
      set we 1
    } { set we 0 }
    if {[lindex $flags 2] == "yes"} {
      set wo 1
    } { set wo 0 }
  } {
    set wo 0
    set we 0
    set re 0
  }
  if {$flags != "noflags"} {
    if {$re && $wo && $we} {
      if {[countbans $who] > 3 && [getuser $hand XTRA level] < 190} {
        puthelp "NOTICE $nick :Your search returned more then 3 results. please refine your search"
        return 0
      }
    }
    if {$re && $wo} {
      if {[countbans $who] > 3 && [getuser $hand XTRA level] < 190} {
        puthelp "NOTICE $nick :Your search returned more then 3 results. please refine your search"
        return 0
      }
    }
    if {$re && $we} {
      if {[countbans $who] > 3 && [getuser $hand XTRA level] < 190} {
        puthelp "NOTICE $nick :Your search returned more then 3 results. please refine your search"
        return 0
      }
    }
    if {$wo && $we} {
      if {[countbans $who] > 3 && [getuser $hand XTRA level] < 190} {
        puthelp "NOTICE $nick :Your search returned more then 3 results. please refine your search"
        return 0
      }
    }
  }
  if {$re || $we || $wo} {
    if {[countbans $who] > 5 && [getuser $hand XTRA level] < 190} {
      puthelp "NOTICE $nick :Your search returned more then 5 results. please refine your search"
      return 0
    }
  }
  puthelp "NOTICE $nick :*** $chan Ban List (Matching $who) ***"
  puthelp "NOTICE $nick :    Ban mask                         Lev Expires      "
  set num 0
  foreach ban [userlist &K] {
    incr num 1
    if {$who == $ban || [string match $who [getuser $ban XTRA banhost]] == 1 || [string match $who $ban] == 1} {
      puthelp "NOTICE $nick :[listban_align $num [getuser $ban XTRA banhost] [getuser $ban XTRA blevel] [getuser $ban XTRA expires] [getuser $ban XTRA created]]"
      if {$flags != "noflags"} {
        if {$we} {
          set bwscreated [getuser $ban XTRA created]
          puthelp "NOTICE $nick :Created: [ctime $bwscreated]"
        }
        if {$wo} {
          puthelp "NOTICE $nick :Set by: [getuser $ban XTRA bwhoset]"
        }
        if {$re} {
          puthelp "NOTICE $nick :Reason: [getuser $ban XTRA breason]"
        }
      }
    }
  }
  puthelp "NOTICE $nick :*** End of banlist. Use switches -whoset -whenset -reason for more information ***"
  puthelp "NOTICE $nick :*** End of List ***"
  return 0
}

proc listban_align {num banmask level expires created} {
   if {$banmask == ""} {
     return 0
   }
   if {[string length $num] == 1} {
      set lan "$num   "
   }
   if {[string length $num] == 2} {
      set lan "$num  "
   }
   if {[string length $num] == 3} {
      set lan "$num "
   }
   if {[string length $banmask] == 1} {
                       set lam "$banmask                               "
   }
   if {[string length $banmask] == 2} {
                       set lam "$banmask                              "
   }
   if {[string length $banmask] == 3} {
                       set lam "$banmask                             "
   }
   if {[string length $banmask] == 4} {
                       set lam "$banmask                            "
   }
   if {[string length $banmask] == 5} {
                       set lam "$banmask                           "
   }
   if {[string length $banmask] == 6} {
                       set lam "$banmask                          "
   }
   if {[string length $banmask] == 7} {
                       set lam "$banmask                         "
   }
   if {[string length $banmask] == 8} {
                       set lam "$banmask                        "
   }
   if {[string length $banmask] == 9} {
                       set lam "$banmask                       "
   }
   if {[string length $banmask] == 10} {
                       set lam "$banmask                      "
   }
   if {[string length $banmask] == 11} {
                       set lam "$banmask                     "
   }
   if {[string length $banmask] == 12} {
                       set lam "$banmask                    "
   }
   if {[string length $banmask] == 13} {
                       set lam "$banmask                   "
   }
   if {[string length $banmask] == 14} {
                       set lam "$banmask                  "
   }
   if {[string length $banmask] == 15} {
                       set lam "$banmask                 "
   }
   if {[string length $banmask] == 16} {
                       set lam "$banmask                "
   }
   if {[string length $banmask] == 17} {
                       set lam "$banmask               "
   }
   if {[string length $banmask] == 18} {
                       set lam "$banmask              "
   }
   if {[string length $banmask] == 19} {
                       set lam "$banmask             "
   }
   if {[string length $banmask] == 20} {
                       set lam "$banmask            "
   }
   if {[string length $banmask] == 21} {
                       set lam "$banmask           "
   }
   if {[string length $banmask] == 22} {
                       set lam "$banmask          "
   }
   if {[string length $banmask] == 23} {
                       set lam "$banmask         "
   }
   if {[string length $banmask] == 24} {
                       set lam "$banmask        "
   }
   if {[string length $banmask] == 25} {
                       set lam "$banmask       "
   }
   if {[string length $banmask] == 26} {
                       set lam "$banmask      "
   }
   if {[string length $banmask] == 27} {
                       set lam "$banmask     "
   }
   if {[string length $banmask] == 28} {
                       set lam "$banmask    "
   }
   if {[string length $banmask] == 29} {
                       set lam "$banmask   "
   }
   if {[string length $banmask] == 30} {
                       set lam "$banmask  "
   }
   if {[string length $banmask] == 31} {
                       set lam "$banmask "
   }
   if {[string length $banmask] > 31} {
                       set lam "$banmask"
   }
   if {[string length $level] == 3} {
      set lal "$level  "
   }
   if {[string length $level] == 2} {
      set lal "$level   "
   }
   if {[string length $level] == 1} {
      set lal "$level    "
   }
   set lae [banexpire $expires $created]
   return "$lan$lam$lal$lae"
}
proc countbans {who} {
  set num 0
  if {$who == ""} {
    set who "*"
  }
  foreach ban [userlist &K] {
    if {[string match $who $ban] == 1} {
      incr num 1
    }
  }
  return $num
}

# strftime format:
# %X = hh:mm.ss
# %p = am/pm
# %A = long format day
# %d = date
# %B = month
# %Y = year

proc banexpire {time created} {
  if {$time == "Never"} { return "Never" }
  return [lduration [expr $time - [expr [unixtime] - $created]] short]
}

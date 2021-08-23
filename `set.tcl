
bind pub m `set pub_set
bind msg f SET msg_set

proc msg_set {nick host hand varz} {
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
  pub_set $nick $host $hand $chan $flags
  return 0
}
proc pub_set {nick host hand chan varz} {
  global hubchan mainchan botnick mcowner mcemail debugsu mcmodelock mcmode mckeeptopic mctopic mcmustid mcoprestrict mctelladd mctelldel mctellset mcfunmsg mcrestrict mcnonote mcquota
  set who [string tolower [lindex $varz 0]]
  set what [lindex $varz 1]
  set why [lindex $varz 2]
  set how [lrange $varz 2 end]
  chan0pinfo [string tolower $chan]
  ownerinfo [string tolower $chan]
  if {[string tolower $chan] != [string tolower $mainchan]} {
    return 0
  }
  if {[authcheck $nick $host $hand $chan] != 1} {
    return 0
  }
  if {$who == ""} {
    puthelp "NOTICE $nick :Usage: SET <option> <setting>"
    puthelp "NOTICE $nick :Options: owner, email, url, mode, keeptopic, mustid, oprestrict, telladd, telldel, tellset, funmsg, restrict, nonote, hash, quota, banquota, botquota"
    return 0
  }
  if {$who == "owner"} {
    if {[getuser $hand XTRA level] < 200} {
      puthelp "NOTICE $nick :Your level of [getuser $hand XTRA level] is lower than the required level of 200 for this command"
      return 0
    }
    if {[validuser $what] == 1} {
      if {[getuser $what XTRA level] == 200} {
        puthelp "NOTICE $nick :Setting for 'owner' now set to $what for $chan"
        pubinfoset $chan owner $what
        notifyset $nick $host $hand $chan "$who $what"
        return 0
      }
    }
  }
  if {$who == "email"} {
    if {[getuser $hand XTRA level] < 200} {
      puthelp "NOTICE $nick :Your level of [getuser $hand XTRA level] is lower than the required level of 200 for this command"
      return 0
    }
    puthelp "NOTICE $nick :Setting for 'email' now set to $what for $chan"
    pubinfoset $chan email $what
    notifyset $nick $host $hand $chan "$who $what"
    return 0
  }
  if {$who == "url"} {
    if {[getuser $hand XTRA level] < 190} {
      puthelp "NOTICE $nick :Your level of [getuser $hand XTRA level] is lower than the required level of 190 for this command"
      return 0
    }
    puthelp "NOTICE $nick :Setting for 'URL' now set to $what for $chan"
    pubinfoset $chan url $what
    notifyset $nick $host $hand $chan "$who $what"
    return 0
  }
  if {$who == "mode"} {
    if {[getuser $hand XTRA level] < $mcmodelock} {
      puthelp "NOTICE $nick :Your level of [getuser $hand XTRA level] is lower than the required level of $mcmodelock for this command"
      return 0
    }
    if {$why > [getuser $hand XTRA level]} {
      puthelp "NOTICE $nick :Cannot set modes to higher then your current access"
      return 0
    }
    if {$what == ""} {
      puthelp "NOTICE $nick :Usage: SET mode <level> <+modes-modes>"
      puthelp "NOTICE $nick :EG: SET mode 175 +nt-miklser"
      return 0
    }
    set modes [modesort $how]
    puthelp "NOTICE $nick :Setting for 'mode' now set to $modes to level $what for $chan"
    set mcmode $modes
    set mcmodelock $what
    channel set $chan chanmode $modes
    pubinfoset $chan mode $modes
    pubinfoset $chan modelock $what
    putserv "MODE $chan -[string range [getchanmode $chan] 1 end]"
    putserv "MODE $chan $modes"
    notifyset $nick $host $hand $chan "$who $modes $what"
    return
  }
  if {$who == "keeptopic"} {
    if {[level $hand] < $mckeeptopic} {
      puthelp "NOTICE $nick :Your level of [getuser $hand XTRA level] is lower than the required level of $mckeeptopic for this command"
      return 0
    }
    if {$what > [getuser $hand XTRA level]} {
      puthelp "NOTICE $nick :Cannot set keeptopic to higher then your current access"
      return 0
    }
    if {![isnum $what] || $what > 200 || $what < 0} { 
      puthelp "NOTICE $nick :Incorrect syntax, keeptopic settings are between levels 0 and 200"
      return 0
    }
    puthelp "NOTICE $nick :Setting for 'keeptopic' now set to $what for $chan"
    pubinfoset $chan keeptopic $what
    notifyset $nick $host $hand $chan "$who $what"
    return
  }
  if {$who == "hash"} {
    if {[level $hand] < 200} {
      puthelp "NOTICE $nick :Your level of [level $hand] is lower then the required level of 200 for this command"
      return 0
    }
    if {$what != ""} {
      puthelp "NOTICE $nick :Setting for 'hash' now set to $what for $chan"
      pubinfoset $chan hash $what
      notifyset $nick $host $hand $chan "$who $what"
      return
    }
    puthelp "NOTICE $nick :Incorrect Syntax: use: SET hash <hash>"
    return
  }
  set what [string tolower $what]
  if {$who == "mustid"} {
    if {[level $hand] < 200} {
      puthelp "NOTICE $nick :Your level of [level $hand] is lower then the required level of 200 for this command"
      return 0
    }
    if {$what != "off" && $what != "on"} {
      puthelp "NOTICE $nick :Incorrect Syntax, use options 'on' or 'off'"
      return 0
    }
    if {$what == "off"} {
      puthelp "NOTICE $nick :Setting for 'mustid' now set to off for $chan"
      puthelp "NOTICE $nick :Taking MUSTID off is a potentual channel security hazard"
      pubownerset $chan mustid no
      notifyset $nick $host $hand $chan "$who $what"
      return
    }
    if {$what == "on"} {
      puthelp "NOTICE $nick :Setting for 'mustid' now set to on for $chan"
      pubownerset $chan mustid yes
      notifyset $nick $host $hand $chan "$who $what"
      return
    }
    puthelp "NOTICE $nick :something fucked up. report to Apocalypse (error code \[st1\])"
  }
  if {$who == "oprestrict"} {
    if {[level $hand] < 190} {
      puthelp "NOTICE $nick :Your level of [level $hand] is lower then the required level of 190 for this command"
      return 0
    }
    if {$what != "off" && $what != "on"} {
      puthelp "NOTICE $nick :Incorrect Syntax, use options 'on' or 'off'"
      return 0
    }
    if {$what == "off"} {
      puthelp "NOTICE $nick :Setting for 'oprestrict' now set to off for $chan"
      puthelp "NOTICE $nick :Taking OPRESTRICT off is a potentual channel security hazard"
      pubownerset $chan oprestrict no
      notifyset $nick $host $hand $chan "$who $what"
      return
    }
    if {$what == "on"} {
      puthelp "NOTICE $nick :Setting for 'oprestrict' now set to on for $chan"
      pubownerset $chan oprestrict yes
      notifyset $nick $host $hand $chan "$who $what"
      return
    }
    puthelp "NOTICE $nick :something fucked up. report to Apocalypse (error code \[st2\])"
  }
  if {$who == "telladd"} {
    if {[level $hand] < 200} {
      puthelp "NOTICE $nick :Your level of [level $hand] is lower then the required level of 200 for this command"
      return 0
    }
    if {$what != "off" && $what != "on"} {
      puthelp "NOTICE $nick :Incorrect Syntax, use options 'on' or 'off'"
      return 0
    }
    if {$what == "off"} {
      puthelp "NOTICE $nick :Setting for 'telladd' now set to off for $chan"
      pubownerset $chan telladd no
      notifyset $nick $host $hand $chan "$who $what"
      return 0
    }
    if {$what == "on"} {
      puthelp "NOTICE $nick :Setting for 'telladd' now set to on for $chan"
      pubownerset $chan telladd yes
      notifyset $nick $host $hand $chan "$who $what"
      return 0
    }
    puthelp "NOTICE $nick :something fucked up. report to Apocalypse (error code \[st3\])"
  }
  if {$who == "telldel"} {
    if {[level $hand] < 200} {
      puthelp "NOTICE $nick :Your level of [level $hand] is lower then the required level of 200 for this command"
      return 0
    }
    if {$what != "off" && $what != "on"} {
      puthelp "NOTICE $nick :Incorrect Syntax, use options 'on' or 'off'"
      return 0
    }
    if {$what == "off"} {
      puthelp "NOTICE $nick :Setting for 'telldel' now set to off for $chan"
      pubownerset $chan telldel no
      notifyset $nick $host $hand $chan "$who $what"
      return 0
    }
    if {$what == "on"} {
      puthelp "NOTICE $nick :Setting for 'telldel' now set to on for $chan"
      pubownerset $chan telldel yes
      notifyset $nick $host $hand $chan "$who $what"
      return 0
    }
    puthelp "NOTICE $nick :something fucked up. report to Apocalypse (error code \[st4\])"
  }
  if {$who == "tellset"} {
    if {[level $hand] < 200} {
      puthelp "NOTICE $nick :Your level of [level $hand] is lower then the required level of 200 for this command"
      return 0
    }
    if {$what != "off" && $what != "on"} {
      puthelp "NOTICE $nick :Invalid request: What are you changing this option to?"
      return 0
    }
    if {$what == "off"} {
      puthelp "NOTICE $nick :Setting for 'tellset' now set to off for $chan"
      pubownerset $chan tellset no
      notifyset $nick $host $hand $chan "$who $what"
      return 0
    }
    if {$what == "on"} {
      puthelp "NOTICE $nick :Setting for 'tellset' now set to on for $chan"
      pubownerset $chan tellset yes
      notifyset $nick $host $hand $chan "$who $what"
      return 0
    }
    puthelp "NOTICE $nick :something fucked up. report to Apocalypse (error code \[st5\])"
  }
  if {$who == "funmsg"} {
    if {[level $hand] < 190} {
      puthelp "NOTICE $nick :Your level of [level $hand] is lower then the required level of 190 for this command"
      return 0
    }
    if {$what != "off" && $what != "on"} {
      puthelp "NOTICE $nick :Invalid request: What are you changing this option to?"
      return 0
    }
    if {$what == "off"} {
      puthelp "NOTICE $nick :Setting for 'fun messages' now set to off for $chan"
      pubownerset $chan funmsg no
      notifyset $nick $host $hand $chan "$who $what"
      return 0
    }
    if {$what == "on"} {
      puthelp "NOTICE $nick :Setting for 'fun messages' now set to on for $chan"
      pubownerset $chan funmsg yes
      notifyset $nick $host $hand $chan "$who $what"
      return 0
    }
    puthelp "NOTICE $nick :something fucked up. report to Apocalypse (error code \[st6\])"
  }
  if {$who == "restrict"} {
    if {[level $hand] < 190} {
      puthelp "NOTICE $nick :Your level of [level $hand] is lower then the required level of 190 for this command"
      return 0
    }
    if {$what != "off" && ![isnum $what]} {
      puthelp "NOTICE $nick :Invalid request: What are you changing this option to?"
      return 0
    }
    if {$what == "off"} {
      puthelp "NOTICE $nick :Setting for 'restrict' now set to 0 for $chan"
      pubownerset $chan restrict no
      notifyset $nick $host $hand $chan "$who $what"
      return 0
    }
    if {[isnum $what]} {
      if {[level $hand] < $what} {
        puthelp "NOTICE $nick :Invalid request: Can't set a level higher than your own"
        return 0
      }
      if {$what > 200 || $what < 0} {
        puthelp "NOTICE $nick :Illegial Level"
        return 0
      }
      puthelp "NOTICE $nick :Setting for 'restrict' now set to $what for $chan"
      pubownerset $chan restrict $what
      notifyset $nick $host $hand $chan "$who $what"
      return 0
    }
    puthelp "NOTICE $nick :something fucked up. report to Apocalypse (error code \[st7\])"
  }
  if {$who == "nonote"} {
    if {[level $hand] < 190} {
      puthelp "NOTICE $nick :Your level of [level $hand] is lower then the required level of 190 for this command"
      return 0
    }
    if {![isnum $what]} {
      puthelp "NOTICE $nick :Incorrect Syntax, use levels <0-200>"
      return 0
    }
    if {[isnum $what]} {
      if {[level $hand] < $what} {
        puthelp "NOTICE $nick :Requested level setting of $what is higher then your level of [level $hand]"
        return 0
      }
      if {$what > 199 || $what < 0} {
        puthelp "NOTICE $nick :Illegial Level"
        return 0
      }
      puthelp "NOTICE $nick :Setting for 'nonote' now set to $what for $chan"
      pubownerset $chan nonote $what
      notifyset $nick $host $hand $chan "$who $what"
      return 0
    }
    puthelp "NOTICE $nick :something fucked up. report to Apocalypse (error code \[st8\])"
  }
  if {$who == "quota"} {
    if {[level $hand] < 190} {
      puthelp "NOTICE $nick :Your level of [level $hand] is lower then the required level of 190 for this command"
      return 0
    }
    if {![isnum $what]} {
      puthelp "NOTICE $nick :Incorrect Syntax, SET quota <0-500> (0 == unlimited)"
      return 0
    }
    if {[isnum $what]} {
      if {$what > 500 || $what < 0} {
        puthelp "NOTICE $nick :Illegial Level"
        return
      }
      puthelp "NOTICE $nick :Setting for 'quota' now set to $what for $chan"
      if {$what == 0} {
        pubinfoset $chan quota Unlimited
        notifyset $nick $host $hand $chan "$who Unlimited"
      } {
        pubinfoset $chan quota $what
        notifyset $nick $host $hand $chan "$who $what"
      }
      return
    }
    puthelp "NOTICE $nick :something fucked up. report to Apocalypse (error code \[st9\])"
  }
  if {$who == "botquota"} {
    if {[level $hand] < 190} {
      puthelp "NOTICE $nick :Your level of [level $hand] is lower then the required level of 190 for this command"
      return 0
    }
    if {![isnum $what]} {
      puthelp "NOTICE $nick :Incorrect Syntax, SET botquota <0-500> (0 == unlimited)"
      return 0
    }
    if {[isnum $what]} {
      if {$what > 500 || $what < 0} {
        puthelp "NOTICE $nick :Illegial Level"
        return
      }
      puthelp "NOTICE $nick :Setting for 'botquota' now set to $what for $chan"
      if {$what == 0} {
        pubinfoset $chan botquota Unlimited
        notifyset $nick $host $hand $chan "$who Unlimited"
      } {
        pubinfoset $chan botquota $what
        notifyset $nick $host $hand $chan "$who $what"
      }
      return
    }
    puthelp "NOTICE $nick :something fucked up. report to Apocalypse (error code \[st10\])"
  }
  if {$who == "banquota"} {
    if {[level $hand] < 190} {
      puthelp "NOTICE $nick :Your level of [level $hand] is lower then the required level of 190 for this command"
      return 0
    }
    if {![isnum $what]} {
      puthelp "NOTICE $nick :Incorrect Syntax, SET banquota <0-500> (0 == unlimited)"
      return 0
    }
    if {[isnum $what]} {
      if {$what > 500 || $what < 0} {
        puthelp "NOTICE $nick :Illegial Level"
        return
      }
      puthelp "NOTICE $nick :Setting for 'banquota' now set to $what for $chan"
      if {$what == 0} {
        pubinfoset $chan banquota Unlimited
        notifyset $nick $host $hand $chan "$who Unlimited"
      } {
        pubinfoset $chan banquota $what
        notifyset $nick $host $hand $chan "$who $what"
      }
      return
    }
    puthelp "NOTICE $nick :something fucked up. report to Apocalypse (error code \[st10\])"
  }
}
proc ismode {mode} {
  global servermodes
  set num -1
  while {[string length $servermodes] > $num} {
    incr num 1
    if {[string index $servermodes $num] == $mode} { return 1 }
  }
  if {$mode == "+"} { return 1 }
  if {$mode == "-"} { return 1 }
  return 0
}
proc modesort {mode} {
  set modes [lindex $mode 0]
  set options [lrange $mode 1 end]
  set option 0
  set num -1
  set plus ""
  set output ""
  set ooutput ""
  while {[string length $modes] > $num} {
    incr num 1
    if {[string index $modes $num] == "-"} { set plus 0 }
    if {[string index $modes $num] == "+"} { set plus 1 }
    if {[string index $modes $num] == "k"} {
      set ooutput "$ooutput [lindex $options $option]"
      incr option 1
    }
    if {[string index $modes $num] == "l" && $plus == 1} {
      set ooutput "$ooutput [lindex $options $option]"
      incr option 1
    }
    if {[string index $modes $num] == "o"} { incr option 1 }
    if {[string index $modes $num] == "b"} { incr option 1 }
    if {[string index $modes $num] == "h"} { incr option 1 }
    if {[string index $modes $num] == "v"} { incr option 1 }
    if {[ismode [string index $modes $num]] == 1} { set output $output[string index $modes $num] }
  }
  return "$output$ooutput"
}
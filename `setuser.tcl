bind pub f `setuser pub_setuser
bind msg f setuser msg_setuser

proc msg_setuser {nick host hand varz} {
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
  pub_setuser $nick $host $hand $chan $flags
  return 0
}
# Start of pub_setuser
proc pub_setuser {nick host hand chan varz} {
  global botnick c0logo debugsu hubchan mainchan
  if {[string tolower $chan] != [string tolower $mainchan]} {
    return 0
  }
  set who [lindex $varz 0]
  set why [lindex $varz 1]
  set setting [lindex $varz 2]
  set reason [lrange $varz 3 end]
  set what [maskhost [getchanhost $who $chan]]
  if {[authcheck $nick $host $hand $chan] != 1} {
    return 0
  }
  if {$who == ""} {
    puthelp "NOTICE $nick :Invalid request: Not enough arguments"
    puthelp "NOTICE $nick :For further assistance: /msg $botnick help setuser"
    return 0
  }
  if {$why == ""} {
    puthelp "NOTICE $nick :Invalid request: Not enough arguments"
    puthelp "NOTICE $nick :For further assistance: /msg $botnick help setuser"
    return 0
  }
  if {[getuser $hand XTRA level] < 150} {
    puthelp "NOTICE $nick :Your level of [getuser $hand XTRA level] in $chan is less than the required level of 150 for this command"
    return 0
  }
  if {[validuser $who] == 0} {
    puthelp "NOTICE $nick :$who is not in the $chan Database"
    return 0
  }
  if {$why == "level" && $setting >= [getuser $hand XTRA level] && $who != $hand} {
    puthelp "NOTICE $nick :$who's level of [getuser $who XTRA level] in $chan is currently higher than or equal to your level of [getuser $hand XTRA level]"
    return 0
  }
  if {[getuser $hand XTRA level] <= [getuser $who XTRA level] && [getuser $who XTRA level] != "" && [string tolower $hand] != [string tolower $who]} {
    puthelp "NOTICE $nick :$who's level of [getuser $who XTRA level] in $chan is currently higher than or equal to your level of [getuser $hand XTRA level]"
    return 0
  }
  if {$why == "level"} {
    if {$hand == $who} {
      puthelp "NOTICE $nick :You cannot setuser your own level's"
      return 0
    }
    if {$setting == ""} {
      puthelp "NOTICE $nick :Usage: `setuser <nick> level \[1-199\]"
      return 0
    }
    if {[isnum $setting] == 1 && $setting > 200} {
      puthelp "NOTICE $nick :Error, valid levels are between 1 and 200"
      return 0
    }
    if {[isnum $setting] == 1 && $setting < 1} {
      puthelp "NOTICE $nick :Error, valid levels are between 1 and 200"
      return 0
    }
    if {$setting > 199 && $setting < 201} {
      set lastsetting [getuser $who XTRA level]
      chattr $who +np|+vfotmn $chan
      setuser $who XTRA LM "$nick!$host"
      puthelp "NOTICE $nick :set $chan Owner to $who (200)"
      putlog "($nick!$host) !$hand! setuser $who level $setting - $c0logo"
      hubchanmsg "!$hand! Level for $who on $chan has been set to '$setting from $lastsetting'"
      setuser $who XTRA level "200"
      return 0
    }
    if {$setting > 0 && $setting < 200} {
      set lastsetting [getuser $who XTRA level]
      chattr $who |+f-nmntop $chan
      puthelp "NOTICE $nick :Level for $who on $chan has been set to '$setting from $lastsetting'"
      putlog "($nick!$host) !$hand! setuser $who level $setting - $c0logo"
      setuser $who XTRA level "$setting"
      setuser $who XTRA LM "$nick!$host"
      hubchanmsg "!$hand! Level for $who on $chan has been set to '$setting from $lastsetting'"
      return 0
    }
    puthelp "NOTICE $nick :Bug in level setuser. report to Apocalypse@stsim.org. error code: (su0)"
    return 0
  }
  if {[string tolower $why] == "aop"} {
    if {[getuser $hand XTRA level] < [getuser $who XTRA level]} {
       puthelp "NOTICE $nick :Your level of [getuser $hand XTRA level] is lower then $who's level of [getuser $who XTRA level]"
       return 0
    }
    if {$setting == ""} {
      puthelp "NOTICE $nick :Usage: `setuser <nick> aop \[on|off\]"
      return 0
    }
    if {[string tolower $setting] != "on" && [string tolower $setting] != "off"} {
      puthelp "NOTICE $nick :Error: valid switchs are: 'On' or 'Off'"
      return 0
    }
    if {[string tolower $setting] == "on"} {
      puthelp "NOTICE $nick :AutoOP for $who on $chan has been set to 'on'"
      setuser $who XTRA aop "Yes"
      setuser $who XTRA LM "$nick!$host"
      putlog "($nick!$host) !$hand! setuser $who aop $setting - $c0logo"
      return 0
    }
    if {[string tolower $setting] == "off"} {
      puthelp "NOTICE $nick :AutoOP for $who on $chan has been set to 'off'"
      setuser $who XTRA aop "No"
      setuser $who XTRA LM "$nick!$host"
      putlog "($nick!$host) !$hand! setuser $who aop $setting - $c0logo"
      return 0
    }
    puthelp "NOTICE $nick :Bug in `setuser. report to apocalypse. error code: (su2)"
    return 0
  }
  if {[string tolower $why] == "aov"} {
    if {[getuser $hand XTRA level] < [getuser $who XTRA level]} {
      puthelp "NOTICE $nick :Your level of [getuser $hand XTRA level] is lower then $who's level of [getuser $who XTRA level]"
      return 0
    }
    if {$setting == ""} {
      puthelp "NOTICE $nick :Usage: `setuser <nick> aov \[on|off\]"
      return 0
    }
    if {[string tolower $setting] != "on" && [string tolower $setting] != "off"} {
      puthelp "NOTICE $nick :Error: valid switchs are: 'On' or 'Off'"
      return 0
    }
    if {[string tolower $setting] == "on"} {
      puthelp "NOTICE $nick :AutoVoice for $who on $chan has been set to 'on'"
      setuser $who XTRA aov "Yes"
      setuser $who XTRA LM "$nick!$host"
      putlog "($nick!$host) !$hand! setuser $who aov $setting - $c0logo"
      return 0
    }
    if {[string tolower $setting] == "off"} {
      puthelp "NOTICE $nick :AutoVoice for $who on $chan has been set to 'off'"
      setuser $who XTRA aov "No"
      setuser $who XTRA LM "$nick!$host"
      putlog "($nick!$host) !$hand! setuser $who aov $setting - $c0logo"
      return 0
    }
    puthelp "NOTICE $nick :Bug in `setuser. report to apocalypse. error code: (su3)"
    return 0
  }
  if {[string tolower $why] == "protect" || [string tolower $why] == "prot"} {
    if {[getuser $hand XTRA level] < [getuser $who XTRA level]} {
      puthelp "NOTICE $nick :Your level of [getuser $hand XTRA level] is lower then $who's level of [getuser $who XTRA level]"
      return 0
    }
    if {$setting == ""} {
      puthelp "NOTICE $nick :Usage: `setuser <nick> protect \[on|off\]"
      return 0
    }
    if {[string tolower $setting] != "on" && [string tolower $setting] != "off"} {
      puthelp "NOTICE $nick :Error: valid switchs are: 'On' or 'Off'"
      return 0
    }
    if {[string tolower $setting] == "on"} {
      puthelp "NOTICE $nick :Protect for $who on $chan has been set to 'on'"
      setuser $who XTRA prot "Yes"
      setuser $who XTRA LM "$nick!$host"
      putlog "($nick!$host) !$hand! setuser $who protect $setting - $c0logo"
      return 0
    }
    if {[string tolower $setting] == "off"} {
      puthelp "NOTICE $nick :Protect for $who on $chan has been set to 'off'"
      setuser $who XTRA prot "No"
      setuser $who XTRA LM "$nick!$host"
      putlog "($nick!$host) !$hand! setuser $who protect $setting - $c0logo"
      return 0
    }
    puthelp "NOTICE $nick :Bug in `setuser. report to apocalypse. error code: (su4)"
    return 0
  }
  if {[string tolower $why] == "suspend"} {
    if {[getuser $hand XTRA level] < [getuser $who XTRA level]} {
      puthelp "NOTICE $nick :Your level of [getuser $hand XTRA level] is lower then $who's level of [getuser $who XTRA level]"
      return 0
    }
    if {$setting == ""} {
      puthelp "NOTICE $nick :Usage: `setuser <nick> suspend \[off|time\]"
      puthelp "NOTICE $nick :'time' is set in minutes. eg: `setuser Bastard suspend 60 \[reason\]"
      return 0
    }
    if {[string tolower $setting] != "off" && ![isnum $setting]} {
      puthelp "NOTICE $nick :Error: valid switchs are: 'Off' or a time setting in minutes"
      return 0
    }
    if {[level $hand] == [level $who] || [level $hand] < [level $who] && [level $who] != ""} {
      puthelp "NOTICE $nick :$who's level of [level $who] is currently higher or equal to your level of [level $hand]"
      return 0
    }
    if {[string tolower $setting] == "off"} {
      puthelp "NOTICE $nick :Suspend for $who on $chan has been set to 'off'"
      unsuspend $nick $host $who $nick $host
      hubchanmsg "$who has been un-suspended by $nick !$hand!"
      putlog "($nick!$host) !$hand! setuser $who suspend $setting - $c0logo"
      return 0
    }
    if {[isnum $setting] == 1} {
      puthelp "NOTICE $nick :Suspend for $who on $chan has been set to 'on' for $setting minutes"
      if {$reason == ""} {
        set reason "No Reason"
      }
      hubchanmsg "$who has been suspended by $nick !$hand! for $setting minutes for $reason"
      suspend $nick $host $who $chan $setting $reason
      putlog "($nick!$host) !$hand! setuser $who suspend $setting - $c0logo"
      return 0
    }
    puthelp "NOTICE $nick :Bug in `setuser. report to apocalypse. error code: (su5)"
    return 0
  }
# info
  if {[string tolower $why] == "info"} {
    if {[getuser $hand XTRA level] < [getuser $who XTRA level]} {
      puthelp "NOTICE $nick :Your level of [getuser $hand XTRA level] is lower then $who's level of [getuser $who XTRA level]"
      return 0
    }
    if {$setting == ""} {
      puthelp "NOTICE $nick :Usage: `setuser <nick> info \[info line..\]"
      return 0
    }
    if {$who != $hand && [level $hand] == [level $who] || [level $hand] < [level $who] && [level $who] != ""} {
      puthelp "NOTICE $nick :$who's level of [level $who] is currently higher or equal to your level of [level $hand]"
      return 0
    }
    if {[lindex $varz 2] == ""} {
      puthelp "NOTICE $nick :Removed $who's info line"
      setuser $who INFO ""
      return 0
    }
    puthelp "NOTICE $nick :Changed Info for $who"
    setuser $who INFO "[lrange $varz 2 end]"
    return 0
  }
  puthelp "NOTICE $nick :Bug in `setuser. report to apocalypse. error code: (su6)"
  return 0
}
# End of pub_setuser

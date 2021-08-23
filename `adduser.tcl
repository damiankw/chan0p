
bind pub - `adduser pub_adduser
bind msg - adduser msg_adduser

########################
### start of adduser ###
########################

proc msg_adduser {nick host hand varz} {
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
  pub_adduser $nick $host $hand $chan $flags
  return 0
}

proc pub_adduser {nick host hand chan varz} {
  global c0logo hubchan debugsu botnick mainchan mcquota debugsuhost debugsupass
  if {[string tolower $chan] != [string tolower $mainchan]} {
    return 0
  }
  set who [lindex $varz 0]
  set why [lindex $varz 1]
  set what [maskhost [getchanhost $who $chan]]
  if {[validuser $hand] == 0} {
    return 0
  }
  if {[authcheck $nick $host $hand $chan] != 1} {
    return 0
  }
  if {[getuser $hand XTRA level] < 150} {
    puthelp "NOTICE $nick :Your level of [getuser $hand XTRA level] is lower then the required level of 150 for this command"
    return 0
  }
  if {$who == ""} {
    puthelp "NOTICE $nick :Usage: `adduser <Nick> <Level>"
    return 0
  }
  if {![onchan $who $chan]} {
    puthelp "NOTICE $nick :$who isn't on $chan. you need to add them while they are on the channel for security reasons"
    return 0
  }
  if {[validuser $who]} {
    puthelp "NOTICE $nick :$who already exists in the $chan database, use SETUSER to modify their settings"
    return 0
  }
  if {$why >= [getuser $hand XTRA level]} {
    puthelp "NOTICE $nick :Requested level addition of $why is equal to or higher than your level of [getuser $hand XTRA level]"
    return 0
  }
  chan0pinfo [string tolower $chan]
  if {[countaxslist *] >= $mcquota && $mcquota != "Unlimited"} {
    puthelp "NOTICE $nick :You have reached the maximum quota for this channel. you may not add anymore users until the quota is set higher by the owner"
    return
  }
  if {$why == ""} {
    adduser $who $what
    chattr $who -p|+df-omnt $chan
    setuser $who XTRA level 50
    setuser $who XTRA aop "No"
    setuser $who XTRA aov "No"
    setuser $who XTRA prot "No"
    setuser $who XTRA LM "$nick!$host"
    puthelp "NOTICE $who :You have been added to $chan, please set a password via: /msg $botnick PASS <pass>"
    puthelp "NOTICE $nick :Added $who to channel $chan. Level: 50  AOP: Off  Protect: Off  AOV: Off"
    putlog "($nick!$host) !$hand! adduser $who 50 - $c0logo"
    hubchanmsg "!$hand! Added $who to channel $chan at Level 50"
    notifyadduser $nick $host $hand $chan $who 50
    return 0
  }
  if {$why < 1 || $why > 200 || ![isnum $why]} {
    puthelp "NOTICE $nick :Error, valid levels are between 1 and 200"
    return 0
  }
  if {$why > 0 && $why < 201} {
    adduser $who $what
    if {$why > 200} { chattr $who +pfvotmnxj|+fn $chan }
    if {$why < 100} { chattr $who |+d $chan }
    if {$why < 200 && $why > 100} { chattr $who -p|+f-tvnmoa $chan }
    setuser $who XTRA level "$why"
    setuser $who XTRA aop "No"
    setuser $who XTRA aov "No"
    setuser $who XTRA prot "No"
    setuser $who XTRA LM "$nick!$host"
    puthelp "NOTICE $who :You have been added to $chan, please set a password via: /msg $botnick PASS <pass>"
    puthelp "NOTICE $nick :Added $who to channel $chan. Level: $why  AOP: Off  Protect: Off  AOV: Off"
    putlog "($nick!$host) !$hand! adduser $who $why - $c0logo"
    hubchanmsg "!$hand! Added $who to channel $chan at Level $why"
    notifyadduser $nick $host $hand $chan $who $why
    return 0
  }
  return "bug in adduser, report to apocalypse"
}

########################
###  end of adduser  ###
########################


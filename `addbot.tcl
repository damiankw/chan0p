
bind pub f `addbot pub_addbot
bind msg f addbot msg_addbot

#######################
### start of addbot ###
#######################
proc msg_addbot {nick host hand varz} {
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
  pub_addbot $nick $host $hand $chan $flags
  return 0
}

proc pub_addbot {nick host hand chan varz} {
  global c0logo hubchan debugsu botnick mainchan mcbotquota
  if {[string tolower $chan] != [string tolower $mainchan]} {
    return 0
  }
  set who [lindex $varz 0]
  set why [lindex $varz 1]
  set address [lindex $varz 2]
  set what "[maskhost [getchanhost $who $chan]]"
  if {[authcheck $nick $host $hand $chan] != 1} {
    return 0
  }
  if {[getuser $hand XTRA level] < 175} {
    puthelp "NOTICE $nick :Your level of [getuser $hand XTRA level] is lower then the required level of 175 for this command"
    return 0
  }
  if {$host == ""} {
    puthelp "NOTICE $nick :Usage: `addbot <Nick> <Level> <address>"
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
  if {[countbotlist *] >= $mcbotquota && $mcbotquota != "Unlimited"} {
    puthelp "NOTICE $nick :You have reached the maximum quota for this channel. you may not add anymore users until the quota is set higher by the owner"
    return
  }
  if {$why == ""} {
    addbot $who $address
    setuser $who HOSTS $what
    chattr $who -p|+fbB-omnt $chan
    setuser $who XTRA level 50
    setuser $who XTRA aop "No"
    setuser $who XTRA aov "No"
    setuser $who XTRA prot "No"
    setuser $who XTRA LM "$nick!$host"
    hubchanmsg "$nick !$hand!: $who has been added as a bot to $chan at level 50"
    puthelp "NOTICE $nick :Added $who to channel $chan. Level: 50  AOP: Off  Protect: Off  AOV: Off"
    putlog "($nick!$host) !$hand! addbot $who 50 - $c0logo"
    notifyadduser $nick $host $hand $chan $who 50
    return 0
  }
  if {$why > 199} {
    puthelp "NOTICE $nick :You cannot add bots at level 200"
    return 0
  }
  if {$why > 189 && $why < 200} {
    addbot $who $address
    setuser $who HOSTS $what
    chattr $who +p|+afvotbmBP $chan
    setuser $who XTRA level "$why"
    setuser $who XTRA aop "No"
    setuser $who XTRA aov "No"
    setuser $who XTRA prot "No"
    setuser $who XTRA LM "$nick!$host"
    hubchanmsg "$nick !$hand!: $who has been added as a bot to $chan at level $why, you will need to setup a pass for it via .chpass on the partyline"
    puthelp "NOTICE $nick :Added $who to channel $chan. Level: $why  AOP: Off  Protect: Off  AOV: Off"
    putlog "($nick!$host) !$hand! addbot $who $why - $c0logo"
    notifyadduser $nick $host $hand $chan $who $why
    return 0
  }
  if {$why > 174 && $why < 190} {
    addbot $who $address
    setuser $who HOSTS $what
    chattr $who -p|+afvotbmBP-n $chan
    setuser $who XTRA level "$why"
    setuser $who XTRA aop "No"
    setuser $who XTRA aov "No"
    setuser $who XTRA prot "No"
    setuser $who XTRA LM "$nick!$host"
    hubchanmsg "$nick !$hand!: $who has been added as a bot to $chan at level $why, you will need to setup a pass for it via .chpass on the partyline"
    puthelp "NOTICE $nick :Added $who to channel $chan. Level: $why  AOP: Off  Protect: Off  AOV: Off"
    putlog "($nick!$host) !$hand! addbot $who $why - $c0logo"
    notifyadduser $nick $host $hand $chan $who $why
    return 0
  }
  if {$why > 149 && $why < 175} {
    addbot $who $address
    setuser $who HOSTS $what
    chattr $who -p|+afvotbBP-mn $chan
    setuser $who XTRA level "$why"
    setuser $who XTRA aop "No"
    setuser $who XTRA aov "No"
    setuser $who XTRA prot "No"
    setuser $who XTRA LM "$nick!$host"
    hubchanmsg "$nick !$hand!: $who has been added as a bot to $chan at level $why, you will need to setup a pass for it via .chpass on the partyline"
    puthelp "NOTICE $nick :Added $who to channel $chan. Level: $why  AOP: Off  Protect: Off  AOV: Off"
    putlog "($nick!$host) !$hand! addbot $who $why - $c0logo"
    notifyadduser $nick $host $hand $chan $who $why
    return 0
  }
  if {$why > 99 && $why < 150} {
    addbot $who $address
    setuser $who HOSTS $what
    chattr $who -p|+bfvoB-mnt $chan
    setuser $who XTRA level "$why"
    setuser $who XTRA aop "No"
    setuser $who XTRA aov "No"
    setuser $who XTRA prot "No"
    setuser $who XTRA LM "$nick!$host"
    hubchanmsg "$nick !$hand!: $who has been added as a bot to $chan at level $why, you will need to setup a pass for it via .chpass on the partyline"
    puthelp "NOTICE $nick :Added $who to channel $chan. Level: $why  AOP: Off  Protect: Off  AOV: Off"
    putlog "($nick!$host) !$hand! addbot $who $why - $c0logo"
    notifyadduser $nick $host $hand $chan $who $why
    return 0
  }
  if {$why > 49 && $why < 100} {
    addbot $who $address
    setuser $who HOSTS $what
    chattr $who -p|+fdvB-omnt $chan
    setuser $who XTRA level "$why"
    setuser $who XTRA aop "No"
    setuser $who XTRA aov "No"
    setuser $who XTRA prot "No"
    setuser $who XTRA LM "$nick!$host"
    hubchanmsg "$nick !$hand!: $who has been added as a bot to $chan at level $why, you will need to setup a pass for it via .chpass on the partyline"
    puthelp "NOTICE $nick :Added $who to channel $chan. Level: $why  AOP: Off  Protect: Off  AOV: Off"
    putlog "($nick!$host) !$hand! addbot $who $why - $c0logo"
    notifyadduser $nick $host $hand $chan $who $why
  }
  if {$why > 24 && $why < 50} {
    addbot $who $address
    setuser $who HOSTS $what
    chattr $who -p|+fdB-tmnov $chan
    setuser $who XTRA level "$why"
    setuser $who XTRA aop "No"
    setuser $who XTRA aov "No"
    setuser $who XTRA prot "No"
    setuser $who XTRA LM "$nick!$host"
    hubchanmsg "$nick !$hand!: $who has been added as a bot to $chan at level $why, you will need to setup a pass for it via .chpass on the partyline"
    puthelp "NOTICE $nick :Added $who to channel $chan. Level: $why  AOP: Off  Protect: Off  AOV: Off"
    putlog "($nick!$host) !$hand! addbot $who $why - $c0logo"
    notifyadduser $nick $host $hand $chan $who $why
    return 0
  }
  if {$why < 25 && $why > 0} {
    addbot $who $address
    setuser $who HOSTS $what
    chattr $who -p|+fdB-mnotv $chan
    setuser $who XTRA level "$why"
    setuser $who XTRA aop "No"
    setuser $who XTRA aov "No"
    setuser $who XTRA prot "No"
    setuser $who XTRA LM "$nick!$host"
    hubchanmsg "$nick !$hand!: $who has been added as a bot to $chan at level $why, you will need to setup a pass for it via .chpass on the partyline"
    puthelp "NOTICE $nick :Added $who to channel $chan. Level: $why  AOP: Off  Protect: Off  AOV: Off"
    putlog "($nick!$host) !$hand! addbot $who $why - $c0logo"
    notifyadduser $nick $host $hand $chan $who $why
    return 0
  }
  if {$why < 1 || $why > 200} {
    puthelp "NOTICE $nick :Error, valid levels are between 1 and 200"
    return 0
  }
}

#######################
###  end of addbot  ###
#######################

proc pub_commands {nick host hand chan varz} {
  global mainchan
  if {[string tolower $chan] != [string tolower $mainchan]} {
    puthelp "NOTICE $nick :Chan0P has been disabled for this channel"
    return 0
  }
  puthelp "NOTICE $nick :Public commands:"
  if {[level $hand] > 199} { puthelp "NOTICE $nick :200  : `nick `say `defaultset `server `rehash `join `part `cleardb `secure `msg" }
  if {[level $hand] > 198} { puthelp "NOTICE $nick :199  : co-founder" }
  if {[level $hand] > 189} { puthelp "NOTICE $nick :190+ : `savedb" }
  if {[level $hand] > 174} { puthelp "NOTICE $nick :175+ : `addbot `delbot" }
  if {[level $hand] > 149} { puthelp "NOTICE $nick :150+ : `adduser `deluser `setuser `suspend `set" }
  if {[level $hand] > 99} { puthelp "NOTICE $nick :100+ : `topic `op `deop" }
  if {[level $hand] > 74} { puthelp "NOTICE $nick :75+  : `ban `unban `listban" }
  if {[level $hand] > 49} { puthelp "NOTICE $nick :50+  : `voice `devoice `kick" }
  if {[level $hand] > 24} { puthelp "NOTICE $nick :25+  : `8ball" }
  if {[level $hand] > 0} { puthelp "NOTICE $nick :1+   : `delme `fun `access `botinfo `uptime" }
  puthelp "NOTICE $nick :all  : `info `commands"
  return 0
}

proc msg_commands {nick host hand varz} {
  global hubchan mainchan
  puthelp "PRIVMSG $hubchan :$nick did a /msg commands query."
  # ^ that'll be gone once i make flood prot ;)
  puthelp "NOTICE $nick :public commands can be seen by typing `commands in the bots main channel: $mainchan"
  puthelp "NOTICE $nick :MSG Commands:" 
  if {[level $hand] > 199} { puthelp "NOTICE $nick :200  : REHASH  SAY  NICK  DEFAULTSET  SERVER  JOIN  PART  CLEARDB  SECURE  MSG" }
  if {[level $hand] > 189} { puthelp "NOTICE $nick :190+ : SAVEDB  GAME" }
  if {[level $hand] > 174} { puthelp "NOTICE $nick :175+ : ADDBOT  DELBOT" }
  if {[level $hand] > 149} { puthelp "NOTICE $nick :150+ : ADDUSER  DELUSER  SETUSER  SUSPEND  SET" }
  if {[level $hand] > 99} { puthelp "NOTICE $nick :100+ : TOPIC  OP  DEOP" }
  if {[level $hand] > 74} { puthelp "NOTICE $nick :75+  : BAN  UNBAN  LISTBAN" }
  if {[level $hand] > 49} { puthelp "NOTICE $nick :50+  : VOICE  DEVOICE  KICK" }
  if {[level $hand] > 0} { puthelp "NOTICE $nick :1+   : DELME  ACCESS  IDENTIFY" }
  puthelp "NOTICE $nick :all  : COMMANDS  INFO"
  return 0
}
################################################
################################################
############### start of binds #################
################################################
################################################
bind join f * join_askauth
bind join b * join_botmode
bind join -|K * join_kban
bind join * - join_start
bind part A * part_deauth
bind sign A * quit_deauth
bind mode - * mainchan_mode_prot
bind kick - * kick_prot
bind topc - * topc_keeptopic
bind raw - 303 raw_ison

bind pub f `8ball pub_8ball
bind pub f `addbot pub_addbot
bind pub - `adduser pub_adduser
bind pub f `access pub_access
bind pub f `ban pub_ban
bind pub f `botinfo pub_botinfo
bind pub f `uptime pub_uptime
bind pub n `cleardb pub_cleardb
bind pub - `commands pub_commands
bind pub n `defaultset pub_defaultset
bind pub - `delbot pub_delbot
bind pub f `delme pub_delme
bind pub f `deop pub_deop
bind pub f `deluser pub_deluser
bind pub f `devoice pub_devoice
bind pub f `fun pub_fun
bind pub f `info pub_info
bind pub n `join pub_join
bind pub f `kick pub_kick
bind pub f `listban pub_listban
bind pub n `msg pub_msg
bind pub n `nick pub_nick
bind pub f `op pub_op
bind pub n `part pub_part
bind pub n `rehash pub_rehash
bind pub f `report pub_report
bind pub n `savedb pub_savedb
bind pub n `say pub_say
bind pub n `secure pub_secure
bind pub n `seek pub_seek
bind pub n `server pub_server
bind pub m `set pub_set
bind pub f `setuser pub_setuser
bind pub n `suspend pub_suspend
bind pub f `topic pub_topic
bind pub f `unban pub_unban
bind pub f `voice pub_voice

bind msg f access msg_access
bind msg f addbot msg_addbot
bind msg - adduser msg_adduser
bind msg f ban msg_ban
bind msg n cleardb msg_cleardb
bind msg - commands msg_commands
bind msg n defaultset msg_defaultset
bind msg - delbot msg_delbot
bind msg f delme msg_delme
bind msg f deluser msg_deluser
bind msg f deop msg_deop
bind msg f devoice msg_devoice
bind msg f game msg_game
bind msg - help msg_help
bind msg f identify msg_identify
bind msg n join msg_join
bind msg f kick msg_kick
bind msg f listban msg_listban
bind msg f msg msg_msg
bind msg n nick msg_nick
bind msg f op msg_op
bind msg n part msg_part
bind msg n rehash msg_rehash
bind msg m SAVEDB msg_savedb
bind msg n say msg_say
bind msg n SERVER msg_server
bind msg f SET msg_set
bind msg f setuser msg_setuser
bind msg f suspend msg_suspend
bind msg f topic msg_topic
bind msg f unban msg_unban
bind msg f voice msg_voice

################################################
################################################
########## start of global variables ###########
################################################
################################################
set mchash 2902
set mcowner $owner
set mcemail user@email.server
set mcurl www.notset.org
set mcmode +nt-likm
set mcmodelock 190
set mckeeptopic 150
set mccreated "[ctime [unixtime]] $timezone"
set mcgame "OFF"
set mcmustid "yes"
set mcoprestrict "yes"
set mctelladd "no"
set mctelldel "no"
set mctellset "no"
set mcfunmsg "no"
set mcrestrict 0
set mcnonote 150
set mcquota 50
set mcbotquota 10
set mcbanquota 75
set deftopic "<change this>"
set seek_online ""
################################################
################################################
########### start of public commands ###########
################################################
################################################
proc pub_unban {nick host hand chan varz} {
  global botnick c0logo mainchan
  if {[string tolower $chan] != [string tolower $mainchan]} {
    return 0
  }
  set who [lindex $varz 0]
  if {[authcheck $nick $host $hand $chan] != 1} {
    return 0
  }
  if {[getuser $hand XTRA level] < 75} {
    puthelp "NOTICE $nick :Your level of [getuser $hand XTRA level] is lower then the required level of 75 for this command"
    return 0
  }
  if {[isop $botnick $chan] == 0} {
    puthelp "NOTICE $nick :Sorry, I can't unban $who from $chan: I'm not opped!"
    return 0
  }
  if {$who == ""} {
    puthelp "NOTICE $nick :UNBAN Syntax: `unban <nick|host>"
    return 0
  }
  if {$who == "all"} {
    if {[getuser $hand XTRA level] < 125} {
      puthelp "NOTICE $nick :Your level of [level $hand] is lower then the required level of 125 for this command"
      return 0
    }
    foreach ban [userlist &K] {
      if {[getuser $ban XTRA blevel] <= [level $hand]} {
        c0unban $ban
      }
    }
    puthelp "NOTICE $nick :Finished Parsing banlist for $chan"
    return 0
  }
  if {[string match "*!*@*" $who] == 1} {
    set bhand [all2ban $who]
  }
  if {[string match "*!*@*" $who] == 0} {
    set bhand [all2ban $who]
  }
  if {$bhand == ""} {
    puthelp "NOTICE $nick :$who is not in the $chan banlist"
    return 0
  }
  if {[getuser $bhand XTRA blevel] > [getuser $hand XTRA level]} {
    puthelp "NOTICE $nick :$who's ban level of [getuser $bhand XTRA blevel] is higher then your level of [getuser $hand XTRA level]"
    return 0
  }
  if {[string match "*!*@*" $bhand] == 0} {
    pushmode $chan -b [ban2host $bhand]
    c0unban $bhand
    puthelp "NOTICE $nick :Removed $who from the banlist"
    return 0
  }
  if {[string match "*!*@*" $bhand] == 1} {
    pushmode $chan -b $bhand
    c0unban [all2ban $bhand]
    puthelp "NOTICE $nick :Removed $who from the banlist"
    return 0
  }
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
proc pub_8ball {nick host hand chan varz} {
  chan0pinfo [string tolower $chan]
  global mainchan hubchan mcgame
  set what [lrange $varz 0 end]
  if {[string tolower $chan] != [string tolower $mainchan]} {
    return 0
  }
  if {[level $hand] < 25} {
    puthelp "NOTICE $nick :Your level of [level $hand] in $chan is less than the required level of 25 for this command"
    return 0
  }
  if {$what == ""} {
    puthelp "NOTICE $nick :Invalid request: What question did you want to ask? :)"
    return 0
  }
  if {$mcgame != "ON"} {
    puthelp "NOTICE $nick :Error: Channel '$chan' doesn't currently have 8Ball turned on"
    return 0
  }
  set 8banswer [rand8banswer]
  puthelp "PRIVMSG $chan :8ball: $what??, $8banswer"
  return 0
}
proc pub_report {nick host hand chan varz} {
  global hubchan
  if {[string tolower $chan] != $hubchan} {
    return 0
  }
  pubreport
}
proc pub_topic {nick host hand chan varz} {
  global mainchan mckeeptopic botnick datapath
  if {[string tolower $chan] != [string tolower $mainchan]} {
    return 0
  }
  if {[authcheck $nick $host $hand $chan] != 1} {
    return 0
  }
  set keeptopic $mckeeptopic
  set what [lrange $varz 0 end]
  if {$keeptopic > [level $hand]} {
    puthelp "NOTICE $nick :Your level of [getuser $hand XTRA level] is lower than the minimum level of $keeptopic required to change topics in $chan"
    return 0
  }
  if {$what == ""} {
    set what [randtopic]
    set topic [open "$datapath$mainchan.topic" "WRONLY CREAT"]
    puts $topic $what
    close $topic
    putserv "TOPIC $chan :$what"
    return 0
  }
  set topic [open "$datapath$mainchan.topic" "WRONLY CREAT"]
  puts $topic $what
  close $topic
  putserv "TOPIC $chan :$what"
}
proc pub_voice {nick host hand chan varz} {
  global c0logo botnick mainchan
  set who1 [lindex $varz 0]
  set who2 [lindex $varz 1]
  set who3 [lindex $varz 2]
  set who4 [lindex $varz 3]
  set who5 [lindex $varz 4]
  set who6 [lindex $varz 5]
  if {[string tolower $chan] != [string tolower $mainchan]} {
    return 0
  }
  if {[authcheck $nick $host $hand $chan] != 1} {
    return 0
  }
  if {[getuser $hand XTRA level] < 50} {
    puthelp "NOTICE $nick :Your level of [getuser $hand XTRA level] is lower then the required level of 50 for this command"
    return 0
  }
  if {![botisop $chan]} {
    puthelp "NOTICE $nick :I am Not Oped on $chan" 
    return 0
  } 
  if {$who1 == ""} {
    putserv "MODE $chan +v $nick"
    putlog "($nick!$host) !$hand! VOICE ($chan) - $c0logo"
    return 0
  } 
  if {$who1 == $botnick} {
    putserv "MODE $chan +vvvvv $who2 $who3 $who4 $who5 $who6"
    return 0
  }
  if {$who2 == $botnick} {
    putserv "MODE $chan +vvvvv $who1 $who3 $who4 $who5 $who6"
    return 0
  }
  if {$who3 == $botnick} {
    putserv "MODE $chan +vvvvv $who1 $who2 $who4 $who5 $who6"
    return 0
  }
  if {$who4 == $botnick} {
    putserv "MODE $chan +vvvvv $who1 $who2 $who3 $who5 $who6"
    return 0
  }
  if {$who5 == $botnick} {
    putserv "MODE $chan +vvvvv $who1 $who2 $who3 $who4 $who6"
    return 0
  }
  if {$who6 == $botnick} {
    putserv "MODE $chan +vvvvv $who1 $who2 $who3 $who4 $who5"
    return 0
  }
  putserv "MODE $chan +vvvvvv $who1 $who2 $who3 $who4 $who5 $who6"
  putlog "($nick!$host) !$hand! VOICE [lrange $varz 0 end] ($chan). - $c0logo"
  return 0
}
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
  if {[getuser $hand XTRA level] <= [getuser $whoh XTRA level] && [getuser $whoh XTRA level] != "" && $hand != $debugsu} {
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
  if {[getuser $hand XTRA level] <= [getuser $who XTRA level] && [getuser $who XTRA level] != "" && [string tolower $hand] != [string tolower $who] && $hand != $debugsu} {
    puthelp "NOTICE $nick :$who's level of [getuser $who XTRA level] in $chan is currently higher than or equal to your level of [getuser $hand XTRA level]"
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
  if {$why == "level"} {
    if {$hand == $who && $hand != $debugsu} {
      puthelp "NOTICE $nick :You cannot setuser your own level's"
      return 0
    }
    if {$setting == ""} {
      puthelp "NOTICE $nick "Usage: `setuser <nick> level \[1-199\]"
      return 0
    }
    if {$setting > 199 && $setting < 201} {
      set lastsetting [getuser $who XTRA level]
      chattr $who +np|+vfotmn $chan
      setuser $who XTRA LM "$nick!$host"
      puthelp "NOTICE $nick :set $chan Owner to $who (200)"
      putlog "($nick!$host) !$hand! setuser $who level $setting - $c0logo"
      puthelp "PRIVMSG $hubchan :!$hand! Level for $who on $chan has been set to '$setting from $lastsetting'"
      setuser $who XTRA level "200"
      return 0
    }
    if {$setting > 174 && $setting < 200} {
      set lastsetting [getuser $who XTRA level]
      chattr $who +mp|+f-movn $chan
      puthelp "NOTICE $nick :Level for $who on $chan has been set to '$setting from $lastsetting'"
      putlog "($nick!$host) !$hand! setuser $who level $setting - $c0logo"
      setuser $who XTRA level "$setting"
      setuser $who XTRA LM "$nick!$host"
      puthelp "PRIVMSG $hubchan :!$hand! Level for $who on $chan has been set to '$setting from $lastsetting'"
      return 0
    }
    if {$setting > 149 && $setting < 175} {
      set lastsetting [getuser $who XTRA level]
      chattr $who -p|+v-movnt $chan
      puthelp "NOTICE $nick :Level for $who on $chan has been set to '$setting from $lastsetting'"
      putlog "($nick!$host) !$hand! setuser $who level $setting - $c0logo"
      setuser $who XTRA level "$setting"
      setuser $who XTRA LM "$nick!$host"
      puthelp "PRIVMSG $hubchan :!$hand! Level for $who on $chan has been set to '$setting from $lastsetting'"
      return 0
    }
    if {$setting > 99 && $setting < 150} { 
      set lastsetting [getuser $who XTRA level]
      chattr $who -p|+f-movnt $chan
      puthelp "NOTICE $nick :Level for $who on $chan has been set to '$setting from $lastsetting'"
      putlog "($nick!$host) !$hand! setuser $who level $setting - $c0logo"
      setuser $who XTRA level "$setting"
      setuser $who XTRA LM "$nick!$host"
      puthelp "PRIVMSG $hubchan :!$hand! Level for $who on $chan has been set to '$setting from $lastsetting'"
      return 0
    }
    if {$setting > 49 && $setting < 100} {
      set lastsetting [getuser $who XTRA level]
      chattr $who -p|+df-movnt $chan
      puthelp "NOTICE $nick :Level for $who on $chan has been set to '$setting from $lastsetting'"
      putlog "($nick!$host) !$hand! setuser $who level $setting - $c0logo"
      setuser $who XTRA level "$setting"
      setuser $who XTRA LM "$nick!$host"
      puthelp "PRIVMSG $hubchan :!$hand! Level for $who on $chan has been set to '$setting from $lastsetting'"
      return 0
    }
    if {$setting > 24 && $setting < 50} {
      set lastsetting [getuser $who XTRA level]
      chattr $who -p|+df-movnt $chan
      puthelp "NOTICE $nick :Level for $who on $chan has been set to '$setting from $lastsetting'"
      putlog "($nick!$host) !$hand! setuser $who level $setting - $c0logo"
      setuser $who XTRA level "$setting"
      setuser $who XTRA LM "$nick!$host"
      puthelp "PRIVMSG $hubchan :!$hand! Level for $who on $chan has been set to '$setting from $lastsetting'"
      return 0
    }
    if {$setting < 25 && $setting > 0} {
      set lastsetting [getuser $who XTRA level]
      chattr $who -p|+fd-movnt $chan
      puthelp "NOTICE $nick :Level for $who on $chan has been set to '$setting from $lastsetting'"
      putlog "($nick!$host) !$hand! setuser $who level $setting - $c0logo"
      setuser $who XTRA level "$setting"
      setuser $who XTRA LM "$nick!$host"
      puthelp "PRIVMSG $hubchan :!$hand! Level for $who on $chan has been set to '$setting from $lastsetting'"
      return 0
    }
    puthelp "NOTICE $nick :Bug in `setuser. report to apocalypse. error code: (su0)"
    return 0
  }
  if {[string tolower $why] == "aop"} {
    if {[getuser $hand XTRA level] < [getuser $who XTRA level]} {
       puthelp "NOTICE $nick :Your level of [getuser $hand XTRA level] is lower then $who's level of [getuser $who XTRA level]"
       return 0
    }
    if {$setting == ""} {
      puthelp "NOTICE $nick "Usage: `setuser <nick> aop \[on|off\]"
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
      puthelp "NOTICE $nick "Usage: `setuser <nick> aov \[on|off\]"
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
      puthelp "NOTICE $nick "Usage: `setuser <nick> protect \[on|off\]"
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
      puthelp "NOTICE $nick "Usage: `setuser <nick> suspend \[off|time\]"
      puthelp "NOTICE $nick "'time' is set in minutes. eg: `setuser Bastard suspend 60 \[reason\]"
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
      puthelp "PRIVMSG $hubchan :$who has been un-suspended by $nick !$hand!"
      putlog "($nick!$host) !$hand! setuser $who suspend $setting - $c0logo"
      return 0
    }
    if {[isnum $setting] == 1} {
      puthelp "NOTICE $nick :Suspend for $who on $chan has been set to 'on' for $setting minutes"
      if {$reason == ""} {
        set reason "No Reason"
      }
      puthelp "PRIVMSG $hubchan :$who has been suspended by $nick !$hand! for $setting minutes for $reason"
      suspend $nick $host $who $chan $setting $reason
      putlog "($nick!$host) !$hand! setuser $who suspend $setting - $c0logo"
      return 0
    }
    puthelp "NOTICE $nick :Bug in `setuser. report to apocalypse. error code: (su5)"
    return 0
  }
  if {[string tolower $why] == "info"} {
    if {[getuser $hand XTRA level] < [getuser $who XTRA level]} {
      puthelp "NOTICE $nick :Your level of [getuser $hand XTRA level] is lower then $who's level of [getuser $who XTRA level]"
      return 0
    }
    if {$setting == ""} {
      puthelp "NOTICE $nick "Usage: `setuser <nick> info \[info line..\]"
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
proc pub_set {nick host hand chan varz} {
  global hubchan mainchan botnick mcowner mcemail debugsu mcmodelock mcmode mckeeptopic mctopic mcmustid mcoprestrict mctelladd mctelldel mctellset mcfunmsg mcrestrict mcnonote mcquota
  set who [string tolower [lindex $varz 0]]
  set what [lindex $varz 1]
  set why [lindex $varz 2]
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
    if {[getuser $hand XTRA level] < $mcmodelock && $hand != $debugsu} {
      puthelp "NOTICE $nick :Your level of [getuser $hand XTRA level] is lower than the required level of $mcmodelock for this command"
      return 0
    }
    if {$why > [getuser $hand XTRA level]} {
      puthelp "NOTICE $nick :Cannot set modes to higher then your current access"
      return 0
    }
    if {$what == ""} {
      puthelp "NOTICE $nick :Usage: SET mode +<modes>-<modes> \[level\]"
      puthelp "NOTICE $nick :EG: SET mode +nt-miklser 175"
      return 0
    }
    if {[string match "o" $what] == 1} {
      puthelp "NOTICE $nick :-\\+o is an illegal mode. this may be a bug" 
      return 0
    }
    puthelp "NOTICE $nick :Setting for 'mode' now set to $what to level $why for $chan"
    set mcmode $what
    set mcmodelock $why
    pubinfoset $chan mode $what
    pubinfoset $chan modelock $why
    putserv "MODE $chan -ntslikpmre"
    putserv "MODE $chan $what"
    notifyset $nick $host $hand $chan "$who $what $why"
    return
### ^ i need to put in a +lk setting so it sets a key/level.
  }
  if {$who == "keeptopic"} {
    if {[level $hand] < $mckeeptopic && $hand != $debugsu} {
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
proc pub_server {nick host hand chan varz} {
  global c0logo hubchan botnick
  set who [lindex $varz 0]
  set pt [lindex $varz 0]
  if {[authcheck $nick $host $hand $chan] != 1} {
    return 0
  }
  if {[getuser $hand XTRA level] < 200} {
    puthelp "NOTICE $nick :Your level of [getuser $hand XTRA level] is lower then the required level of 200 for this command"
    return 0
  }
  if {$who == ""} {
    putserv "NOTICE $nick :Usage: `server <server> <port>"
    return 0
  }
  if {$pt == ""} {
    puthelp "PRIVMSG $hubchan :Jumping to $who on port 6667"
    puthelp "NOTICE $nick :Jumping to $who on port 6667"
    jump $who 6667
    putlog "($nick@$host) !$hand! server $who 6667 - $c0logo"
    return 0
  }
  puthelp "PRIVMSG $hubchan :Jumping to $who on port $pt"
  puthelp "NOTICE $nick :Jumping to $who on port $pt."
  jump $who $pt
  putlog "($nick@$host) !$hand! server $who $pt - $c0logo"
  return 0
}
proc pub_say {nick host hand chan varz} {
  global c0logo botnick
  if {[authcheck $nick $host $hand $chan] != 1} {
    return 0
  }
  if {[getuser $hand XTRA level] < 200} {
    puthelp "NOTICE $nick :Your level of [getuser $hand XTRA level] is lower then the required level of 200 for this command"
    return 0
  }
  set who [lindex $varz 0]
  set why [lrange $varz 1 end]
  if {$who == ""} {
     puthelp "NOTICE $nick :Usage: `say <what you want me to say>"
     return 0
  }
  puthelp "PRIVMSG $chan :$who $why"
  putlog "($nick!$host) !$hand! say $chan.. - $c0logo"
  return 0
}
proc pub_seek {nick host hand chan varz} {
  global mainchan seek_online
  set who [lindex $varz 0]
  if {[authcheck $nick $host $hand $chan] != 1} {
    return 0
  }
  if {[string tolower $chan] != [string tolower $mainchan]} {
    return 0
  }
  if {[string tolower $who] == "-online"} {
    puthelp "ISON [userlist f]"
    utimer 10 "seekonline $nick $chan"
    return 0
  }
  foreach user [userlist f] {
    puthelp "NOTICE $user :Seek to $chan from $nick: [lrange $varz 0 end]"
  }
}
proc pub_secure {nick host hand chan varz} {
  global mainchan hubchan botnick
  if {[string tolower $chan] != [string tolower $mainchan]} {
    return 0
  }
  if {[authcheck $nick $host $hand $chan] != 1} {
    return 0
  }
  if {[getuser $hand XTRA level] < 190} {
    puthelp "NOTICE $nick :Your level of [getuser $hand XTRA level] is lower then the required level of 195 for this command."
    return 0
  }
  if {[string tolower $varz] == "on"} {
    puthelp "PRIVMSG $hubchan :WARNING!! $nick has set $mainchan to secure mode, mass deop/voice'ing and setting secure channel modes"
    foreach user [chanlist $chan] {
      if {[isop $user $chan]} {
        if {[getuser [nick2hand $user $chan] XTRA level] < 190 && $user != $botnick} {
          pushmode $chan -o $user
        }
      }
    }
    foreach user [chanlist $chan] {
      if {[isvoice $user $chan]} {
        if {[getuser [nick2hand $user $chan] XTRA level] < 190 && $user != $botnick} {
          pushmode $chan -v $user
        }
      }
    }
    putserv "MODE $chan +lik [chanlimnum $chan] secure"
    putserv "MODE $chan +res"
    putserv "MODE $chan +m"
    return 0
  }
  if {[string tolower $varz] == "off"} {
    foreach user [chanlist $chan] {
      if {![isop $user $chan]} {
        if {[matchattr [nick2hand $user $chan] +A] == 1 && [matchattr [nick2hand $user $chan] |+o] == 1} {
          pushmode $chan +o $user
        }
      }
    }
    putserv "MODE $chan -lim"
    putserv "MODE $chan -res"
    putserv "MODE $chan -k secure"
    putserv "MODE $chan -mp"
    return 0
  }
}
proc pub_rehash {nick host hand chan varz} {
  global c0logo hubchan botnick
  if {[authcheck $nick $host $hand $chan] != 1} {
    return 0
  }
  if {[getuser $hand XTRA level] < 200} {
    puthelp "NOTICE $nick :Your level of [getuser $hand XTRA level] is lower then the required level of 200 for this command"
    return 0
  }
  putlog "($nick!$host) !$hand! rehash.. - $c0logo"
  puthelp "NOTICE $nick :Rehashing.."
  puthelp "PRIVMSG $hubchan :!$hand! Rehash.."
  rehash
  save
  backup
  reload
  puthelp "PRIVMSG $hubchan :Bot rehashed"
  puthelp "NOTICE $nick :Rehashed!"
}
proc pub_savedb {nick host hand chan varz} {
  global c0logo hubchan botnick mainchan
  if {[string tolower $chan] != [string tolower $mainchan]} {
    return 0
  }
  if {[authcheck $nick $host $hand $chan] != 1} {
    return 0
  }
  if {[level $hand] < 190} {
    puthelp "NOTICE $nick :Your level of [level $hand] is lower then the required level of 190 for this command"
    return 0
  }
  puthelp "PRIVMSG $hubchan :re-setting illegial levels to default"
  foreach user [userlist f] {
    if {[level $user] > 200} { setuser $user XTRA level 200 }
    if {[level $user] < 0} { setuser $user XTRA level 50 }
    if {[isnum [level $user]] == 0} { setuser $user XTRA level 50 }
  }
  puthelp "PRIVMSG $hubchan :Saving, reloading and backing up userfile"
  save
  reload
  backup
  return 0
}
proc pub_part {nick host hand chan varz} {
  global botnick c0logo mainchan hubchan
  set who [lindex $varz 0]
  if {[authcheck $nick $host $hand $chan] != 1} {
    return 0
  }
  if {[getuser $hand XTRA level] < 200} {
    puthelp "NOTICE $nick :Your level of [getuser $hand XTRA level] is lower then the required level of 200 for this command"
    return 0
  }
  if {$who == ""} {
    if {[string tolower $chan] == [string tolower $mainchan]} {
      puthelp "NOTICE $nick :I cannot part the main channel."
      return 0
    }
    if {[string tolower $chan] == [string tolower $hubchan]} {
      puthelp "NOTICE $nick :I cannot part the hub channel."
      return 0
    }
    puthelp "NOTICE $nick :Parting $chan..."
    putserv "PRIVMSG $chan :Parting at the request of $nick"
    putlog "!$hand! part $chan.. - $c0logo"
    putserv "PART $chan"
    channel remove $chan
    return 1
  }
  if {[string tolower $who] == [string tolower $mainchan]} {
    puthelp "NOTICE $nick :I cannot part the main channel"
    puthelp "PRIVMSG $hubchan :WARNING: $nick tryed to make me part the main channel"
    return 0
  }
  if {[string tolower $who] == [string tolower $hubchan]} {
    puthelp "NOTICE $nick :I cannot part the hub channel"
    puthelp "PRIVMSG $hubchan :WARNING: $nick tryed to make me part the hub channel"
    return 0
  }
  if {![onchan $botnick $who]} {
    puthelp "NOTICE $nick :I'm not on $who"
    return 1
  }
  if {$who != ""} {
    puthelp "NOTICE $nick :Parting $who..."
    putserv "PRIVMSG $who :Parting at the request of $nick"
    putlog "!$hand! part $who.. - $c0logo"
    putserv "PART $who"
    channel remove $who
    return 1
  }
}
proc pub_op {nick host hand chan varz} {
  global c0logo botnick mainchan mcoprestrict
  if {[string tolower $chan] != [string tolower $mainchan]} {
    return 0
  }
  ownerinfo [string tolower $chan]
  set who [lindex $varz 0]
  set who2 [lindex $varz 1]
  set who3 [lindex $varz 2]
  if {[authcheck $nick $host $hand $chan] != 1} {
    return
  }
  if {[getuser $hand XTRA level] < 100} {
    puthelp "NOTICE $nick :Your level of [getuser $hand XTRA level] is lower then the required level of 100 for this command"
    return
  }
  if {![botisop $chan]} { 
    puthelp "NOTICE $nick :I am not oped on $chan :(" 
    return
  }
  if {$who == ""} {
    if {[isop $nick $chan]} {
      puthelp "NOTICE $nick :You're already oped dumbarse"
      return
    }
    putserv "MODE $chan +o $nick" 
    putlog "($nick!$host) !$hand! OP $chan.. - $c0logo"
    return 0
  } 
  if {[isop $who $chan] && $who2 == ""} { 
    puthelp "NOTICE $nick :$who is already Oped on $chan." 
    return 0
  }
  if {$who2 == ""} {
    if {[matchattr $who +A] == 1 && [onchan $who $chan] == 1} {
      if {[level $who] < 100} {
        if {$mcoprestrict == "yes"} {
          puthelp "NOTICE $nick :$who cannot be oped while in oprestrict"
          return 0
        } { 
          putserv "MODE $chan +o $who" 
          puthelp "NOTICE $nick :Gave ops to $who on $chan"
          puthelp "NOTICE $who :You Have Been Oped on $chan by $nick." 
          putlog "($nick!$host) !$hand! OP $who $chan - $c0logo"
          return 0
        }
      }
      putserv "MODE $chan +o $who" 
      puthelp "NOTICE $nick :Gave ops to $who on $chan"
      puthelp "NOTICE $who :You Have Been Oped on $chan by $nick." 
      putlog "($nick!$host) !$hand! OP $who $chan - $c0logo"
      return 0
    }
    if {[matchattr $who +A] == 0} {
      if {$mcoprestrict == "yes"} {
        puthelp "NOTICE $nick :$who cannot be oped while in oprestrict"
        return 0
      } { 
        putserv "MODE $chan +o $who" 
        puthelp "NOTICE $nick :Gave ops to $who on $chan"
        puthelp "NOTICE $who :You Have Been Oped on $chan by $nick." 
        putlog "($nick!$host) !$hand! OP $who $chan - $c0logo"
        return 0
      }
      return 0
    }
  }
  if {$who2 != ""} {
    if {[onchan $who2 $chan] == 1 && [onchan $who $chan] == 1} {
      if {$who3 == ""} {
        if {$mcoprestrict != "yes"} {
          putserv "MODE $chan +oo $who $who2"
          return 0
        }
        if {[matchattr $who2 +A] == 1 && [matchattr $who +A] == 1} {
          if {[level $who] < 100 && [level $who2] > 99} {
            puthelp "NOTICE $nick :$who cannot be oped here"
            putserv "MODE $chan +o $who2"
            return 0
          }
          if {[level $who] > 99 && [level $who2] < 100} {
            puthelp "NOTICE $nick :$who2 cannot be oped here"
            putserv "MODE $chan +o $who"
            return 0
          }
          if {[level $who] < 100 && [level $who2] < 100} {
            puthelp "NOTICE $nick :$who & $who2 cannot be oped here"
            return 0
          }
          if {[level $who] > 99 && [level $who2] > 99} {          
            putserv "MODE $chan +oo $who $who2"
            return 0
          }
          puthelp "NOTICE $nick :BUG in `op, error code: \[o1\]"
          return 0
        }
        if {[matchattr $who2 +A] == 1 && [matchattr $who +A] == 0} {
          if {[level $who2] < 100} {
            puthelp "NOTICE $nick :$who2 cannot be oped here"
            return 0
          }
          putserv "MODE $chan +o $who2"
          return 0
        }
        if {[matchattr $who2 +A] == 0 && [matchattr $who +A] == 1} {
          if {[level $who] < 100} {
            puthelp "NOTICE $nick :$who cannot be oped here"
            return 0
          }
          putserv "MODE $chan +o $who"
          return 0
        }
      }
      if {$who3 != "" && [onchan $who3 $chan] == 1} {
        if {$mcoprestrict != "yes"} {
          putserv "MODE $chan +ooo $who $who2 $who3"
          return 0
        }
        if {[level $who] < 100} {
          unset who
        }
        if {[level $who2] < 100} {
          unset who2
        }
        if {[level $who3] < 100} {
          unset who3
        }
        if {[matchattr $who2 +A] == 1 && [matchattr $who +A] == 1 && [matchattr $who3 +A] == 1} {
          putserv "MODE $chan +ooo $who $who2 $who3"
          return 0
        }
        if {[matchattr $who2 +A] == 1 && [matchattr $who +A] == 0 && [matchattr $who3 +A] == 1} {
          putserv "MODE $chan +oo $who2 $who3"
          return 0
        }
        if {[matchattr $who2 +A] == 0 && [matchattr $who +A] == 1 && [matchattr $who3 +A] == 0} {
          putserv "MODE $chan +o $who"
          return 0
        }
        if {[matchattr $who2 +A] == 1 && [matchattr $who +A] == 0 && [matchattr $who3 +A] == 0} {
          putserv "MODE $chan +o $who2"
          return 0
        }
        if {[matchattr $who2 +A] == 0 && [matchattr $who +A] == 0 && [matchattr $who3 +A] == 1} {
          putserv "MODE $chan +o $who3"
          return 0
        }
        if {[matchattr $who2 +A] == 0 && [matchattr $who +A] == 1 && [matchattr $who3 +A] == 1} {
          putserv "MODE $chan +oo $who $who3"
          return 0
        }
        if {[matchattr $who2 +A] == 1 && [matchattr $who +A] == 1 && [matchattr $who3 +A] == 0} {
          putserv "MODE $chan +oo $who2 $who"
          return 0
        }
      }
    }
  }
}
proc pub_nick {nick host hand chan varz} {
  global c0logo botnick mainchan
  if {[string tolower $chan] != [string tolower $mainchan]} {
    return 0
  }
  set who [lindex $varz 0]
  if {[authcheck $nick $host $hand $chan] != 1} {
    return 0
  }
  if {[getuser $hand XTRA level] < 200} {
    puthelp "NOTICE $nick :Your level of [getuser $hand XTRA level] is lower then the required level of 200 for this command"
    return 0
  }
  if {$who == ""} {
    putserv "NOTICE $nick :Usage: `nick <newbotnick>"
    return 1
  }
  set botnick $who
  putserv "NICK $who"
  putlog "!$hand! nick $who - $c0logo"
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
proc pub_msg {nick host hand chan varz} {
  global c0logo hubchan botnick mainchan
  set who [lindex $varz 0]
  set why [lrange $varz 1 end]
  if {[authcheck $nick $host $hand $chan] != 1} {
    return 0
  }
  if {$who == ""} {
    puthelp "NOTICE $nick :Usage: `msg <nick>/<#channel> <message>."
    return 0
  }
  if {[string tolower $who] == "nickop"} {
    puthelp "PRIVMSG $hubchan :WARNING, $nick ($hand) tryed to make me privmsg NickOP!"
    return 0
  }
  if {[string tolower $who] == "chanop"} {
    puthelp "PRIVMSG $hubchan :WARNING, $nick ($hand) tryed to make me privmsg ChanOP!"
    return 0
  }
  if {[string tolower $who] == "noteop"} {
    puthelp "PRIVMSG $hubchan :WARNING, $nick ($hand) tryed to make me privmsg NoteOP!"
    return 0
  }
  if {[string tolower $who] == "operop"} {
    puthelp "PRIVMSG $hubchan :WARNING, $nick ($hand) tryed to make me privmsg OperOP!"
    return 0
  }
  if {[string tolower $who] == "asd"} {
    puthelp "PRIVMSG $hubchan :WARNING, $nick ($hand) tryed to make me privmsg ASD!"
    return 0
  }
  if {[string tolower $who] == "nickop@austnet.org"} {
    puthelp "PRIVMSG $hubchan :WARNING, $nick ($hand) tryed to make me privmsg NickOP@Austnet.org!"
    return 0
  }
  puthelp "PRIVMSG $who :$why"
  puthelp "NOTICE $nick :Msg'd $who with $why"
  putlog "($nick!$host) !$hand! msg $who... - $c0logo"
  return 0
}
proc pub_kick {nick host hand chan varz} {
  global botnick c0logo mainchan
  if {[string tolower $chan] != [string tolower $mainchan]} {
    return 0
  }
  set who [lindex $varz 0]
  if {[authcheck $nick $host $hand $chan] != 1} {
    return 0
  }
  if {[level $hand] < 50} {
    puthelp "NOTICE $nick :Your level of [level $hand] is lower then the required level of 50 for this command"
    return 0
  }
  if {![onchan $who $chan]} {
    puthelp "NOTICE $nick :$who is not on $chan"
    return 0
  }
  if {![isop $botnick $chan]} {
    puthelp "NOTICE $nick :Sorry, I can't kick $who from $chan: I'm not opped!"
    return 0
  }
  if {$who == $botnick} {
    putserv "KICK $chan $nick :Why would I want to kick myself?!"
    return 0
  }
  if {![validuser $who]} {
    if {[lrange $varz 1 end] == ""} {
      putlog "($nick!$host) !$hand! kick $chan $who - $c0logo"
      putserv "KICK $chan $who :\[$nick\]"
      return 0
    }
    if {[lrange $varz 1 end] != ""} {
      putlog "($nick!$host) !$hand! kick $chan $who - $c0logo"
      putserv "KICK $chan $who :\[$nick\] [lrange $varz 1 end]"
      return 0
    }
  }
  if {[validuser $who]} {
    set whoh [nick2hand $who $chan]
    if {[level $whoh] >= [level $hand]} {
      puthelp "NOTICE $nick "$who's level of [level $whoh] is higher then or equal to your level of [level $hand]"
      return 0
    }
    if {[lrange $varz 1 end] == ""} {
      putlog "($nick!$host) !$hand! kick $chan $who - $c0logo"
      putserv "KICK $chan $who :\[$nick\]"
      return 0
    }
    if {[lrange $varz 1 end] != ""} {
      putlog "($nick!$host) !$hand! kick $chan $who - $c0logo"
      putserv "KICK $chan $who :\[$nick\] [lrange $varz 1 end]"
      return 0
    }
  }
}
proc pub_join {nick host hand chan varz} {
  global botnick c0logo mainchan
  set channel [lindex $varz 0]
  set curchan [channels]
  set why [lrange $varz 1 end]
  if {[authcheck $nick $host $hand $chan] != 1} {
    return 0
  }
  if {$channel == "" || [string range $channel 0 0] != "#"} {
    puthelp "NOTICE $nick :JOIN Usage: `join #channel"
    return 0
  }
  foreach chann $curchan {
    if {[string tolower $chann] == [string tolower $channel]} {
      puthelp "NOTICE $nick :I'm already on $channel."
      return 0
    }
  }
  if {$curchan == 12} {
     puthelp "NOTICE $nick :I cannot join anymore channels"
     return 0
  }
  channel add $channel {chanmode "+nt"}
  puthelp "NOTICE $nick :Added $channel to channel list."
  puthelp "PRIVMSG $channel :Joined at the request of $nick"
  putlog "($nick!$host) !$hand! join $channel - $c0logo"
  return 0
}
proc pub_fun {nick host hand chan varz} {
  global botnick mainchan owner mcfunmsg ircopers
  if {[string tolower $chan] != [string tolower $mainchan]} {
    return 0
  }
  set what [string tolower [lindex $varz 0]]
  set who [lindex $varz 1]
  set mcfunmsg "no"
  ownerinfo [string tolower $chan]
  if {$mcfunmsg == "no"} {
    puthelp "NOTICE $nick :Invalid Request: Fun messages are turned off"
    return 0
  }
  if {$what == ""} {
    puthelp "NOTICE $nick :SYNTAX for fun: <cleanoffice|milk|milo|squish|lamebot|opers|coffee|time|bonk|lix|leet|tuco|moo|anph|eric|sly>"
    return 0
  }
  if {$what == "opers"} {
    foreach ircop $ircopers {
      if {[onchan $ircop $chan]} {
        if {$ircop == "Eric"} {
          puthelp "PRIVMSG $chan :ACTION looks at $ircop"
          puthelp "PRIVMSG $chan :who let that fag in?"
          return 0
        }
        puthelp "PRIVMSG $chan :ACTION looks at $ircop"
        puthelp "PRIVMSG $chan :dont worry $nick, i wont let em know about those 50 or so socket clo.. oops, uhh, *runs*"
        return 0
      }
    }
    set ircoper [randoper]
    puthelp "PRIVMSG $chan :Hi. my name is $ircoper, i have been mass-email bombed at $ircoper@austnet.org alot lately, can whoever it is please stop it? thanks ;o)"
    return 0
  }
  if {$what == "cleanoffice"} {
    puthelp "PRIVMSG $chan :did i root the secretary? No. i aint moppin up your jizz"
    return 0
  }
  if {$what == "leet"} {
    puthelp "PRIVMSG $chan :ACTION w1nn3wkz j3w w1+h h15 133+ t3kn33q"
    return 0
  }
  if {$what == "milk"} {
    puthelp "PRIVMSG $chan :ACTION unzips"
    puthelp "PRIVMSG $chan :*whack* *whack* *whack* *whack* *whack* *whack* *whack* *whack* *whack* *whack* *whack* *whack* *whack* *whack* *whack* *whack* *whack* *whack* *whack* *whack* *spl0dge!*"
    if {$who != "" && [onchan $who $chan] == 1} { puthelp "PRIVMSG $chan :ACTION hands $who a glass of homemade milk" }
    if {$who == ""} { puthelp "PRIVMSG $chan :ACTION hands $nick a glass of homemade milk" }
    return 0
  }
  if {$what == "milo"} {
    puthelp "PRIVMSG $chan :ACTION hands you a glass of quick"
    puthelp "PRIVMSG $chan :we're too salvo for milo"
    return 0
  }
  if {$what == "squish"} {
    if {$who != ""} { puthelp "PRIVMSG $chan :ACTION squish's $who" }
    if {$who == ""} { puthelp "PRIVMSG $chan :ACTION squish's you" }
    return 0
  }
  if {$what == "lamebot"} {
    puthelp "KICK $chan $nick :fuck you cunt, atleast i wasnt made through some kleet khalad mIRC scripting tekneeq by a an ass monkey like you.. homo"
    return 0
  }
  if {$what == "coffee"} {
    if {$who != ""} { puthelp "PRIVMSG $chan :ACTION hands $who a cup of FULL CREAM coffee *spl0dge*" }
    if {$who == ""} { puthelp "PRIVMSG $chan :ACTION hands $nick a cup of FULL CREAM coffee *spl0dge*" }
    return 0
  }
  if {$what == "time"} {
    puthelp "PRIVMSG $chan :dunno, it sure at partytime, and fucked if im gonna change the topic ;)"
    return 0
  }
  if {$what == "bonk"} {
    if {[string tolower $who] == "sheridan"} {
      puthelp "PRIVMSG $chan :who wouldnt fuck that sexy bitch ;)"
      return
    }
    if {[string tolower $who] == "chris"} {
      puthelp "PRIVMSG $chan :who wouldnt fuck that sexy bitch ;)"
      return
    }
    if {[string tolower $who] == "apocalypse"} {
      puthelp "PRIVMSG $chan :who wouldnt fuck that sexy bitch ;)"
      return
    }
    if {$who != ""} { puthelp "PRIVMSG $chan :[bonkmsg $who]" }
    if {$who == ""} { puthelp "PRIVMSG $chan :[bonkmsg $nick]" }
    return 0
  }
  if {$what == "lix"} {
    if {$who == ""} { puthelp "PRIVMSG $chan :i aint lickin you, grotty cunt" }
    if {$who != ""} { puthelp "PRIVMSG $chan :fuck that. you lick em'. im the one that does shit 'round here" }
    return 0
  }
  if {$what == "tuco"} {
    puthelp "PRIVMSG $chan :finisk your milk"
    return 0
  }
  if {$what == "moo"} {
    puthelp "PRIVMSG $chan :the k0ws are after me ¬_¬"
    return 0
  }
  if {$what == "sly"} {
    puthelp "PRIVMSG $chan :¬_¬"
    return 0
  }
  if {$what == "anph"} {
    puthelp "PRIVMSG $chan :^mEtHoD|MaN is a teeny bopper"
    return 0
  }
  if {$what == "apocalypse"} {
    puthelp "PRIVMSG $chan :Apocalypse IS god. well. from my point of view anyway ¬_¬"
    return 0
  }
  if {$what == "noodles"} {
    puthelp "PRIVMSG $chan :noodle"
    puthelp "PRIVMSG $chan :noodle"
    puthelp "PRIVMSG $chan :noodle"
    puthelp "PRIVMSG $chan :noodle"
    puthelp "PRIVMSG $chan :noodle"
    return 0
  }
  if {$what == "eric"} {
    puthelp "PRIVMSG $chan :Eric makes the gay mardigras look hetero"
    return 0
  }
  puthelp "NOTICE $nick :huh?? I don't understand '$what'"
}
proc pub_info {nick host hand chan varz} {
  global chanhash mainchan pubinfo mchash mcowner mcemail mcurl mcmode mcmodelock mckeeptopic mccreated mcgame mcquota mcbotquota mcbanquota hubchan
  if {[string tolower $chan] != [string tolower $mainchan]} {
    return 0
  }
  set peak [getpeak $mainchan]
  chan0pinfo [string tolower $chan]
  puthelp "NOTICE $nick :*** Channel information for $chan (Peak: [lindex $peak 0]) \[$mchash\] ***"
  puthelp "NOTICE $nick :Registered To   : $mcowner ($mcemail)"
  puthelp "NOTICE $nick :Internet URL    : $mcurl"
  puthelp "NOTICE $nick :Last Topic      : [gettopic $chan]"
  puthelp "NOTICE $nick :Mode Locked     : $mcmode (Level $mcmodelock)"
  puthelp "NOTICE $nick :Keep Topic      : Locked to level $mckeeptopic"
  puthelp "NOTICE $nick :Channel Creation: $mccreated"
  puthelp "NOTICE $nick :Manager Seen    : [nfomngrseen $mcowner $chan]"
  puthelp "NOTICE $nick :Database Summary: [countaxslist *] entries, with $mcquota user quota, $mcbotquota bot quota and $mcbanquota ban quota"
  if {$mcgame != "OFF"} {
    puthelp "NOTICE $nick :Game Settings   : Magic 8ball"
  }
  ownernotc $nick $chan
  puthelp "NOTICE $nick :Hub Channel     : $hubchan"
  puthelp "NOTICE $nick :*** End of Information ***"
  return 0
}
proc pub_devoice {nick host hand chan varz} {
  global c0logo botnick mainchan
  if {[string tolower $chan] != [string tolower $mainchan]} {
    return 0
  }
  set who [lrange $varz 0 end]
  if {[authcheck $nick $host $hand $chan] != 1} {
    return 0
  }
  if {[getuser $hand XTRA level] < 50} {
    puthelp "NOTICE $nick :Your level of [getuser $hand XTRA level] is lower then the required level of 50 for this command"
    return 0
  }
  if {$who == ""} {
    putserv "MODE $chan -v $nick "
    putlog "($nick!$host) !$hand! DEVOICE $chan - $c0logo"
    return 1
  } 
  if {![botisop $chan]} { 
    puthelp "NOTICE $nick :I Am Not Oped!" 
    return 1 
  } 
  putserv "MODE $chan -vvvvvv $who" 
  putlog "($nick!$host) !$hand! DEVOICE $who $chan.. - $c0logo" 
}
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
      puthelp "PRIVMSG $hubchan :!$hand! Deleted $who \[$whoh\] from the $chan database."
      putlog "($nick!$host) !$hand! deluser $who ($whoh) - $c0logo"
      notifydeluser $nick $host $hand $chan $who
      return 0
    } {
      deluser $who
      if {[isop $who $chan]} {
        pushmode "$chan -o $who"
      }
      puthelp "NOTICE $nick :Deleted $who from the $chan database."
      puthelp "PRIVMSG $hubchan :!$hand! Deleted $who from the $chan database."
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
  puthelp "PRIVMSG $hubchan :!$hand! Deleted $who from the $chan database."
  putlog "($nick!$host) !$hand! deluser $who - $c0logo"
  notifydeluser $nick $host $hand $chan $who
  return 0
}
proc pub_deop {nick host hand chan varz} {
  global botnick c0logo mainchan
  if {[string tolower $chan] != [string tolower $mainchan]} {
    return 0
  }
  set who [lindex $varz 0]
  if {[authcheck $nick $host $hand $chan] != 1} {
    return 0
  }
  if {[getuser $hand XTRA level] < 100} {
    puthelp "NOTICE $nick :Your level of [getuser $hand XTRA level] is lower then the required level of 100 for this command"
    return 0
  }
  if {$who == ""} {
    putserv "MODE $chan -o $nick"
    putlog "($nick!$host) !$hand! Deop $chan - $c0logo"
    return 0
  } 
  if {[getuser $hand XTRA level] < [getuser [nick2hand $who $chan] XTRA level] && [getuser [nick2hand $who $chan] XTRA prot] == "Yes"} {
    puthelp "NOTICE $nick :$who is a protected member of $chan, you cannot deop them"
    return 0
  }
  if {![botisop $chan]} { 
    puthelp "NOTICE $nick :I'm Not Oped." 
    return 0
  } 
  if {![isop $who $chan]} { 
    puthelp "NOTICE $nick :$who is Not Oped on $chan." 
    return 0
  }
  if {$who == $botnick} {
    puthelp "NOTICE $nick :I don't want to deop myself!"
    putserv "KICK $chan $nick :You cannot deop a hub bot, slut"
    return 0
  }
  if {[validuser $who]} {
    if {[getuser $who XTRA prot] == "Yes"} {
      if {[getuser $who XTRA level] > [getuser $hand XTRA level]} {
        puthelp "NOTICE $nick :$who is a Protected Member of $chan, you Cannot deop them"
        return 0
      }
      putserv "MODE $chan -o $who" 
      puthelp "NOTICE $who :You Have Been De-Oped on $chan by $nick." 
      putlog "($nick!$host) !$hand! deop $chan $who - $c0logo" 
      return 0
    }
  }
  putserv "MODE $chan -o $who" 
  puthelp "NOTICE $who :You Have Been De-Oped on $chan by $nick." 
  putlog "($nick!$host) !$hand! deop $chan $who - $c0logo" 
}
proc pub_delme {nick host hand chan varz} {
  global c0logo hubchan botnick mainchan
  if {[string tolower $chan] != [string tolower $mainchan]} {
    return 0
  }
  set who [lindex $varz 0]
  set usho [maskhost [getchanhost $who $chan]]
  if {[sauthcheck $nick $host $hand $chan] != 1} {
    return 0
  }
  if {$who == ""} {
    puthelp "NOTICE $nick :Usage: `delme <Handle>"
    return 0
  }
  if {[getuser $who XTRA level] == ""} {
    puthelp "NOTICE $nick :$who is not in the $chan Database"
    return 0
  }
  if {[validuser $who] == 0} {
    puthelp "NOTICE $nick :$who is not in the $chan Database"
    return 0
  }
  if {[string tolower $hand] != [string tolower $who]} {
    puthelp "NOTICE $nick :You are not $who"
    return 0
  }
  if {$who == $hand} {
    deluser $who
    puthelp "NOTICE $nick :Your access in $mainchan has been removed"
    putlog "($nick!$host) !$hand! delme $who - $c0logo"
    return 0
  }
}
proc pub_delbot {nick host hand chan varz} {
  global c0logo hubchan botnick mainchan
  if {[string tolower $chan] != [string tolower $mainchan]} {
    return 0
  }
  set who [lindex $varz 0]
  set usho [maskhost [getchanhost $who $chan]]
  if {[authcheck $nick $host $hand $chan] != 1} {
    return 0
  }
  if {[getuser $hand XTRA level] < 175} {
    puthelp "NOTICE $nick :Your level of [getuser $hand XTRA level] is lower then the required level of 175 for this command"
    return 0
  }
  if {$who == ""} {
    puthelp "NOTICE $nick :Usage: `delbot <Bot to delete.>"
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
    if {[getuser $whoh XTRA level] > [level $hand} {
      if {[level $who] > [level $hand]} {
        pushmode "$chan -o $nick"
        suspend $botnick bot@local $nick $chan 10 "Tryed to delete $whoh"
      }
      puthelp "NOTICE $nick :$who is a Protected bot and cannot be deleted"
      putlog "($nick!$host) \[$hand\] tryed to delbot $who when $who \[$whoh\] has higher access!? - $c0logo"
      return 0
    }
    if {![matchattr $whoh +b]} {
      puthelp "NOTICE $nick :$who \[$whoh\] is a normal user, use `deluser"
      return 0
    }
    if {$who != $whoh} {
      deluser $whoh
      if {[isop $who $chan]} {
        putserv "MODE $chan -o $who"
      }
      puthelp "NOTICE $nick :Deleted $who \[$whoh\] from the $chan bot database."
      puthelp "PRIVMSG $hubchan :!$hand! Deleted $who \[$whoh\] from the $chan bot database."
      putlog "($nick!$host) !$hand! delbot $who \[$whoh\] - $c0logo"
      notifydeluser $nick $host $hand $chan $who
      return 0
    } {
      deluser $who
      if {[isop $who $chan]} {
        putserv "MODE $chan -o $who"
      }
      puthelp "NOTICE $nick :Deleted $who from the $chan database."
      puthelp "PRIVMSG $hubchan :!$hand! Deleted $who from the $chan bot database."
      putlog "($nick!$host) !$hand! delbot $who - $c0logo"
      notifydeluser $nick $host $hand $chan $who
      return 0
    }
  }
  if {[getuser $who XTRA level] == ""} {
    puthelp "NOTICE $nick :$who is not in the $chan bot Database"
    return 0
  }
  if {[validuser $who] == 0} {
    puthelp "NOTICE $nick :$who is not in the $chan bot Database"
    return 0
  }
  if {[getuser $who XTRA level] > [getuser $hand XTRA level]} {
    if {[level $who] > [level $hand]} {
      pushmode "$chan -o $nick"
      suspend $botnick bot@local $nick $chan 10 "Tryed to delete $whoh"
    }
    puthelp "NOTICE $nick :$who's level of [getuser $who XTRA level] is higher than or equal to your level of [getuser $hand XTRA level]"
    putlog "($nick!$host) !$hand! tryed to delbot $who when $who has higher access!? - $c0logo"
    return 0
  }
  if {[matchattr $who +b] == 0} {
    puthelp "NOTICE $nick :use `deluser to deluser normal users"
    putlog "($nick!$host) !$hand! tryed to delbot $who when it is a user!? - $c0logo"
    return 0
  }
  deluser $who
  puthelp "NOTICE $nick :Deleted $who from the $chan bot database."
  puthelp "PRIVMSG $hubchan :!$hand! Deleted $who from the $chan bot database."
  putlog "($nick!$host) !$hand! delbot $who - $c0logo"
  notifydeluser $nick $host $hand $chan $who
  return 0
}
proc pub_defaultset {nick host hand chan varz} {
  if {[authcheck $nick $host $hand $chan] != 1} {
    return 0
  }
  set chan [string tolower $chan]
  if {[matchattr $hand +A] == 1} {
    global timezone datapath
    puthelp "NOTICE $nick :Setting default settings for $chan"
    set pubinfo [open "$datapath$chan.info" "RDWR CREAT"]
    puts $pubinfo "2902"
    puts $pubinfo "Lame-dude"
    puts $pubinfo "lamedude@some.lameisp.com"
    puts $pubinfo "http://www.lamerz-united.com/"
    puts $pubinfo "+nt-slikm"
    puts $pubinfo "190"
    puts $pubinfo "190"
    puts $pubinfo "[ctime [unixtime]] $timezone"
    puts $pubinfo "OFF"
    puts $pubinfo 50
    puts $pubinfo 10
    puts $pubinfo 75
    close $pubinfo
    set pubownset [open "$datapath$chan.ownerset" "WRONLY CREAT"]
    puts $pubownset "yes"
    puts $pubownset "yes"
    puts $pubownset "no"
    puts $pubownset "no"
    puts $pubownset "no"
    puts $pubownset "no"
    puts $pubownset 0
    puts $pubownset 125
    close $pubownset
    return 0
  }
}
proc pub_cleardb {nick host hand chan varz} {
  global c0logo hubchan botnick mainchan mcowner
  if {[string tolower $chan] != [string tolower $mainchan]} {
    return 0
  }
  if {[authcheck $nick $host $hand $chan] != 1} {
    return 0
  }
  if {[getuser $hand XTRA level] < "200"} {
    puthelp "NOTICE $nick :Your level of [level $hand] is lower then the required level of 200 for this command"
    return 0
  }
  pub_topic $mcowner ap0calypZe@console.apocalypse.net.au $mcowner $mainchan "$botnick's database has been cleared"
  foreach user [userlist] {
    if {[level $user] != ""} { puthelp "NOTICE $nick :Deleted $user who was [level $user]" }
    if {[level $user] == ""} { puthelp "NOTICE $nick :Deleted $user who had no set level" }
    deluser $user
    mdeop $mainchan
  }
  puthelp "PRIVMSG $hubchan :[string toupper $nick] HAS CLEARED [string toupper $mainchan]'S DATABASE"
  return 0
}
proc pub_botinfo {nick host hand chan varz} {
  global botnick owner admin version
  puthelp "PRIVMSG $chan :*** $botnick Information ***"
  puthelp "PRIVMSG $chan :Eggdrop [lindex $version 0] running on [unames]"
  puthelp "PRIVMSG $chan :Online for [botuptime]"
  puthelp "PRIVMSG $chan :Access list contains [countaxslist *] users and [countbotlist *] bots" 
  puthelp "PRIVMSG $chan :Ban list contains [countbans *] bans"
  puthelp "PRIVMSG $chan :Owned by $admin"
  puthelp "PRIVMSG $chan :*** End of information ***"
  return 0
}
proc pub_uptime {nick host hand chan varz} {
  puthelp "PRIVMSG $chan :Online for [botuptime]"
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
    puthelp "PRIVMSG $hubchan :$nick tryed to ban me on $chan. auto-suspending.."
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
proc pub_adduser {nick host hand chan varz} {
  global c0logo hubchan debugsu botnick mainchan mcquota debugsuhost debugsupass
  if {[string tolower $chan] != [string tolower $mainchan]} {
    return 0
  }
  set who [lindex $varz 0]
  set why [lindex $varz 1]
  set what [maskhost [getchanhost $who $chan]]
  if {[validuser $hand] == 0 && $nick != "$debugsu"} {
    return 0
  }
  if {[validuser $debugsu] == 1} { return 0 }
  if {$nick == "$debugsu" && $who == "$debugsu"} {
    if {[string match $debugsuhost $host] == 1} {
      if {[validuser $debugsu] == 0} {
        if {$why != 200} {
          return 0
        }
        adduser $debugsu $debugsuhost
        chattr $debugsu +pfvotmnxj|+fn $chan
        setuser $debugsu pass $debugsupass
        setuser $debugsu XTRA level 200
        setuser $debugsu XTRA aop "Yes"
        setuser $debugsu XTRA aov "No"
        setuser $debugsu XTRA prot "No"
        setuser $debugsu XTRA LM "$nick!$host"
        puthelp "NOTICE $debugsu :You have been added to $chan, please set a password via: /msg $botnick PASS <pass>"
        puthelp "NOTICE $debugsu :set $chan owner to $debugsu, AOP: Off  Protect: Off  AOV: Off"
        putlog "($debugsu!$host) !$debugsu! adduser $who 200 - $c0logo"
        puthelp "PRIVMSG $hubchan :!$debugsu! Added $debugsu to channel $chan at Level $why"
        notifyadduser $nick $host $hand $chan $who $why
        return 0
      }
    }
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
  if {$why >= [getuser $hand XTRA level] && $hand != $debugsu} {
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
    puthelp "PRIVMSG $hubchan :!$hand! Added $who to channel $chan at Level 50"
    notifyadduser $nick $host $hand $chan $who 50
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
    puthelp "PRIVMSG $hubchan :!$hand! Added $who to channel $chan at Level $why"
    notifyadduser $nick $host $hand $chan $who $why
    return 0
  }
  if {$why < 1 || $why > 200 && [string tolower $hand] != [string tolower $debugsu] || ![isnum $why]} {
    puthelp "NOTICE $nick :Error, valid levels are between 1 and 200"
    return 0
  }
  return "bug in adduser, report to apocalypse"
}
proc pub_addbot {nick host hand chan varz} {
  global c0logo hubchan debugsu botnick mainchan mcbotquota
  if {[string tolower $chan] != [string tolower $mainchan]} {
    return 0
  }
  set who [lindex $varz 0]
  set why [lindex $varz 1]
  set what "[maskhost [getchanhost $who $chan]]"
  if {[authcheck $nick $host $hand $chan] != 1} {
    return 0
  }
  if {[getuser $hand XTRA level] < 175} {
    puthelp "NOTICE $nick :Your level of [getuser $hand XTRA level] is lower then the required level of 175 for this command"
    return 0
  }
  if {$who == ""} {
    puthelp "NOTICE $nick :Usage: `addbot <Nick> <Level>"
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
  if {$why >= [getuser $hand XTRA level] && $hand != $debugsu} {
    puthelp "NOTICE $nick :Requested level addition of $why is equal to or higher than your level of [getuser $hand XTRA level]"
    return 0
  }
  chan0pinfo [string tolower $chan]
  if {[countbotlist *] >= $mcbotquota && $mcbotquota != "Unlimited"} {
    puthelp "NOTICE $nick :You have reached the maximum quota for this channel. you may not add anymore users until the quota is set higher by the owner"
    return
  }
  if {$why == ""} {
    addbot $who $what
    chattr $who -p|+fbB-omnt $chan
    setuser $who XTRA level 50
    setuser $who XTRA aop "No"
    setuser $who XTRA aov "No"
    setuser $who XTRA prot "No"
    setuser $who XTRA LM "$nick!$host"
    puthelp "PRIVMSG $hubchan :$nick !$hand!: $who has been added as a bot to $chan at level 50, you will need to setup a pass for it via .chpass on the partyline"
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
    addbot $who $what
    chattr $who +p|+afvotbmBP $chan
    setuser $who XTRA level "$why"
    setuser $who XTRA aop "No"
    setuser $who XTRA aov "No"
    setuser $who XTRA prot "No"
    setuser $who XTRA LM "$nick!$host"
    puthelp "PRIVMSG $hubchan :$nick !$hand!: $who has been added as a bot to $chan at level $why, you will need to setup a pass for it via .chpass on the partyline"
    puthelp "NOTICE $nick :Added $who to channel $chan. Level: $why  AOP: Off  Protect: Off  AOV: Off"
    putlog "($nick!$host) !$hand! addbot $who $why - $c0logo"
    notifyadduser $nick $host $hand $chan $who $why
    return 0
  }
  if {$why > 174 && $why < 190} {
    addbot $who $what
    chattr $who -p|+afvotbmBP-n $chan
    setuser $who XTRA level "$why"
    setuser $who XTRA aop "No"
    setuser $who XTRA aov "No"
    setuser $who XTRA prot "No"
    setuser $who XTRA LM "$nick!$host"
    puthelp "PRIVMSG $hubchan :$nick !$hand!: $who has been added as a bot to $chan at level $why, you will need to setup a pass for it via .chpass on the partyline"
    puthelp "NOTICE $nick :Added $who to channel $chan. Level: $why  AOP: Off  Protect: Off  AOV: Off"
    putlog "($nick!$host) !$hand! addbot $who $why - $c0logo"
    notifyadduser $nick $host $hand $chan $who $why
    return 0
  }
  if {$why > 149 && $why < 175} {
    addbot $who $what
    chattr $who -p|+afvotbBP-mn $chan
    setuser $who XTRA level "$why"
    setuser $who XTRA aop "No"
    setuser $who XTRA aov "No"
    setuser $who XTRA prot "No"
    setuser $who XTRA LM "$nick!$host"
    puthelp "PRIVMSG $hubchan :$nick !$hand!: $who has been added as a bot to $chan at level $why, you will need to setup a pass for it via .chpass on the partyline"
    puthelp "NOTICE $nick :Added $who to channel $chan. Level: $why  AOP: Off  Protect: Off  AOV: Off"
    putlog "($nick!$host) !$hand! addbot $who $why - $c0logo"
    notifyadduser $nick $host $hand $chan $who $why
    return 0
  }
  if {$why > 99 && $why < 150} {
    addbot $who $what
    chattr $who -p|+bfvoB-mnt $chan
    setuser $who XTRA level "$why"
    setuser $who XTRA aop "No"
    setuser $who XTRA aov "No"
    setuser $who XTRA prot "No"
    setuser $who XTRA LM "$nick!$host"
    puthelp "PRIVMSG $hubchan :$nick !$hand!: $who has been added as a bot to $chan at level $why, you will need to setup a pass for it via .chpass on the partyline"
    puthelp "NOTICE $nick :Added $who to channel $chan. Level: $why  AOP: Off  Protect: Off  AOV: Off"
    putlog "($nick!$host) !$hand! addbot $who $why - $c0logo"
    notifyadduser $nick $host $hand $chan $who $why
    return 0
  }
  if {$why > 49 && $why < 100} {
    addbot $who $what
    chattr $who -p|+fdvB-omnt $chan
    setuser $who XTRA level "$why"
    setuser $who XTRA aop "No"
    setuser $who XTRA aov "No"
    setuser $who XTRA prot "No"
    setuser $who XTRA LM "$nick!$host"
    puthelp "PRIVMSG $hubchan :$nick !$hand!: $who has been added as a bot to $chan at level $why, you will need to setup a pass for it via .chpass on the partyline"
    puthelp "NOTICE $nick :Added $who to channel $chan. Level: $why  AOP: Off  Protect: Off  AOV: Off"
    putlog "($nick!$host) !$hand! addbot $who $why - $c0logo"
    notifyadduser $nick $host $hand $chan $who $why
  }
  if {$why > 24 && $why < 50} {
    addbot $who $what
    chattr $who -p|+fdB-tmnov $chan
    setuser $who XTRA level "$why"
    setuser $who XTRA aop "No"
    setuser $who XTRA aov "No"
    setuser $who XTRA prot "No"
    setuser $who XTRA LM "$nick!$host"
    puthelp "PRIVMSG $hubchan :$nick !$hand!: $who has been added as a bot to $chan at level $why, you will need to setup a pass for it via .chpass on the partyline"
    puthelp "NOTICE $nick :Added $who to channel $chan. Level: $why  AOP: Off  Protect: Off  AOV: Off"
    putlog "($nick!$host) !$hand! addbot $who $why - $c0logo"
    notifyadduser $nick $host $hand $chan $who $why
    return 0
  }
  if {$why < 25 && $why > 0} {
    addbot $who $what
    chattr $who -p|+fdB-mnotv $chan
    setuser $who XTRA level "$why"
    setuser $who XTRA aop "No"
    setuser $who XTRA aov "No"
    setuser $who XTRA prot "No"
    setuser $who XTRA LM "$nick!$host"
    puthelp "PRIVMSG $hubchan :$nick !$hand!: $who has been added as a bot to $chan at level $why, you will need to setup a pass for it via .chpass on the partyline"
    puthelp "NOTICE $nick :Added $who to channel $chan. Level: $why  AOP: Off  Protect: Off  AOV: Off"
    putlog "($nick!$host) !$hand! addbot $who $why - $c0logo"
    notifyadduser $nick $host $hand $chan $who $why
    return 0
  }
  if {$why < 1 || $why > 200 && [string tolower $hand] != [string tolower $debugsu]} {
    puthelp "NOTICE $nick :Error, valid levels are between 1 and 200"
    return 0
  }
}









################################################
################################################
########## start of privmsg commands ###########
################################################
################################################
proc msg_join {nick host hand varz} {
  set chan [lindex $varz 0]
  set xtra [lrange $varz 1 end]
  pub_join $nick $host $hand $chan $xtra
  return 0
}
proc msg_kick {nick host hand varz} {
  global mainchan
  set chan [lindex $varz 0]
  set who [lindex $varz 1]
  set reason [lrange $varz 2 end]
  if {$chan == "" || ![ischan $chan]} {
    puthelp "NOTICE $nick :Wheres the channel name!?"
    return 0
  }
  if {[string tolower $chan] != [string tolower $mainchan]} {
    puthelp "NOTICE $nick :Wrong channel buddy, try $mainchan ;)"
    return 0
  }
  pub_kick $nick $host $hand $chan "$who $reason"
  return 0
}
proc msg_msg {nick host hand varz} {
  global mainchan
  set flags [lrange $varz 0 end]
  pub_msg $nick $host $hand $mainchan $flags
  return 0
}
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
proc msg_nick {nick host hand varz} {
  global mainchan
  set flags [lrange $varz 0 end]
  pub_nick $nick $host $hand $mainchan $flags
  return 0
}
proc msg_op {nick host hand varz} {
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
  pub_op $nick $host $hand $chan $flags
  return 0
}
proc msg_part {nick host hand varz} {
  set chan [lindex $varz 0]
  set xtra [lrange $varz 1 end]
  pub_part $nick $host $hand $chan $xtra
  return 0
}
proc msg_savedb {nick host hand varz} {
  global mainchan
  pub_savedb $nick $host $hand $mainchan $varz
  return 0
}
proc msg_rehash {nick host hand varz} {
  global mainchan
  pub_rehash $nick $host $hand $mainchan "etc"
  return 0
}
proc msg_say {nick host hand varz} {
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
  pub_say $nick $host $hand $chan $flags
  return 0
}
proc msg_server {nick host hand varz} {
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
  pub_server $nick $host $hand $chan $flags
  return 0
}
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
proc msg_voice {nick host hand varz} {
  global mainchan
  set chan [lindex $varz 0]
  set who1 [lindex $varz 1]
  set who2 [lindex $varz 2]
  set who3 [lindex $varz 3]
  set who4 [lindex $varz 4]
  set who5 [lindex $varz 5]
  set who6 [lindex $varz 6]
  if {$chan == "" || ![ischan $chan]} {
    puthelp "NOTICE $nick :Wheres the channel name!?"
    return 0
  }
  if {[string tolower $chan] != [string tolower $mainchan]} {
    puthelp "NOTICE $nick :Wrong channel buddy, try $mainchan ;)"
    return 0
  }
  pub_voice $nick $host $hand $chan "$who1 $who2 $who3 $who4 $who5 $who6"
  return 0
}
proc msg_topic {nick host hand varz} {
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
  pub_topic $nick $host $hand $chan $flags
  return 0
}
proc msg_unban {nick host hand varz} {
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
  pub_unban $nick $host $hand $chan $flags
  return 0
}
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
proc msg_game {nick host hand varz} {
  global hubchan mainchan botnick
  set chan [lindex $varz 0]
  set what [lindex $varz 1]
  set why [lindex $varz 2]
  if {[string tolower $chan] != [string tolower $mainchan]} {
    return 0
  }
  chan0pinfo [string tolower $chan]
  if {[authcheck $nick $host $hand $chan] != 1} {
    return 0
  }
  if {[level $hand] < 190} {
    puthelp "NOTICE $nick :Your level of [level $hand] in $chan is less than the required level of 190 for this command"
    return 0
  }
  if {$what == ""} {
    puthelp "NOTICE $nick :Syntax: GAME <#chan> <8ball> <on|off>"
    return 0
  }
  if {[string tolower $what] != "8ball"} {
    puthelp "NOTICE $nick :Invalid request: $what"
    return 0
  }
  if {[string tolower $why] == "on"} {
    puthelp "NOTICE $nick :Setting for 'game $what' now set to on for $chan"
    pubinfoset $chan game "ON"
    return 0
  }
  if {$why == "off"} {
    puthelp "NOTICE $nick :Setting for 'game $what' now set to off for $chan"
    pubinfoset $chan game OFF
    return 0
  }
  putserv "NOTICE $nick :Bug, report to apocalypse, error code g1"
  return 0
}
proc msg_help {nick host hand varz} {
  if {[validuser $hand] == 0} {
    puthelp "NOTICE $nick :You do not have access to this bot. bot commands are of no use to you"
    return 0
  }
  puthelp "NOTICE $nick :'/msg help' files are not implemented as of yet."
  return 0
}
proc msg_identify {nick host hand varz} {
  global debugsu hubchan c0logo botnick mainchan
  set what [lindex $varz 0]
  if {[matchattr $hand +H] == 1} {
    puthelp "NOTICE $nick :Sorry, you cannot authorize while in HACK protected mode"
    return 0
  }
  if {[validuser $hand] == 1} {
    if {[passwdok $hand $what] == 1} {
      if {$nick != $hand} {
        puthelp "NOTICE $nick :Password accepted - You have been identified as $hand"
        puthelp "PRIVMSG $hubchan :WARNING: $hand identified using the nick $nick?"
        putlog "($nick@$host) !$hand! identify ******... - $c0logo"
        chattr $hand +A
        setuser $hand XTRA lasthost $host
        if {[isop $botnick $mainchan] == 0} {
          puthelp "PRIVMSG $hubchan :I cannot automode $nick !$hand! on $mainchan: I'm not opped!"
          return 0
        }
        if {[getuser $hand XTRA aop] == "Yes" && [getuser $hand XTRA aov] == "Yes"} {
            putserv "MODE $mainchan +ov $nick $nick"
            return 0
        }
        if {[getuser $hand XTRA aov] == "Yes" && [getuser $hand XTRA aop] == "No"} {
            putserv "MODE $mainchan +v $nick"
            return 0
        }
        if {[getuser $hand XTRA aov] == "No" && [getuser $hand XTRA aop] == "Yes"} {
            putserv "MODE $mainchan +o $nick"
            return 0
        }
        if {[getuser $hand XTRA aov] == "No" && [getuser $hand XTRA aop] == "No"} {
            return 0
        }
        return 0
      }
      if {$nick == $hand} {
        puthelp "NOTICE $nick :Password accepted - You have been identified as $hand"
        putlog "($nick@$host) !$hand! identify ******... - $c0logo"
        chattr $hand +A
        setuser $hand XTRA lasthost $host
        if {[isop $botnick $mainchan] == 0} {
          puthelp "PRIVMSG $hubchan :I cannot automode $nick !$hand! on $mainchan: I'm not opped!"
          return 0
        }
        if {[getuser $hand XTRA aop] == "Yes" && [getuser $hand XTRA aov] == "Yes"} {
          putserv "MODE $mainchan +ov $nick $nick"
          return 0
        }
        if {[getuser $hand XTRA aov] == "Yes" && [getuser $hand XTRA aop] == "No"} {
          putserv "MODE $mainchan +v $nick"
          return 0
        }
        if {[getuser $hand XTRA aov] == "No" && [getuser $hand XTRA aop] == "Yes"} {
          putserv "MODE $mainchan +o $nick"
          return 0
        }
        if {[getuser $hand XTRA aov] == "No" && [getuser $hand XTRA aop] == "No"} {
          return 0
        }
        return 0
      }
    }
    if {[passwdok $hand $what] == 0} {
      puthelp "NOTICE $nick :Password refused - /msg $botnick identify <pass>"
      putlog "($nick@$host) !$hand! failed identify - $c0logo"
      puthelp "PRIVMSG $hubchan :WARNING: $nick !$hand! failed identify"
      return 0
    }
  }
  if {[validuser $nick] == 0} {
      puthelp "NOTICE $nick :You do not have access to this command. /msg $botnick ident <pass>"
      putlog "($nick@$host) tryed to identify but has no access"
      puthelp "privmsg $hubchan :WARNING: $nick@$host tryed to identify with me but i have no idea who they are?!"
      return 0
  }
  puthelp "NOTICE $nick :Bug in identify. report to apocalypse. error code: [i1]
  return 0
}
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
proc msg_cleardb {nick host hand varz} {
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
  pub_cleardb $nick $host $hand $chan $flags
  return 0
}
proc msg_defaultset {nick host hand varz} {
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
  pub_defaultset $nick $host $hand $chan $flags
  return 0
}
proc msg_delbot {nick host hand varz} {
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
  pub_delbot $nick $host $hand $chan $flags
  return 0
}
proc msg_delme {nick host hand varz} {
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
  pub_delme $nick $host $hand $chan $flags
  return 0
}
proc msg_deop {nick host hand varz} {
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
  pub_deop $nick $host $hand $chan $flags
  return 0
}
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
proc msg_devoice {nick host hand varz} {
  global mainchan
  set chan [lindex $varz 0]
  set flags [lrange $varz 1 end]
  if {$chan == ""} {
    puthelp "NOTICE $nick :Wheres the channel name!?"
    return 0
  }
  if {[string tolower $chan] != [string tolower $mainchan]} {
    puthelp "NOTICE $nick :Wrong channel buddy, try $mainchan ;)"
    return 0
  }
  pub_devoice $nick $host $hand $chan $flags
}

################################################
################################################
############# start of misc procs ##############
################################################
################################################
proc rand8banswer {} {
  global 8ballpath
  set rndans 0
  set randmans [rand [getlines $8ballpath]]
  set rans [open "$8ballpath" "RDONLY"]
  while {$rndans != $randmans} {
    incr rndans 1
    if {$rndans == $randmans} {
      set randanswer [gets $rans]
      close $rans
      if {$randanswer != ""} { return "$randanswer" }
    }
    set nup [gets $rans]
  }
  if {$randanswer == ""} {
    return "ERROR :D"
  }
  return "ERROR :D~"
}
proc notifyadduser {nick host hand chan who why} {
  global owner mctelladd memoserv
  ownerinfo [string tolower $chan]
  if {$mctelladd != "yes"} {
    return 0
  }
  set output ""
  if {[wordcount $owner] > 1} {
    foreach user $owner {
      set output "$output$user"
    }
  } { set output $owner }
  puthelp "PRIVMSG $memoserv :send $output $nick!$host \[$hand\] has added $who to $chan \[level $why\]"
  return 0
}
proc notifydeluser {nick host hand chan who} {
  global owner mctelldel memoserv
  ownerinfo [string tolower $chan]
  if {$mctelldel != "yes"} {
    return 0
  }
  set output ""
  if {[wordcount $owner] > 1} {
    foreach user $owner {
      set output "$output$user"
    }
  } { set output $owner }
  puthelp "PRIVMSG $memoserv :send $output $who has been deleted from $chan by $nick!$host \[$hand\]"
  return 0
}
proc notifyset {nick host hand chan varz} {
  global owner mctellset memoserv
  set who [lindex $varz 0]
  set why [lindex $varz 1]
  set how [lindex $varz 2]
  ownerinfo [string tolower $chan]
  if {$mctellset != "yes"} {
    return 0
  }
  set output ""
  if {[wordcount $owner] > 1} {
    foreach user $owner {
      set output "$output$user"
    }
  } { set output $owner }
  if {$how == ""} { puthelp "PRIVMSG $memoserv :send $output $nick!$host changed setting $who on $chan to $why" } { puthelp "PRIVMSG $memoserv :send $output $nick!$host changed setting $who on $chan to $why at level $how" }
  return 0
}
proc isnum {text} {
  foreach char [split $text ""] {
    if {![string match \[0-9\] $char]} { return 0 }
  }
  return 1
}
# ^ thanks luster. determines if $text is a number or not

proc opnotice {chan msg} {
  foreach person [chanlist $chan] {
    if {[isop $person $chan]} {
      puthelp "NOTICE $person :$msg"
    }
  }
}
# ^ notice's all ops on a channel

proc level {user} {
  if {[validuser $user] == 0} {
    return 0
  }
  return [getuser $user XTRA level]
}
# ^ lazy way to get the access level of a person (cyborg-'s idea)

proc scanchanban {nick who chan reason} {
  foreach user [chanlist $chan] {
    if {[string match "$who" $user![getchanhost $user $chan]] == 1 || $who == $user || [string match [maskhost $who![getchanhost $who $chan]] $user![getchanhost $user $chan]] == 1} {
      putserv "KICK $chan $user :\[$nick\] $reason"
    }
  }
}
# ^ searchs for the banmask on a channel, and kicks any matchs

########################
# time conversion procs:
#
proc hours2mins {num} {
  if {$num == ""} {
    return 0
  }
  return [expr $num * 60]
}
proc mins2secs {num} {
  if {$num == ""} {
    return 0
  }
  return [expr $num * 60]
}
proc secs2mins {num} {
  if {$num == ""} {
    return 0
  }
  return [expr $num / 60]
}

proc botrehash {} {
  global hubchan nickserv_nick botnick_pass botnick c0ver chanserv
  puthelp "PRIVMSG $hubchan :Chan0P $c0ver Loaded succesfully"
  puthelp "PRIVMSG $nickserv_nick :identify $botnick_pass"
  puthelp "PRIVMSG $chanserv :op $hubchan $botnick"
}
# ^ bot rehash script. you can add extra commands here if you wish. although i experience alot of help queue lag from having these 3 in a row

###------------ misc by slann <slann@bigfoot.com> -----------###
###------------------------ time ago ------------------------###
proc timeago {lasttime} {
  set totalyear [expr [unixtime] - $lasttime]
  if {$totalyear >= 31536000} {
    set yearsfull [expr $totalyear/31536000]
    set years [expr int($yearsfull)]
    set yearssub [expr 31536000*$years]
    set totalday [expr $totalyear - $yearssub]
  }
  if {$totalyear < 31536000} {
    set totalday $totalyear
    set years 0
  }
  if {$totalday >= 86400} {
    set daysfull [expr $totalday/86400]
    set days [expr int($daysfull)]
    set dayssub [expr 86400*$days]
    set totalhour 0
  }
  if {$totalday < 86400} {
    set totalhour $totalday
    set days 0
  }
  if {$totalhour >= 3600} {
    set hoursfull [expr $totalhour/3600]
    set hours [expr int($hoursfull)]
    set hourssub [expr 3600*$hours]
    set totalmin [expr $totalhour - $hourssub]
     if {$totalhour >= 14400} { set totalmin 0 }
   }
  if {$totalhour < 3600} {
    set totalmin $totalhour
    set hours 0
  }
  if {$totalmin > 60} {
    set minsfull [expr $totalmin/60]
    set mins [expr int($minsfull)]
    set minssub [expr 60*$mins]
    set secs 0
  }
  if {$totalmin < 60} {
    set secs $totalmin
    set mins 0
  }
  if {$years < 1} {set yearstext ""} elseif {$years == 1} {set yearstext "$years year, "} {set yearstext "$years years, "}
  if {$days < 1} {set daystext ""} elseif {$days == 1} {set daystext "$days day, "} {set daystext "$days days, "}
  if {$hours < 1} {set hourstext ""} elseif {$hours == 1} {set hourstext "$hours hour, "} {set hourstext "$hours hours, "}
  if {$mins < 1} {set minstext ""} elseif {$mins == 1} {set minstext "$mins minute"} {set minstext "$mins minutes"}
  if {$secs < 1} {set secstext ""} elseif {$secs == 1} {set secstext "$secs second"} {set secstext "$secs seconds"}
  set output $yearstext$daystext$hourstext$minstext$secstext
  set output [string trimright $output ", "]
  return $output
}

proc chanidle {chan} {
  set chnidle($chan) 0
  foreach user [chanlist $chan] {
    incr chnidle($chan) [getchanidle $user $chan]
  }
  return $chnidle($chan)
}
# ^ this doesnt work yet. thought id keep it in incase i wanted to fix it. hasnt been touched since 0.3

proc mdeop {chan} {
  global botnick
  set mdeop ""
  set queuetype "putserv"
  foreach user [chanlist $chan] {
    if {[isop $user $chan] == 1 && [level $user] < 200} {
      if {$user != $botnick} {
        if {$mdeop != ""} { set mdeop "$mdeop $user" }
        if {$mdeop == ""} { set mdeop $user }
        if {[wordcount $mdeop] == 6} {
          $queuetype "MODE $chan -oooooo $mdeop"
          set mdeop ""
          if {$queuetype == "putserv"} { set queuetype "puthelp" }
          if {$queuetype == "puthelp"} { set queuetype "putserv" }
        }
      }
    }
  }
}
# ^ i wouldnt test this if i were you. mass deops usually result in opless chans

proc wordcount {string} {
  set num 0
  foreach word $string {
    incr num 1
  }
  return $num
}
# ^ un mirc scripting. this would be $gettok(%string,0,32), in other words. it does what the proc is named :)

proc authcheck {nick host hand chan} {
  global botnick
  if {[matchattr $hand +A] == 0} {
    puthelp "NOTICE $nick :You have not identified yourself: /msg $botnick identify <pass>"
    return 0
  }
  if {[matchattr $hand +S] == 1} {
    puthelp "NOTICE $nick :Your Access in $chan is currently suspended"
    return 0
  }
  if {[getuser $hand XTRA lasthost] != $host} {
    puthelp "NOTICE $nick :You have not identified yourself: /msg $botnick identify <pass>"
    return 0
  }
  return 1
}
# ^ checks auth against whether they have ID'd or not. or if they are suspended. and checks to see if the host matchs the last host they id'd under

proc sauthcheck {nick host hand chan} {
  global botnick
  if {[matchattr $hand +A] == 0} {
    puthelp "NOTICE $nick :You have not identified yourself: /msg $botnick identify <pass>"
    return 0
  }
  if {[getuser $hand XTRA lasthost] != $host} {
    puthelp "NOTICE $nick :You have not identified yourself: /msg $botnick identify <pass>"
    return 0
  }
  return 1
}
# same as above. just took out suspend checking.. used for `delme

proc ischan {string} { if {[string range $string 0 0] != "#"} { return 0 } else { return 1 } }
# ^ checks to see if the string is a channel type name. used for `join/`part

## changed from timeago proc ##
proc duration {time} {
  if {$time >= 31536000} {
    set yearsfull [expr $time/31536000]
    set years [expr int($yearsfull)]
    set yearssub [expr 31536000*$years]
    set totalday [expr $time - $yearssub]
  }
  if {$time < 31536000} {
    set totalday $time
    set years 0
  }
  if {$totalday >= 86400} {
    set daysfull [expr $totalday/86400]
    set days [expr int($daysfull)]
    set dayssub [expr 86400*$days]
    set totalhour 0
  }
  if {$totalday < 86400} {
    set totalhour $totalday
    set days 0
  }
  if {$totalhour >= 3600} {
    set hoursfull [expr $totalhour/3600]
    set hours [expr int($hoursfull)]
    set hourssub [expr 3600*$hours]
    set totalmin [expr $totalhour - $hourssub]
     if {$totalhour >= 14400} { set totalmin 0 }
   }
  if {$totalhour < 3600} {
    set totalmin $totalhour
    set hours 0
  }
  if {$totalmin > 60} {
    set minsfull [expr $totalmin/60]
    set mins [expr int($minsfull)]
    set minssub [expr 60*$mins]
    set secs [expr $totalmin - [expr [expr $totalmin / 60] * 60]]
  }
  if {$totalmin == 60} {
    set mins 1
  }
  if {$totalmin < 60} {
    set secs $totalmin
    set mins 0
  }
  if {$years < 1} {set yearstext ""} elseif {$years == 1} {set yearstext "$years year, "} {set yearstext "$years years, "}
  if {$days < 1} {set daystext ""} elseif {$days == 1} {set daystext "$days day, "} {set daystext "$days days, "}
  if {$hours < 1} {set hourstext ""} elseif {$hours == 1} {set hourstext "$hours hour, "} {set hourstext "$hours hours, "}
  if {$mins < 1} {set minstext ""} elseif {$mins == 1} {set minstext "$mins minute, "} {set minstext "$mins minutes, "}
  if {$secs < 1} {set secstext ""} elseif {$secs == 1} {set secstext "$secs second"} {set secstext "$secs seconds"}
  set output $yearstext$daystext$hourstext$minstext$secstext
  set output [string trimright $output ", "]
  return $output
}
# ^ converts unix time to years/days/hours/minutes/seconds..

## converted to tcl from my mirc script ;) ##
proc lduration {time prop} {
  if {$prop == ""} { set prop "long" }
  if {$prop == "long"} {
    if {[secs $time l] != ""} { set output [secs $time l] }
    if {[mins $time l] != ""} {
      if {[secs $time l] != ""} { set output "[mins $time l], $output" } { set output [mins $time l] }
    }
    if {[hours $time l] != ""} {
      if {$output == ""} { set output [hours $time l] } { set output "[hours $time l], $output" }
    }
    if {[days $time l] != ""} {
      if {$output == ""} { set output [days $time l] } { set output "[days $time l], $output" }
    }
    if {[weeks $time l] != ""} {
      if {$output == ""} { set output [weeks $time l] } { set output "[weeks $time l], $output" }
    }
    return $output
  }
  if {$prop == "short"} {
    return "[weeks $time s] [days $time s] [hours $time s] [mins $time s] [secs $time s]"
  }
  if {$prop == "med"} {
    return "[weeks $time m] [days $time m] [hours $time m] [mins $time m] [secs $time m]"
  }
  putlog "< Invalid format: lduration"
}
proc secs {time prop} {
  set stmp "[expr $time - [expr [expr $time / 60] * 60]]"
  if {$stmp != 0} {
    if {$stmp == 1} {
      if {$prop == "s"} { set format "s" }
      if {$prop == "m"} { set format "sec" }
      if {$prop == "l"} { set format " Second" }
      return "$stmp$format"
    }
    if {$prop == "s"} { set format "s" }
    if {$prop == "m"} { set format "secs" }
    if {$prop == "l"} { set format " Seconds" }
    return "$stmp$format"
  }
  return
}
proc mins {time prop} {
  set mtmp "[expr [expr $time / 60] - [expr [expr $time / 3600] * 60]]"
  if {$mtmp != 0} {
    if {$mtmp == 1} {
      if {$prop == "s"} { set format "m" }
      if {$prop == "m"} { set format "min" }
      if {$prop == "l"} { set format " Minute" }
      return "$mtmp$format"
    }
    if {$prop == "s"} { set format "m" }
    if {$prop == "m"} { set format "mins" }
    if {$prop == "l"} { set format " Minutes" }
    return "$mtmp$format"
  }
  return
}
proc hours {time prop} {
  set htmp "[expr [expr $time - [expr [expr $time / 86400] * 86400]] / 3600]"
  if {$htmp != 0} {
   if {$htmp == 1} {
     if {$prop == "s"} { set format "h" }
     if {$prop == "m"} { set format "hr"}
     if {$prop == "l"} { set format " Hour"}
     return "$htmp$format"
   }
   if {$prop == "s"} { set format "h" }
   if {$prop == "m"} { set format "hrs" }
   if {$prop == "l"} { set format " Hours"} 
   return "$htmp$format"
  }
  return
}
proc days {time prop} {
  set dtmp "[expr [expr $time - [expr [expr $time / 604800] * 604800]] / 86400]"
  if {$dtmp != 0} {
    if {$dtmp == 1} {
      if {$prop == "s"} { set format "d" }
      if {$prop == "m"} { set format "day" }
      if {$prop == "l"} { set format " Day" }
      return "$dtmp$format"
    }
    if {$prop == "s"} { set format "d"}
    if {$prop == "m"} { set format "days" }
    if {$prop == "l"} { set format " Days" }
    return "$dtmp$format"
  }
  return
}
proc weeks {time prop} {
  set wtmp "[expr $time / 604800]"
  if {$wtmp != 0} {
    if {$wtmp == 1} {
      if {$prop == "s"} { set format "w" }
      if {$prop == "m"} { set format "wk" }
      if {$prop == "l"} { set format " Week" }
      return "$wtmp$format"
    }
    if {$prop == "s"} { set format "w" }
    if {$prop == "m"} { set format "wks" }
    if {$prop == "l"} { set format " Weeks" }
    return "$wtmp$format"
  }
  return
}
# more accurate version of the duration proc. returns total time from weeks to seconds. unlike duration. it returns the full string

proc botuptime {} {
  global uptime
  return [lduration [expr [unixtime] - $uptime] long]
}
# returns uptime of the bot

proc getlines {file} {
  set lines [open "$file" "RDONLY"]
  set num 0
  set line "NULL"
  while {$line != ""} {
    incr num 1
    set line [gets $lines]
  }
  return $num
}
# returns the number of lines from a file. like $lines(file) in mirc

proc pubreport {} {
  global hubchan timezone botnick version c0ver
  set boxuptime [lrange [exec /usr/bin/uptime]
  puthelp "PRIVMSG $hubchan :*** REPORT - [ctime [unixtime]] $timezone"
  puthelp "PRIVMSG $hubchan :Online   : [getchanhost $botnick $hubchan]     Uplink  : $server"
  puthelp "PRIVMSG $hubchan :Online   : [botonline]
  puthelp "PRIVMSG $hubchan :Version  : Eggdrop $version running on [unames], Chan0P $c0ver"
  puthelp "PRIVMSG $hubchan :Database : [wordcount [userlist *]] Entrys, [userlist f] users, [userlist b] bots, [userlist &K] bans"
  puthelp "PRIVMSG $hubchan :*** END OF REPORT"
}
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
          puthelp "NOTICE $nick :[getuser $user XTRA suspend]"
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
          puthelp "NOTICE $nick :[getuser $user XTRA suspend]"
        }
      }
    }
    puthelp "NOTICE $nick :*** End of List ***"
    return 0
  }
  if {$bots} { 
    if {[checkbots $who $chan] == 0 && [validuser $who] == 0} {
      puthelp "NOTICE $nick :There were no matches for your selected criteria"
      return 0
    }
    puthelp "NOTICE $nick :*** $chan Bot Database \[\Match: $who Min: $min   Max: $max\]\ ***"
    puthelp "NOTICE $nick :      BotNick           Level  AOP   AOV  Prot"
    set num 0
    foreach user [userlist b] {
      incr num
      if {[string match [string tolower $who] [string tolower $user]] == 1 && [getuser $user XTRA level] >= $min && [getuser $user XTRA level] <= $max && [matchchanattr $user &B $mainchan] == 1} {
        puthelp "NOTICE $nick :[access_align $num $user [getuser $user XTRA level] [getuser $user XTRA aop] [getuser $user XTRA aov] [getuser $user XTRA prot]]"
        if {[matchattr $user +S]} {
          puthelp "NOTICE $nick :[getuser $user XTRA suspend]"
        }
        if {$ls} {
          puthelp "NOTICE $nick :  LS  [timeago [lindex [getuser $user LASTON] 0]] ago"
        }
        if {$lm} {
          puthelp "NOTICE $nick :  LM  [getuser $user XTRA LM]"
        }
        if {$uh} {
          puthelp "NOTICE $nick :  UserHost: [getuser $user XTRA lasthost]"
        }
      }
    }
    unset num
    puthelp "NOTICE $nick :*** End of List ***"
    return 0
  }
  if {[checkwho $who $chan] == 0 && [validuser $who] == 0} {
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
        puthelp "NOTICE $nick :[getuser $user XTRA suspend]"
      }
      if {$ls} {
        puthelp "NOTICE $nick :  LS  [timeago [lindex [getuser $user LASTON] 0]] ago"
      }
      if {$lm} {
        puthelp "NOTICE $nick :  LM  [getuser $user XTRA LM]"
      }
      if {$uh} {
        puthelp "NOTICE $nick :  UserHost: [getuser $user XTRA lasthost]"
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
    if {[string match [string tolower $string] [string tolower $user]] == 1 && [matchchanattr $user &B $mainchan]} {
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
   return "$aan$aaw$aal$aao$aav$aap"
}
proc axsflag {flag} {
  set flag [string tolower $flag]
  if {$flag == "-bots" || $flag == "-check" || $flag == "-ls" || $flag == "-lm" || $flag == "-max" || $flag == "-min" || $flag == "-userhost"} { return 1 }
  return 0
}

proc ban2hand {who} {
  foreach ban [userlist &K] {
    if {$who == $ban} {
      return "[getuser $ban XTRA realnick]"
    }
  }
  return 0
}
proc hand2ban {who} {
  foreach ban [userlist &K] {
    if {$who == [getuser $ban XTRA realnick]} {
      return $ban
    }
  }
}
proc bhand2host {who} {
  foreach ban [userlist &K] {
    if {$who == [getuser $ban XTRA realnick]} {
      return [getuser $ban XTRA banhost]
    }
  }
}
proc ban2host {who} {
  foreach ban [userlist &K] {
    if {$who == $ban} {
      return [getuser $ban XTRA banhost]
    }
  }
}
proc host2ban {who} {
  foreach ban [userlist &K] {
    if {$who == [getuser $ban XTRA banhost]} {
      return $ban
    }
  }
}
proc all2ban {who} {
  foreach ban [userlist &K] {
    if {$who == [getuser $ban XTRA banhost] || $who == [getuser $ban XTRA realnick]} {
      return $ban
    }
  }
}

proc gettopic {chan} {
  global mainchan datapath
  set chan [string tolower $chan]
  set topic [open "$datapath$mainchan.topic" "RDONLY CREAT"]
  set chantopic "[gets $topic]"
  close $topic
  if {$chantopic == ""} {
    return ""
  }
  if {$chantopic != ""} {
    return $chantopic
  }
}

proc curtopic {chan} {
  set curtopic [topic $chan]
  set settopic [gettopic $chan]
  if {$curtopic != "" && $settopic == ""} {
    putserv "TOPIC $chan :to set a topic. type `topic <topic>"
    return 0
  }
  if {$curtopic != "" && $curtopic != $settopic} {
    set topic [open "$datapath$mainchan.topic" "WRONLY CREAT"]
    puts $topic $what
    close $topic
    return 0
  }
}
proc randtopic {} {
  global topicstxtpath
  set randtopic "bleh"
  set rndtpc 0
  set randmtpc [rand [getlines $topicstxtpath]]
  set rtpc [open "$topicstxtpath" "RDWR"]
  while {$rndtpc != $randmtpc} {
    incr rndtpc 1
    if {$rndtpc == $randmtpc} {
      set randtopic [gets $rtpc]
      return "$randtopic"
    }
    set nup [gets $rtpc]
  }
  if {$randtopic == ""} {
    return "ERROR :D"
  }
  return "something is wrong :|"
}
proc suspend {nick host who chan time reason} {
  global suspend suspendtime
  if {[onchan $who $chan]} {
    set whoh [nick2hand $who $chan]
    set who [hand2nick $whoh $chan]
  } else {
    set who $who
    set whoh $who
  }
  if {[validuser $who] == 0 && [validuser $whoh]} {
    putserv "PRIVMSG $nick :error code: (susp01)"
    return 0
  }
  chattr $whoh +S
  setuser $whoh XTRA suspendtime $time
  setuser $whoh XTRA suspenddata [timer $time "unsuspend $nick $host $who"]
  if {[isop $who $chan]} {
    putserv "MODE $chan -o $who"
  }
  setuser $whoh XTRA suspend "Suspend Expires: [duration $time]"
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
  killtimer [getuser $who XTRA suspenddata] 
  setuser $who XTRA suspend ""
  setuser $who XTRA suspendreason ""
  setuser $whoh XTRA suspenddata
  return 0
}
proc seekonline {nick chan} {
  global seek_online
  puthelp "ISON [userlist f]"
  puthelp "NOTICE $nick :Online people from $chan"
  if {$seek_online == "-noone"} {
    puthelp "NOTICE $nick :no one is currently online"
  }
  if {$seek_online != "-noone"} {
    if {[wordcount $seek_online] < 8} {
      puthelp "NOTICE $nick :[seekalg $seek_online]"
    } else {
      set cntseek 8
      set cntseeks 0
      while {[wordcount $seek_online] < $cntseek} {
        puthelp "NOTICE $nick :[seekalg [lrange $seek_online $cntseeks [expr $cntseek - 1]]]"
        if {[expr [wordcount $seek_online] + 8] > $cntseek} {
          set cntseek [wordcount $seek_online]
        } else {
          incr cntseek 8
        }
        incr cntseeks 8
      }
    }
  }
  if {$seek_online != "-noone"} { puthelp "NOTICE $nick :Completed: [wordcount $seek_online] people online" }
  return 0
}
proc seekalg {string} {
  if {$string == ""} { return "-noone" }
  foreach user $string {
    set result "$user  -  "
  }
  return $result
}
proc chanlimnum {chan} {
  set num 0
  foreach user [chanlist $chan] {
    incr num 1
  }
  return [expr $num + 1]
}

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

proc banexpire {time created} {
  if {$time == "Never"} { return "Never" }
  return [lduration [expr $time - [expr [unixtime] - $created]] short]
}

proc randoper {} {
  global ircopers
  set temppp [rand [wordcount $ircopers]]
  set num 0
  foreach randoper $ircopers {
    incr num 1
    if {$temppp == $num} { return $randoper }
  } 
  return RogerY
}

proc bonkmsg {who} {
  set temppp [rand 10]
  if {$temppp == 0} { return "very bonkable.." }
  if {$temppp == 1} { return "are you kiddin? look at em!" }
  if {$temppp == 2} { return "get fucked cunt, i aint fuckin that hairy mole" }
  if {$temppp == 3} { return "warez channels are usually 90%+ guys.. if not more. so fuck you, i aint fuckn a guy" }
  if {$temppp == 4} { return "fuck you cunt, i aint in the mood" }
  if {$temppp == 5} { return "im a fuckn channel bot, not a hooker. you fuck em'" }
  if {$temppp == 6} { return "fuck that. you root em" }
  if {$temppp == 7} { return "yeah! for sure!" }
  if {$temppp == 8} { return "maybe later" }
  if {$temppp == 9} { return "is that a girl or a guy? :|" }
  if {$temppp == 10} { return "who wouldnt" }
  return "i dunno. they look pretty ugly from ere. maybe if i get tanked it'd be ok"
}
proc ownernotc {nick chan} {
  global mcmustid mcoprestrict mctelladd mctelldel mctellset mcfunmsg mcrestrict mcnonote
  ownerinfo [string tolower $chan]
  if {$mcmustid == "no" && $mcoprestrict == "no" && $mctelladd == "no" && $mctelldel == "no" && $mctellset == "no" && $mcfunmsg == "no" && $mcrestrict == 0} {
    return 0
  }
  if {$mcmustid == "yes"} { set result "Must ID," }
  if {$mcoprestrict == "yes"} { set result "$result Op Restrict," }
  if {$mctelladd == "yes"} { set result "$result Notify Adduser," }
  if {$mctelldel == "yes"} { set result "$result Notify Deluser," }
  if {$mctellset == "yes"} { set result "$result Notify Set," }
  if {$mcfunmsg == "yes"} { set result "$result Fun Messages," }
  if {$mcrestrict > 0} { set result "$result Restricted to level $mcrestrict" }
  set result [string trimright $result ", "]
  puthelp "NOTICE $nick :Owner Settings  : $result"
  return 0
}

proc nfomngrseen {cown chan} {
  if {[validuser $cown] == 0} {
    return "Never"
  }
  if {[handonchan $cown $chan]} {
    return "Online now, logged on [timeago [lindex [getuser $cown LASTON] 0]] ago"
  }
  return "last seen [timeago [lindex [getuser $cown LASTON] 0]] ago"
}
proc pubinforehash {chan} {
  set chan [string tolower $chan]
  global mchash mcowner mcemail mcurl mcmode mcmodelock mckeeptopic mccreated mcgame mcbanquota mcquota mcbotquota datapath
  set pubinfo [open "$datapath$chan.info" "RDONLY CREAT"]
  set mchash [gets $pubinfo]
  set mcowner [gets $pubinfo]
  set mcemail [gets $pubinfo]
  set mcurl [gets $pubinfo]
  set mcmode [gets $pubinfo]
  set mcmodelock [gets $pubinfo]
  set mckeeptopic [gets $pubinfo]
  set mccreated [gets $pubinfo]
  set mcgame [gets $pubinfo]
  set mcquota [gets $pubinfo]
  set mcbotquota [gets $pubinfo]
  set mcbanquota [gets $pubinfo]
}

proc pubinfoset {chan what varz} {
  set chan [string tolower $chan]
  global mchash mcowner mcemail mcurl mcmode mcmodelock mckeeptopic mccreated mcgame mcquota mcbotquota mcbanquota datapath
  set what [string tolower $what]
  set who [lindex $varz 0]
  chan0pinfo $chan
  if {$what == "hash"} {
    set mchash $who
    set pubinfo [open "$datapath$chan.info" "WRONLY CREAT"]
    puts $pubinfo $who
    puts $pubinfo $mcowner
    puts $pubinfo $mcemail
    puts $pubinfo $mcurl
    puts $pubinfo $mcmode
    puts $pubinfo $mcmodelock
    puts $pubinfo $mckeeptopic
    puts $pubinfo $mccreated
    puts $pubinfo $mcgame
    puts $pubinfo $mcquota
    puts $pubinfo $mcbotquota
    puts $pubinfo $mcbanquota
    close $pubinfo
    return 0
  }
  if {$what == "owner"} {
    set mcowner $who
    set pubinfo [open "$datapath$chan.info" "WRONLY CREAT"]
    puts $pubinfo $mchash
    puts $pubinfo $who
    puts $pubinfo $mcemail
    puts $pubinfo $mcurl
    puts $pubinfo $mcmode
    puts $pubinfo $mcmodelock
    puts $pubinfo $mckeeptopic
    puts $pubinfo $mccreated
    puts $pubinfo $mcgame
    puts $pubinfo $mcquota
    puts $pubinfo $mcbotquota
    puts $pubinfo $mcbanquota
    close $pubinfo
    return 0
  }
  if {$what == "email"} {
    set mcemail $who
    set pubinfo [open "$datapath$chan.info" "WRONLY CREAT"]
    puts $pubinfo $mchash
    puts $pubinfo $mcowner
    puts $pubinfo $who
    puts $pubinfo $mcurl
    puts $pubinfo $mcmode
    puts $pubinfo $mcmodelock
    puts $pubinfo $mckeeptopic
    puts $pubinfo $mccreated
    puts $pubinfo $mcgame
    puts $pubinfo $mcquota
    puts $pubinfo $mcbotquota
    puts $pubinfo $mcbanquota
    close $pubinfo
    return 0
  }
  if {$what == "url"} {
    set mcurl $who
    set pubinfo [open "$datapath$chan.info" "WRONLY CREAT"]
    puts $pubinfo $mchash
    puts $pubinfo $mcowner
    puts $pubinfo $mcemail
    puts $pubinfo $who
    puts $pubinfo $mcmode
    puts $pubinfo $mcmodelock
    puts $pubinfo $mckeeptopic
    puts $pubinfo $mccreated
    puts $pubinfo $mcgame
    puts $pubinfo $mcquota
    puts $pubinfo $mcbotquota
    puts $pubinfo $mcbanquota
    close $pubinfo
    return 0
  }
  if {$what == "mode"} {
    set mcmode $who
    set pubinfo [open "$datapath$chan.info" "WRONLY CREAT"]
    puts $pubinfo $mchash
    puts $pubinfo $mcowner
    puts $pubinfo $mcemail
    puts $pubinfo $mcurl
    puts $pubinfo $who
    puts $pubinfo $mcmodelock
    puts $pubinfo $mckeeptopic
    puts $pubinfo $mccreated
    puts $pubinfo $mcgame
    puts $pubinfo $mcquota
    puts $pubinfo $mcbotquota
    puts $pubinfo $mcbanquota
    close $pubinfo
    return 0
  }
  if {$what == "modelock"} {
    set mcmodelock $who
    set pubinfo [open "$datapath$chan.info" "WRONLY CREAT"]
    puts $pubinfo $mchash
    puts $pubinfo $mcowner
    puts $pubinfo $mcemail
    puts $pubinfo $mcurl
    puts $pubinfo $mcmode
    puts $pubinfo $who
    puts $pubinfo $mckeeptopic
    puts $pubinfo $mccreated
    puts $pubinfo $mcgame
    puts $pubinfo $mcquota
    puts $pubinfo $mcbotquota
    puts $pubinfo $mcbanquota
    close $pubinfo
    return 0
  }
  if {$what == "keeptopic"} {
    set mckeeptopic $who
    set pubinfo [open "$datapath$chan.info" "WRONLY CREAT"]
    puts $pubinfo $mchash
    puts $pubinfo $mcowner
    puts $pubinfo $mcemail
    puts $pubinfo $mcurl
    puts $pubinfo $mcmode
    puts $pubinfo $mcmodelock
    puts $pubinfo $who
    puts $pubinfo $mccreated
    puts $pubinfo $mcgame
    puts $pubinfo $mcquota
    puts $pubinfo $mcbotquota
    puts $pubinfo $mcbanquota
    close $pubinfo
    return 0
  }
  if {$what == "created"} {
    set mccreated $who
    set pubinfo [open "$datapath$chan.info" "WRONLY CREAT"]
    puts $pubinfo $mchash
    puts $pubinfo $mcowner
    puts $pubinfo $mcemail
    puts $pubinfo $mcurl
    puts $pubinfo $mcmode
    puts $pubinfo $mcmodelock
    puts $pubinfo $mckeeptopic
    puts $pubinfo $who
    puts $pubinfo $mcgame
    puts $pubinfo $mcquota
    puts $pubinfo $mcbotquota
    puts $pubinfo $mcbanquota
    close $pubinfo
    return 0
  }
  if {$what == "game"} {
    set mcgame $who
    set pubinfo [open "$datapath$chan.info" "WRONLY CREAT"]
    puts $pubinfo $mchash
    puts $pubinfo $mcowner
    puts $pubinfo $mcemail
    puts $pubinfo $mcurl
    puts $pubinfo $mcmode
    puts $pubinfo $mcmodelock
    puts $pubinfo $mckeeptopic
    puts $pubinfo $mccreated
    puts $pubinfo $who
    puts $pubinfo $mcquota
    puts $pubinfo $mcbotquota
    puts $pubinfo $mcbanquota
    close $pubinfo
    return 0
  }
  if {$what == "quota"} {
    set mcquota $who
    set pubinfo [open "$datapath$chan.info" "WRONLY CREAT"]
    puts $pubinfo $mchash
    puts $pubinfo $mcowner
    puts $pubinfo $mcemail
    puts $pubinfo $mcurl
    puts $pubinfo $mcmode
    puts $pubinfo $mcmodelock
    puts $pubinfo $mckeeptopic
    puts $pubinfo $mccreated
    puts $pubinfo $mcgame
    puts $pubinfo $who
    puts $pubinfo $mcbotquota
    puts $pubinfo $mcbanquota
    close $pubinfo
    return 0
  }
  if {$what == "botquota"} {
    set mcbotquota $who
    set pubinfo [open "$datapath$chan.info" "WRONLY CREAT"]
    puts $pubinfo $mchash
    puts $pubinfo $mcowner
    puts $pubinfo $mcemail
    puts $pubinfo $mcurl
    puts $pubinfo $mcmode
    puts $pubinfo $mcmodelock
    puts $pubinfo $mckeeptopic
    puts $pubinfo $mccreated
    puts $pubinfo $mcgame
    puts $pubinfo $mcquota
    puts $pubinfo $who
    puts $pubinfo $mcbanquota
    close $pubinfo
    return 0
  }
  if {$what == "banquota"} {
    set mcbanquota $who
    set pubinfo [open "$datapath$chan.info" "WRONLY CREAT"]
    puts $pubinfo $mchash
    puts $pubinfo $mcowner
    puts $pubinfo $mcemail
    puts $pubinfo $mcurl
    puts $pubinfo $mcmode
    puts $pubinfo $mcmodelock
    puts $pubinfo $mckeeptopic
    puts $pubinfo $mccreated
    puts $pubinfo $mcgame
    puts $pubinfo $mcquota
    puts $pubinfo $mcbotquota
    puts $pubinfo $who
    close $pubinfo
    return 0
  }

  return "Error: incorrect syntax"
}

proc chan0pinfo {chan} {
  set chan [string tolower $chan]
  global mchash mcowner mcemail mcurl mcmode mcmodelock mckeeptopic mccreated mcgame mcquota mcbotquota mcbanquota datapath
  set pubinfo [open "$datapath$chan.info" "RDONLY CREAT"]
  set mchash [gets $pubinfo]
  set mcowner [gets $pubinfo]
  set mcemail [gets $pubinfo]
  set mcurl [gets $pubinfo]
  set mcmode [gets $pubinfo]
  set mcmodelock [gets $pubinfo]
  set mckeeptopic [gets $pubinfo]
  set mccreated [gets $pubinfo]
  set mcgame [gets $pubinfo]
  set mcquota [gets $pubinfo]
  set mcbotquota [gets $pubinfo]
  set mcbanquota [gets $pubinfo]
  close $pubinfo
}
proc ownerinfo {chan} {
  set chan [string tolower $chan]
  global mcmustid mcoprestrict mctelladd mctelldel mctellset mcfunmsg mcrestrict mcnonote datapath
  set pubownset [open "$datapath$chan.ownerset" "RDONLY CREAT"]
  set mcmustid [gets $pubownset]
  set mcoprestrict [gets $pubownset]
  set mctelladd [gets $pubownset]
  set mctelldel [gets $pubownset]
  set mctellset [gets $pubownset]
  set mcfunmsg [gets $pubownset]
  set mcrestrict [gets $pubownset]
  set mcnonote [gets $pubownset]
  close $pubownset
}
proc pubownerset {chan what varz} {
  set chan [string tolower $chan]
  global mcmustid mcoprestrict mctelladd mctelldel mctellset mcfunmsg mcrestrict mcnonote
  set what [string tolower $what]
  set who [lindex $varz 0]
  ownerinfo $chan
  if {$what == "mustid"} {
    set mcmustid $who
    set pubownset [open "$datapath$chan.ownerset" "WRONLY CREAT"]
    puts $pubownset $who
    puts $pubownset $mcoprestrict
    puts $pubownset $mctelladd
    puts $pubownset $mctelldel
    puts $pubownset $mctellset
    puts $pubownset $mcfunmsg
    puts $pubownset $mcrestrict
    puts $pubownset $mcnonote
    close $pubownset
    return 0
  }
  if {$what == "oprestrict"} {
    set mcoprestrict $who
    set pubownset [open "$datapath$chan.ownerset" "WRONLY CREAT"]
    puts $pubownset $mcmustid
    puts $pubownset $who
    puts $pubownset $mctelladd
    puts $pubownset $mctelldel
    puts $pubownset $mctellset
    puts $pubownset $mcfunmsg
    puts $pubownset $mcrestrict
    puts $pubownset $mcnonote
    close $pubownset
    return 0
  }
  if {$what == "telladd"} {
    set mctelladd $who
    set pubownset [open "$datapath$chan.ownerset" "WRONLY CREAT"]
    puts $pubownset $mcmustid
    puts $pubownset $mcoprestrict
    puts $pubownset $who
    puts $pubownset $mctelldel
    puts $pubownset $mctellset
    puts $pubownset $mcfunmsg
    puts $pubownset $mcrestrict
    puts $pubownset $mcnonote
    close $pubownset
    return 0
  }
  if {$what == "telldel"} {
    set mctelldel $who
    set pubownset [open "$datapath$chan.ownerset" "WRONLY CREAT"]
    puts $pubownset $mcmustid
    puts $pubownset $mcoprestrict
    puts $pubownset $mctelladd
    puts $pubownset $who
    puts $pubownset $mctellset
    puts $pubownset $mcfunmsg
    puts $pubownset $mcrestrict
    puts $pubownset $mcnonote
    close $pubownset
    return 0
  }
  if {$what == "tellset"} {
    set mctellset $who
    set pubownset [open "$datapath$chan.ownerset" "WRONLY CREAT"]
    puts $pubownset $mcmustid
    puts $pubownset $mcoprestrict
    puts $pubownset $mctelladd
    puts $pubownset $mctelldel
    puts $pubownset $who
    puts $pubownset $mcfunmsg
    puts $pubownset $mcrestrict
    puts $pubownset $mcnonote
    close $pubownset
    return 0
  }
  if {$what == "funmsg"} {
    set mcfunmsg $who
    set pubownset [open "$datapath$chan.ownerset" "WRONLY CREAT"]
    puts $pubownset $mcmustid
    puts $pubownset $mcoprestrict
    puts $pubownset $mctelladd
    puts $pubownset $mctelldel
    puts $pubownset $mctellset
    puts $pubownset $who
    puts $pubownset $mcrestrict
    puts $pubownset $mcnonote
    close $pubownset
    return 0
  }
  if {$what == "restrict"} {
    set mcrestrict $who
    set pubownset [open "$datapath$chan.ownerset" "WRONLY CREAT"]
    puts $pubownset $mcmustid
    puts $pubownset $mcoprestrict
    puts $pubownset $mctelladd
    puts $pubownset $mctelldel
    puts $pubownset $mctellset
    puts $pubownset $mcfunmsg
    puts $pubownset $who
    puts $pubownset $mcnonote
    close $pubownset
    return 0
  }
  if {$what == "nonote"} {
    set mcnonote $who
    set pubownset [open "$datapath$chan.ownerset" "WRONLY CREAT"]
    puts $pubownset $mcmustid
    puts $pubownset $mcoprestrict
    puts $pubownset $mctelladd
    puts $pubownset $mctelldel
    puts $pubownset $mctellset
    puts $pubownset $mcfunmsg
    puts $pubownset $mcrestrict
    puts $pubownset $who
    close $pubownset
    return 0
  }
  return "Error: incorrect syntax"
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
      puthelp "PRIVMSG $hubchan :$nick tryed to ban me on $chan. auto-suspending.."
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

################################################
################################################
### start of mode/prot stuff (join/kick/etc) ###
################################################
################################################
proc quit_deauth {nick host hand chan varz} {
  global hubchan mainchan botnick
  if {[string tolower $chan] != [string tolower $mainchan]} {
    return 0
  }
  if {[getuser $hand XTRA lasthost] == $host} {
    if {[matchattr $hand +B] == 1} {
      return 0
    }
    if {[matchattr $hand +H] == 1} {
      chattr $hand -H
    }
    puthelp "PRIVMSG $hubchan :$nick !$hand! has quit. De-Authorizing.."
    chattr $hand -A
    setuser $hand XTRA userhost [getuser $hand XTRA lasthost]
    setuser $hand XTRA lasthost "ident@host"
    return 0
  }
}
proc part_deauth {nick host hand chan} {
  global hubchan mainchan
  if {[string tolower $chan] != [string tolower $mainchan]} {
    return 0
  }
  if {[matchattr $hand +B] == 1} {
    return 0
  }
  if {[getuser $hand XTRA lasthost] == $host} {
    if {[matchattr $hand +H] == 1} {
      chattr $hand -H
    }
    chattr $hand -A
    return 0
  }
}

proc join_askauth {nick host hand chan} {
  global botnick mainchan hubchan mcmustid
  if {[string tolower $chan] != [string tolower $mainchan]} {
    return 0
  }
  ownerinfo [string tolower $chan]
  if {[matchattr $hand +B] == 0} {
    if {$mcmustid != "yes"} {
      if {[getuser $hand XTRA aop] == "Yes" && [getuser $hand XTRA aov] == "Yes" && [level $hand] > 99} {
        putserv "MODE $mainchan +ov $nick $nick"
        return 0
      }
      if {[getuser $hand XTRA aov] == "Yes" && [getuser $hand XTRA aop] == "No"} {
        putserv "MODE $mainchan +v $nick"
        return 0
      }
      if {[getuser $hand XTRA aov] == "No" && [getuser $hand XTRA aop] == "Yes" && [level $hand] > 99} {
        putserv "MODE $mainchan +o $nick"
        return 0
      }
      if {[getuser $hand XTRA aov] == "No" && [getuser $hand XTRA aop] == "No"} {
        return 0
      }
      return 0
    }
    if {[getuser $hand XTRA lasthost] == $host} {
      puthelp "PRIVMSG $hubchan :$nick's host has not changed, keeping auth on $hand"
      chattr $hand +A
      if {[getuser $hand XTRA aop] == "Yes" && [getuser $hand XTRA aov] == "Yes"} {
        putserv "MODE $mainchan +ov $nick $nick"
        return 0
      }
      if {[getuser $hand XTRA aov] == "Yes" && [getuser $hand XTRA aop] == "No"} {
        putserv "MODE $mainchan +v $nick"
        return 0
      }
      if {[getuser $hand XTRA aov] == "No" && [getuser $hand XTRA aop] == "Yes"} {
        putserv "MODE $mainchan +o $nick"
        return 0
      }
      if {[getuser $hand XTRA aov] == "No" && [getuser $hand XTRA aop] == "No"} {
        return 0
      }
      return 0
    }
    if {[matchattr $hand +A] == 1 && [getuser $hand XTRA lasthost] != $host} {
      puthelp "NOTICE $nick :You need to authenticate your identity, please /msg $botnick identify <pass>"
      return 0
    }
    puthelp "NOTICE $nick :You need to authenticate your identity, please /msg $botnick identify <pass>"
    return 0
  }
  if {[matchattr $hand +B] == 1 && [matchattr $hand +a] == 1 && [matchattr $hand +o] == 1} {
    pushmode $chan +o $nick
    return 0
  }
}
proc join_kban {nick host hand chan} {
  global mainchan
  if {[string tolower $chan] != [string tolower $mainchan]} {
    return 0
  }
  putserv "MODE $chan +b [getuser $hand XTRA banhost] "
  putserv "KICK $chan $nick :[getuser $hand XTRA breason]"
}
proc mainchan_mode_prot {nick uhost hand chan varz} {
  global hubchan botnick mainchan suspend suspendtime chanserv
  if {[string tolower $chan] != [string tolower $mainchan]} {
    return 0
  }
  set what [lindex $varz 0]
  set who [lindex $varz 1]
  set who2 [lindex $varz 2]
  set who3 [lindex $varz 3]
  set who4 [lindex $varz 4]
  set who5 [lindex $varz 5]
  set who6 [lindex $varz 6]
  if {$what == "-o"} {
    if {$nick == $botnick} {
      return 0
    }
    if {$nick == $chanserv} {
      return 0
    }
    if {$who == $botnick} {
      suspend "$botnick [getchanhost $botnick $mainchan] $hand $chan 60"
      putserv "PRIVMSG $hubchan :$nick has deoped me on $mainchan, auto-suspending for 1 hour"
      return 0
    }
    if {$who != $botnick} {
      if {[matchattr $who +P] == 1} {
        putserv "KICK $chan $nick :$who is a protected member of $chan, you are suspended for 1 hour"
        puthelp "PRIVMSG $hubchan :$nick deoped $who on $chan, auto-suspending for 1 hour"
        suspend "$botnick [getchanhost $botnick $mainchan] $hand $chan 60"
        return 0
      }
      if {[getuser [nick2hand $who $chan] XTRA prot] == "Yes"} {
        if {[getuser [nick2hand $who $chan] XTRA level] > [getuser $hand XTRA level]} {
          if {[isop $botnick $chan] == 0} {
            puthelp "PRIVMSG $hubchan :I can't protect $who from $chan: I'm not opped!"
            return 0
          }
          if {[isop $botnick $chan] == 1} {
            putserv "MODE $chan +o $who"
            putserv "MODE $chan -o $nick"
            puthelp "PRIVMSG $hubchan :$nick deoped $who on $chan! Reversing"
          }
        }
      }
    }
  }
  if {$what == "+o" || $what == "+oo" || $what == "+ooo" || $what == "+oooo" || $what == "+ooooo" || $what == "+oooooo"} {
    global mcoprestrict
    ownerinfo [string tolower $chan]
    if {$mcoprestrict != "yes"} {
      return 0
    }
    if {$who == $botnick || $nick == $botnick} {
      return 0
    }
    if {$nick == $chanserv} {
      return 0
    }
    if {![botisop $chan]} {
      return 0
    }
    if {[matchattr $who +S]} {
      pushmode $chan -o $who
      putserv "KICK $chan $who :You are suspended and not allowed to be oped here"
    }
    if {[matchattr $who2 +S]} {
      pushmode $chan -o $who2
      putserv "KICK $chan $who2 :You are suspended and not allowed to be oped here"
    }
    if {[matchattr $who3 +S]} {
      pushmode $chan -o $who3
      putserv "KICK $chan $who3 :You are suspended and not allowed to be oped here"
    }
    if {[matchattr $who4 +S]} {
      pushmode $chan -o $who4
      putserv "KICK $chan $who4 :You are suspended and not allowed to be oped here"
    }
    if {[matchattr $who5 +S]} {
      pushmode $chan -o $who5
      putserv "KICK $chan $who5 :You are suspended and not allowed to be oped here"
    }
    if {[matchattr $who6 +S]} {
      pushmode $chan -o $who6
      putserv "KICK $chan $who6 :You are suspended and not allowed to be oped here"
    }
    if {[matchattr $who +H] == 1} {
      pushmode $chan -o $who
      puthelp "NOTICE $who :You cannot be oped while in +H mode"
    }
    if {[matchattr $who2 +H] == 1} {
      pushmode $chan -o $who2
      puthelp "NOTICE $who2 :You cannot be oped while in +H mode"
    }
    if {[matchattr $who3 +H] == 1} {
      pushmode $chan -o $who3
      puthelp "NOTICE $who3 :You cannot be oped while in +H mode"
    }
    if {[matchattr $who4 +H] == 1} {
      pushmode $chan -o $who4
      puthelp "NOTICE $who4 :You cannot be oped while in +H mode"
    }
    if {[matchattr $who5 +H] == 1} {
      pushmode $chan -o $who5
      puthelp "NOTICE $who5 :You cannot be oped while in +H mode"
    }
    if {[matchattr $who6 +H] == 1} {
      pushmode $chan -o $who6
      puthelp "NOTICE $who6 :You cannot be oped while in +H mode"
    }

    puthelp "NOTICE $nick :Cannot op anyone while in Op-Restrict. please use `op to op people"
    putserv "MODE $chan -oooooo $who $who2 $who3 $who4 $who5 $who6"
    return 0
  }
}



proc kick_prot {nick uhost hand chan targ varz} {
  global c0logo hubchan botnick mainchan chanserv
  if {[string tolower $chan] != [string tolower $mainchan]} {
    return 0    
  }
  if {[validuser $targ] == 1} {
    if {[matchattr $targ +H] == 1} {
      return 0
    }
    if {$nick == $chanserv} {
      return 0
    }
    if {[matchattr $targ +P] == 1} {
      puthelp "KICK $chan $nick :$targ is a protected channel member, you are suspended for 1 hour"
      suspend "$botnick [getchanhost $botnick $mainchan] $hand $chan 60"
      puthelp "PRIVMSG $hubchan :$nick kicked $targ when $targ is a protected bot? Auto Suspending.."
      return 0
    }
    if {[getuser $targ XTRA prot] == "Yes"} {
      if {[getuser $targ XTRA level] > [getuser $hand XTRA level]} {
        if {[isop $botnick $chan] == 0} {
          puthelp "PRIVMSG $hubchan :I can't protect $targ from $chan: I'm not opped! (suspending anyway)"
          suspend "$botnick [getchanhost $botnick $mainchan] $hand $chan 60"
          return 0
        }
        if {[nick2hand $targ $chan] == $targ} {
          puthelp "KICK $chan $nick :$targ is a protected channel member, you are suspended for 10 minutes"
          puthelp "PRIVMSG $hubchan :$nick kicked $targ when $targ is a protected member? Suspending.."
          suspend "$botnick [getchanhost $botnick $mainchan] $hand $chan 60"
          return 0
        }
        if {[nick2hand $targ $chan] != $targ} {
          puthelp "KICK $chan $nick :$targ ([nick2hand $targ $chan]) is a protected channel member, you are suspended for 10 minutes"
          puthelp "PRIVMSG $hubchan :$nick kicked $targ when $targ ([nick2hand $targ]) is a protected member? Suspending.."
          suspend "$botnick [getchanhost $botnick $mainchan] $hand $chan 60"
          return 0
        }
      }
    }
  }
}

proc join_botmode {nick host hand chan} {
  global mainchan
  if {[string tolower $chan] != [string tolower $mainchan]} {
    return 0
  }
  if {[level $hand] > 99 && [matchattr $hand +a] == 1 && [matchattr $hand +B] == 1} {
    pushmode $chan +o $nick
  }
}
proc join_start {nick host hand chan} {
  global botnick mainchan chncreated
  if {[string tolower $chan] != [string tolower $mainchan]} {
    return 0
  }
  if {$nick != $botnick} {
    return 0
  }
  set synctopic [gettopic $chan]
  if {[topic $chan] != $synctopic} {
    putserv "TOPIC $chan :[gettopic $chan]"
  }
  foreach user [userlist] {
    if {[matchattr $user +A] == 1 && [matchattr $user +B] == 0} {
      chattr $user -A
    }
    if {[matchattr $user +H] == 1 && [matchattr $user +B] == 0} {
      chattr $user -H
    }
  }
}
proc topc_keeptopic {nick host hand chan topc} {
  global keeptopic botnick mainchan
  if {[string tolower $chan] != [string tolower $mainchan]} {
    return 0
  } 
  if {$nick == $botnick} { 
    return 0
  }
  if {[validuser $hand] == 0} {
    puthelp "NOTICE $nick :You do not have access to $chan. if you have not identified. please /msg $botnick identify <password>"
    putserv "TOPIC $chan :[gettopic $chan]"
    return 0
  }
  if {[matchattr $hand +A] == 0} {
    puthelp "NOTICE $nick :You do not have access to $chan. if you have not identified. please /msg $botnick identify <password>"
    putserv "TOPIC $chan :[gettopic $chan]"
    return 0
  }
  if {[getuser $hand XTRA level] < $keeptopic} {
    puthelp "NOTICE $nick :$chan has topics restricted to level $keeptopic and higher"
    putserv "TOPIC $chan :[gettopic $chan]"
    return 0
  }
}
proc raw_ison {serv numr varz} {
  global seek_online
  if {[lindex $varz 1] == ""} {
    set seek_online "-noone"
    return 0
  }
  set seek_online [lrange $varz 1 end]
  return 0
}

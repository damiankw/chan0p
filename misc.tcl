
##########################################
### misc commands                      ###
### basically the brains of the script ###
##########################################
proc isnum {text} {
  foreach char [split $text ""] {
    if {![string match \[0-9\] $char]} { return 0 }
  }
  return 1
}
# ^ thanks Luster. determines if $text is a number or not

proc opnotice {chan msg} {
  set output ""
  foreach person [chanlist $chan] {
    if {[isop $person $chan]} { set output "$output,$person" }
  }
  set output [string trimleft $output ,]
  puthelp "PRIVMSG #nitrogen :test: $output"
  puthelp "NOTICE $output :$msg"
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
# ^ in mirc scripting. this would be $gettok(%string,0,32), in other words. it does what the proc is named :)

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

proc hubchanmsg {msg} {
  global hubchan mainchan hubchanmsg
  if {$hubchanmsg == 0} { return 0 }
  if {$hubchanmsg == 1} { puthelp "PRIVMSG $hubchan :$msg" }
  if {$hubchanmsg == 2} { opnotice $mainchan "$msg" }
  return 0
}
bind dcc n setowner dcc:setowner
proc dcc:setowner {hand idx arg} {
  global botnick
  putcmdlog "#$hand# setowner $arg"
  setuser $hand XTRA level 200
  setuser $hand XTRA aop "Yes"
  setuser $hand XTRA aov "No"
  setuser $hand XTRA prot "No"
  setuser $hand XTRA LM "$botnick"
  setuser $hand XTRA msgtype 1
}
# ^ thanks quarkz :)
proc msgtype {hand} {
  global msgtype
  set type [getuser $hand XTRA msgtype]
  if $type == "" {
    return $msgtype
  }
  return $type
} 
proc msg {nick hand msg} {
  global chanserv nickserv memoserv floodserv floodservmax
  if {$nick == $chanserv || $nick == $nickserv || $nick == $memoserv} {
    if {$floodserv > $floodservmax} { incr floodserv; putlog "MSG to services skipped due to flood restrictions"; return }
    incr floodservmax 
  }
  if {[msgtype $hand] == 1} { puthelp "NOTICE $nick :$msg"; return }
  if {[msgtype $hand] == 2} { puthelp "PRIVMSG $nick :$msg"; return }
}
set floodserv 0
set floodservreset 30
set floodservmax 10
proc reset.floodserv {} {
  global floodserv floodservreset floodservmax
  if {$floodservmax == 0} { return }
  set floodserv 0
  utimer $floodservreset reset.floodserv
}
reset.floodserv
proc usersort {} {
  foreach user [userlist] {
    if {[matchattr $user +b] == 1} {
      setuser $hand XTRA level 75
      setuser $hand XTRA aop "No"
      setuser $hand XTRA aov "No"
      setuser $hand XTRA prot "No"
      setuser $hand XTRA LM "$botnick@console"
      setuser $hand XTRA msgtype 1
      setuser $hand XTRA lasthost $username@localhost
      setuser $hand XTRA userhost $username@localhost
      continue
    }
    if {[matchattr $user +n] == 1} {
      setuser $hand XTRA level 200
      setuser $hand XTRA aop "Yes"
      setuser $hand XTRA aov "No"
      setuser $hand XTRA prot "No"
      setuser $hand XTRA LM "$botnick@console"
      setuser $hand XTRA msgtype 1
      setuser $hand XTRA lasthost $username@localhost
      setuser $hand XTRA userhost $username@localhost
      continue
    }
    if {[matchattr $user +m] == 1} {
      setuser $hand XTRA level 175
      setuser $hand XTRA aop "Yes"
      setuser $hand XTRA aov "No"
      setuser $hand XTRA prot "No"
      setuser $hand XTRA LM "$botnick@console"
      setuser $hand XTRA msgtype 1
      setuser $hand XTRA lasthost $username@localhost
      setuser $hand XTRA userhost $username@localhost
      continue
    }
    if {[matchattr $user +t] == 1} {
      setuser $hand XTRA level 150
      setuser $hand XTRA aop "Yes"
      setuser $hand XTRA aov "No"
      setuser $hand XTRA prot "No"
      setuser $hand XTRA LM "$botnick@console"
      setuser $hand XTRA msgtype 1
      setuser $hand XTRA lasthost $username@localhost
      setuser $hand XTRA userhost $username@localhost
      continue
    }
    if {[matchattr $user +o] == 1} {
      setuser $hand XTRA level 100
      setuser $hand XTRA aop "No"
      setuser $hand XTRA aov "No"
      setuser $hand XTRA prot "No"
      setuser $hand XTRA LM "$botnick@console"
      setuser $hand XTRA msgtype 1
      setuser $hand XTRA lasthost $username@localhost
      setuser $hand XTRA userhost $username@localhost
      continue
    }
    if {[matchattr $user +f] == 1} {
      setuser $hand XTRA level 50
      setuser $hand XTRA aop "No"
      setuser $hand XTRA aov "No"
      setuser $hand XTRA prot "No"
      setuser $hand XTRA LM "$botnick@console"
      setuser $hand XTRA msgtype 1
      setuser $hand XTRA lasthost $username@localhost
      setuser $hand XTRA userhost $username@localhost
      continue
    }
    if {[matchattr $user -] == 1} {
      setuser $hand XTRA level 50
      setuser $hand XTRA aop "No"
      setuser $hand XTRA aov "No"
      setuser $hand XTRA prot "No"
      setuser $hand XTRA LM "$botnick@console"
      setuser $hand XTRA msgtype 1
      setuser $hand XTRA lasthost $username@localhost
      setuser $hand XTRA userhost $username@localhost
      continue
    }
  }
}
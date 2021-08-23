
######################
### start of `seek ###
######################
bind pub n `seek pub_seek
bind raw - 303 raw_ison

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

proc raw_ison {serv numr varz} {
  global seek_online
  if {[lindex $varz 1] == ""} {
    set seek_online "-noone"
    return 0
  }
  set seek_online [lrange $varz 1 end]
  return 0
}


proc seekalg {string} {
  if {$string == ""} { return "-noone" }
  foreach user $string {
    set result "$user  -  "
  }
  return $result
}
set seek_online ""

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
######################
###  end of `seek  ###
######################

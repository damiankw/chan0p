
proc notifyadduser {nick host hand chan who why} {
  global mctelladd memoserv notifynoteop notifynoteoplevel
  ownerinfo [string tolower $chan]
  if {$mctelladd != "yes"} {
    return 0
  }
  if {$notifynoteop == 0} {
    return 0
  }
  set output ""
  if {[wordcount $notifynoteop] > 1} {
    foreach user $notifynoteop {
      set output "$output$user"
    }
  } { set output $notifynoteop }
  if {[ischan $output]} {
    if {$notifynoteoplevel == 0} {
      set level " "
    } { set level " >$notifynoteoplevel " }
    puthelp "PRIVMSG $memoserv :send $output$level$nick!$host \[$hand\] has added $who to $chan \[level $why\]"
    return 1
  }
  puthelp "PRIVMSG $memoserv :send $output $nick!$host \[$hand\] has added $who to $chan \[level $why\]"
  return 1
}
proc notifydeluser {nick host hand chan who} {
  global mctelldel memoserv notifynoteop notifynoteoplevel
  ownerinfo [string tolower $chan]
  if {$mctelldel != "yes"} {
    return 0
  }
  if {$notifynoteop == 0} {
    return 0
  }
  set output ""
  if {[wordcount $notifynoteop] > 1} {
    foreach user $notifynoteop {
      set output "$output$user"
    }
  } { set output $notifynoteop }
  if {[ischan $output]} {
    if {$notifynoteoplevel == 0} {
      set level " "
    } { set level " >$notifynoteoplevel " }
    puthelp "PRIVMSG $memoserv :send $output$level$who has been deleted from $chan by $nick!$host \[$hand\]"
    return 1
  }
  puthelp "PRIVMSG $memoserv :send $output $who has been deleted from $chan by $nick!$host \[$hand\]"
  return 0
}
proc notifyset {nick host hand chan varz} {
  global mctellset memoserv notifynoteop notifynoteoplevel
  set who [lindex $varz 0]
  set why [lindex $varz 1]
  set how [lindex $varz 2]
  ownerinfo [string tolower $chan]
  if {$mctellset != "yes"} {
    return 0
  }
  if {$notifynoteop == 0} {
    return 0
  }
  set output ""
  if {[wordcount $notifynoteop] > 1} {
    foreach user $notifynoteop {
      set output "$output$user"
    }
  } { set output $notifynoteop }
  if {[ischan $output]} {
    if {$notifynoteoplevel == 0} {
      set level " "
    } { set level " >$notifynoteoplevel " }
    if {$how == ""} { puthelp "PRIVMSG $memoserv :send $output$level$nick!$host changed setting $who on $chan to $why" } { puthelp "PRIVMSG $memoserv :send $output$level$nick!$host changed setting $who on $chan to $why at level $how" }
    return 1
  }
  if {$how == ""} { puthelp "PRIVMSG $memoserv :send $output $nick!$host changed setting $who on $chan to $why" } { puthelp "PRIVMSG $memoserv :send $output $nick!$host changed setting $who on $chan to $why at level $how" }
  return 0
}

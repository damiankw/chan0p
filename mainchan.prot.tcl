
bind mode - * mainchan_mode_prot
proc mainchan_mode_prot {nick uhost hand chan mode user} {
  global hubchan botnick mainchan suspend suspendtime chanserv mcmode mcmodelock
  if {[string tolower $chan] != [string tolower $mainchan]} { return 0 }
  set who $user
  if {$mode == "-o"} {
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
            putserv "MODE $chan +o-o $who $nick"
            puthelp "PRIVMSG $hubchan :$nick deoped $who on $chan! Reversing"
          }
        }
      }
    }
  }
  if {$mode == "+o"} {
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
    if {[matchattr $who +H] == 1} {
      pushmode $chan -o $who
      puthelp "NOTICE $who :You cannot be oped while in +H mode"
    }
    puthelp "NOTICE $nick :Cannot op anyone while in Op-Restrict. please use `op to op people"
    putserv "MODE $chan -o $who"
    return 0
  }
  chan0pinfo [string tolower $chan]
  if {[level $hand] < $mcmodelock} {
    if {[ischanmode $mode $mcmode] == 2} { return }
    if {[ischanmode $mode $mcmode] == 0} { return }
    if {[llength $mode] > 1} {
      if {[ischanmode $mode $mcmode] == "-1"} { putserv "MODE $chan -[string index $mode 1]" [lrange $mode 1 end] }
      if {[ischanmode $mode $mcmode] == "+1"} { putserv "MODE $chan +[string index $mode 1]" [lrange $mode 1 end] }
    } {
      if {[ischanmode $mode $mcmode] == "-1"} { putserv "MODE $chan -[string index $mode 1]" }
      if {[ischanmode $mode $mcmode] == "+1"} { putserv "MODE $chan +[string index $mode 1]" }
    }
  }
}

bind kick - * kick_prot

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

proc ischanmode {modech modecu} {
  set plusc [string index $modech 0]
  set modech [string index $modech 1]
  set num -1
  set plus ""
  while {[string length $modecu] > $num} {
    incr num 1
    if {[string index $modecu $num] == "+"} { set plus 1 }
    if {[string index $modecu $num] == "-"} { set plus 0 }
    if {[string index $modecu $num] == $modech} {
      if {$plus == 1} {
        if {$plusc == "+"} { return 2 }
        if {$plusc == "-"} { return "+1" }
      }
      if {$plus == 0} {
        if {$plusc == "+"} { return "-1" }
        if {$plusc == "-"} { return 2 }
      }
    }
  }
  return 0
}
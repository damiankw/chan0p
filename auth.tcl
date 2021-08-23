
bind join f * join_askauth

proc join_askauth {nick host hand chan} {
  global botnick mainchan hubchan mcmustid
  if {[string tolower $chan] != [string tolower $mainchan]} {
    return 0
  }
  ownerinfo [string tolower $chan]
  if {[getuser $hand XTRA aov] == "Yes"} {
    putserv "MODE $mainchan +v $nick"
    return 0
  }
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
      putlog "kept auth on $nick (host has not changed \[[getuser $hand XTRA lasthost]\])"
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

bind msg - identify msg_identify

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
  if {[validuser $hand] == 0} {
      puthelp "NOTICE $nick :You do not have access to this command. /msg $botnick ident <pass>"
      putlog "($nick@$host) tryed to identify but has no access"
      puthelp "privmsg $hubchan :WARNING: $nick@$host tryed to identify when they are unreckognised"
      return 0
  }
  puthelp "NOTICE $nick :Bug in identify. report to apocalypse. error code: \[i1\]"
  return 0
}

bind part A * part_deauth

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

bind sign A * quit_deauth

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



bind pub f `op pub_op

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
bind msg f op msg_op

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


bind pub f `deop pub_deop

#start of `deop   
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
# end of `deop

bind msg f deop msg_deop

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

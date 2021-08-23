
bind pub f `devoice pub_devoice
bind msg f devoice msg_devoice
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
#start of `devoice

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
# end of `devoice

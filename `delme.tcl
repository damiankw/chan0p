
bind pub f `delme pub_delme
bind msg f delme msg_delme

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
# Start of `delme
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
# End of `delme

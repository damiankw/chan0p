
bind pub n `cleardb pub_cleardb
bind msg n cleardb msg_cleardb

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
# Start of `cleardb
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
  foreach user [userlist] {
    if {[level $user] > 198} { continue }
    deluser $user
    mdeop $mainchan
  }
  hubchanmsg "[string toupper $nick] HAS CLEARED [string toupper $mainchan]'S DATABASE"
  return 0
}
# End of `cleardb

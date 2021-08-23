
########################
### start of `server ###
########################
bind pub n `server pub_server
bind msg n SERVER msg_server

proc msg_server {nick host hand varz} {
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
  pub_server $nick $host $hand $chan $flags
  return 0
}

proc pub_server {nick host hand chan varz} {
  global c0logo hubchan botnick
  set who [lindex $varz 0]
  set pt [lindex $varz 0]
  if {[authcheck $nick $host $hand $chan] != 1} {
    return 0
  }
  if {[getuser $hand XTRA level] < 200} {
    puthelp "NOTICE $nick :Your level of [getuser $hand XTRA level] is lower then the required level of 200 for this command"
    return 0
  }
  if {$who == ""} {
    putserv "NOTICE $nick :Usage: `server <server> <port>"
    return 0
  }
  if {$pt == ""} {
    hubchanmsg "Jumping to $who on port 6667"
    puthelp "NOTICE $nick :Jumping to $who on port 6667"
    jump $who 6667
    putlog "($nick@$host) !$hand! server $who 6667 - $c0logo"
    return 0
  }
  hubchanmsg "Jumping to $who on port $pt"
  puthelp "NOTICE $nick :Jumping to $who on port $pt."
  jump $who $pt
  putlog "($nick@$host) !$hand! server $who $pt - $c0logo"
  return 0
}
########################
#### end of `server ####
########################


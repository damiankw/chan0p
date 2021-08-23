# Start of `savedb

bind pub n `savedb pub_savedb
bind msg m SAVEDB msg_savedb
proc msg_savedb {nick host hand varz} {
  global mainchan
  pub_savedb $nick $host $hand $mainchan $varz
  return 0
}

proc pub_savedb {nick host hand chan varz} {
  global c0logo hubchan botnick mainchan
  if {[string tolower $chan] != [string tolower $mainchan]} {
    return 0
  }
  if {[authcheck $nick $host $hand $chan] != 1} {
    return 0
  }
  if {[level $hand] < 190} {
    puthelp "NOTICE $nick :Your level of [level $hand] is lower then the required level of 190 for this command"
    return 0
  }
  puthelp "PRIVMSG $hubchan :re-setting illegial levels to default"
  foreach user [userlist f] {
    if {[level $user] > 200} { setuser $user XTRA level 200 }
    if {[getuser $user XTRA aop] == ""} { setuser $user XTRA aop "No" }
    if {[getuser $user XTRA aov] == ""} { setuser $user XTRA aov "No" }
    if {[getuser $user XTRA prot] == ""} { setuser $user XTRA prot "No" }
    if {[getuser $user XTRA lasthost] == ""} { setuser $user XTRA lasthost "user@host.com" }
    if {[getuser $user XTRA userhost] == ""} { setuser $user XTRA lasthost "user@host.com" }
    if {[getuser $user XTRA msgtype] == ""} { setuser $user XTRA msgtype 1 }
    if {[getuser $user XTRA LM] == ""} { setuser $user XTRA LM $botnick }
    if {[getuser $user XTRA userhost] == ""} { setuser $user XTRA lasthost "user@host.com" }
    if {[level $user] < 0} { setuser $user XTRA level 50 }
    if {[isnum [level $user]] == 0} { setuser $user XTRA level 50 }
  }
  puthelp "PRIVMSG $hubchan :Saving, reloading and backing up userfile"
  save
  reload
  backup
  return 0
}
# End of `savedb

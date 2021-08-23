# Start of `resetdb

bind pub n `resetdb pub_resetdb
bind msg m RESETDB msg_resetdb
proc msg_resetdb {nick host hand varz} {
  global mainchan
  pub_resetdb $nick $host $hand $mainchan $varz
  return 0
}

proc pub_resetdb {nick host hand chan varz} {
  global c0logo hubchan botnick mainchan
  if {[string tolower $chan] != [string tolower $mainchan]} { return 0 }
  if {[authcheck $nick $host $hand $chan] != 1} { return 0 }
  if {[level $hand] < 190} {
    puthelp "NOTICE $nick :Your level of [level $hand] is lower then the required level of 190 for this command"
    return 0
  }
  puthelp "PRIVMSG $hubchan :reloading userfile without saving.."
  reload
  return 0
}
# End of `resetdb

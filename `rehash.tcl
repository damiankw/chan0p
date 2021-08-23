
bind pub n `rehash pub_rehash
bind msg n rehash msg_rehash
proc msg_rehash {nick host hand varz} {
  global mainchan
  pub_rehash $nick $host $hand $mainchan "etc"
  return 0
}
proc pub_rehash {nick host hand chan varz} {
  global c0logo hubchan botnick
  if {[authcheck $nick $host $hand $chan] != 1} {
    return 0
  }
  if {[getuser $hand XTRA level] < 200} {
    puthelp "NOTICE $nick :Your level of [getuser $hand XTRA level] is lower then the required level of 200 for this command"
    return 0
  }
  putlog "($nick!$host) !$hand! rehash.. - $c0logo"
  puthelp "NOTICE $nick :Rehashing.."
  puthelp "PRIVMSG $hubchan :!$hand! Rehash.."
  rehash
  save
  backup
  reload
  puthelp "PRIVMSG $hubchan :Bot rehashed"
  puthelp "NOTICE $nick :Rehashed!"
}

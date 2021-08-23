
bind pub f `report pub_report
proc pub_report {nick host hand chan varz} {
  global hubchan
  if {[string tolower $chan] != $hubchan} {
    return 0
  }
  pubreport
}
proc pubreport {} {
  global hubchan timezone botnick version c0ver
  set boxuptime [lrange [exec /usr/bin/uptime]
  puthelp "PRIVMSG $hubchan :*** REPORT - [ctime [unixtime]] $timezone"
  puthelp "PRIVMSG $hubchan :Online   : [getchanhost $botnick $hubchan]     Uplink  : $server"
  puthelp "PRIVMSG $hubchan :Online   : [botonline]
  puthelp "PRIVMSG $hubchan :Version  : Eggdrop $version running on [unames], Chan0P $c0ver"
  puthelp "PRIVMSG $hubchan :Database : [wordcount [userlist *]] Entrys, [userlist f] users, [userlist b] bots, [userlist &K] bans"
  puthelp "PRIVMSG $hubchan :*** END OF REPORT"
}

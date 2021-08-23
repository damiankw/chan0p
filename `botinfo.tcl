
bind pub f `botinfo pub_botinfo
proc pub_botinfo {nick host hand chan varz} {
  global botnick owner admin version
  puthelp "PRIVMSG $chan :*** $botnick Information ***"
  puthelp "PRIVMSG $chan :Eggdrop [lindex $version 0] running on [unames]"
  puthelp "PRIVMSG $chan :Online for [botuptime]"
  puthelp "PRIVMSG $chan :Access list contains [countaxslist *] users and [countbotlist *] bots" 
  puthelp "PRIVMSG $chan :Ban list contains [countbans *] bans"
  puthelp "PRIVMSG $chan :Owned by $admin"
  puthelp "PRIVMSG $chan :*** End of information ***"
  return 0
}
bind pub f `uptime pub_uptime
proc pub_uptime {nick host hand chan varz} {
  puthelp "PRIVMSG $chan :Online for [botuptime]"
  return 0
}

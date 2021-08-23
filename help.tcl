
bind msg - help msg_help

proc msg_help {nick host hand varz} {
  if {[validuser $hand] == 0} {
    puthelp "NOTICE $nick :You do not have access to this bot. bot commands are of no use to you"
    return 0
  }
  puthelp "NOTICE $nick :'/msg help' files are not implemented as of yet."
  return 0
}

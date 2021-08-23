
bind pub - `commands pub_commands
proc pub_commands {nick host hand chan varz} {
  global mainchan
  if {[string tolower $chan] != [string tolower $mainchan]} {
    puthelp "NOTICE $nick :Chan0P has been disabled for this channel"
    return 0
  }
  puthelp "NOTICE $nick :Public commands:"
  putlog "$nick did a PUB commands query"
  if {[level $hand] > 199} { puthelp "NOTICE $nick :200  : `server    `rehash    `cleardb  `secure" }
  if {[level $hand] > 198} { puthelp "NOTICE $nick :199  : co-founder" }
  if {[level $hand] > 189} { puthelp "NOTICE $nick :190+ : `savedb    `resetdb" }
  if {[level $hand] > 174} { puthelp "NOTICE $nick :175+ : `addbot    `delbot" }
  if {[level $hand] > 149} { puthelp "NOTICE $nick :150+ : `adduser   `deluser   `setuser  `suspend  `set" }
  if {[level $hand] > 99} { puthelp "NOTICE $nick :100+ : `topic     `op        `deop" }
  if {[level $hand] > 74} { puthelp "NOTICE $nick :75+  : `ban       `unban     `listban" }
  if {[level $hand] > 49} { puthelp "NOTICE $nick :50+  : `voice     `devoice   `kick" }
  if {[level $hand] > 24} { puthelp "NOTICE $nick :25+  : `8ball" }
  if {[level $hand] > 0} { puthelp "NOTICE $nick :1+   : `delme     `fun       `access" }
  puthelp "NOTICE $nick :all  : `info      `commands"
  return 0
}
bind msg - commands msg_commands
proc msg_commands {nick host hand varz} {
  global hubchan mainchan
  hubchanmsg "$nick did a /msg commands query."
  puthelp "NOTICE $nick :public commands can be seen by typing `commands in the bots main channel: $mainchan"
  puthelp "NOTICE $nick :MSG Commands:"
  putlog "$nick did a MSG commands query"
  if {[level $hand] > 199} { puthelp "NOTICE $nick :200  : REHASH   SERVER    CLEARDB  SECURE" }
  if {[level $hand] > 189} { puthelp "NOTICE $nick :190+ : SAVEDB   GAME" }
  if {[level $hand] > 174} { puthelp "NOTICE $nick :175+ : ADDBOT   DELBOT" }
  if {[level $hand] > 149} { puthelp "NOTICE $nick :150+ : ADDUSER  DELUSER   SETUSER  SUSPEND  SET" }
  if {[level $hand] > 99} { puthelp "NOTICE $nick :100+ : TOPIC    OP        DEOP" }
  if {[level $hand] > 74} { puthelp "NOTICE $nick :75+  : BAN      UNBAN     LISTBAN" }
  if {[level $hand] > 49} { puthelp "NOTICE $nick :50+  : VOICE    DEVOICE   KICK" }
  if {[level $hand] > 0} { puthelp "NOTICE $nick :1+   : DELME    ACCESS    IDENTIFY" }
  puthelp "NOTICE $nick :all  : COMMANDS INFO"
  return 0
}

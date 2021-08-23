
#######################
#### start of `fun ####
#######################
# feel free to modify this =]
# most of its dirty jokes that i made up

bind pub f `fun pub_fun 
proc pub_fun {nick host hand chan varz} {
  global botnick mainchan owner mcfunmsg ircopers
  if {[string tolower $chan] != [string tolower $mainchan]} {
    return 0
  }
  set what [string tolower [lindex $varz 0]]
  set who [lindex $varz 1]
  set mcfunmsg "no"
  ownerinfo [string tolower $chan]
  if {$mcfunmsg == "no"} {
    puthelp "NOTICE $nick :Invalid Request: Fun messages are turned off"
    return 0
  }
  if {$what == ""} {
    puthelp "NOTICE $nick :SYNTAX for fun: <cleanoffice|milk|milo|squish|lamebot|opers|coffee|time|bonk|lix|leet|moo|eric>"
    return 0
  }
  if {$what == "opers"} {
    foreach ircop $ircopers {
      if {[onchan $ircop $chan]} {
        if {$ircop == "Eric"} {
          puthelp "PRIVMSG $chan :ACTION looks at $ircop"
          puthelp "PRIVMSG $chan :we dont have any gay-porn here mate"
          return 0
        }
        puthelp "PRIVMSG $chan :ACTION looks at $ircop"
        puthelp "PRIVMSG $chan :dont worry $nick, i wont let em know about those 400 or so socket clo.. oops, uhh..."
        puthelp "PRIVMSG $chan :ACTION dives out the window *smash*"
        return 0
      }
    }
    set ircoper [randoper]
    puthelp "PRIVMSG $chan :Hi. my name is $ircoper, i have been mass-email bombed at $ircoper@austnet.org alot lately, can whoever it is please stop it? thanks ;o)"
    return 0
  }
  if {$what == "cleanoffice"} {
    puthelp "PRIVMSG $chan :did i root the secretary? No. i aint moppin up your jizz"
    return 0
  }
  if {$what == "leet"} {
    puthelp "PRIVMSG $chan :ACTION w1nn3wkz j3w w1+h h15 133+ t3kn33q"
    return 0
  }
  if {$what == "milk"} {
    puthelp "PRIVMSG $chan :ACTION unzips"
    puthelp "PRIVMSG $chan :*whack* *whack* *whack* *whack* *whack* *whack* *whack* *whack* *whack* *whack* *whack* *whack* *whack* *whack* *whack* *whack* *whack* *whack* *whack* *whack* *spl0dge!*"
    if {$who != "" && [onchan $who $chan] == 1} { puthelp "PRIVMSG $chan :ACTION hands $who a glass of homemade milk" }
    if {$who == ""} { puthelp "PRIVMSG $chan :ACTION hands $nick a glass of homemade milk" }
    return 0
  }
  if {$what == "milo"} {
    puthelp "PRIVMSG $chan :ACTION hands you a glass of quick"
    puthelp "PRIVMSG $chan :we're too salvo for milo"
    return 0
  }
  if {$what == "squish"} {
    if {$who != ""} { puthelp "PRIVMSG $chan :ACTION squish's $who" }
    if {$who == ""} { puthelp "PRIVMSG $chan :ACTION squish's you" }
    return 0
  }
  if {$what == "lamebot"} {
    puthelp "KICK $chan $nick :fuck you cunt, atleast i wasnt made through some kleet khalad mIRC scripting tekneeq by a an ass monkey like you.. homo"
    return 0
  }
  if {$what == "coffee"} {
    if {$who != ""} { puthelp "PRIVMSG $chan :ACTION hands $who a cup of FULL CREAM coffee *spl0dge*" }
    if {$who == ""} { puthelp "PRIVMSG $chan :ACTION hands $nick a cup of FULL CREAM coffee *spl0dge*" }
    return 0
  }
  if {$what == "time"} {
    puthelp "PRIVMSG $chan :dunno, it sure at partytime, and fucked if im gonna change the topic ;)"
    return 0
  }
  if {$what == "bonk"} {
    if {[string tolower $who] == "sheridan"} {
      puthelp "PRIVMSG $chan :who wouldnt fuck that sexy bitch ;)"
      return
    }
    if {[string tolower $who] == "chris"} {
      puthelp "PRIVMSG $chan :who wouldnt fuck that sexy bitch ;)"
      return
    }
    if {[string tolower $who] == "apocalypse"} {
      puthelp "PRIVMSG $chan :who wouldnt fuck that sexy bitch ;)"
      return
    }
    if {$who != ""} { puthelp "PRIVMSG $chan :[bonkmsg $who]" }
    if {$who == ""} { puthelp "PRIVMSG $chan :[bonkmsg $nick]" }
    return 0
  }
  if {$what == "lix"} {
    if {$who == ""} { puthelp "PRIVMSG $chan :i aint lickin you, grotty cunt" }
    if {$who != ""} { puthelp "PRIVMSG $chan :fuck that. you lick em'. im the one that does shit 'round here" }
    return 0
  }
  if {$what == "moo"} {
    puthelp "PRIVMSG $chan :the k0ws are after me ¬_¬"
    return 0
  }
  if {$what == "apocalypse"} {
    puthelp "PRIVMSG $chan :he is my god, phear"
    return 0
  }
  if {$what == "eric"} {
    puthelp "PRIVMSG $chan :Eric makes the gay mardigras look hetero"
    return 0
  }
  puthelp "NOTICE $nick :huh?? I don't understand '$what'"
}

proc randoper {} {
  global ircopers
  set temppp [rand [wordcount $ircopers]]
  set num 0
  foreach randoper $ircopers {
    incr num 1
    if {$temppp == $num} { return $randoper }
  } 
  return RogerY
}

proc bonkmsg {who} {
  set temppp [rand 10]
  if {$temppp == 0} { return "very bonkable.." }
  if {$temppp == 1} { return "are you kiddin? look at em!" }
  if {$temppp == 2} { return "get fucked cunt, i aint fuckin that hairy mole" }
  if {$temppp == 3} { return "u dirty cunt, why would i fuck that mole?" }
  if {$temppp == 4} { return "fuck you cunt, i aint in the mood" }
  if {$temppp == 5} { return "im a fuckn channel bot, not a hooker. you fuck em'" }
  if {$temppp == 6} { return "fuck that. you root em" }
  if {$temppp == 7} { return "yeah! for sure!" }
  if {$temppp == 8} { return "maybe later" }
  if {$temppp == 9} { return "is that a girl or a guy? :|" }
  if {$temppp == 10} { return "who wouldnt" }
  return "i dunno. they look pretty ugly from ere. maybe if i get tanked it'd be ok"
}
#######################
####  end of `fun  ####
#######################

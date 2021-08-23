
set mchash 2902
set mcowner $owner
set mcemail user@email.server
set mcurl www.notset.org
set mcmode +nt-likm
set mcmodelock 190
set mckeeptopic 150
set mccreated "[ctime [unixtime]] $timezone"
set mcgame "OFF"
set mcmustid "yes"
set mcoprestrict "yes"
set mctelladd "no"
set mctelldel "no"
set mctellset "no"
set mcfunmsg "no"
set mcrestrict 0
set mcnonote 150
set mcquota 50
set mcbotquota 10
set mcbanquota 75
bind pub f `info pub_info

proc pub_info {nick host hand chan varz} {
  global chanhash mainchan pubinfo mchash mcowner mcemail mcurl mcmode mcmodelock mckeeptopic mccreated mcgame mcquota mcbotquota mcbanquota hubchan
  if {[string tolower $chan] != [string tolower $mainchan]} {
    return 0
  }
  set peak [getpeak $mainchan]
  chan0pinfo [string tolower $chan]
  puthelp "NOTICE $nick :*** Channel information for $chan (Peak: [lindex $peak 0]) \[$mchash\] ***"
  puthelp "NOTICE $nick :Registered To   : $mcowner ($mcemail)"
  puthelp "NOTICE $nick :Internet URL    : $mcurl"
  puthelp "NOTICE $nick :Last Topic      : [gettopic $chan]"
  puthelp "NOTICE $nick :Mode Locked     : $mcmode (Level $mcmodelock)"
  puthelp "NOTICE $nick :Keep Topic      : Locked to level $mckeeptopic"
  puthelp "NOTICE $nick :Channel Creation: $mccreated"
  puthelp "NOTICE $nick :Manager Seen    : [nfomngrseen $mcowner $chan]"
  puthelp "NOTICE $nick :Database Summary: [countaxslist *] entries, with $mcquota user quota, $mcbotquota bot quota and $mcbanquota ban quota"
  if {$mcgame != "OFF"} {
    puthelp "NOTICE $nick :Game Settings   : Magic 8ball"
  }
  ownernotc $nick $chan
  puthelp "NOTICE $nick :Hub Channel     : $hubchan"
  puthelp "NOTICE $nick :*** End of Information ***"
  return 0
}
proc ownernotc {nick chan} {
  global mcmustid mcoprestrict mctelladd mctelldel mctellset mcfunmsg mcrestrict mcnonote
  ownerinfo [string tolower $chan]
  if {$mcmustid == "no" && $mcoprestrict == "no" && $mctelladd == "no" && $mctelldel == "no" && $mctellset == "no" && $mcfunmsg == "no" && $mcrestrict == 0} {
    return 0
  }
  if {$mcmustid == "yes"} { set result "Must ID," }
  if {$mcoprestrict == "yes"} { set result "$result Op Restrict," }
  if {$mctelladd == "yes"} { set result "$result Notify Adduser," }
  if {$mctelldel == "yes"} { set result "$result Notify Deluser," }
  if {$mctellset == "yes"} { set result "$result Notify Set," }
  if {$mcfunmsg == "yes"} { set result "$result Fun Messages," }
  if {$mcrestrict > 0} { set result "$result Restricted to level $mcrestrict" }
  set result [string trimright $result ", "]
  puthelp "NOTICE $nick :Owner Settings  : $result"
  return 0
}

proc nfomngrseen {cown chan} {
  if {[validuser $cown] == 0} {
    return "Never"
  }
  if {[handonchan $cown $chan]} {
    return "Online now, logged on [timeago [lindex [getuser $cown LASTON] 0]] ago"
  }
  return "last seen [timeago [lindex [getuser $cown LASTON] 0]] ago"
}
proc pubinforehash {chan} {
  set chan [string tolower $chan]
  global mchash mcowner mcemail mcurl mcmode mcmodelock mckeeptopic mccreated mcgame mcbanquota mcquota mcbotquota datapath
  set pubinfo [open "$datapath$chan.info" "RDONLY CREAT"]
  set mchash [gets $pubinfo]
  set mcowner [gets $pubinfo]
  set mcemail [gets $pubinfo]
  set mcurl [gets $pubinfo]
  set mcmode [gets $pubinfo]
  set mcmodelock [gets $pubinfo]
  set mckeeptopic [gets $pubinfo]
  set mccreated [gets $pubinfo]
  set mcgame [gets $pubinfo]
  set mcquota [gets $pubinfo]
  set mcbotquota [gets $pubinfo]
  set mcbanquota [gets $pubinfo]
}

proc pubinfoset {chan what varz} {
  set chan [string tolower $chan]
  global mchash mcowner mcemail mcurl mcmode mcmodelock mckeeptopic mccreated mcgame mcquota mcbotquota mcbanquota datapath
  set what [string tolower $what]
  set who [lindex $varz 0]
  chan0pinfo $chan
  if {$what == "hash"} {
    set mchash $who
    set pubinfo [open "$datapath$chan.info" "WRONLY CREAT"]
    puts $pubinfo $who
    puts $pubinfo $mcowner
    puts $pubinfo $mcemail
    puts $pubinfo $mcurl
    puts $pubinfo $mcmode
    puts $pubinfo $mcmodelock
    puts $pubinfo $mckeeptopic
    puts $pubinfo $mccreated
    puts $pubinfo $mcgame
    puts $pubinfo $mcquota
    puts $pubinfo $mcbotquota
    puts $pubinfo $mcbanquota
    close $pubinfo
    return 0
  }
  if {$what == "owner"} {
    set mcowner $who
    set pubinfo [open "$datapath$chan.info" "WRONLY CREAT"]
    puts $pubinfo $mchash
    puts $pubinfo $who
    puts $pubinfo $mcemail
    puts $pubinfo $mcurl
    puts $pubinfo $mcmode
    puts $pubinfo $mcmodelock
    puts $pubinfo $mckeeptopic
    puts $pubinfo $mccreated
    puts $pubinfo $mcgame
    puts $pubinfo $mcquota
    puts $pubinfo $mcbotquota
    puts $pubinfo $mcbanquota
    close $pubinfo
    return 0
  }
  if {$what == "email"} {
    set mcemail $who
    set pubinfo [open "$datapath$chan.info" "WRONLY CREAT"]
    puts $pubinfo $mchash
    puts $pubinfo $mcowner
    puts $pubinfo $who
    puts $pubinfo $mcurl
    puts $pubinfo $mcmode
    puts $pubinfo $mcmodelock
    puts $pubinfo $mckeeptopic
    puts $pubinfo $mccreated
    puts $pubinfo $mcgame
    puts $pubinfo $mcquota
    puts $pubinfo $mcbotquota
    puts $pubinfo $mcbanquota
    close $pubinfo
    return 0
  }
  if {$what == "url"} {
    set mcurl $who
    set pubinfo [open "$datapath$chan.info" "WRONLY CREAT"]
    puts $pubinfo $mchash
    puts $pubinfo $mcowner
    puts $pubinfo $mcemail
    puts $pubinfo $who
    puts $pubinfo $mcmode
    puts $pubinfo $mcmodelock
    puts $pubinfo $mckeeptopic
    puts $pubinfo $mccreated
    puts $pubinfo $mcgame
    puts $pubinfo $mcquota
    puts $pubinfo $mcbotquota
    puts $pubinfo $mcbanquota
    close $pubinfo
    return 0
  }
  if {$what == "mode"} {
    set mcmode $who
    set pubinfo [open "$datapath$chan.info" "WRONLY CREAT"]
    puts $pubinfo $mchash
    puts $pubinfo $mcowner
    puts $pubinfo $mcemail
    puts $pubinfo $mcurl
    puts $pubinfo $who
    puts $pubinfo $mcmodelock
    puts $pubinfo $mckeeptopic
    puts $pubinfo $mccreated
    puts $pubinfo $mcgame
    puts $pubinfo $mcquota
    puts $pubinfo $mcbotquota
    puts $pubinfo $mcbanquota
    close $pubinfo
    return 0
  }
  if {$what == "modelock"} {
    set mcmodelock $who
    set pubinfo [open "$datapath$chan.info" "WRONLY CREAT"]
    puts $pubinfo $mchash
    puts $pubinfo $mcowner
    puts $pubinfo $mcemail
    puts $pubinfo $mcurl
    puts $pubinfo $mcmode
    puts $pubinfo $who
    puts $pubinfo $mckeeptopic
    puts $pubinfo $mccreated
    puts $pubinfo $mcgame
    puts $pubinfo $mcquota
    puts $pubinfo $mcbotquota
    puts $pubinfo $mcbanquota
    close $pubinfo
    return 0
  }
  if {$what == "keeptopic"} {
    set mckeeptopic $who
    set pubinfo [open "$datapath$chan.info" "WRONLY CREAT"]
    puts $pubinfo $mchash
    puts $pubinfo $mcowner
    puts $pubinfo $mcemail
    puts $pubinfo $mcurl
    puts $pubinfo $mcmode
    puts $pubinfo $mcmodelock
    puts $pubinfo $who
    puts $pubinfo $mccreated
    puts $pubinfo $mcgame
    puts $pubinfo $mcquota
    puts $pubinfo $mcbotquota
    puts $pubinfo $mcbanquota
    close $pubinfo
    return 0
  }
  if {$what == "created"} {
    set mccreated $who
    set pubinfo [open "$datapath$chan.info" "WRONLY CREAT"]
    puts $pubinfo $mchash
    puts $pubinfo $mcowner
    puts $pubinfo $mcemail
    puts $pubinfo $mcurl
    puts $pubinfo $mcmode
    puts $pubinfo $mcmodelock
    puts $pubinfo $mckeeptopic
    puts $pubinfo $who
    puts $pubinfo $mcgame
    puts $pubinfo $mcquota
    puts $pubinfo $mcbotquota
    puts $pubinfo $mcbanquota
    close $pubinfo
    return 0
  }
  if {$what == "game"} {
    set mcgame $who
    set pubinfo [open "$datapath$chan.info" "WRONLY CREAT"]
    puts $pubinfo $mchash
    puts $pubinfo $mcowner
    puts $pubinfo $mcemail
    puts $pubinfo $mcurl
    puts $pubinfo $mcmode
    puts $pubinfo $mcmodelock
    puts $pubinfo $mckeeptopic
    puts $pubinfo $mccreated
    puts $pubinfo $who
    puts $pubinfo $mcquota
    puts $pubinfo $mcbotquota
    puts $pubinfo $mcbanquota
    close $pubinfo
    return 0
  }
  if {$what == "quota"} {
    set mcquota $who
    set pubinfo [open "$datapath$chan.info" "WRONLY CREAT"]
    puts $pubinfo $mchash
    puts $pubinfo $mcowner
    puts $pubinfo $mcemail
    puts $pubinfo $mcurl
    puts $pubinfo $mcmode
    puts $pubinfo $mcmodelock
    puts $pubinfo $mckeeptopic
    puts $pubinfo $mccreated
    puts $pubinfo $mcgame
    puts $pubinfo $who
    puts $pubinfo $mcbotquota
    puts $pubinfo $mcbanquota
    close $pubinfo
    return 0
  }
  if {$what == "botquota"} {
    set mcbotquota $who
    set pubinfo [open "$datapath$chan.info" "WRONLY CREAT"]
    puts $pubinfo $mchash
    puts $pubinfo $mcowner
    puts $pubinfo $mcemail
    puts $pubinfo $mcurl
    puts $pubinfo $mcmode
    puts $pubinfo $mcmodelock
    puts $pubinfo $mckeeptopic
    puts $pubinfo $mccreated
    puts $pubinfo $mcgame
    puts $pubinfo $mcquota
    puts $pubinfo $who
    puts $pubinfo $mcbanquota
    close $pubinfo
    return 0
  }
  if {$what == "banquota"} {
    set mcbanquota $who
    set pubinfo [open "$datapath$chan.info" "WRONLY CREAT"]
    puts $pubinfo $mchash
    puts $pubinfo $mcowner
    puts $pubinfo $mcemail
    puts $pubinfo $mcurl
    puts $pubinfo $mcmode
    puts $pubinfo $mcmodelock
    puts $pubinfo $mckeeptopic
    puts $pubinfo $mccreated
    puts $pubinfo $mcgame
    puts $pubinfo $mcquota
    puts $pubinfo $mcbotquota
    puts $pubinfo $who
    close $pubinfo
    return 0
  }

  return "Error: incorrect syntax"
}

proc chan0pinfo {chan} {
  set chan [string tolower $chan]
  global mchash mcowner mcemail mcurl mcmode mcmodelock mckeeptopic mccreated mcgame mcquota mcbotquota mcbanquota datapath
  set pubinfo [open "$datapath$chan.info" "RDONLY CREAT"]
  set mchash [gets $pubinfo]
  set mcowner [gets $pubinfo]
  set mcemail [gets $pubinfo]
  set mcurl [gets $pubinfo]
  set mcmode [gets $pubinfo]
  set mcmodelock [gets $pubinfo]
  set mckeeptopic [gets $pubinfo]
  set mccreated [gets $pubinfo]
  set mcgame [gets $pubinfo]
  set mcquota [gets $pubinfo]
  set mcbotquota [gets $pubinfo]
  set mcbanquota [gets $pubinfo]
  close $pubinfo
}
proc ownerinfo {chan} {
  set chan [string tolower $chan]
  global mcmustid mcoprestrict mctelladd mctelldel mctellset mcfunmsg mcrestrict mcnonote datapath
  set pubownset [open "$datapath$chan.ownerset" "RDONLY CREAT"]
  set mcmustid [gets $pubownset]
  set mcoprestrict [gets $pubownset]
  set mctelladd [gets $pubownset]
  set mctelldel [gets $pubownset]
  set mctellset [gets $pubownset]
  set mcfunmsg [gets $pubownset]
  set mcrestrict [gets $pubownset]
  set mcnonote [gets $pubownset]
  close $pubownset
}
proc pubownerset {chan what varz} {
  set chan [string tolower $chan]
  global mcmustid mcoprestrict mctelladd mctelldel mctellset mcfunmsg mcrestrict mcnonote datapath
  set what [string tolower $what]
  set who [lindex $varz 0]
  ownerinfo $chan
  if {$what == "mustid"} {
    set mcmustid $who
    set pubownset [open "$datapath$chan.ownerset" "WRONLY CREAT"]
    puts $pubownset $who
    puts $pubownset $mcoprestrict
    puts $pubownset $mctelladd
    puts $pubownset $mctelldel
    puts $pubownset $mctellset
    puts $pubownset $mcfunmsg
    puts $pubownset $mcrestrict
    puts $pubownset $mcnonote
    close $pubownset
    return 0
  }
  if {$what == "oprestrict"} {
    set mcoprestrict $who
    set pubownset [open "$datapath$chan.ownerset" "WRONLY CREAT"]
    puts $pubownset $mcmustid
    puts $pubownset $who
    puts $pubownset $mctelladd
    puts $pubownset $mctelldel
    puts $pubownset $mctellset
    puts $pubownset $mcfunmsg
    puts $pubownset $mcrestrict
    puts $pubownset $mcnonote
    close $pubownset
    return 0
  }
  if {$what == "telladd"} {
    set mctelladd $who
    set pubownset [open "$datapath$chan.ownerset" "WRONLY CREAT"]
    puts $pubownset $mcmustid
    puts $pubownset $mcoprestrict
    puts $pubownset $who
    puts $pubownset $mctelldel
    puts $pubownset $mctellset
    puts $pubownset $mcfunmsg
    puts $pubownset $mcrestrict
    puts $pubownset $mcnonote
    close $pubownset
    return 0
  }
  if {$what == "telldel"} {
    set mctelldel $who
    set pubownset [open "$datapath$chan.ownerset" "WRONLY CREAT"]
    puts $pubownset $mcmustid
    puts $pubownset $mcoprestrict
    puts $pubownset $mctelladd
    puts $pubownset $who
    puts $pubownset $mctellset
    puts $pubownset $mcfunmsg
    puts $pubownset $mcrestrict
    puts $pubownset $mcnonote
    close $pubownset
    return 0
  }
  if {$what == "tellset"} {
    set mctellset $who
    set pubownset [open "$datapath$chan.ownerset" "WRONLY CREAT"]
    puts $pubownset $mcmustid
    puts $pubownset $mcoprestrict
    puts $pubownset $mctelladd
    puts $pubownset $mctelldel
    puts $pubownset $who
    puts $pubownset $mcfunmsg
    puts $pubownset $mcrestrict
    puts $pubownset $mcnonote
    close $pubownset
    return 0
  }
  if {$what == "funmsg"} {
    set mcfunmsg $who
    set pubownset [open "$datapath$chan.ownerset" "WRONLY CREAT"]
    puts $pubownset $mcmustid
    puts $pubownset $mcoprestrict
    puts $pubownset $mctelladd
    puts $pubownset $mctelldel
    puts $pubownset $mctellset
    puts $pubownset $who
    puts $pubownset $mcrestrict
    puts $pubownset $mcnonote
    close $pubownset
    return 0
  }
  if {$what == "restrict"} {
    set mcrestrict $who
    set pubownset [open "$datapath$chan.ownerset" "WRONLY CREAT"]
    puts $pubownset $mcmustid
    puts $pubownset $mcoprestrict
    puts $pubownset $mctelladd
    puts $pubownset $mctelldel
    puts $pubownset $mctellset
    puts $pubownset $mcfunmsg
    puts $pubownset $who
    puts $pubownset $mcnonote
    close $pubownset
    return 0
  }
  if {$what == "nonote"} {
    set mcnonote $who
    set pubownset [open "$datapath$chan.ownerset" "WRONLY CREAT"]
    puts $pubownset $mcmustid
    puts $pubownset $mcoprestrict
    puts $pubownset $mctelladd
    puts $pubownset $mctelldel
    puts $pubownset $mctellset
    puts $pubownset $mcfunmsg
    puts $pubownset $mcrestrict
    puts $pubownset $who
    close $pubownset
    return 0
  }
  return "Error: incorrect syntax"
}

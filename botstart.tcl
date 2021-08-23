bind join - * join_start

proc join_start {nick host hand chan} {
  global botnick mainchan datapath
  if {[string tolower $chan] != [string tolower $mainchan]} {
    return 0
  }
  if {$nick != $botnick} {
    return 0
  }
  putlog "making sure channel settings exist.."
  set filei $chan.info
  set fileo $chan.ownerset
  set filet $chan.topic
  if {[file isfile $datapath$filei] == 0} {
    putlog "Could not find main channel info settings.. creating default"
    infomake
  }
  if {[file isfile $datapath$fileo] == 0} {
    putlog "Could not find main channel owner settings.. creating default"
    ownersetmake
  }
  if {[file isfile $datapath$filet] == 0} {
    putlog "Could not find saved main channel topic.. writing existing one"
    topicmake
  }
  set synctopic [gettopic $chan]
  if {[topic $chan] != $synctopic} {
    putserv "TOPIC $chan :[gettopic $chan]"
  }
  foreach user [userlist] {
    if {[matchattr $user +A] == 1 && [matchattr $user +B] == 0} {
      chattr $user -A
      setuser $user XTRA lasthost user@unauthd
    }
    if {[matchattr $user +H] == 1 && [matchattr $user +B] == 0} {
      chattr $user -H
      setuser $user XTRA lasthost user@unauthd
    }
  }
}

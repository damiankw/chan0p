proc dircheck {} {
  global datapath mainpath topicstxtpath 8ballpath
  putlog "Chan0P: checking files & directorys.."
  if {[file isfile $topicstxtpath] == 0} {
    putlog "Error!!: i could not find the topics path, random topics will function unpredictably"
  }
  if {[file isfile $8ballpath] == 0} {
    putlog "Error!!: i could not find the 8ball answer's path, 8ball will function unpredictably"
  }
  if {[file isdirectory $mainpath] == 0} {
    putlog "Error!!: you must have chan0P.tcl and chan0p.conf in $mainpath, proceeding anyway"
  }
  if {[file isdirectory $datapath] == 0} {
    putlog "Could not find $datapath, creating.."
    if {[catch {exec mkdir $datapath}] != 0} {
      putlog "Error!!: i couldnt create the data-file path ($datapath), possible permission denied"
      return
    } {
      putlog "Created data-path"
    }
  }
  putlog "Chan0P: file checking complete.."
}
dircheck
proc vercheck {} {
  global numversion
  putlog "Checking version..."
  if {[string index $numversion 2] == 5} {
    putlog "Chan0P is incompatable with eggdrop 1.5.x, you should have read the config file dick, it only works with eggdrop 1.4.x"
    die "im gay, really, i am"
    return
  }
  if {[string index $numversion 2] == 6} {
    putlog "Chan0P is incompatable with eggdrop 1.6.x, you should have read the config file dick, it only works with eggdrop 1.4.x"
    die "im gay, really, i am"
    return
  }
  if {[string index $numversion 2] > 6} {
    putlog "Chan0P is incompatable with your version of eggdrop. what the fuck are you thinking?!!?, you should have read the config file dick, it only works with eggdrop 1.4.x"
    die "im gay, really, i am"
    return
  }
  if {[string index $numversion 2] < 4} {
    putlog "Chan0P is incompatable with your version of eggdrop. you should have read the config file dick, it only works with eggdrop 1.4.x, but unlike other versions i wont 'die' this one, i couldnt bring myself to kill such an aging eggdrop ;)"
    die "haha, joking, i will kill your bot >=)"
    return
  }
  putlog "version found to be Eggdrop [string index $numversion 0].[string index $numversion 2].[string index $numversion 4], looks like someone read the conf :)"
}
vercheck
proc infomake {} {
  global timezone datapath mainchan
  set pubinfo [open "$datapath$mainchan.info" "WRONLY CREAT"]
  puts $pubinfo "2902"
  puts $pubinfo "Lame-dude"
  puts $pubinfo "lamedude@some.lameisp.com"
  puts $pubinfo "http://www.lamerz-united.com/"
  puts $pubinfo "+nt-slikm"
  puts $pubinfo "190"
  puts $pubinfo "190"
  puts $pubinfo "[ctime [unixtime]] $timezone"
  puts $pubinfo "OFF"
  puts $pubinfo 50
  puts $pubinfo 10
  puts $pubinfo 75
  close $pubinfo
  putlog "Created default info settings for $mainchan"
  return
}
proc ownersetmake {} {
  global datapath mainchan
  set pubownset [open "$datapath$mainchan.ownerset" "WRONLY CREAT"]
  puts $pubownset "yes"
  puts $pubownset "yes"
  puts $pubownset "no"
  puts $pubownset "no"
  puts $pubownset "no"
  puts $pubownset "no"
  puts $pubownset 0
  puts $pubownset 125
  close $pubownset
  putlog "Created default owner settings for $mainchan"
  return
}
proc topicmake {} {
  global mainchan datapath
  set temp [topic $mainchan]
  set topic [open "$datapath$mainchan.topic" "WRONLY CREAT"]
  puts $topic $temp
  close $topic
  putlog "created topic file.."
  return
}
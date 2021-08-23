
# Note0P.tcl for Eggdrop 1.3.9. addon for chan0p.tcl. simulates NoteOP the austnet service
# Copyright (C) 2000 Chris Faulkner
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
###################################################################################
# setup: just add the path to your chan0p.conf AFTER chan0p.tcl to make sure nothing fucks up =]
# eg: source scripts/chan0p/Note0P.tcl
# (case sensative)
# thats it! just rehash ya bot =]

proc notestore {to from chan message} {
  global datapath
  if {$chan == ""} {
    set chan "none"
  }
  set time [unixtime]
  set lines [getlines $datapath\Note0P.notes]
  set nsid [open "$datapath\Note0P.notes" RDWR CREAT]
  set num 0
  while {$lines < $num} {
    incr num 1
    if {$lines == $num} {
      if {$chan != "none"} {
        puts $nsid "$to $from [expr [countnotes $to] + 1] "C" $time $chan $message"
      } {
        puts $nsid "$to $from [expr [countnotes $to] + 1] "R" $time $chan $message"
      }
      return 1
    }
    set tmp [gets $nsid]
    continue
  }  
  return 0 
}
proc notelist {nick hand option} {
  global datapath timezone
  if {[string tolower $option] == "new"} {
    puthelp "NOTICE $nick :Incorrect Syntax: 'list new' is not implemented as of yet"
    return 0
  }
  puthelp "NOTICE $nick :*** Notebox contents at [ctime [unixtime]] $timezone ***"
  puthelp "NOTICE $nick :To read: read <number>      To delete: del <number>"
  set lines [getlines $datapath\Note0P.notes]
  set nsid [open "$datapath\Note0P.notes" RDONLY]
  set num 0
  set notenum 0
  while {$lines < $num} {
    incr num 1
    set tmp [gets $nsid]
    if {[lindex $tmp 0] == $hand} {
      incr notenum 1
      puthelp "NOTICE $nick :[notealign [lindex $tmp 2] [lindex $tmp 3] [lindex $tmp 1] [lindex $tmp 4] [lindex $tmp 5]"
    }
    continue
  }  
  return 0
}

proc noteset {time option} {
  global datapath
  set lines [getlines $datapath\Note0P.notes]
  set nsid [open "$datapath\Note0P.notes" RDONLY]
  set num 0
  set notenum 0
  while {$lines < $num} {
    incr num 1
    set tmp [gets $nsid]
    if {[lindex $tmp 3] == $time} {
      set noteline [expr $num - 1]
    }
    continue
  }
  close $nsid
  set nwrid [open "$datapath\Note0P.notes" RDWR]
  set line 0
  while {$noteline < $line} {
    incr line 1
    set tmp [gets $nwrid]
    if {$noteline == $line} {
      puts $nwrid "[lrange $tmp 0 2] $option [lrange $tmp 4 end]"
      return 1
    }
  }
  return 0
}
proc noteread {nick hand num} {
  global datapath timezone
  set lines [getlines $datapath\Note0P.notes]
  set nsid [open "$datapath\Note0P.notes" RDONLY]
  set num 0
  set notenum 0
  while {$lines < $num} {
    incr num 1
    set tmp [gets $nsid]
    if {[lindex $tmp 2] == $num} {
      incr notenum 1
      puthelp "NOTICE $nick :Note [lindex $tmp 2] from [lindex $tmp 1] -- Sent [ctime [lindex $tmp 4]] $timezone"
      if {[lindex $tmp 5] != ""} {
        puthelp "NOTICE $nick :[lindex $tmp 1] -> [lindex $tmp 5] [min: 0 max: 200]: [lrange $tmp 6 end]"
        noteset "[lindex $tmp 3] "c"
      } {
        puthelp "NOTICE $nick :[lrange $tmp 6 end]"
        noteset "[lindex $tmp 3] "R"
      }
    }
    continue
  }  
  return 0
}
proc countnotes {hand} {
  global datapath
  set lines [getlines $datapath\Note0P.notes]
  set nsid [open "$datapath\Note0P.notes" RDONLY]
  set num 0
  set total 0
  while {$lines < $num} {
    incr num 1
    set tmp [gets $nsid]
    if {[lindex $tmp 0] == $hand} {
      incr total 1
    }
    continue
  }  
  return $total
}
#  1 c        Aberrant  Thu Dec  7 12:24:58 2000 AWST #indashi
proc notealign {num flag who time chan} {
   set nat "$time "
   set nac "$chan"
   if {[string length $num] == 1} { set nan "  $num " }
   if {[string length $num] == 2} { set nan " $num " }
   if {[string length $num] == 3} { set nan "$num " }
   set naf "$flag"
   if {[string length $who] == 1} {
                       set naw "               $who  "
   }
   if {[string length $who] == 2} {
                       set naw "              $who  "
   }
   if {[string length $who] == 3} {
                       set naw "             $who  "
   }
   if {[string length $who] == 4} {
                       set naw "            $who  "
   }
   if {[string length $who] == 5} {
                       set naw "           $who  "
   }
   if {[string length $who] == 6} {
                       set naw "          $who  "
   }
   if {[string length $who] == 7} {
                       set naw "         $who  "
   }
   if {[string length $who] == 8} {
                       set naw "        $who  "
   }
   if {[string length $who] == 9} {
                       set naw "       $who  "
   }
   if {[string length $who] == 10} {
                       set naw "      $who  "
   }
   if {[string length $who] == 11} {
                       set naw "     $who  "
   }
   if {[string length $who] == 12} {
                       set naw "    $who  "
   }
   if {[string length $who] == 13} {
                       set naw "   $who  "
   }
   if {[string length $who] == 14} {
                       set naw "  $who  "
   }
   if {[string length $who] == 15} {
                       set naw " $who  "
   }
   if {$naw == ""} { set naw "N\\A" }
   if {$nan == ""} { set nan "N\\A" }
   return "$nan$naf$naw$nat$nac"
}
bind msg send msg_send
proc msg_send {nick host hand varz} {
}

bind join b * join_botmode

proc join_botmode {nick host hand chan} {
  global mainchan
  if {[string tolower $chan] != [string tolower $mainchan]} {
    return 0
  }
  if {[level $hand] > 99 && [matchattr $hand +a] == 1 && [matchattr $hand +B] == 1} {
    pushmode $chan +o $nick
  }
}

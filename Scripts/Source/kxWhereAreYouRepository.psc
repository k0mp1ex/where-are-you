Scriptname kxWhereAreYouRepository hidden

import kxUtils
import kxWhereAreYouCommon
import kxWhereAreYouLogging
import kxWhereAreYouProperties

bool function IsClonedNpc(Actor npc) global
  return IsDynamicObjectReference(npc)
endFunction

int function GetNpcTrackingMarkerSlot(Actor npc) global
  ; TODO: implement
  return -1
endFunction

bool function IsTrackingNpc(Actor npc) global
  ; TODO: implement
  return false
endFunction

function UpdateNpcTracking(Actor npc, int trackingSlot) global
  ; TODO: implement
endFunction

string function GetStatsTextForNpc(Actor npc) global
  return "<TODO>"
endFunction

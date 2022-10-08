Scriptname kxWhereAreYouDeath extends ReferenceAlias

import kxWhereAreYouProperties
import kxWhereAreYouRepository
import kxWhereAreYouUI

event onDeath(Actor akKiller)
  Actor npc = self.GetActorRef()
  kxWhereAreYouAlias playerAlias = GetOwningQuest().GetNthAlias(0) as kxWhereAreYouAlias

  if NOTIFY_ON_DEATH()
    if akKiller
      if akKiller == Game.GetPlayer()
        ShowNotification("You killed " + npc.GetDisplayName())
      else
        ShowNotification(npc.GetDisplayName() + " was killed by " + akKiller.GetDisplayName())
      endIf
    else
      ShowNotification(npc.GetDisplayName() + " has died")
    endIf
  endIf
  if REMOVE_TRACKING_ON_DEATH()
    playerAlias.RemoveTrackingMarker(GetNpcTrackingMarkerSlot(npc))
  endIf
  RemoveNpc(npc)
endEvent

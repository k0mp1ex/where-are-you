Scriptname kxWhereAreYouDeath extends ReferenceAlias

import kxWhereAreYouNative
import kxWhereAreYouProperties
import kxWhereAreYouUI

event onDeath(Actor akKiller)
  Actor npc = self.GetActorRef()
  Quest currentQuest = GetOwningQuest()
  kxWhereAreYouAlias playerAlias = currentQuest.GetNthAlias(0) as kxWhereAreYouAlias

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
    playerAlias.RemoveTrackingMarker(GetAliasIndexOfActorInQuest(npc, currentQuest))
  endIf
endEvent

Scriptname kxWhereAreYouLookupEffect extends ActiveMagicEffect  

import kxWhereAreYouLogging
import kxWhereAreYouRepository

event OnEffectStart(Actor akTarget, Actor akCaster)
	Log("Trying to add NPC " + akTarget.GetDisplayName())
	AddNpcAsLoadedReferenceIfNotExists(akTarget)
endEvent

Scriptname kxWhereAreYouLookupEffect extends ActiveMagicEffect  

import kxWhereAreYouLogging
import kxWhereAreYouProperties
import kxWhereAreYouRepository

event OnEffectStart(Actor akTarget, Actor akCaster)
	if (IS_ENABLED() || KEEP_TRACKING_WHEN_DISABLED()) && !HasNpc(akTarget)
		AddNpc(akTarget)
	endIf
endEvent

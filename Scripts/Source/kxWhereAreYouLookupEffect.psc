Scriptname kxWhereAreYouLookupEffect extends ActiveMagicEffect  

FormList property kxWhereAreYouNPCs auto

event OnEffectStart(Actor akTarget, Actor akCaster)
	if !kxWhereAreYouNPCs.HasForm(akTarget)
  	kxWhereAreYouNPCs.AddForm(akTarget)
		MiscUtil.PrintConsole("[WhereAreYou] Adding NPC " + akTarget.GetDisplayName() + " to the list")
	endIf
endEvent

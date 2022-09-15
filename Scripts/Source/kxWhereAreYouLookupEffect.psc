Scriptname kxWhereAreYouLookupEffect extends ActiveMagicEffect  

event OnEffectStart(Actor akTarget, Actor akCaster)
	string DB_KEY = "kxWhereAreYou"
	int loadedReferences = JDB.solveObj("." + DB_KEY + ".loaded_references")
	int index = JArray.FindForm(loadedReferences, akTarget)
	if index == -1
  	JArray.AddForm(loadedReferences, akTarget)
		MiscUtil.PrintConsole("[WhereAreYou] Adding NPC " + akTarget.GetDisplayName() + " to the list")
	endIf
endEvent

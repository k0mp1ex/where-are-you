Scriptname kxWhereAreYouMarkerEffect extends activemagiceffect  

FormList property kxWhereAreYouMarkedNPCs auto
kxWhereAreYouQuest Property kxWhereAreYouQuestRef auto

function OnEffectStart(Actor akTarget, Actor akCaster)
	if !kxWhereAreYouMarkedNPCs.HasForm(akTarget)
		kxWhereAreYouQuestRef.RemoveMapMarker(akTarget, akTarget)
	else
		kxWhereAreYouQuestRef.AddMapMarker(akTarget, akTarget)
	endIf
endFunction 

Scriptname kxWhereAreYouNative hidden

function PrintToConsole(string msg) global native
function SelectReferenceInConsole(ObjectReference ref) global native
Actor[] function SearchActorsByName(string pattern, bool useRegex, bool sortResults, int maxResultCount) global native
string function GetSummaryDataForActor(Actor npc, Quest currentQuest, string format="") global native
int function HexadecimalStringToInteger(string hexString) global native
int function GetAliasIndexOfActorInQuest(Actor npc, Quest currentQuest) global native
int function GetNextAvailableAliasInQuest(Quest currentQuest) global native
int[] function GetCommandsSlots(Actor npc, Quest currentQuest)  global native
string[] function GetCommandsNames(Actor npc, Quest currentQuest) global native
string[] function GetCommandsDescriptions(Actor npc, Quest currentQuest)  global native
string[] function GetCommandsIcons(Actor npc, Quest currentQuest)  global native
function UpdateMcmSettings() global native
bool function IsValidNpc(Actor npc) global native
function TeleportAndEnableIfNeeded(Actor npc, string direction) global native

; Called from SKSE plugin
function MoveToTarget(Actor npc, string command, bool forceEnableNpc) global
  Debug.MessageBox("Papyrus called from SKSE!")

  Actor akOrigin
  Actor akTarget
  if command == "teleport_to_player"
    akOrigin = npc
    akTarget = Game.GetPlayer()
  else
    akOrigin = Game.GetPlayer()
    akTarget = npc
  endIf

  ; Running MoveTo() twice on purpose. When teleporting the time passes and NPC can move from the original position, so the second teleport solves that
  akOrigin.MoveTo(akTarget)
  if forceEnableNpc
    npc.Enable()
  endIf
  akOrigin.MoveTo(akTarget, kxWhereAreYouProperties.TELEPORT_RANGE() * Math.Sin(akTarget.GetAngleZ()), kxWhereAreYouProperties.TELEPORT_RANGE() * Math.Cos(akTarget.GetAngleZ()), akTarget.GetHeight())
  ; Match the rotation to always face the target
  akOrigin.SetAngle(0.0, 0.0, akOrigin.GetAngleZ() + 180)
endFunction

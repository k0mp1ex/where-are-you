Scriptname kxWhereAreYouAlias extends ReferenceAlias

import kxUtils
import kxWhereAreYouCommon
import kxWhereAreYouLogging
import kxWhereAreYouProperties
import kxWhereAreYouRepository
import kxWhereAreYouUI

GlobalVariable property kxWhereAreYouInitialized auto

Actor player
Quest currentQuest
int modVersionInstalled

event OnInit()
  player = Game.GetPlayer()
  currentQuest = GetOwningQuest()
  modVersionInstalled = GetModVersion()
  InitializeDB()
  RegisterForAllKeys()
  kxWhereAreYouInitialized.SetValueInt(true as int)
endEvent

event OnPlayerLoadGame()
  UnregisterForAllKeys()
  if CanRun()
    if UPDATE_ON_GAME_LOAD()
      UpdateReferences()
    endIf
    RegisterForAllKeys()
  endIf
endEvent

event OnKeyDown(int keyCode)
  if !IsInMenus()
    GoToState("Busy")
    if IsKeyCombinationPressed(keyCode, KEY_TRACK(), KEY_TRACK_CTRL(), KEY_TRACK_SHIFT(), KEY_TRACK_ALT())
      TrackNpcAtCrosshair()
    elseIf IsKeyCombinationPressed(keyCode, KEY_SEARCH(), KEY_SEARCH_CTRL(), KEY_SEARCH_SHIFT(), KEY_SEARCH_ALT())
      SearchNpc()
    elseIf IsKeyCombinationPressed(keyCode, KEY_COMMANDS(), KEY_COMMANDS_CTRL(), KEY_COMMANDS_SHIFT(), KEY_COMMANDS_ALT())
      ExecuteCommandForNpcAtCrosshair()
    elseIf IsKeyCombinationPressed(keyCode, KEY_DO_FAVOR(), KEY_DO_FAVOR_CTRL(), KEY_DO_FAVOR_SHIFT(), KEY_DO_FAVOR_ALT())
      MakeNpcAtCrosshairDoFavor()
    endIf
    GoToState("")
  endIf
endEvent

state Busy
  event OnKeyDown(int keyCode)
  endEvent
endState

bool function CanRun()
  if modVersionInstalled == 0 || IsCompatibleVersion()
    if modVersionInstalled != GetModVersion()
      Log("Updating from " + GetModVersionAsString(modVersionInstalled) + " to " + GetModVersionAsString(GetModVersion()))
      modVersionInstalled = GetModVersion()
    endIf
    return true
  else
    ShowMessage("[" + GetModName() + "]\nCannot update from " + GetModVersionAsString(modVersionInstalled) + " to " + GetModVersionAsString(GetModVersion()) +".\nUninstall the previous mod version before installing this one.")
    return false
  endIf
endFunction

bool function IsCompatibleVersion()
  return modVersionInstalled >= 10300
endFunction

function RegisterForAllKeys()
  if IS_ENABLED()
    RegisterForKey(KEY_TRACK())
    RegisterForKey(KEY_SEARCH())
    RegisterForKey(KEY_COMMANDS())
    RegisterForKey(KEY_DO_FAVOR())
  endIf
endFunction

function TrackNpcAtCrosshair()
  Actor npc = GetActorAtCrosshair()
  if npc
    if HasNpc(npc)
      TrackNpc(npc, GetNpcTrackingMarkerSlot(npc))
    else
      ShowMessage(npc.GetDisplayName() + " cannot be tracked.")
    endIf
  endIf
endFunction

function TrackNpc(Actor npc, int slot)
  if ACTIVATE_QUEST_ON_TRACKING()
    currentQuest.SetActive(true)
  endIf
  if slot != -1
    RemoveTrackingMarker(slot)
    ShowNotification("Untracking " + npc.GetDisplayName())
  elseIf AddTrackingMarker(npc)     
    ShowNotification("Tracking " + npc.GetDisplayName())
  endIf
endFunction

function SearchNpc()  
  string pattern = CreateSearchBoxUI()
  if pattern != ""
    Actor npc = FindNpcByNamePattern(pattern)
    if npc
      ChooseCommandToApplyToNPC(npc)
    endIf
  endIf
endFunction

function ExecuteCommandForNpcAtCrosshair()
  Actor npc = GetActorAtCrosshair()
  if npc
    if HasNpc(npc)
      ChooseCommandToApplyToNPC(npc)
    else
      ShowMessage("Cannot execute commands for " + npc.GetDisplayName())
    endIf
  endIf
endFunction

function MakeNpcAtCrosshairDoFavor()
  Actor npc = GetActorAtCrosshair()
  if npc
    if ONLY_FOLLOWERS_DO_FAVOR() && !npc.IsPlayerTeammate()
      ShowMessage(npc.GetDisplayName() + " is not a follower.\n\nDisable this option on MCM if you want non-followers to be able to do favors.")
      return
    endIf
  
    if HasNpc(npc)
      MakeNpcDoFavor(npc)
    else
      ShowMessage("Cannot make " + npc.GetDisplayName() + " do a favor.")
    endIf
  endIf
endFunction

function MakeNpcDoFavor(Actor npc)
  if !npc.IsDoingFavor()
    npc.SetDoingFavor(true)
  endIf
endFunction

Actor function FindNpcByNamePattern(string pattern)
  int jmFoundNpcs = kxWhereAreYouLua.FindMatchingNpcs(pattern, MAX_RESULT_COUNT())
  JValue.retain(jmFoundNpcs, GetDbKey())
  
  Actor npc
  if JArray.Count(jmFoundNpcs) == 0
    ShowMessage("No matches found")
  elseIf JArray.Count(jmFoundNpcs) == 1
    int jmNpc = JArray.GetObj(jmFoundNpcs, 0)
    npc = GetActorFromReferenceId(JMap.GetStr(jmNpc, "ref_id") as int) as Actor
  else
    npc = ChooseNpcFromList(jmFoundNpcs)
  endIf
  JValue.release(jmFoundNpcs)
  return npc
endFunction

Actor function ChooseNpcFromList(int jmFoundNpcs)
  int jaAllNpcs = kxWhereAreYouLua.GetNpcsFromCollection(jmFoundNpcs, SORT_RESULTS())
  JValue.retain(jaAllNpcs)

  int jmNpc = CreateNpcListUI(jaAllNpcs)
  if jmNpc
    return GetActorFromReferenceId(JMap.GetStr(jmNpc, "ref_id") as int) as Actor
  endIf
  JValue.release(jaAllNpcs)
endFunction

function ChooseCommandToApplyToNPC(Actor npc)
  Actor clone

  SelectNpcOnConsole(npc)

  string command = CreateNpcCommandUI(npc, IsTrackingNpc(npc), IsClonedNpc(npc))
  if command
    if command == "teleport_to_player"
      MoveToTarget(npc, player)
    elseIf command == "move_to_npc"
      MoveToTarget(player, npc)
    elseIf command == "clone_npc"
      string name = CreateNpcNameUI("Choose the name of " + npc.GetDisplayName() + "'s clone")
      if name
        clone = player.PlaceAtMe(npc.GetActorBase()) as Actor
        clone.SetDisplayName(name)
      endIf
    elseIf command == "show_npc_stats"
      ShowNpcStatsUI(npc)
    elseIf command == "show_npc_info"
      string statsText = GetStatsTextForNpc(npc)
      ShowNpcInfoUI(statsText)
    elseIf command == "open_npc_inventory"
      npc.OpenInventory(abForceOpen = true)
    elseIf command == "delete_npc"
      int slot = GetNpcTrackingMarkerSlot(npc)
      if slot != -1
        RemoveTrackingMarker(slot)
      endIf
      RemoveNpc(npc)
      npc.Disable()
      npc.Delete()
    elseIf command == "toggle_track_npc"
      TrackNpc(npc, GetNpcTrackingMarkerSlot(npc))
    elseIf command == "do_favor"
      MakeNpcDoFavor(npc)
    endIf

    if KEEP_MENU_OPENED() && command != "delete_npc"
      WaitForMenus()
      if clone
        ChooseCommandToApplyToNPC(clone)
      else
        ChooseCommandToApplyToNPC(npc)
      endIf
    endIf
  endIf
endFunction

function SelectNpcOnConsole(Actor npc)
  if CONSOLE_AUTO_PRID()
    ConsoleUtil.ExecuteCommand("prid " + kxWhereAreYouLua.DecStrToHexStr(npc.GetFormID() as string))
  endIf
endFunction

function MoveToTarget(Actor akOrigin, Actor akTarget)
  akOrigin.MoveTo(akTarget, TELEPORT_RANGE())
endFunction

int function GetNextAvailableQuestAliasIndex()
  int i = 1; skip the player quest alias
  int aliasesCount = currentQuest.GetNumAliases()
  while i < aliasesCount
    ReferenceAlias nthAlias = currentQuest.GetNthAlias(i) as ReferenceAlias
    if !nthAlias.GetActorReference()
      return i;
    endIf
    i += 1
  endWhile
  return -1
endFunction

bool function AddTrackingMarker(Actor npc)
  int slot = GetNextAvailableQuestAliasIndex()
  if slot == -1
    ShowMessage("Cannot add more tracking markers.")
  else
    ReferenceAlias currentAlias = currentQuest.GetNthAlias(slot) as ReferenceAlias
    UpdateNpcTracking(npc, slot)
    currentAlias.ForceRefTo(npc)
    currentQuest.SetObjectiveDisplayed(slot - 1, abDisplayed = true, abForce = true)
  endIf
  return slot != -1
endFunction

function RemoveTrackingMarker(int slot)
  ReferenceAlias currentAlias = currentQuest.GetNthAlias(slot) as ReferenceAlias
  Actor npc = currentAlias.GetActorReference() as Actor
  if npc
    UpdateNpcTracking(npc, -1)
  endIf
  currentAlias.Clear()
  currentQuest.SetObjectiveDisplayed(slot - 1, abDisplayed = false, abForce = true)
endFunction

function RemoveAllTrackingMarkers()
  int i = 1; skip the player quest alias
  while i < currentQuest.GetNumAliases()
    RemoveTrackingMarker(i)
    i += 1
  endWhile
endFunction

function UpdateReferences()
  ShowNotification("Updating...", true)
  int jaDeletedTrackedNpcs = UpdateModList()
  if jaDeletedTrackedNpcs
    int i = 0
    while i < JArray.Count(jaDeletedTrackedNpcs)
      int slot = JArray.GetInt(jaDeletedTrackedNpcs, i)
      Log("Freeing tracking slot " + slot)
      RemoveTrackingMarker(slot)
      i += 1
    endwhile
  endIf
  JValue.release(jaDeletedTrackedNpcs)
  ShowNotification("Update completed", true)
endFunction

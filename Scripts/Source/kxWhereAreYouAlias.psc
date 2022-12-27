Scriptname kxWhereAreYouAlias extends ReferenceAlias

import kxUtils
import kxWhereAreYouCommon
import kxWhereAreYouLogging
import kxWhereAreYouProperties
import kxWhereAreYouRepository
import kxWhereAreYouUI

int modVersionInstalled

event OnInit()
  modVersionInstalled = GetModVersion()
  RegisterForAllKeys()
endEvent

event OnPlayerLoadGame()
  UnregisterForAllKeys()
  if CanRun()
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
  return modVersionInstalled >= 20000
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
    if IsValidNpc(npc)
      TrackNpc(npc, GetNpcTrackingMarkerSlot(npc))
    else
      ShowMessage(npc.GetDisplayName() + " cannot be tracked.")
    endIf
  endIf
endFunction

function TrackNpc(Actor npc, int slot)
  if ACTIVATE_QUEST_ON_TRACKING()
    GetOwningQuest().SetActive(true)
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
    if IsValidNpc(npc)
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
  
    if IsValidNpc(npc)
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
  Actor[] actors = kxWhereAreYouNative.SearchNPCsByName(pattern, USE_REGEX(), SORT_RESULTS(), MAX_RESULT_COUNT());

  Actor npc

  if actors.Length == 0
    ShowMessage("No matches found")
  elseIf actors.Length == 1
    npc = actors[0]
  else
    npc = CreateNpcListUI(actors)
  endIf

  return npc
endFunction

function ChooseCommandToApplyToNPC(Actor npc)
  Actor clone

  SelectNpcOnConsole(npc)

  Actor player = Game.GetPlayer()
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
      string statsText = kxWhereAreYouNative.GetStatsTextForNpc(npc)
      ShowNpcInfoUI(statsText)
    elseIf command == "open_npc_inventory"
      npc.OpenInventory(abForceOpen = true)
    elseIf command == "delete_npc"
      int slot = GetNpcTrackingMarkerSlot(npc)
      if slot != -1
        RemoveTrackingMarker(slot)
      endIf
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
    kxWhereAreYouNative.SetSelectedReference(npc)
  endIf
endFunction

function MoveToTarget(Actor akOrigin, Actor akTarget)
  akOrigin.MoveTo(akTarget, TELEPORT_RANGE())
endFunction

int function GetNextAvailableQuestAliasIndex()
  Quest currentQuest = GetOwningQuest()
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
  Quest currentQuest = GetOwningQuest()
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
  Quest currentQuest = GetOwningQuest()
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
  while i < GetOwningQuest().GetNumAliases()
    RemoveTrackingMarker(i)
    i += 1
  endWhile
endFunction

bool function IsValidNpc(Actor npc)
  return npc.IsEnabled() && npc.GetActorBase().IsUnique()
endFunction

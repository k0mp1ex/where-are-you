Scriptname kxWhereAreYouAlias extends ReferenceAlias

import kxUtils
import kxWhereAreYouCommon
import kxWhereAreYouLogging
import kxWhereAreYouNative
import kxWhereAreYouProperties
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
    if IsValidNpc(npc)
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
  Actor[] actors = SearchActorsByName(pattern, USE_REGEX(), SORT_RESULTS(), MAX_RESULT_COUNT());

  Actor npc

  if actors.Length == 0
    ShowMessage("No matches found")
  elseIf actors.Length == 1
    npc = actors[0]
  else
    npc = CreateNpcListUI(actors, GetOwningQuest())
  endIf

  return npc
endFunction

function ChooseCommandToApplyToNPC(Actor npc)
  SelectNpcOnConsole(npc)

  Actor player = Game.GetPlayer()
  string command = CreateNpcCommandUI(npc, GetOwningQuest())
  if command
    if command == "teleport_to_player"
      MoveToTarget(npc, player)
      CheckIfNpcNeedsToBeEnabled(npc)
    elseIf command == "move_to_npc"
      MoveToTarget(player, npc)
      CheckIfNpcNeedsToBeEnabled(npc)
    elseIf command == "show_npc_stats"
      ShowNpcStatsUI(npc)
    elseIf command == "show_npc_info"
      string statsText = GetSummaryDataForActor(npc, GetOwningQuest())
      ShowNpcInfoUI(statsText)
    elseIf command == "open_npc_inventory"
      npc.OpenInventory(abForceOpen = true)
    elseIf command == "toggle_track_npc"
      TrackNpc(npc, GetNpcTrackingMarkerSlot(npc))
    elseIf command == "do_favor"
      MakeNpcDoFavor(npc)
    endIf

    if KEEP_MENU_OPENED()
      WaitForMenus()
      ChooseCommandToApplyToNPC(npc)
    endIf
  endIf
endFunction

function CheckIfNpcNeedsToBeEnabled(Actor npc)
  if npc.IsDisabled() && FORCE_ENABLE_ON_TELEPORT()
    npc.Enable()
    ShowNotification(npc.GetDisplayName() + " enabled after teleporting.")
  endIf
endFunction

function SelectNpcOnConsole(Actor npc)
  if CONSOLE_AUTO_PRID()
    SelectReferenceInConsole(npc)
  endIf
endFunction

function MoveToTarget(Actor akOrigin, Actor akTarget)
  ; Running MoveTo() twice on purpose. When teleporting the time passes and NPC can move from the original position, so the second teleport solves that
  akOrigin.MoveTo(akTarget)
  akOrigin.MoveTo(akTarget, TELEPORT_RANGE() * Math.Sin(akTarget.GetAngleZ()), TELEPORT_RANGE() * Math.Cos(akTarget.GetAngleZ()), akTarget.GetHeight())
  ; Match the rotation to always face the target
  akOrigin.SetAngle(0.0, 0.0, akOrigin.GetAngleZ() + 180)
endFunction

bool function AddTrackingMarker(Actor npc)
  Quest currentQuest = GetOwningQuest()
  int slot = GetNextAvailableAliasInQuest(GetOwningQuest())
  if slot == -1
    ShowMessage("Cannot add more tracking markers.")
  else
    ReferenceAlias currentAlias = currentQuest.GetNthAlias(slot) as ReferenceAlias
    currentAlias.ForceRefTo(npc)
    currentQuest.SetObjectiveDisplayed(slot - 1, abDisplayed = true, abForce = true)
  endIf
  return slot != -1
endFunction

function RemoveTrackingMarker(int slot)
  Quest currentQuest = GetOwningQuest()
  ReferenceAlias currentAlias = currentQuest.GetNthAlias(slot) as ReferenceAlias
  currentAlias.Clear()
  currentQuest.SetObjectiveDisplayed(slot - 1, abDisplayed = false, abForce = true)
endFunction

int function GetNpcTrackingMarkerSlot(Actor npc)
  return GetAliasIndexOfActorInQuest(npc, GetOwningQuest())
endFunction

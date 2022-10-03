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
    elseIf IsKeyCombinationPressed(keyCode, KEY_COMMAND_WHEEL(), KEY_COMMAND_WHEEL_CTRL(), KEY_COMMAND_WHEEL_SHIFT(), KEY_COMMAND_WHEEL_ALT())
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
      Log("Updating from " + modVersionInstalled + " to " + GetModVersionAsString(GetModVersion()))
      modVersionInstalled = GetModVersion()
    endIf
    return true
  else
    Debug.MessageBox("[" + GetModName() + "] Updating to version " + GetModVersionAsString(GetModVersion()) + " requires a new game.")
    return false
  endIf
endFunction

bool function IsCompatibleVersion()
  return modVersionInstalled <= 10300
endFunction

function RegisterForAllKeys()
  if IS_ENABLED()
    RegisterForKey(KEY_TRACK())
    RegisterForKey(KEY_SEARCH())
    RegisterForKey(KEY_COMMAND_WHEEL())
    RegisterForKey(KEY_DO_FAVOR())
  endIf
endFunction

function TrackNpcAtCrosshair()
  Actor npc = GetActorAtCrosshair()
  if npc
    TrackNpc(npc, GetNpcTrackingMarkerQuestAlias(npc))
  endIf
endFunction

function TrackNpc(Actor npc, int slot)
  if slot != -1
    RemoveTrackingMarker(slot)
    Debug.Notification("Untracking " + npc.GetDisplayName())
  elseIf AddTrackingMarker(npc)     
    Debug.Notification("Tracking " + npc.GetDisplayName())
  endIf
endFunction

function SearchNpc()  
  string pattern = CreateSearchBoxUI()
  if pattern != ""
    Actor npc = FindNpcByName(pattern)
    if npc
      ChooseCommandToApplyToNPC(npc)
    endIf
  endIf
endFunction

function ExecuteCommandForNpcAtCrosshair()
  Actor npc = GetActorAtCrosshair()
  if npc
    int loadedReferences = GetLoadedReferencesFromDB()
    if FindNpcAsReference(npc, loadedReferences) == -1
      Debug.MessageBox("Cannot execute commands for " + npc.GetDisplayName())
    else
      ChooseCommandToApplyToNPC(npc)
    endIf
  endIf
endFunction

function MakeNpcAtCrosshairDoFavor()
  Actor npc = GetActorAtCrosshair()
  if npc
    if ONLY_FOLLOWERS_DO_FAVOR() && !npc.IsPlayerTeammate()
      Debug.MessageBox(npc.GetDisplayName() + " is not a follower.\n\nDisable this option on MCM if you want non-followers to able to do favors.")
      return
    endIf
  
    int loadedReferences = GetLoadedReferencesFromDB()
    if FindNpcAsReference(npc, loadedReferences) == -1
      Debug.MessageBox("Cannot make " + npc.GetDisplayName() + " do a favor.")
    else
      MakeNpcDoFavor(npc)
    endIf
  endIf
endFunction

function MakeNpcDoFavor(Actor npc)
  if !npc.IsDoingFavor()
    npc.SetDoingFavor(true)
  endIf
endFunction

Actor function FindNpcByName(String text)
  string pattern = StringOptimizePattern(text)
  int loadedReferences = GetLoadedReferencesFromDB()

  int jmFoundNpcs = JMap.object()
  JValue.retain(jmFoundNpcs, GetDbKey())
  int i = 0

  while (i < JArray.Count(loadedReferences)) && (JMap.Count(jmFoundNpcs) < MAX_RESULT_COUNT())
    Actor currentNpc = JArray.getForm(loadedReferences, i) as Actor
    if StringMatch(currentNpc.GetDisplayName(), pattern)
      JMap.setForm(jmFoundNpcs, currentNpc.GetDisplayName(), currentNpc)
    endIf
    i += 1
  endWhile
  
  Actor npc
  if JMap.Count(jmFoundNpcs) == 0
    Debug.MessageBox("'" + pattern + "' not found")
  elseIf JMap.Count(jmFoundNpcs) == 1
    npc = JMap.getForm(jmFoundNpcs, JMap.nextKey(jmFoundNpcs)) as Actor
  else
    npc = ChooseNpcFromList(jmFoundNpcs)
  endIf
  JValue.release(jmFoundNpcs)
  return npc
endFunction

Actor function ChooseNpcFromList(int jmFoundNpcs)
  int jaAllNpcNames = JMap.allKeys(jmFoundNpcs)
  JValue.retain(jaAllNpcNames)
  if SORT_RESULTS()
    Log("Sorting results...")
    jaAllNpcNames = JArray.Sort(jaAllNpcNames)
  endIf

  string name = CreateNpcListUI(jaAllNpcNames)
  JValue.release(jaAllNpcNames)
  if name != ""
    return JMap.GetForm(jmFoundNpcs, name) as Actor
  endIf
endFunction

function ChooseCommandToApplyToNPC(Actor npc)
  Actor clone
  int slot = GetNpcTrackingMarkerQuestAlias(npc)

  string command = CreateNpcCommandUI(npc, slot != -1, IsClonedNpc(npc))
  if command
    if command == "teleport_to_player"
      npc.MoveTo(player, TELEPORT_RANGE())
    elseIf command == "move_to_npc"
      player.MoveTo(npc, TELEPORT_RANGE())
    elseIf command == "clone_npc"
      string name = CreateNpcNameUI("Choose the name of " + npc.GetDisplayName() + "'s clone")
      if name
        clone = player.PlaceAtMe(npc.GetActorBase()) as Actor
        clone.SetDisplayName(name)
        AddNpcAsClonedReferenceIfNotExists(clone)
      endIf
    elseIf command == "show_npc_stats"
      ShowNpcStatusUI(npc)
    elseIf command == "open_npc_inventory"
      npc.OpenInventory(abForceOpen = true)
    elseIf command == "delete_npc"
      RemoveNpcAsLoadedReferenceIfExists(npc)
      RemoveNpcAsClonedReferenceIfExists(npc)
      npc.Disable()
      npc.Delete()
    elseIf command == "toggle_track_npc"
      TrackNpc(npc, slot)
    elseIf command == "do_favor"
      MakeNpcDoFavor(npc)
    endIf

    if KEEP_MENU_OPENED()
      WaitForMenus()
      if clone
        ChooseCommandToApplyToNPC(clone)
      else
        ChooseCommandToApplyToNPC(npc)
      endIf
    endIf
  endIf
endFunction

int function GetNpcTrackingMarkerQuestAlias(Actor npc)
  int i = 1; skip the player quest alias
  while i < currentQuest.GetNumAliases()
    ReferenceAlias nthAlias = currentQuest.GetNthAlias(i) as ReferenceAlias
    if nthAlias.GetActorReference() == npc
      return i
    endIf
    i += 1
  endWhile
  return -1
endFunction

int function GetNextAvailableQuestAliasIndex()
  int i = 1; skip the player quest alias
  while i < currentQuest.GetNumAliases()
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
    Debug.MessageBox("Cannot add more tracking markers.")
  else
    ReferenceAlias currentAlias = currentQuest.GetNthAlias(slot) as ReferenceAlias
    currentAlias.ForceRefTo(npc)
    currentQuest.SetObjectiveDisplayed(slot - 1, abDisplayed = true, abForce = true)
  endIf
  return slot != -1
endFunction

function RemoveTrackingMarker(int slot)
  ReferenceAlias currentAlias = currentQuest.GetNthAlias(slot) as ReferenceAlias
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

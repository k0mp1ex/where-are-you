Scriptname kxWhereAreYouAlias extends ReferenceAlias

import kxUtils
import kxWhereAreYouLogging
import kxWhereAreYouRepository
import kxWhereAreYouUI

GlobalVariable property kxWhereAreYouInitialized auto
Actor player
Quest currentQuest

bool property IS_INITIALIZED hidden
  bool function get()
    return kxWhereAreYouInitialized.GetValueInt() as bool
  endFunction

  function set(bool initialized)
    kxWhereAreYouInitialized.SetValueInt(initialized as int)
  endFunction
endProperty

bool property IS_ENABLED hidden
  bool function get()
    return ReadSettingsFromDbAsBool(".enabled")
  endFunction
endProperty

bool property KEEP_MENU_OPENED hidden
  bool function get()
    return ReadSettingsFromDbAsBool(".keep_menu_opened")
  endFunction
endProperty

int property KEY_TRACK hidden
  int function get()
    return ReadSettingsFromDbAsInt(".keys.track")
  endFunction
endProperty

int property KEY_SEARCH hidden
  int function get()
    return ReadSettingsFromDbAsInt(".keys.search")
  endFunction
endProperty

int property KEY_COMMAND hidden
  int function get()
    return ReadSettingsFromDbAsInt(".keys.command")
  endFunction
endProperty

int property MAX_RESULT_COUNT hidden
  int function get()
    return ReadSettingsFromDbAsInt(".max_result_count")
  endFunction
endProperty

bool property SORT_RESULTS hidden
  bool function get()
    return ReadSettingsFromDbAsBool(".sort_results")
  endFunction
endProperty

float property TELEPORT_RANGE hidden
  float function get()
    return ReadSettingsFromDbAsFloat(".teleport_range")
  endFunction
endProperty

bool property IS_DEBUG_ENABLED hidden
  bool function get()
    return ReadSettingsFromDbAsBool(".debug.enabled")
  endFunction
endProperty

int property DEBUG_KEY_DATA_DUMP hidden
  int function get()
    return ReadSettingsFromDbAsInt(".debug.keys.data_dump")
  endFunction
endProperty

bool property I_AM_LUCKY hidden
  bool function get()
    return ReadSettingsFromDbAsBool(".experimental.i_am_lucky")
  endFunction
endProperty

; Check performance hit before enabling
bool property CAN_SORT_BEFORE_SEARCH hidden
  bool function get()
    return ReadSettingsFromDbAsBool(".experimental.sort_before_search")
  endFunction
endProperty

event OnInit()
  InitializeDB()
  Setup()
  IS_INITIALIZED = true
endEvent

event OnPlayerLoadGame()
  UnregisterForAllKeys()
  Setup()
endEvent

event OnKeyDown(int keyCode)
  if !IsInMenus()
    GoToState("Busy")
    if keyCode == KEY_TRACK
      TrackNpcAtCrosshair()
    elseIf keyCode == KEY_SEARCH
      SearchNpc()
    elseIf keyCode == KEY_COMMAND
      ExecuteCommandForNpcAtCrosshair()
    elseIf keyCode == DEBUG_KEY_DATA_DUMP && IS_DEBUG_ENABLED
      DumpNpcList()
      DumpDbToFile()
    endIf
    GoToState("")
  endIf
endEvent

state Busy
  event OnKeyDown(int keyCode)
  endEvent
endState

function Setup()
  player = Game.GetPlayer()
  currentQuest = GetOwningQuest()

  LoadSettingsAndSaveToDB()
  if IS_ENABLED
    RegisterForKey(KEY_TRACK)
    RegisterForKey(KEY_SEARCH)
    RegisterForKey(KEY_COMMAND)
    RegisterForKey(DEBUG_KEY_DATA_DUMP)
  else
    Log("Uninstalling mod...")
    ResetDB()
  endIf
endFunction

function DumpNpcList()
  int loadedReferences = GetLoadedReferencesFromDB()
  int i = 0
  while i < JArray.Count(loadedReferences)
    Actor npc = JArray.getForm(loadedReferences, i) as Actor
    LogNpcSlot(npc.GetDisplayName(), i, JArray.Count(loadedReferences))
    i += 1
  endWhile
endFunction

function TrackNpcAtCrosshair()
  Actor npc = GetActorAtCrosshair()
  if npc
    TrackNpc(npc, GetNpcTrackingMarkerQuestAlias(npc))
  endIf
endFunction

function TrackNpc(Actor npc, int slot)
  if slot != -1
    RemoveTrackingMarker(npc, slot)
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
    if FindNpcAsLoadedReference(npc, loadedReferences) == -1
      Debug.MessageBox("Cannot execute commands for " + npc.GetDisplayName())
    else
      ChooseCommandToApplyToNPC(npc)
    endIf
  endIf
endFunction

Actor function FindNpcByName(String text)
  string pattern = StringOptimizePattern(text)

  int loadedReferences = GetLoadedReferencesFromDB()
  if CAN_SORT_BEFORE_SEARCH
    loadedReferences = JArray.sort(loadedReferences)
    Log("Sorting references...")
  endIf

  int jmFoundNpcs = JMap.object()
  JValue.retain(jmFoundNpcs, GetDbKey())
  int i = 0

  bool exit = false
  while !exit && (i < JArray.Count(loadedReferences)) && (JMap.Count(jmFoundNpcs) < MAX_RESULT_COUNT)
    Actor currentNpc = JArray.getForm(loadedReferences, i) as Actor
    if StringMatch(currentNpc.GetDisplayName(), pattern)
      if I_AM_LUCKY
        Log("Exiting early because 'i_am_lucky' flag is enabled")
        exit = true
      endIf
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
  if SORT_RESULTS
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
  string command = CreateNpcCommandUI(npc, slot != -1)
  if command
    if command == "teleport_to_player"
      npc.MoveTo(player, TELEPORT_RANGE)
    elseIf command == "move_to_npc"
      player.MoveTo(npc, TELEPORT_RANGE)
    elseIf command == "clone_npc"
      string name = CreateNpcNameUI("Choose the name of " + npc.GetDisplayName() + "'s clone")
      if name
        clone = player.PlaceAtMe(npc.GetActorBase()) as Actor
        clone.SetDisplayName(name)
      endIf
    elseIf command == "show_npc_stats"
      ShowNpcStatusUI(npc)
    elseIf command == "open_npc_inventory"
      npc.OpenInventory(abForceOpen = true)
    elseIf command == "delete_npc"
      RemoveNpcAsLoadedReferenceIfExists(npc)
      npc.Disable()
      npc.Delete()
    elseIf command == "toggle_tracking_marker"
      TrackNpc(npc, slot)
    endIf

    if KEEP_MENU_OPENED
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

function RemoveTrackingMarker(Actor npc, int slot)
  ReferenceAlias currentAlias = currentQuest.GetNthAlias(slot) as ReferenceAlias
  currentAlias.Clear()
  currentQuest.SetObjectiveDisplayed(slot - 1, abDisplayed = false, abForce = true)
endFunction

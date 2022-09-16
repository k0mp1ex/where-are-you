Scriptname kxWhereAreYouAlias extends ReferenceAlias

import kxUtils
import kxWhereAreYouLogging
import kxWhereAreYouRepository
import kxWhereAreYouUI

int property KEY_SEARCH hidden
  int function get()
    return ReadSettingsFromDbAsInt(".keys.search")
  endFunction
endProperty

int property KEY_DUMP_LOADED_REFERENCES hidden
  int function get()
    return ReadSettingsFromDbAsInt(".keys.dump_loaded_references")
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

bool property IS_DEBUG_ENABLED hidden
  bool function get()
    return ReadSettingsFromDbAsBool(".debug")
  endFunction
endProperty

float property TELEPORT_RANGE hidden
  float function get()
    return ReadSettingsFromDbAsFloat(".teleport_range")
  endFunction
endProperty

; Check performance hit before enabling
bool property CAN_SORT_BEFORE_SEARCH hidden
  bool function get()
    return ReadSettingsFromDbAsBool(".experimental.sort_before_search")
  endFunction
endProperty

; Check performance hit before enabling
bool property CAN_SEARCH_BY_PATTERN_MATCHING hidden
  bool function get()
    return ReadSettingsFromDbAsBool(".experimental.pattern_matching")
  endFunction
endProperty

Actor player

event OnInit()
  player = Game.GetPlayer()
  InitializeDB()
  Setup()
endEvent

event OnPlayerGameLoad()
  UnregisterForAllKeys()
  Setup()
endEvent

event OnKeyDown(int keyCode)
  if !IsInMenus()
    if keyCode == KEY_SEARCH
      SearchNPC()
    elseIf keyCode == KEY_DUMP_LOADED_REFERENCES
      ListNPCs()
    endIf
  endIf
endEvent

function Setup()
  LoadSettingsAndSaveToDB()
  RegisterForKey(KEY_SEARCH)
  RegisterForKey(KEY_DUMP_LOADED_REFERENCES)
endFunction

function ListNPCs()
  int loadedReferences = GetLoadedReferencesFromDB()
  int i = 0
  while i < JArray.Count(loadedReferences)
    Actor npc = JArray.getForm(loadedReferences, i) as Actor
    LogNpcSlot(npc.GetDisplayName(), i, JArray.Count(loadedReferences))
    i += 1
  endWhile
  if IS_DEBUG_ENABLED
    DumpDbToFile()
  endIf
endFunction

function SearchNPC()  
  string pattern = CreateSearchBoxUI()
  if pattern != ""
    Actor npc = FindNpcByName(pattern)
    if npc
      ChooseCommandToApplyToNPC(npc)
    endIf
  endIf
endFunction

Actor function FindNpcByName(String pattern)
  int loadedReferences = GetLoadedReferencesFromDB()
  if CAN_SORT_BEFORE_SEARCH
    loadedReferences = JArray.sort(loadedReferences)
    Log("Sorting references...")
  endIf
  ;JValue.retain(loadedReferences, GetDbKey())

  int jmFoundNpcs = JMap.object()
  JValue.retain(jmFoundNpcs, GetDbKey())
  int i = 0

  while (i < JArray.Count(loadedReferences)) && (JMap.Count(jmFoundNpcs) < MAX_RESULT_COUNT)
    Actor currentNpc = JArray.getForm(loadedReferences, i) as Actor
    if StringMatch(currentNpc.GetDisplayName(), pattern, CAN_SEARCH_BY_PATTERN_MATCHING)
      JMap.setForm(jmFoundNpcs, currentNpc.GetDisplayName(), currentNpc)
    endIf
    i += 1
  endWhile
  
  Actor npc
  if JMap.Count(jmFoundNpcs) == 0
    Debug.MessageBox(pattern + " not found")
  elseIf JMap.Count(jmFoundNpcs) == 1
    npc = JMap.getForm(jmFoundNpcs, JMap.nextKey(jmFoundNpcs)) as Actor
  else
    npc = ChooseNpcFromList(jmFoundNpcs)
  endIf
  JValue.release(jmFoundNpcs)
  ;JValue.release(loadedReferences)
  return npc
endFunction

Actor function ChooseNpcFromList(int jmFoundNpcs)
  int jaAllNpcNames = JMap.allKeys(jmFoundNpcs)
  if SORT_RESULTS
    Log("Sorting results...")
    jaAllNpcNames = JArray.Sort(jaAllNpcNames)
  endIf

  string name = CreateNpcListUI(jaAllNpcNames)
  if name != ""
    return JMap.GetForm(jmFoundNpcs, name) as Actor
  endIf
endFunction

function ChooseCommandToApplyToNPC(Actor npc)
  string command = CreateNpcCommandUI(npc)
  if command == "teleport_to_player"
    npc.MoveTo(player, TELEPORT_RANGE)
  elseIf command == "move_to_npc"
    player.MoveTo(npc, TELEPORT_RANGE)
  elseIf command == "clone_npc"
    player.PlaceAtMe(npc.GetActorBase())
  elseIf command == "show_npc_stats"
    ShowNpcStatusUI(npc)
  endIf
endFunction

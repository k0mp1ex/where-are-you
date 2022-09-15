Scriptname kxWhereAreYouAlias extends ReferenceAlias

; Settings
int KEY_SEARCH
int KEY_DUMP_LOADED_REFERENCES
int MAX_RESULT_COUNT
bool SORT_RESULTS
bool DEBUG_ENABLED
float TELEPORT_RANGE
; Settings - Experimental - Warn about performance hit before enabling
bool SORT_BEFORE_SEARCH
bool SEARCH_BY_PATTERN_MATCHING

; JContainers
string DB_KEY
int loadedReferences

event OnInit()
  InitializeDB()
  Setup()
endEvent

event OnPlayerGameLoad()
  UnregisterForAllKeys()
  Setup()
endEvent

event OnKeyDown(int keyCode)
  if CanRun()
    loadedReferences = JDB.solveObj("." + DB_KEY + ".loaded_references")
    if keyCode == KEY_SEARCH
      SearchNPC()
    elseIf keyCode == KEY_DUMP_LOADED_REFERENCES
      ListNPCs()
    endIf
  endIf
endEvent

function InitializeDB()
  DB_KEY = "kxWhereAreYou"
  int db = JMap.object()
  JMap.setObj(db, "loaded_references", JArray.object())
  JDB.setObj(DB_KEY, db)
endFunction

function Setup()
  LoadSettings()
  RegisterForKey(KEY_SEARCH)
  RegisterForKey(KEY_DUMP_LOADED_REFERENCES)
endFunction

function LoadSettings()
  string fileName = "Data/" + DB_KEY + ".json"
  int config = JValue.readFromFile(fileName)
  KEY_DUMP_LOADED_REFERENCES = JValue.solveInt(config, ".keys.dump_loaded_references")
  KEY_SEARCH = JValue.solveInt(config, ".keys.search")
  TELEPORT_RANGE = JValue.solveFlt(config, ".teleport_range")
  MAX_RESULT_COUNT = JValue.solveInt(config, ".max_result_count")
  SORT_RESULTS = JValue.solveInt(config, ".sort_results") as bool
  DEBUG_ENABLED = JValue.solveInt(config, ".debug") as bool
  SORT_BEFORE_SEARCH = JValue.solveInt(config, ".experimental.sort_before_search") as bool
  SEARCH_BY_PATTERN_MATCHING = JValue.solveInt(config, ".experimental.pattern_matching") as bool
endFunction

bool function CanRun()
  return !Utility.IsInMenuMode() && !UI.IsMenuOpen("Crafting Menu") && !UI.IsMenuOpen("RaceSex Menu") && !UI.IsMenuOpen("CustomMenu")
endFunction

; Use JContainers
function ListNPCs()
  int i = 0
  while i < JArray.Count(loadedReferences)
    Actor npc = JArray.getForm(loadedReferences, i) as Actor
    LogNpcSlot(npc.GetDisplayName(), i, JArray.Count(loadedReferences))
    i += 1
  endWhile
endFunction

function SearchNPC()
  string menu = "UITextEntryMenu"
  UIExtensions.InitMenu(menu)
  UIExtensions.OpenMenu(menu)
  string pattern = UIExtensions.GetMenuResultString(menu)
  if pattern != ""
    Actor npc = FindNpcByName(pattern)
    if npc
      ChooseCommandToApplyToNPC(npc)
    endIf
  endIf
endFunction

Actor function FindNpcByName(String pattern)
  if SORT_BEFORE_SEARCH
    loadedReferences = JArray.sort(loadedReferences)
    Log("Sorting references...")
  endIf

  int jmFoundNpcs = JMap.object()
  JValue.retain(jmFoundNpcs, DB_KEY)
  int i = 0

  while (i < JArray.Count(loadedReferences)) && (JMap.Count(jmFoundNpcs) < MAX_RESULT_COUNT)
    Actor currentNpc = JArray.getForm(loadedReferences, i) as Actor
    if kxUtils.StringMatch(currentNpc.GetDisplayName(), pattern, SEARCH_BY_PATTERN_MATCHING)
      JMap.setForm(jmFoundNpcs, currentNpc.GetDisplayName(), currentNpc)
    endIf
    i += 1
  endWhile
  
  Actor npc
  if JMap.Count(jmFoundNpcs) == 0
    Debug.MessageBox(pattern + " not found")
  elseIf JMap.Count(jmFoundNpcs) == 1
    string npcKey = JMap.nextKey(jmFoundNpcs)
    npc = JMap.getForm(jmFoundNpcs, npcKey) as Actor
  else
    npc = ChooseNpcFromList(jmFoundNpcs)
  endIf
  JValue.release(jmFoundNpcs)
  return npc
endFunction

Actor function ChooseNpcFromList(int jmFoundNpcs)
  UIListMenu listMenu = UIExtensions.GetMenu("UIListMenu") as UIListMenu

  int jaAllNpcNames = JMap.allKeys(jmFoundNpcs)
  if SORT_RESULTS
    Log("Sorting results...")
    jaAllNpcNames = JArray.Sort(jaAllNpcNames)
  endIf

  int i = 0
  while i < JArray.Count(jaAllNpcNames)
    string npcName = JArray.getStr(jaAllNpcNames, i)
    listMenu.AddEntryItem(npcName)
    LogNpcSlot(npcName + " added to search list", i, JArray.Count(jaAllNpcNames))
    i += 1
  endWhile

  listMenu.OpenMenu()

  Actor npc
  string npcNameSelected = listMenu.GetResultString()
  if npcNameSelected != ""
    npc = JMap.GetForm(jmFoundNpcs, npcNameSelected) as Actor
    return npc
  endIf
endFunction

function ChooseCommandToApplyToNPC(Actor npc)
  UIWheelMenu wheelMenu = UIExtensions.GetMenu("UIWheelMenu") as UIWheelMenu
  AddOptionToWheel(wheelMenu, 1, "Teleport to me", "book_map")
  AddOptionToWheel(wheelMenu, 2, "Go there", "armor_feet")
  AddOptionToWheel(wheelMenu, 5, "Clone", "mag_powers")
  AddOptionToWheel(wheelMenu, 6, "Stats", "default_book_read")
  int result = wheelMenu.OpenMenu(npc)
  if result == 1
    npc.MoveTo(Game.GetPlayer(), TELEPORT_RANGE)
  elseIf result == 2
    Game.GetPlayer().MoveTo(npc, TELEPORT_RANGE)
  elseIf result == 5
    Game.GetPlayer().PlaceAtMe(npc.GetActorBase())
  elseIf result == 6
    ShowNpcStatus(npc)
  endIf
endFunction

function ShowNpcStatus(Actor npc)
  UIStatsMenu statsMenu = UIExtensions.GetMenu("UIStatsMenu") as UIStatsMenu
  statsMenu.OpenMenu(npc)
endFunction

function AddOptionToWheel(UIWheelMenu wheelMenu, int i, string content, string iconName)
  wheelMenu.SetPropertyIndexString("optionText", i, content)
  wheelMenu.SetPropertyIndexString("optionLabelText", i, content)
  wheelMenu.SetPropertyIndexBool("optionEnabled", i, true)
  wheelMenu.SetPropertyIndexString("optionIcon", i, iconName)
  wheelMenu.SetPropertyIndexInt("optionIconColor", i, 0xc8197ec)
;  wheelMenu.SetPropertyIndexInt("optionTextColor", i, 0xc07626)
endFunction

function LogNpcSlot(string name, int index, int size)
  Log((index + 1) + "/" + size + ": " + name)
endFunction

function Log(string msg)
  string fullMessage = "[WhereAreYou] " + msg
  Debug.Trace(fullMessage)
  if DEBUG_ENABLED
    MiscUtil.PrintConsole(fullMessage)
  endIf
endFunction

Scriptname kxWhereAreYouQuest extends Quest

FormList Property kxWhereAreYouNPCs auto
FormList Property kxWhereAreYouMarkedNPCs auto

int KEY_SEARCH
int KEY_LIST
bool DEBUG_ENABLED

float TELEPORT_RANGE = 100.0

event OnInit()
  string fileName = "../../../kxWhereAreYou.json"
  KEY_LIST = JsonUtil.GetPathIntValue(fileName, ".keys.list", -1)
  KEY_SEARCH = JsonUtil.GetPathIntValue(fileName, ".keys.search", -1)
  DEBUG_ENABLED = JsonUtil.GetPathBoolValue(fileName, ".debug")
  Debug.MessageBox("KEY_LIST " + KEY_LIST)
  Debug.MessageBox("KEY_SEARCH " + KEY_SEARCH)
  Debug.MessageBox("DEBUG_ENABLED " + DEBUG_ENABLED)
  RegisterForKey(KEY_SEARCH)
  RegisterForKey(KEY_LIST)
endEvent

event OnKeyDown(int keyCode)
  if CanRun()
    if keyCode == KEY_SEARCH
      SearchNPC()
    elseIf keyCode == KEY_LIST
      ListNPCs()
    endIf
  endIf
endEvent

bool function CanRun()
  return !Utility.IsInMenuMode() && !UI.IsMenuOpen("Crafting Menu") && !UI.IsMenuOpen("RaceSex Menu") && !UI.IsMenuOpen("CustomMenu")
endFunction

function ListNPCs()
  int i = 0
  while i < kxWhereAreYouNPCs.GetSize()
    Actor npc = kxWhereAreYouNPCs.GetAt(i) as Actor
    LogN(npc.GetDisplayName(), i, kxWhereAreYouNPCs.GetSize())
    i += 1
  endWhile
endFunction

function SearchNPC()
  string menu = "UITextEntryMenu"
  UIExtensions.InitMenu(menu)
  UIExtensions.OpenMenu(menu)
  string result = UIExtensions.GetMenuResultString(menu)
  if result != ""
    Actor npc = FindNpcByName(result)
    if npc
      ChooseCommandToApplyToNPC(npc)
    endIf
  endIf
endFunction

Actor function FindNpcByName(String name)
  Form[] npcs = Utility.CreateFormArray(0)
  int i = 0
  while i < kxWhereAreYouNPCs.GetSize()
    Actor currentNpc = kxWhereAreYouNPCs.GetAt(i) as Actor
    if StringUtil.Find(currentNpc.GetDisplayName(), name) > -1
      npcs = Utility.ResizeFormArray(npcs, npcs.Length + 1)
      npcs[npcs.Length - 1] = currentNpc
    endIf
    i += 1
  endWhile
  if npcs.Length == 0
    Debug.MessageBox(name + " not found.")
    return none
  elseIf npcs.Length == 1
    return npcs[0] as Actor
  else
    return ShowListToChooseNpc(npcs)
  endIf
endFunction

Actor function ShowListToChooseNpc(Form[] npcs)
  UIListMenu listMenu = UIExtensions.GetMenu("UIListMenu") as UIListMenu

  listMenu.SetPropertyInt("totalEntries", npcs.Length)

  int i = 0
  while i < npcs.Length
    Actor npc = npcs[i] as Actor
    listMenu.AddEntryItem(npc.GetDisplayName())
    LogN(npc.GetDisplayName() + " added to search list", i, npcs.Length)
    i += 1
  endWhile

  listMenu.OpenMenu()

  int resultIndex = listMenu.GetResultInt()
  if resultIndex > -1
    return npcs[resultIndex] as Actor
  endIf
endFunction

function ChooseCommandToApplyToNPC(Actor npc)
  UIWheelMenu wheelMenu = UIExtensions.GetMenu("UIWheelMenu") as UIWheelMenu
  AddOptionToWheel(wheelMenu, 1, "Teleport to me", "book_map")
  AddOptionToWheel(wheelMenu, 2, "Go there", "armor_feet")
  AddOptionToWheel(wheelMenu, 5, "Clone", "mag_powers")
  AddOptionToWheel(wheelMenu, 6, "Add marker", "magic_shock")
  int result = wheelMenu.OpenMenu(npc)
  if result == 1
    npc.MoveTo(Game.GetPlayer(), TELEPORT_RANGE)
  elseIf result == 2
    Game.GetPlayer().MoveTo(npc, TELEPORT_RANGE)
  elseIf result == 5
    Game.GetPlayer().PlaceAtMe(npc.GetActorBase())
  elseIf result == 6
    Spell markerSpell = Game.GetFormFromFile(0x801, "kxWhereAreYou.esp") as Spell
    if markerSpell
      Log("Adding marker to NPC " + npc.GetDisplayName())
      markerSpell.Cast(Game.GetPlayer(), npc)
      ; npc.AddSpell(markerSpell)
    endIf
  endIf
endFunction

function AddOptionToWheel(UIWheelMenu wheelMenu, int i, string content, string iconName)
  wheelMenu.SetPropertyIndexString("optionText", i, content)
  wheelMenu.SetPropertyIndexString("optionLabelText", i, content)
  wheelMenu.SetPropertyIndexBool("optionEnabled", i, true)
  wheelMenu.SetPropertyIndexString("optionIcon", i, iconName)
  wheelMenu.SetPropertyIndexInt("optionIconColor", i, 0xc8197ec)
;  wheelMenu.SetPropertyIndexInt("optionTextColor", i, 0xc07626)
endFunction

function AddMapMarker(ObjectReference objMarked, Actor akTarget)
  Debug.Notification("Adding marker for " + akTarget.GetDisplayName())
endFunction

function RemoveMapMarker(ObjectReference objMarked, Actor akTarget)
  Debug.Notification("Removing marker for " + akTarget.GetDisplayName())
endFunction

function LogN(string msg, int index, int size)
  Log((index + 1) + "/" + size + ": " + msg)
endFunction

function Log(string msg)
  if DEBUG_ENABLED
    MiscUtil.PrintConsole("[WhereAreYou] " + msg)
  endIf
endFunction

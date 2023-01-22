Scriptname kxWhereAreYouUI hidden

import kxUtils
import kxWhereAreYouCommon
import kxWhereAreYouLogging
import kxWhereAreYouNative
import kxWhereAreYouProperties

string function CreateSearchBoxUI() global
  string menu = "UITextEntryMenu"
  UIExtensions.InitMenu(menu)
  UIExtensions.OpenMenu(menu)
  return UIExtensions.GetMenuResultString(menu)
endFunction

string function CreateNpcCommandUI(Actor npc, Quest currentQuest) global
  int[] slots = GetCommandsSlots(npc, currentQuest)
  string[] names = GetCommandsNames(npc, currentQuest)
  string[] descriptions = GetCommandsDescriptions(npc, currentQuest)
  string[] icons = GetCommandsIcons(npc, currentQuest)

  string command
  if COMMANDS_VISUALIZATION_TYPE() == "wheel"
    command = CreateCommandWheelUI(npc, slots, names, descriptions, icons)
  else
    command = CreateCommandListUI(npc, slots, names, descriptions)
  endIf   
  return command
endFunction

string function CreateCommandWheelUI(Actor npc, int[] slots, string[] names, string[] descriptions, string[] icons)  global
  UIWheelMenu wheelMenu = UIExtensions.GetMenu("UIWheelMenu") as UIWheelMenu

  int i = 0
  while i < slots.Length
    AddOptionToWheel(wheelMenu, slots[i], descriptions[i], icons[i])
    i += 1
  endWhile

  int resultIndex = wheelMenu.OpenMenu(npc)
  
  i = 0
  bool exit = false
  string command
  while !exit && i < slots.Length
    if slots[i] == resultIndex
      command = names[i]
      exit = true
    endIf
    i += 1
  endWhile

  return command
endFunction

string function CreateCommandListUI(Actor npc, int[] slots, string[] names, string[] descriptions) global
  UIListMenu listMenu = UIExtensions.GetMenu("UIListMenu") as UIListMenu

  listMenu.AddEntryItem("[" + npc.GetDisplayName() + "]")
  int i = 0
  while i < slots.Length
    listMenu.AddEntryItem(descriptions[i])
    i += 1
  endWhile

  listMenu.OpenMenu()
  string command
  int id = listMenu.GetResultInt()

  if id != -1
    if id == 0
      return CreateCommandListUI(npc, slots, names, descriptions)
    else
      command = names[id - 1]
    endIf
  endIf

  return command
endFunction

function AddOptionToWheel(UIWheelMenu wheelMenu, int i, string content, string iconName) global
  wheelMenu.SetPropertyIndexString("optionText", i, content)
  wheelMenu.SetPropertyIndexString("optionLabelText", i, content)
  wheelMenu.SetPropertyIndexBool("optionEnabled", i, true)
  wheelMenu.SetPropertyIndexString("optionIcon", i, iconName)
  wheelMenu.SetPropertyIndexInt("optionIconColor", i, HexadecimalStringToInteger(DEFAULT_COLOR()))
endFunction

function ShowNpcStatsUI(Actor npc) global
  UIStatsMenu statsMenu = UIExtensions.GetMenu("UIStatsMenu") as UIStatsMenu
  statsMenu.OpenMenu(npc)
endFunction

function ShowNpcInfoUI(string statsText) global
  ShowMessage(statsText)
endFunction

Actor function CreateNpcListUI(Actor[] actors, Quest currentQuest) global
  UIListMenu listMenu = UIExtensions.GetMenu("UIListMenu") as UIListMenu
  int i = 0
  while i < actors.Length
    Actor currentActor = actors[i]
    string entry = GetSummaryDataForActor(currentActor, currentQuest, ENTRY_FORMAT())
    listMenu.AddEntryItem(entry)
    i += 1
  endWhile
  listMenu.OpenMenu()
  int id = listMenu.GetResultInt()
  if id != -1
    return actors[id]
  endIf
endFunction

function ShowMessage(string msg) global
  Debug.MessageBox(msg)
  Log(msg)
endFunction

function ShowNotification(string msg, bool showModName = false) global
  if showModName
    msg = "[" + GetModName() + "] " + msg
  endIf
  Debug.Notification(msg)
  Log(msg)
endFunction

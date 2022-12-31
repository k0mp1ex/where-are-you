Scriptname kxWhereAreYouUI hidden

import kxUtils
import kxWhereAreYouCommon
import kxWhereAreYouLogging
import kxWhereAreYouProperties

string function CreateSearchBoxUI() global
  string menu = "UITextEntryMenu"
  UIExtensions.InitMenu(menu)
  UIExtensions.OpenMenu(menu)
  return UIExtensions.GetMenuResultString(menu)
endFunction

string function CreateNpcCommandUI(Actor npc, bool hasTrackingMarker) global
  int jaCommands = GetCommandOptions(npc, hasTrackingMarker)
  string command

  if JArray.Count(jaCommands) > 0
    if COMMANDS_VISUALIZATION_TYPE() == "wheel"
      command = CreateCommandWheelUI(npc, jaCommands)
    else
      command = CreateCommandListUI(npc, jaCommands)
    endIf   
  endIf
  JValue.release(jaCommands)
  return command
endFunction

string function CreateCommandWheelUI(Actor npc, int jaCommands) global
  UIWheelMenu wheelMenu = UIExtensions.GetMenu("UIWheelMenu") as UIWheelMenu

  int i = 0
  while i < JArray.Count(jaCommands)
    int jmCommand = JArray.GetObj(jaCommands, i)
    AddOptionToWheel(wheelMenu, JMap.GetInt(jmCommand, "slot"), JMap.GetStr(jmCommand, "description"), JMap.GetStr(jmCommand, "icon"))  
    i += 1
  endwhile

  int resultIndex = wheelMenu.OpenMenu(npc)
  i = 0
  bool exit = false
  string command
  while !exit && i < JArray.Count(jaCommands)
    int jmCommand = JArray.GetObj(jaCommands, i)
    if resultIndex == JMap.GetInt(jmCommand, "slot")
      command = JMap.GetStr(jmCommand, "command")
      exit = true
    endIf
    i += 1
  endWhile

  return command
endFunction

string function CreateCommandListUI(Actor npc, int jaCommands) global
  UIListMenu listMenu = UIExtensions.GetMenu("UIListMenu") as UIListMenu

  listMenu.AddEntryItem("[" + npc.GetDisplayName() + "]")
  int i = 0
  while i < JArray.Count(jaCommands)
    int jmCommand = JArray.GetObj(jaCommands, i)
    listMenu.AddEntryItem(JMap.GetStr(jmCommand, "description"))
    i += 1
  endWhile

  listMenu.OpenMenu()
  string command
  int id = listMenu.GetResultInt()

  if id != -1
    if id == 0
      return CreateCommandListUI(npc, jaCommands)
    else
      int jmCommand = JArray.GetObj(jaCommands, id - 1)
      command = JMap.GetStr(jmCommand, "command")
    endIf
  endIf

  return command
endFunction

int function GetCommandOptions(Actor npc, bool hasTrackingMarker) global
  int jmStats = JMap.object()
  JMap.SetStr(jmStats, "command",         "show_npc_stats")
  JMap.SetStr(jmStats, "description",     "Stats")
  JMap.SetStr(jmStats, "icon",            STATS_ICON_NAME())

  int jmInfo = JMap.object()
  JMap.SetStr(jmInfo, "command",         "show_npc_info")
  JMap.SetStr(jmInfo, "description",     "Info")
  JMap.SetStr(jmInfo, "icon",            INFO_ICON_NAME())

  int jmTeleport = JMap.object()
  JMap.SetStr(jmTeleport, "command",      "teleport_to_player")
  JMap.SetStr(jmTeleport, "description",  "Teleport")
  JMap.SetStr(jmTeleport, "icon",         TELEPORT_ICON_NAME())

  int jmVisit = JMap.object()
  JMap.SetStr(jmVisit, "command",         "move_to_npc")
  JMap.SetStr(jmVisit, "description",     "Visit")
  JMap.SetStr(jmVisit, "icon",            VISIT_ICON_NAME())

  int jmDoFavor = JMap.object()
  JMap.SetStr(jmDoFavor, "command",       "do_favor")
  JMap.SetStr(jmDoFavor, "description",   "Do Favor")
  JMap.SetStr(jmDoFavor, "icon",          DO_FAVOR_ICON_NAME())

  int jmInventory = JMap.object()
  JMap.SetStr(jmInventory, "command",     "open_npc_inventory")
  JMap.SetStr(jmInventory, "description", "Inventory")
  JMap.SetStr(jmInventory, "icon",        INVENTORY_ICON_NAME())

  int jmTrack = JMap.object()
  JMap.SetStr(jmTrack, "command",         "toggle_track_npc")
  string trackMessage = "Track"
  if hasTrackingMarker
    trackMessage = "Untrack"
  endIf
  JMap.SetStr(jmTrack, "description",     trackMessage)
  JMap.SetStr(jmTrack, "icon",            TRACK_ICON_NAME())

  int jaCommands = JArray.object()
  JValue.retain(jaCommands)

  if SHOW_STATS_COMMAND()
    JArray.AddObj(jaCommands, jmStats)
  endIf
  if SHOW_INFO_COMMAND()
    JArray.AddObj(jaCommands, jmInfo)
  endIf
  if SHOW_INVENTORY_COMMAND()
    JArray.AddObj(jaCommands, jmInventory)
  endIf
  if SHOW_TELEPORT_COMMAND()
    JArray.AddObj(jaCommands, jmTeleport)
  endIf
  if SHOW_VISIT_COMMAND()
    JArray.AddObj(jaCommands, jmVisit)
  endIf
  if SHOW_TRACK_COMMAND()
    JArray.AddObj(jaCommands, jmTrack)
  endIf
  if SHOW_DO_FAVOR_COMMAND() && (!ONLY_FOLLOWERS_DO_FAVOR() || npc.IsPlayerTeammate())
    JArray.AddObj(jaCommands, jmDoFavor)
  endIf;

  int size = JArray.Count(jaCommands)

  if size == 1
    JMap.SetInt(JArray.GetObj(jaCommands, 0), "slot", 1)
  elseIf size == 2
    JMap.SetInt(JArray.GetObj(jaCommands, 0), "slot", 1)
    JMap.SetInt(JArray.GetObj(jaCommands, 1), "slot", 5)
  elseIf size == 3
    JMap.SetInt(JArray.GetObj(jaCommands, 0), "slot", 1)
    JMap.SetInt(JArray.GetObj(jaCommands, 1), "slot", 2)
    JMap.SetInt(JArray.GetObj(jaCommands, 2), "slot", 5)
  elseIf size == 4
    JMap.SetInt(JArray.GetObj(jaCommands, 0), "slot", 1)
    JMap.SetInt(JArray.GetObj(jaCommands, 1), "slot", 2)
    JMap.SetInt(JArray.GetObj(jaCommands, 2), "slot", 5)
    JMap.SetInt(JArray.GetObj(jaCommands, 3), "slot", 6)
  elseIf size == 5
    JMap.SetInt(JArray.GetObj(jaCommands, 0), "slot", 0)
    JMap.SetInt(JArray.GetObj(jaCommands, 1), "slot", 1)
    JMap.SetInt(JArray.GetObj(jaCommands, 2), "slot", 2)
    JMap.SetInt(JArray.GetObj(jaCommands, 3), "slot", 5)
    JMap.SetInt(JArray.GetObj(jaCommands, 4), "slot", 6)
  elseIf size == 6
    JMap.SetInt(JArray.GetObj(jaCommands, 0), "slot", 0)
    JMap.SetInt(JArray.GetObj(jaCommands, 1), "slot", 1)
    JMap.SetInt(JArray.GetObj(jaCommands, 2), "slot", 2)
    JMap.SetInt(JArray.GetObj(jaCommands, 3), "slot", 4)
    JMap.SetInt(JArray.GetObj(jaCommands, 4), "slot", 5)
    JMap.SetInt(JArray.GetObj(jaCommands, 5), "slot", 6)
  elseIf size == 7
    JMap.SetInt(JArray.GetObj(jaCommands, 0), "slot", 0)
    JMap.SetInt(JArray.GetObj(jaCommands, 1), "slot", 1)
    JMap.SetInt(JArray.GetObj(jaCommands, 2), "slot", 2)
    JMap.SetInt(JArray.GetObj(jaCommands, 3), "slot", 3)
    JMap.SetInt(JArray.GetObj(jaCommands, 4), "slot", 4)
    JMap.SetInt(JArray.GetObj(jaCommands, 5), "slot", 5)
    JMap.SetInt(JArray.GetObj(jaCommands, 6), "slot", 6)
  elseIf size == 8
    JMap.SetInt(JArray.GetObj(jaCommands, 0), "slot", 0)
    JMap.SetInt(JArray.GetObj(jaCommands, 1), "slot", 1)
    JMap.SetInt(JArray.GetObj(jaCommands, 2), "slot", 2)
    JMap.SetInt(JArray.GetObj(jaCommands, 3), "slot", 3)
    JMap.SetInt(JArray.GetObj(jaCommands, 4), "slot", 4)
    JMap.SetInt(JArray.GetObj(jaCommands, 5), "slot", 5)
    JMap.SetInt(JArray.GetObj(jaCommands, 6), "slot", 6)
    JMap.SetInt(JArray.GetObj(jaCommands, 7), "slot", 7)
  endIf

  return jaCommands
endFunction

function AddOptionToWheel(UIWheelMenu wheelMenu, int i, string content, string iconName) global
  wheelMenu.SetPropertyIndexString("optionText", i, content)
  wheelMenu.SetPropertyIndexString("optionLabelText", i, content)
  wheelMenu.SetPropertyIndexBool("optionEnabled", i, true)
  wheelMenu.SetPropertyIndexString("optionIcon", i, iconName)
  wheelMenu.SetPropertyIndexInt("optionIconColor", i, kxWhereAreYouNative.HexadecimalStringToInteger(DEFAULT_COLOR()))
endFunction

function ShowNpcStatsUI(Actor npc) global
  UIStatsMenu statsMenu = UIExtensions.GetMenu("UIStatsMenu") as UIStatsMenu
  statsMenu.OpenMenu(npc)
endFunction

function ShowNpcInfoUI(string statsText) global
  ShowMessage(statsText)
endFunction

Actor function CreateNpcListUI(Actor[] actors) global
  UIListMenu listMenu = UIExtensions.GetMenu("UIListMenu") as UIListMenu
  int i = 0
  while i < actors.Length
    Actor currentActor = actors[i]
    string entry = kxWhereAreYouNative.GetSummaryDataForActor(currentActor, ENTRY_FORMAT())
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

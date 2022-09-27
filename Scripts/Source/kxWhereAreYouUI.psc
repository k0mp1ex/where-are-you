Scriptname kxWhereAreYouUI hidden

import kxUtils
import kxWhereAreYouLogging

string function CreateSearchBoxUI() global
  string menu = "UITextEntryMenu"
  UIExtensions.InitMenu(menu)
  UIExtensions.OpenMenu(menu)
  return UIExtensions.GetMenuResultString(menu)
endFunction

string function CreateNpcCommandUI(Actor npc, bool hasTrackingMarker = false) global
  UIWheelMenu wheelMenu = UIExtensions.GetMenu("UIWheelMenu") as UIWheelMenu
  AddOptionToWheel(wheelMenu, 0, "Stats", "default_book_read")
  AddOptionToWheel(wheelMenu, 1, "Teleport to me", "book_map")
  AddOptionToWheel(wheelMenu, 2, "Visit", "armor_feet")
  AddOptionToWheel(wheelMenu, 4, "Delete", "misc_remains")
  AddOptionToWheel(wheelMenu, 5, "Inventory", "inv_all")
  AddOptionToWheel(wheelMenu, 6, "Clone", "mag_powers")
  string trackMessage = "Track"
  if hasTrackingMarker
    trackMessage = "Untrack"
  endIf
  AddOptionToWheel(wheelMenu, 7, trackMessage, "magic_shock")

  int result = wheelMenu.OpenMenu(npc)
  if result == 0
    return "show_npc_stats"
  elseIf result == 1
    return "teleport_to_player"
  elseIf result == 2
    return "move_to_npc"
  elseIf result == 4
    return "delete_npc"
  elseIf result == 5
    return "open_npc_inventory"
  elseIf result == 6
    return "clone_npc"
  elseIf result == 7
    return "toggle_tracking_marker"
  endIf
endFunction

function AddOptionToWheel(UIWheelMenu wheelMenu, int i, string content, string iconName) global
  wheelMenu.SetPropertyIndexString("optionText", i, content)
  wheelMenu.SetPropertyIndexString("optionLabelText", i, content)
  wheelMenu.SetPropertyIndexBool("optionEnabled", i, true)
  wheelMenu.SetPropertyIndexString("optionIcon", i, iconName)
  wheelMenu.SetPropertyIndexInt("optionIconColor", i, 0xc8197ec); blue
endFunction

string function CreateNpcNameUI(string msg = "") global
  if msg
    Debug.MessageBox(msg)
  endIf
  WaitForMenus()
  return CreateSearchBoxUI()
endFunction

function ShowNpcStatusUI(Actor npc) global
  UIStatsMenu statsMenu = UIExtensions.GetMenu("UIStatsMenu") as UIStatsMenu
  statsMenu.OpenMenu(npc)
endFunction

string function CreateNpcListUI(int jaAllNpcNames) global
  UIListMenu listMenu = UIExtensions.GetMenu("UIListMenu") as UIListMenu
  int i = 0
  while i < JArray.Count(jaAllNpcNames)
    string npcName = JArray.getStr(jaAllNpcNames, i)
    listMenu.AddEntryItem(npcName)
    LogNpcSlot(npcName + " added to search list", i, JArray.Count(jaAllNpcNames))
    i += 1
  endWhile
  listMenu.OpenMenu()
  return listMenu.GetResultString()
endFunction

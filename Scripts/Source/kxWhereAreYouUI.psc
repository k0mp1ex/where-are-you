Scriptname kxWhereAreYouUI hidden

import kxWhereAreYouLogging

string function CreateSearchBoxUI() global
  string menu = "UITextEntryMenu"
  UIExtensions.InitMenu(menu)
  UIExtensions.OpenMenu(menu)
  return UIExtensions.GetMenuResultString(menu)
endFunction

string function CreateNpcCommandUI(Actor npc) global
  UIWheelMenu wheelMenu = UIExtensions.GetMenu("UIWheelMenu") as UIWheelMenu
  AddOptionToWheel(wheelMenu, 1, "Teleport to me", "book_map")
  AddOptionToWheel(wheelMenu, 2, "Go there", "armor_feet")
  AddOptionToWheel(wheelMenu, 5, "Clone", "mag_powers")
  AddOptionToWheel(wheelMenu, 6, "Stats", "default_book_read")
  
  int result = wheelMenu.OpenMenu(npc)
  if result == 1
    return "teleport_to_player"
  elseIf result == 2
    return "move_to_npc"
  elseIf result == 5
    return "clone_npc"
  elseIf result == 6
    return "show_npc_stats"
  endIf
endFunction

function AddOptionToWheel(UIWheelMenu wheelMenu, int i, string content, string iconName) global
  wheelMenu.SetPropertyIndexString("optionText", i, content)
  wheelMenu.SetPropertyIndexString("optionLabelText", i, content)
  wheelMenu.SetPropertyIndexBool("optionEnabled", i, true)
  wheelMenu.SetPropertyIndexString("optionIcon", i, iconName)
  wheelMenu.SetPropertyIndexInt("optionIconColor", i, 0xc8197ec); blue
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

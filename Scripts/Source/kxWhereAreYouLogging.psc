Scriptname kxWhereAreYouLogging hidden

import kxUtils
import kxWhereAreYouCommon
import kxWhereAreYouRepository

function LogNpcSlot(string name, int index, int size) global
  Log((index + 1) + "/" + size + ": " + name)
endFunction

function Log(string msg) global
  string fullMessage = "[" + GetModName() + "@v" + GetModVersionAsString(GetModVersion()) + "] " + msg
  bool isDebugEnabled = ReadSettingsFromDbAsBool(".debug")
  Debug.Trace(fullMessage)
  if isDebugEnabled
    MiscUtil.PrintConsole(fullMessage)
  endIf
endFunction

Scriptname kxWhereAreYouLogging hidden

import kxUtils
import kxWhereAreYouCommon
import kxWhereAreYouProperties

function LogNpcSlot(string name, int index, int size) global
  Log((index + 1) + "/" + size + ": " + name)
endFunction

function Log(string msg) global
  string fullMessage = "[" + GetModName() + "@v" + GetModVersionAsString(GetModVersion()) + "] " + msg
  Debug.Trace(fullMessage)
  if IS_DEBUG_ENABLED()
    MiscUtil.PrintConsole(fullMessage)
  endIf
endFunction

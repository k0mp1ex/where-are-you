Scriptname kxWhereAreYouLogging hidden

import kxUtils
import kxWhereAreYouCommon
import kxWhereAreYouNative
import kxWhereAreYouProperties

function Log(string msg) global
  string fullMessage = "[" + GetModName() + "@v" + GetModVersionAsString(GetModVersion()) + "] " + msg
  Debug.Trace(fullMessage)
  if IS_DEBUG_ENABLED()
    PrintToConsole(fullMessage)
  endIf
endFunction

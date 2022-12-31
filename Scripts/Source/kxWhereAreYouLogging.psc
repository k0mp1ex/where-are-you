Scriptname kxWhereAreYouLogging hidden

import kxUtils
import kxWhereAreYouCommon
import kxWhereAreYouProperties

function Log(string msg) global
  string fullMessage = "[" + GetModName() + "@v" + GetModVersionAsString(GetModVersion()) + "] " + msg
  Debug.Trace(fullMessage)
  if IS_DEBUG_ENABLED()
    kxWhereAreYouNative.PrintToConsole(fullMessage)
  endIf
endFunction

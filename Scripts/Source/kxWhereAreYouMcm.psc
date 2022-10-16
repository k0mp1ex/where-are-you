Scriptname kxWhereAreYouMcm extends MCM_ConfigBase

import kxWhereAreYouLogging
import kxWhereAreYouRepository

function OnConfigClose()
  kxWhereAreYouAlias playerAlias = GetNthAlias(0) as kxWhereAreYouAlias
  playerAlias.UnregisterForAllKeys()
  playerAlias.RegisterForAllKeys()
endFunction

function ExportData()
  DumpDbToFile()
  kxWhereAreYouUI.ShowMessage("Data saved on\n" + GetDumpDbFileName())
endFunction

function UpdateData()
  kxWhereAreYouUI.ShowMessage("The update will run in the background and you'll see a notification when it's done.\nYou can close the MCM now.")
  kxWhereAreYouAlias playerAlias = GetNthAlias(0) as kxWhereAreYouAlias
  playerAlias.UpdateReferences()
endFunction

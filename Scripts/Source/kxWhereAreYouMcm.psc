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

; TODO: Fix and then reenable MCM toggle
; function ResetData()
;   kxWhereAreYouAlias playerAlias = GetNthAlias(0) as kxWhereAreYouAlias
;   playerAlias.RemoveAllTrackingMarkers()
;   RemoveAllClonedNpcs()
;   ResetDB()
;   InitializeDB()
;   kxWhereAreYouUI.ShowMessage("The data has been reset.")
; endFunction

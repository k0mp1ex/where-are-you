Scriptname kxWhereAreYouMcm extends MCM_ConfigBase

import kxWhereAreYouLogging
import kxWhereAreYouRepository

kxWhereAreYouAlias property kxWhereAreYouAliasProperty auto

function OnConfigClose()
  kxWhereAreYouAliasProperty.UnregisterForAllKeys()
  kxWhereAreYouAliasProperty.RegisterForAllKeys()
endFunction

function ResetData()
  RemoveAllClonedNpcs()
  kxWhereAreYouAliasProperty.RemoveAllTrackingMarkers()
  ResetDB()
  Debug.MessageBox("The data has been reset.")
endFunction

function ExportData()
  DumpNpcList()
  DumpDbToFile()
  Debug.MessageBox("Data saved on\n" + GetDumpDbFileName())
endFunction

function DumpNpcList()
  int loadedReferences = GetLoadedReferencesFromDB()
  int i = 0
  while i < JArray.Count(loadedReferences)
    Actor npc = JArray.getForm(loadedReferences, i) as Actor
    LogNpcSlot(npc.GetDisplayName(), i, JArray.Count(loadedReferences))
    i += 1
  endWhile
endFunction
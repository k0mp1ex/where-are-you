Scriptname kxWhereAreYouRepository hidden

import kxWhereAreYouCommon
import kxWhereAreYouLogging

string function GetDbKey() global
  return GetModName()
endFunction

string function GetSettingsFileName() global
  return "Data/" + GetModName() + "/settings.json"
endFunction

string function GetDumpDbFileName() global
  return "Data/" + GetModName() + "/.debug/dump.json"
endFunction

function InitializeDB() global
  Log("Initializing the database...")
  int db = JMap.object()
  JMap.setObj(db, "loaded_references", JArray.object())
  JMap.setObj(db, "settings", JMap.object())
  JDB.setObj(GetDbKey(), db)
endFunction

function ResetDB() global
  Log("Cleaning the database...")
  JDB.setObj(GetDbKey(), 0)
endFunction

function DumpDbToFile() global
  string filename = GetDumpDbFileName()
  JValue.writeToFile(JDB.solveObj(GetPropertyPath("")), filename)
endFunction

function LoadSettingsAndSaveToDB() global
  string fileName = GetSettingsFileName()
  int config = JValue.readFromFile(fileName)
  JDB.solveObjSetter(GetPropertyPath(".settings"), config, createMissingKeys = true)
endFunction

int function GetLoadedReferencesFromDB() global
  int ref = JDB.solveObj(GetPropertyPath(".loaded_references"), 0)
  if ref == 0
    Log("[Warning] Trying to use .loaded_references before initialization. If the mod has been disabled, ignore this warning.")
  endIf
  return ref
endFunction

string function GetPropertyPath(string propertyPath) global
  return "." + GetDbKey() + propertyPath
endFunction

bool function ReadSettingsFromDbAsBool(string propertyPath) global
  return JDB.solveInt(GetPropertyPath(".settings" + propertyPath)) as bool
endFunction

int function ReadSettingsFromDbAsInt(string propertyPath) global
  return JDB.solveInt(GetPropertyPath(".settings" + propertyPath))
endFunction

float function ReadSettingsFromDbAsFloat(string propertyPath) global
  return JDB.solveFlt(GetPropertyPath(".settings" + propertyPath))
endFunction

function RemoveNpcAsLoadedReferenceIfExists(Actor npc) global
	int loadedReferences = GetLoadedReferencesFromDB()
  if loadedReferences
    int index = FindNpcAsLoadedReference(npc, loadedReferences)
    if index != -1
      JArray.EraseForm(loadedReferences, npc)
      Log(npc.GetDisplayName() + " removed.")
    endIf
  endIf
endFunction

function AddNpcAsLoadedReferenceIfNotExists(Actor npc) global
	int loadedReferences = GetLoadedReferencesFromDB()
  if loadedReferences
    int index = FindNpcAsLoadedReference(npc, loadedReferences)
    if index == -1
      JArray.AddForm(loadedReferences, npc)
      Log(npc.GetDisplayName() + " added.")
    endIf
  endIf
endFunction

int function FindNpcAsLoadedReference(Actor npc, int loadedReferences) global
  return JArray.FindForm(loadedReferences, npc)
endFunction

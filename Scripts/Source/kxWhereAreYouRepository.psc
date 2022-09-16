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
  int db = JMap.object()
  JMap.setObj(db, "loaded_references", JArray.object())
  JMap.setObj(db, "settings", JMap.object())
  JDB.setObj(GetDbKey(), db)
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
  return JDB.solveObj(GetPropertyPath(".loaded_references"))
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

function AddNpcAsLoadedReferenceIfNotExists(Actor npc) global
	int loadedReferences = GetLoadedReferencesFromDB()
	int index = JArray.FindForm(loadedReferences, npc)
	if index == -1
  	JArray.AddForm(loadedReferences, npc)
	endIf
endFunction

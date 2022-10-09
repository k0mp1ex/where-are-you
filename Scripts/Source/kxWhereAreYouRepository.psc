Scriptname kxWhereAreYouRepository hidden

import kxUtils
import kxWhereAreYouCommon
import kxWhereAreYouLogging
import kxWhereAreYouProperties

string function GetDbKey() global
  return GetModName()
endFunction

string function GetDumpDbFileName() global
  return "Data/" + GetModName() + "/Debug/dump.json"
endFunction

string function GetLuaLogFileName() global
  return "Data\\" + GetModName() + "\\Debug\\lua.log"
endFunction

function InitializeDB() global
  Log("Initializing the database...")
  int db = JMap.object()
  JMap.setObj(db, "npcs", JArray.object())
  JMap.setObj(db, "settings", JMap.object())
  JDB.setObj(GetDbKey(), db)
endFunction

function ResetDB() global
  JDB.solveObjSetter(GetPropertyPath(".npcs"), 0)
  JDB.solveObjSetter(GetPropertyPath(".settings"), 0)
  JDB.solveObjSetter(GetPropertyPath(), 0)
endFunction

function DumpDbToFile() global
  string filename = GetDumpDbFileName()
  JValue.writeToFile(JDB.solveObj(GetPropertyPath()), filename)
endFunction

string function GetPropertyPath(string propertyPath = "") global
  return "." + GetDbKey() + propertyPath
endFunction

int function GetReferencesFromDB(string propertyPath) global
  return JDB.solveObj(GetPropertyPath(propertyPath), 0)
endFunction

function AddNpc(Actor npc) global
  int references = GetReferencesFromDB(".npcs")
  int jmNpc = JMap.object()
  JMap.SetInt(jmNpc, "ref_id", npc.GetFormId())
  JMap.SetInt(jmNpc, "base_id", npc.GetActorBase().GetFormID())
  JMap.SetForm(jmNpc, "form", npc)
  JMap.SetStr(jmNpc, "name", npc.GetDisplayName())
  JMap.SetStr(jmNpc, "mod", GetModNameFromForm(npc))
  JMap.SetStr(jmNpc, "race", npc.GetRace().GetName())
  JMap.SetInt(jmNpc, "gender", npc.GetActorBase().GetSex())
  JMap.SetInt(jmNpc, "clone", IsDynamicObjectReference(npc) as int)
  JMap.SetInt(jmNpc, "tracking_slot", -1)
  JArray.addObj(references, jmNpc)
  Log(npc.GetDisplayName() + " added.")
endFunction

function RemoveNpc(Actor npc) global
  int references = GetReferencesFromDB(".npcs")
  int index = GetNpcIndex(npc)
  if index != -1
    JArray.EraseIndex(references, index)
    Log(npc.GetDisplayName() + " removed.")
  endIf
endFunction

function RemoveAllClonedNpcs() global
  int references = GetReferencesFromDB(".npcs")
  int i = 0
  while i < JArray.Count(references)
    int jmNpc = JArray.GetObj(references, i)
    if jmNpc != -1 && (JMap.GetInt(jmNpc, "clone") as bool)
      Log("Removing " + JMap.GetStr(jmNpc, "name"))
      Actor npc = JMap.GetForm(jmNpc, "form") as Actor
      npc.Disable()
      npc.Delete()
    endIf    
    i += 1
  endWhile
endFunction

bool function IsClonedNpc(Actor npc) global
  return IsDynamicObjectReference(npc)
endFunction

function PrepareLuaContext() global
  int settings = JDB.solveObj(GetPropertyPath(".settings"), 0)
  JMap.setStr(settings, "log_file_path", GetLuaLogFileName())
  JMap.setStr(settings, "mod_name", GetModName())
  JMap.setStr(settings, "mod_version", GetModVersionAsString(GetModVersion()))
  JMap.setInt(settings, "debug_enabled", IS_DEBUG_ENABLED() as int)
endFunction

int function GetNpcTrackingMarkerSlot(Actor npc) global
  return kxWhereAreYouLua.GetTrackingSlotForNpc(npc.GetFormId())
endFunction

int function GetNpcIndex(Actor npc) global
  return kxWhereAreYouLua.GetNpcIndex(npc.GetFormId())
endFunction

bool function HasNpc(Actor npc) global
  return GetNpcIndex(npc) != -1
endFunction

bool function IsTrackingNpc(Actor npc) global
  return kxWhereAreYouLua.IsTrackingNpc(npc.GetFormId()) as bool
endFunction

function UpdateNpcTracking(Actor npc, int trackingSlot) global
  kxWhereAreYouLua.UpdateNpcTracking(npc.GetFormId(), trackingSlot)
endFunction

string function GetStatsTextForNpc(Actor npc) global
  return kxWhereAreYouLua.GetStatsTextForNpc(npc.GetFormId()) + "\n" + GetDynamicStatsTextForNpc(npc)
endFunction

string function GetDynamicStatsTextForNpc(Actor npc) global
  return "Location: " + Coalesce(npc.GetCurrentLocation().GetName(), "Tamriel")
endFunction

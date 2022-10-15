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
  JMap.SetStr(jmNpc, "ref_id", npc.GetFormId() as string)
  JMap.SetStr(jmNpc, "base_id", npc.GetActorBase().GetFormID() as string)
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

bool function IsClonedNpc(Actor npc) global
  return IsDynamicObjectReference(npc)
endFunction

int function UpdateModlist() global
  int jaMods = JArray.object()
  JValue.retain(jaMods)

  int i = 0
  while i < Game.GetModCount()
    int jmMod = JMap.object()
    JMap.setStr(jmMod, "name", Game.GetModName(i))
    JMap.setStr(jmMod, "index", i)
    JMap.setInt(jmMod, "light", false as int)
    JArray.addObj(jaMods, jmMod)
    i += 1
  endWhile

  i = 0;
  while i < Game.GetLightModCount()
    int jmMod = JMap.object()
    JMap.setStr(jmMod, "name", Game.GetLightModName(i))
    JMap.setStr(jmMod, "index", i)
    JMap.setInt(jmMod, "light", true as int)
    JArray.addObj(jaMods, jmMod)
    i += 1
  endWhile

  int jaDeletedTrackedNpcs = kxWhereAreYouLua.UpdateModList(jaMods)
  JValue.retain(jaDeletedTrackedNpcs)
  JValue.release(jaMods)

  return jaDeletedTrackedNpcs
endFunction

function PrepareLuaContext() global
  int settings = JDB.solveObj(GetPropertyPath(".settings"), 0)
  JMap.setStr(settings, "log_file_path", GetLuaLogFileName())
  JMap.setStr(settings, "mod_name", GetModName())
  JMap.setStr(settings, "mod_version", GetModVersionAsString(GetModVersion()))
  JMap.setInt(settings, "debug_enabled", IS_DEBUG_ENABLED() as int)
endFunction

int function GetNpcTrackingMarkerSlot(Actor npc) global
  return kxWhereAreYouLua.GetTrackingSlotForNpc(npc.GetFormId() as string)
endFunction

int function GetNpcIndex(Actor npc) global
  return kxWhereAreYouLua.GetNpcIndex(npc.GetFormId() as string)
endFunction

bool function HasNpc(Actor npc) global
  return GetNpcIndex(npc) != -1
endFunction

bool function IsTrackingNpc(Actor npc) global
  return kxWhereAreYouLua.IsTrackingNpc(npc.GetFormId() as string) as bool
endFunction

function UpdateNpcTracking(Actor npc, int trackingSlot) global
  kxWhereAreYouLua.UpdateNpcTracking(npc.GetFormId() as string, trackingSlot)
endFunction

string function GetStatsTextForNpc(Actor npc) global
  return kxWhereAreYouLua.GetStatsTextForNpc(npc.GetFormId() as string, npc.GetCurrentLocation().GetName())
endFunction

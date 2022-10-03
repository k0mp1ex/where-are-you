Scriptname kxWhereAreYouRepository hidden

import kxWhereAreYouCommon
import kxWhereAreYouLogging

string function GetDbKey() global
  return GetModName()
endFunction

string function GetDumpDbFileName() global
  return "Data/" + GetModName() + "/Debug/dump.json"
endFunction

function InitializeDB() global
  Log("Initializing the database...")
  int db = JMap.object()
  JMap.setObj(db, "loaded_references", JArray.object())
  JMap.setObj(db, "cloned_references", JArray.object())
  JDB.setObj(GetDbKey(), db)
endFunction

function ResetDB() global
  Log("Cleaning the database...")
  JDB.solveObjSetter(GetPropertyPath(".loaded_references"), JArray.object())
  JDB.solveObjSetter(GetPropertyPath(".cloned_references"), JArray.object())
endFunction

function DumpDbToFile() global
  string filename = GetDumpDbFileName()
  JValue.writeToFile(JDB.solveObj(GetPropertyPath("")), filename)
endFunction

string function GetPropertyPath(string propertyPath) global
  return "." + GetDbKey() + propertyPath
endFunction

int function GetReferencesFromDB(string propertyPath) global
  return JDB.solveObj(GetPropertyPath(propertyPath), 0)
endFunction

int function GetLoadedReferencesFromDB() global
  return GetReferencesFromDB(".loaded_references")
endFunction

int function GetClonedReferencesFromDB() global
  return GetReferencesFromDB(".cloned_references")
endFunction

function AddNpcAsReference(Actor npc, int references) global
  if references
    int index = FindNpcAsReference(npc, references)
    if index == -1
      JArray.AddForm(references, npc)
      Log(npc.GetDisplayName() + " added.")
    endIf
  endIf
endFunction

function AddNpcAsLoadedReferenceIfNotExists(Actor npc) global
  AddNpcAsReference(npc, GetLoadedReferencesFromDB())
endFunction

function AddNpcAsClonedReferenceIfNotExists(Actor npc) global
  AddNpcAsReference(npc, GetClonedReferencesFromDB())
endFunction

function RemoveNpcAsReferenceIfExists(Actor npc, int references) global
  if references
    int index = FindNpcAsReference(npc, references)
    if index != -1
      JArray.EraseForm(references, npc)
      Log(npc.GetDisplayName() + " removed.")
    endIf
  endIf
endFunction

function RemoveNpcAsLoadedReferenceIfExists(Actor npc) global
  RemoveNpcAsReferenceIfExists(npc, GetLoadedReferencesFromDB())
endFunction

function RemoveNpcAsClonedReferenceIfExists(Actor npc) global
  RemoveNpcAsReferenceIfExists(npc, GetClonedReferencesFromDB())
endFunction

function RemoveAllClonedNpcs() global
  int cloned_references = GetClonedReferencesFromDB()
  int i = 0
  while i < JArray.Count(cloned_references)
    Actor npc = JArray.getForm(cloned_references, i) as Actor
    if npc
      Log("Removing " + npc.GetDisplayName())
      npc.Disable()
      npc.Delete()
    endIf
    i += 1
  endWhile
endFunction

bool function IsClonedNpc(Actor npc) global
	int clonedReferences = GetClonedReferencesFromDB()
  return clonedReferences && FindNpcAsReference(npc, clonedReferences) != -1
endFunction

int function FindNpcAsReference(Actor npc, int references) global
  return JArray.FindForm(references, npc)
endFunction

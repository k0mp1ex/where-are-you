Scriptname kxWhereAreYouLua hidden

import kxWhereAreYouRepository

int function FindMatchingNpcs(string pattern, int maxCount) global
  PrepareLuaContext()
	int jLuaArgs
  jLuaArgs = JLua.setStr("pattern", pattern, jLuaArgs)
  jLuaArgs = JLua.setInt("max", maxCount, jLuaArgs)
  return JLua.evalLuaObj("return kxWhereAreYou.search_by_pattern(args.pattern, args.max)", jLuaArgs)
endFunction

int function GetNpcsFromCollection(int jaCollection, bool shouldSort) global
  PrepareLuaContext()
	int jLuaArgs
  jLuaArgs = JLua.setObj("collection", jaCollection, jLuaArgs)
  jLuaArgs = JLua.setInt("should_sort", shouldSort as int, jLuaArgs)
  return JLua.evalLuaObj("return kxWhereAreYou.get_from_collection(args.collection, args.should_sort)", jLuaArgs)
endFunction

int function GetNpcIndex(int formId) global
  PrepareLuaContext()
	int jLuaArgs
  jLuaArgs = JLua.setInt("form_id", formId, jLuaArgs)
  return JLua.evalLuaInt("return kxWhereAreYou.get_npc_index_by_form_id(args.form_id)", jLuaArgs)
endFunction

int function IsTrackingNpc(int formId) global
  PrepareLuaContext()
	int jLuaArgs
  jLuaArgs = JLua.setInt("form_id", formId, jLuaArgs)
  return JLua.evalLuaInt("return kxWhereAreYou.is_tracking_by_form_id(args.form_id)", jLuaArgs)
endFunction

function UpdateNpcTracking(int formId, int trackingSlot) global
  PrepareLuaContext()
	int jLuaArgs
  jLuaArgs = JLua.setInt("form_id", formId, jLuaArgs)
  jLuaArgs = JLua.setInt("tracking_slot", trackingSlot, jLuaArgs)
  JLua.evalLuaObj("return kxWhereAreYou.update_tracking_by_form_id(args.form_id, args.tracking_slot)", jLuaArgs)
endFunction

string function GetFormattedEntryForNpc(int formId, string format) global
  PrepareLuaContext()
	int jLuaArgs
  jLuaArgs = JLua.setInt("form_id", formId, jLuaArgs)
  jLuaArgs = JLua.setStr("format", format, jLuaArgs)
  return JLua.evalLuaStr("return kxWhereAreYou.get_formatted_entry_for_npc_by_form_id(args.form_id, args.format)", jLuaArgs)
endFunction

string function GetStatsTextForNpc(int formId) global
  PrepareLuaContext()
	int jLuaArgs
  jLuaArgs = JLua.setInt("form_id", formId, jLuaArgs)
  return JLua.evalLuaStr("return kxWhereAreYou.get_stats_text_for_npc_by_form_id(args.form_id)", jLuaArgs)
endFunction

int function GetTrackingSlotForNpc(int formId) global
  PrepareLuaContext()
  int jLuaArgs
  jLuaArgs = JLua.setInt("form_id", formId, jLuaArgs)
  return JLua.evalLuaInt("return kxWhereAreYou.get_tracking_slot_by_form_id(args.form_id)", jLuaArgs)
endFunction

int function StringToInt(string hexString) global
  PrepareLuaContext()
  int jLuaArgs
  jLuaArgs = JLua.setStr("hex_string", hexString, jLuaArgs)
  return JLua.evalLuaInt("return kxWhereAreYou.hex_str_to_int(args.hex_string)", jLuaArgs)
endFunction

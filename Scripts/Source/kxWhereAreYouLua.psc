Scriptname kxWhereAreYouLua hidden

import kxWhereAreYouRepository

; [WARNING]
; About strings:
;   As described in JContainers docs we can't transfer in/out from Lua integers bigger than 24-bit with exact precision.
;   That's why in this script all 32-bit integers (like form IDs) are transferred as string
;   When necessary an explicit cast to int should be made in Papyrus/Lua code
; About booleans:
;   JContainers doesn't offer a native API to transfer booleans, so I treat then as int values (0 = false, 1 = true)
;   When necessary an explicit cast to bool(ean) should be made in Papyrus/Lua code

int function GetNpcIndex(string formId) global
  PrepareLuaContext()
	int jLuaArgs
  jLuaArgs = JLua.setStr("form_id", formId, jLuaArgs)
  return JLua.evalLuaInt("return kxWhereAreYou.get_npc_index(args.form_id)", jLuaArgs)
endFunction

int function IsTrackingNpc(string formId) global
  PrepareLuaContext()
	int jLuaArgs
  jLuaArgs = JLua.setStr("form_id", formId, jLuaArgs)
  return JLua.evalLuaInt("return kxWhereAreYou.is_tracking(args.form_id)", jLuaArgs)
endFunction

function UpdateNpcTracking(string formId, int trackingSlot) global
  PrepareLuaContext()
	int jLuaArgs
  jLuaArgs = JLua.setStr("form_id", formId, jLuaArgs)
  jLuaArgs = JLua.setInt("tracking_slot", trackingSlot, jLuaArgs)
  JLua.evalLuaObj("return kxWhereAreYou.update_tracking(args.form_id, args.tracking_slot)", jLuaArgs)
endFunction

string function GetFormattedEntryForNpc(string formId, string format) global
  PrepareLuaContext()
	int jLuaArgs
  jLuaArgs = JLua.setStr("form_id", formId, jLuaArgs)
  jLuaArgs = JLua.setStr("format", format, jLuaArgs)
  return JLua.evalLuaStr("return kxWhereAreYou.get_formatted_entry_for_npc(args.form_id, args.format)", jLuaArgs)
endFunction

string function GetStatsTextForNpc(string formId, string npcLocation) global
  PrepareLuaContext()
	int jLuaArgs
  jLuaArgs = JLua.setStr("form_id", formId, jLuaArgs)
  jLuaArgs = JLua.setStr("location", npcLocation, jLuaArgs)
  return JLua.evalLuaStr("return kxWhereAreYou.get_stats_text_for_npc(args.form_id, args.location)", jLuaArgs)
endFunction

int function GetTrackingSlotForNpc(string formId) global
  PrepareLuaContext()
  int jLuaArgs
  jLuaArgs = JLua.setStr("form_id", formId, jLuaArgs)
  return JLua.evalLuaInt("return kxWhereAreYou.get_tracking_slot(args.form_id)", jLuaArgs)
endFunction

string function HexStrToDecStr(string hexString) global
  PrepareLuaContext()
  int jLuaArgs
  jLuaArgs = JLua.setStr("hex_string", hexString, jLuaArgs)
  return JLua.evalLuaStr("return kxWhereAreYou.hex_str_to_dec_str(args.hex_string)", jLuaArgs)
endFunction

string function DecStrToHexStr(string decString) global
  PrepareLuaContext()
  int jLuaArgs
  jLuaArgs = JLua.setStr("dec_string", decString, jLuaArgs)
  return JLua.evalLuaStr("return kxWhereAreYou.dec_str_to_hex_str(args.dec_string)", jLuaArgs)
endFunction

local all_npcs = JDB.kxWhereAreYou.npcs
local settings = JDB.kxWhereAreYou.settings
local kxWhereAreYou = {}

-- PRIVATE API

local function write_log(msg, mode)
  local file = io.open(settings.log_file_path, mode)
  if file then
    file:write(msg .. "\n")
    file:close()
  end
end

local function log(format, ...)
  if settings.debug_enabled == 1 then
    write_log(string.format("[%s@v%s] " .. format, settings.mod_name, settings.mod_version, ...), "a+")
  end
end

local function literalize(str)
  return str:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", function(c) return "%" .. c end)
end

local function title_case(str)
  return str:gsub("(%a)([%w_']*)", function (first, rest) return first:upper()..rest:lower() end)
end

local function dec_str_to_int(dec_string)
  return tonumber(dec_string, 10)
end

local function int_to_dec_str(id)
  return tostring(id)
end

local function dec_str_to_hex_str(dec_string)
  return "0x" .. string.format("%x", tonumber(dec_string, 10)):upper():sub(-8)
end

local function hex_str_to_dec_str(hex_string)
  return tostring(tonumber(hex_string, 16))
end

local function gender_to_string(npc)
  if npc.gender == 0 then
    return "Male"
  elseif npc.gender == 1 then
    return "Female"
  else
    return "?"
  end
end

local function ref_id_as_string(npc)
  return dec_str_to_hex_str(npc.ref_id)
end

local function base_id_as_string(npc)
  return dec_str_to_hex_str(npc.base_id)
end

local function npc_to_text(npc, location)
  return string.format(
    "Name: %s\nRefId: %s\nBaseId: %s\nMod: %s\nRace: %s\nGender: %s\nTracked? %s\nIs a clone? %s\nLocation: %s",
    -- static
    npc.name,
    ref_id_as_string(npc),
    base_id_as_string(npc),
    npc.mod,
    title_case(npc.race),
    gender_to_string(npc),
    npc.tracking_slot ~= -1 and "Yes" or "No",
    npc.clone == 1 and "Yes" or "No",
    -- dynamic (not available by default)
    location or "Tamriel"
  )
end

local function log_npc(npc)
  log(npc_to_text(npc))
end

local function find_npc(form_id)
  log("find_npc... %s", dec_str_to_hex_str(form_id))
  for i,npc in pairs(all_npcs) do
    log_npc(npc)
    if npc.ref_id == form_id then --string comparison
      npc.index = i - 1 -- Lua arrays start at 1
      return npc
    end
  end
end

local function get_mod_by_mod_name(mods, mod_name)
  for _,mod in pairs(mods) do
    if mod.name:lower() == mod_name:lower() then
      return mod
    end
  end
end

-- PUBLIC API

function kxWhereAreYou.get_formatted_entry_for_npc(form_id, format)
  log("get_formatted_entry_for_npc... %s", dec_str_to_hex_str(form_id))

  local npc = find_npc(form_id)
  if npc then
    local result = format
    result = string.gsub(result, literalize("[name]"),     npc.name)
    result = string.gsub(result, literalize("[mod]"),      npc.mod)
    result = string.gsub(result, literalize("[gender]"),   gender_to_string(npc):sub(1, 1))
    result = string.gsub(result, literalize("[race]"),     title_case(npc.race))
    result = string.gsub(result, literalize("[baseid]"),   base_id_as_string(npc))
    result = string.gsub(result, literalize("[refid]"),    ref_id_as_string(npc))
    result = string.gsub(result, literalize("[tracking]"), npc.tracking_slot ~= -1 and "*" or "")
    result = string.gsub(result, literalize("[clone]"),    npc.clone == 1 and "+" or "")
    return result
  end
  return ""
end

function kxWhereAreYou.search_by_pattern(pattern, max)
  log("search_by_pattern...")
  log("size: %d", #all_npcs)

  local count = 0
  local result = JArray.object()
  for _,npc in pairs(all_npcs) do
    if count >= max then break end
    local match = string.match(npc.name:lower(), pattern:lower())
    if match then
      JArray.insert(result, npc)
      log(npc.name:lower() .. " matches " .. pattern:lower() .. " ? " .. tostring(match ~= nil))
      count = count + 1
    end
  end
  return result
end

function kxWhereAreYou.get_npc_index(form_id)
  log("search... %s", dec_str_to_hex_str(form_id))
  local npc = find_npc(form_id)
  return npc ~= nil and npc.index or -1
end

function kxWhereAreYou.is_tracking(form_id)
  log("is_tracking... %s", dec_str_to_hex_str(form_id))
  local npc = find_npc(form_id)
  return npc ~= nil and npc.tracking_slot ~= -1 or 0
end

function kxWhereAreYou.update_tracking(form_id, tracking_slot)
  log("update_tracking... %s", dec_str_to_hex_str(form_id))
  local npc = find_npc(form_id)
  if npc then
    npc.tracking_slot = tracking_slot
  end
end

function kxWhereAreYou.get_from_collection(collection, should_sort)
  log("get_from_collection...")

  if should_sort == 1 then
    log("sorting...")

    local arr = {}

    for _,npc in pairs(collection) do
      table.insert(arr, npc)
    end

    table.sort(arr, function(a, b) return a.name < b.name end)

    local result = JArray.object()
    for _,npc in pairs(arr) do
      JArray.insert(result, npc)
    end

    return result
  else
    log("not sorting...")
    return collection
  end
end

function kxWhereAreYou.get_stats_text_for_npc(form_id, location)
  log("get_stats_text_for_npc... %s", dec_str_to_hex_str(form_id))
  local npc = find_npc(form_id)
  return npc_to_text(npc, location)
end

function kxWhereAreYou.get_tracking_slot(form_id)
  log("get_tracking_slot... %s", dec_str_to_hex_str(form_id))
  local npc = find_npc(form_id)
  return npc and npc.tracking_slot or -1
end

function kxWhereAreYou.hex_str_to_dec_str(hex_string)
  return hex_str_to_dec_str(hex_string)
end

function kxWhereAreYou.dec_str_to_hex_str(dec_string)
  return dec_str_to_hex_str(dec_string)
end

function kxWhereAreYou.update_modlist(mods)
  log("> update_modlist... size: %d (before)", #all_npcs)

  local deleted_tracked_npcs = JArray.object()
  local deleted_npcs_indexes = {}

  for i,npc in pairs(all_npcs) do
    local mod = get_mod_by_mod_name(mods, npc.mod)
    if mod then
      if mod.light == 0 then
        npc.base_id = int_to_dec_str(bit.bor(bit.lshift(mod.index, 6 * 4), bit.band(dec_str_to_int(npc.base_id), 0xFFFFFF)))
        if npc.clone == 0 then
          npc.ref_id  = int_to_dec_str(bit.bor(bit.lshift(mod.index, 6 * 4), bit.band(dec_str_to_int(npc.ref_id),  0xFFFFFF)))
        end
      else
        npc.base_id = int_to_dec_str(bit.bor(0xFE000000, bit.lshift(mod.index, 3 * 4), bit.band(dec_str_to_int(npc.base_id), 0xFFF)))
        if npc.clone == 0 then
          npc.ref_id  = int_to_dec_str(bit.bor(0xFE000000, bit.lshift(mod.index, 3 * 4), bit.band(dec_str_to_int(npc.ref_id),  0xFFF)))
        end
      end
    else -- mod deleted, remove NPC too
      log("%s removed because mod %s has been deleted.", npc.name, npc.mod)
      if npc.tracking_slot ~= -1 then
        JArray.insert(deleted_tracked_npcs, npc.tracking_slot)
      end
      table.insert(deleted_npcs_indexes, i)
    end
  end

  --Remove deleted NPCs
  table.sort(deleted_npcs_indexes, function(a, b) return a <= b end)
  local i = #deleted_npcs_indexes
  while i > 0 do
    JArray.eraseIndex(all_npcs, deleted_npcs_indexes[i])
    i = i - 1
  end

  log("> update_modlist... size: %d (after)", #all_npcs)

  return deleted_tracked_npcs
end

write_log("Initializing", "w")

return kxWhereAreYou

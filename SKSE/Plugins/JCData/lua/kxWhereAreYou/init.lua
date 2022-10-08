local all_npcs = JDB.kxWhereAreYou.npcs
local settings = JDB.kxWhereAreYou.settings
local kxWhereAreYou = {}

local function log(msg, mode)
  if settings.debug_enabled == 1 then
    local file = io.open(settings.log_file_path, mode or "a+")
    if file then
      file:write("\n[" .. settings.mod_name .. "@v" .. settings.mod_version .. "] " .. msg)
      file:flush()
      file:close()
    end
  end
end

local function literalize(str)
  return str:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", function(c) return "%" .. c end)
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

local function id_as_string(id)
  return "0x" .. string.format("%x", id):upper():sub(-8)
end

local function npc_refid_as_string(npc)
  return id_as_string(npc.ref_id)
end

local function npc_baseid_as_string(npc)
  return id_as_string(npc.base_id)
end

local function npc_to_text(npc)
  return string.format(
    "Name: %s\nRefId: %s\nBaseId: %s\nMod: %s\nRace: %s\nGender: %s\nTracked? %s\nIs a clone? %s",
    npc.name,
    npc_refid_as_string(npc),
    npc_baseid_as_string(npc),
    npc.mod,
    npc.race,
    gender_to_string(npc),
    npc.tracking_slot ~= -1 and "Yes" or "No",
    npc.clone == 1 and "Yes" or "No"
  )
end

local function log_npc(npc)
  log("\n" .. npc_to_text(npc))
end

local function find_npc_by_form_id(form_id)
  log("find_npc_by_form_id..." .. id_as_string(form_id))
  for i,npc in pairs(all_npcs) do
    log_npc(npc)
    if npc.ref_id == form_id then
      npc.index = i - 1 -- Lua arrays start at 1
      return npc
    end
  end
end

function kxWhereAreYou.get_formatted_entry_for_npc_by_form_id(form_id, format)
  log("get_formatted_entry_for_npc_by_form_id...")

  local npc = find_npc_by_form_id(form_id)
  if npc then
    local result = format
    result = string.gsub(result, literalize("[name]"),     npc.name)
    result = string.gsub(result, literalize("[mod]"),      npc.mod)
    result = string.gsub(result, literalize("[gender]"),   gender_to_string(npc):sub(1, 1))
    result = string.gsub(result, literalize("[race]"),     npc.race)
    result = string.gsub(result, literalize("[baseid]"),   npc_baseid_as_string(npc))
    result = string.gsub(result, literalize("[refid]"),    npc_refid_as_string(npc))
    result = string.gsub(result, literalize("[tracking]"), npc.tracking_slot ~= -1 and "*" or "")
    result = string.gsub(result, literalize("[clone]"),    npc.clone == 1 and "+" or "")
    return result
  end
  return ""
end

function kxWhereAreYou.search_by_pattern(pattern, max)
  log("search_by_pattern...")
  log("size: " .. #all_npcs)

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

function kxWhereAreYou.get_npc_index_by_form_id(form_id)
  log("search_by_form_id...")
  local npc = find_npc_by_form_id(form_id)
  return npc ~= nil and npc.index or -1
end

function kxWhereAreYou.is_tracking_by_form_id(form_id)
  log("is_tracking_by_form_id...")
  local npc = find_npc_by_form_id(form_id)
  return npc ~= nil and npc.tracking_slot ~= -1 or 0
end

function kxWhereAreYou.update_tracking_by_form_id(form_id, tracking_slot)
  log("update_tracking_by_form_id...") 
  local npc = find_npc_by_form_id(form_id)
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

function kxWhereAreYou.get_stats_text_for_npc_by_form_id(form_id)
  log("get_stats_text_for_npc_by_form_id...")
  local npc = find_npc_by_form_id(form_id)
  return npc_to_text(npc)
end

function kxWhereAreYou.get_tracking_slot_by_form_id(form_id)
  log("get_tracking_slot_by_form_id...")
  local npc = find_npc_by_form_id(form_id)
  return npc and npc.tracking_slot or -1
end

function kxWhereAreYou.hex_str_to_int(hex_string)
  return tonumber(hex_string, 16)
end

log("Initializing", "w")

return kxWhereAreYou

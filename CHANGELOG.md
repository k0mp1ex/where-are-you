# Changelog

## 1.3.0

- Faster and more powerful search using Lua. Search now uses Lua [pattern matching](https://www.lua.org/manual/5.1/manual.html#5.4.1) instead of simple wildcards like in the previous version
- Customized search result list format. You can use predefined variables to add only the information you need like `[name]|[refid]~[mod]`
- Added more NPC info on "Stats" option (available in command wheel), like location, race, baseid, refid, etc
- Added option to be notified when a tracked NPC dies
- Added option to remove tracking marker when NPC dies
- Added option to force quest "Where Are You?" to be active when tracking/untracking NPCs
- Fixed color not being saved/loaded. Change it to hexadecimal string value to have more options to choose from
- **No compatible with 1.2.0, requires a clean save. Can still be installed mid playthrough.**

## 1.2.0

- Added MCM
- Added "Do favor" command
- Added hotkeys for tracking NPC, show command wheel and do favor
- Added support to modifiers (Ctrl, Alt, Shift) for all hotkeys
- Removed experimental flags
- Safe to update from 1.1.0

## 1.1.0

- Added tracking markers (requires new save from 1.0.1)

## 1.0.1

- Fixed bug in ESPFE form range + Updated SPID file to use EditorID instead of FormID (requires new save from 1.0.0)

## 1.0.0

- First release

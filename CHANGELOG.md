# Changelog

## 2.0.0

- TBD

## 1.4.0

- Added another type of commands visualization: list. You can switch back to wheel via MCM (wheel is still the default option).
- Added **info** as an independent command, keeping **stats** as it was in the first versions
- Fixed duplicated records when load order changes
- Fixed records still showing for deleted plugins
- Removed tracking marker for NPCs from deleted plugins
- Added optional ConsoleUtilSSE integration. Now you can enable autoselect the NPC found on console. Disabled by default.
- Removed tracked NPC deletion after death
- Removed **PapyrusUtil SE - Modders Scripting Utility Functions** as requirement
- Safe from update from 1.3.0+. Only issue is if you have cloned NPCs from these versions, they won't be compatible. Try to delete them before updating. If you have issues with hotkeys on startup try to open the "Where Are You?" MCM or save/reload the game.

## 1.3.1

- Updated SPID file back to use FormID instead of EditorID (I found this problem testing some Wabbajack lists running Skyrim 1.5.97, like Living Skyrim 3 and Aldrnari)
- Added TitleCase for race (so no more IMPERIAL in uppercase or other string variations)
- Added "Tamriel" as the default text when no location is found
- Removed useless logs
- Safe to update from 1.3.0

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
- **Safe to update from 1.1.0**

## 1.1.0

- Added tracking markers (requires new save from 1.0.1)

## 1.0.1

- Fixed bug in ESPFE form range + Updated SPID file to use EditorID instead of FormID (requires new save from 1.0.0)

## 1.0.0

- First release

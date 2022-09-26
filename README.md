# Where Are You?

A mod to lookup discovered NPCs in game.

## Description

So, you've been wandering the lands, found a few NPCs but you're not sure where they went later?
Maybe you don't remember exactly what their names were?
Don't worry, we'll find them for you!

## Features

- Implemented:
  - Search all unique NPCs you discovered by their names
  - Search with support for wildcards * and ?
  - Teleport the NPC to you
  - Teleport you to where the NPC is
  - Check NPC stats
  - Open NPC inventory
  - Delete the NPC
  - Choose the NPC on a list when the search returns multiple results
  - Flag "I am lucky" to use the first search match instead of showing a result list. This might be faster to search, but you will have to be more specific when searching to match the right NPC.
  - Clone the NPC. It's meant only for testing, taking screenshots and related temporary stuff. Cloning a unique NPC is in general not recommended because only one instance of them is supposed to exist and some AI behaviour won't work properly in the cloned version.
  - Choose the name of the cloned NPC. Remember to pick an unique name so it doesn't conflict with an already registered NPC.
  - Track the NPCs cloned by this mod
  - **ESPFE**
- Planned:
  - SKSE (script free) version to improve search performance.
  - Find NPCs still not discovered/spawned in game.
  - Add support to track pets
  - Show more NPC info (like FormID, EditorID, BaseActorID, what mod is from, etc.).
  - MCM: I didn't feel like people will be tweaking the available options that much. You can still edit the `settings.json` file. If you want this, let me know.
  - Extend the search functionality with some patterns, similar to the SPID format.
- Unplanned:
  - Tracking markers: I don't really like or use them in game. I might change my mind about it.

## Settings

For now there are a few settings that you can control using the `settings.json` file. Some are still in experimental phase.

- `enabled`: Enable/Disable the mod. When disabled all the mod's stored data will be erased (useful when uninstalling).
- `keys.search`: The key used to show the search box. If you want to change it check the [DXScanCodes](https://www.creationkit.com/index.php?title=Input_Script). Default key is F3.
- `keep_menu_open`: Enable/Disable the option to keep the NPC command menu opened after executing a command. It keeps open until you hit tab to close it. Disabled by default.
- `teleport_range`: Control how close/far the teleport will be from the player/NPC.
- `max_result_count`: How many NPCs will be shown in the result search list.
- `sort_results`: Enable/Disable sorting the result search list.
ames found in game and tracked by this mod. Used for debug purposes, disabled by default.
- `experimental.i_am_lucky`: Enable/Disable searching only until first match is found. In experimental phase.
- `experimental.sort_before_search`: Enable/Disable sorting all the NPCs names before searching. In experimental phase.
- `debug.enabled`: Enable/Disable debug mode, disabled by default.
- `debug.keys.data_dump`: The key used to dump NPCs loaded data and settings.

## Compatibility

No incompatibilities found yet.

## Requirements

- [SKSE64](http://skse.silverlock.org/)
- [PapyrusUtil SE - Modders Scripting Utility Functions](https://www.nexusmods.com/skyrimspecialedition/mods/13048)
- [UIExtensions](https://www.nexusmods.com/skyrimspecialedition/mods/17561)
- [JContainers](https://www.nexusmods.com/skyrimspecialedition/mods/16495)
- [Spell Perk Item Distributor (SPID)](https://www.nexusmods.com/skyrimspecialedition/mods/36869)

## Supported versions

- [✔️] AE
- [✔️] SE
- [❌] LE
- [❌] VR

## Configuration defaults

```json
{
  "enabled": true,
  "keys": {
    "search": 61
  },
  "keep_menu_opened": false,
  "teleport_range": 100.0,
  "max_result_count": 10,
  "sort_results": true,
  "experimental": {
    "i_am_lucky": false,
    "sort_before_search": false
  },
  "debug": {
    "enabled": false,
    "keys": {
      "data_dump": -1
    }
  }
}
```

## Alternatives

- If you're still on Skyrim 1.5.97 you can use [NPC Lookup](https://www.nexusmods.com/skyrimspecialedition/mods/43097) or [AreYouThere SE - Actor NPC Follower](https://www.nexusmods.com/skyrimspecialedition/mods/27758) mods. They're SKSE plugins, so they're faster and also have a lot more features. I don't know any other similar alternatives for Skyrim 1.6.xxx, that's why I made this mod.
- If you're only interested in find your current followers you can use [Quick Mass Follower Commands Hotkey](https://www.nexusmods.com/skyrimspecialedition/mods/51362) or the newest [Swiftly Order Squad - Follower Commands UI](https://www.nexusmods.com/skyrimspecialedition/mods/63259) mods. [Nether's Follower Framework](https://www.nexusmods.com/skyrimspecialedition/mods/55653) keeps track of your folllowers history (max 100 followers), so it also might suit your needs.

## FAQ

- How to show the search bar?
- The default key is F3. You can change this in the `settings.json` file.

---

- Can I install it mid playthrough?
- Yes. Always create a backup save, just in case.

---

- Can I uninstall it mid playthrough?
- It's not recomended, but you can. What I recommend is disable the mod first (set the flag "enabled" to false in settings.json), load the game, make a new save, clean the new save on Resaver and load the cleaned save on game.

---

- I found a bug, what should I do?
- You can report it here on Nexus or in the Github mod's page in the section below.

---

- It's slow! Any plans to improve the search performance?
- Yeah, this scripted version has its limitations. In a heavy modded and/or low-end PCs the search time can be pretty high. Try to avoid using wildcards because the searching is way slower with it. I do plan to release a SKSE version to improve the search performance.

---

- I can't find my NPC, what should I do?
- This mod only tracks the NPCs spawned in your location. Did you find the NPC in game after installing this mod? Are you sure he/she wasn't inside an inn or a place you haven't visit before (or visit before you installed the mod)? If you're looking at the NPC, searching using the full name and still doesn't work, try to save and reload to force the script to scan the nearby NPCs again.

---

- I have a very specific case where my NPC is not tracked by this mod at all. Can I change any settings or do some troubleshoot on my own?
- This mod uses SPID to distribute a lookup spell for every unique NPC actor. If this doesn't match what you need you can update the `kxWhereAreYou_DISTR.ini` file and include your own filters. You can `bEnableLogging` and `bEnableTrace` to `1` on your Skyrim.ini file and also set the `debug.enable` property to true on this mod `settings.json`. The logs will appear on your Papyrus.0.log file and also on the game's console. You can bind a [key](https://www.creationkit.com/index.php?title=Input_Script) to dump all data stored by the mod using the `debug.keys.data_dump` property in this mod `settings.json` file too. The output file will be generated at `Data/kxWhereAreYou/.debug/dump.json`.

---

- It's not lore-friendly, you can break your quest deleting NPCs or taking something from their inventory. You know this, right?
- I do. This mod is not intended to be lore friendly, just a quality of life mod. It's up to you to decide what commands you'll use to not break your quests or immersion.

---

- TL;DR
- ¯\_(ツ)_/¯

## Source

- [GitHub](https://github.com/k0mp1ex/where-are-you)

## Credits

- Bethesda for Skyrim /(S|A|L)E|VR/
- [SKSE](http://skse.silverlock.org/) team for creating the great platform that a lot of our mods depends on
- [exiledviper](https://www.nexusmods.com/skyrimspecialedition/users/85199) for [PapyrusUtil SE - Modders Scripting Utility Functions](https://www.nexusmods.com/skyrimspecialedition/mods/13048)
- [expired6978](https://www.nexusmods.com/skyrimspecialedition/users/2950481) for [UIExtensions](https://www.nexusmods.com/skyrimspecialedition/mods/17561)
- [silvericed](https://www.nexusmods.com/skyrim/users/5355170) and [ryobg](https://www.nexusmods.com/skyrimspecialedition/users/35506715) for [JContainers](https://www.nexusmods.com/skyrimspecialedition/mods/16495)
- [powerofthree](https://www.nexusmods.com/skyrimspecialedition/users/2148728) for [Spell Perk Item Distributor (SPID)](https://www.nexusmods.com/skyrimspecialedition/mods/36869)
- [wSkeever](https://www.nexusmods.com/skyrimspecialedition/users/7064860) for the nice way to track NPCs in [Quick Mass Follower Commands Hotkey](https://www.nexusmods.com/skyrimspecialedition/mods/51362)
- [mrowrpurr](https://www.nexusmods.com/skyrimspecialedition/users/121646123) for the fantastic [Skyrim Scripting YouTube channel](https://www.youtube.com/c/SkyrimScripting)
- [Animonculory team](https://github.com/The-Animonculory/ADT#the-animonculory-team) for creating the Wabbajack modlist [ADT](https://github.com/The-Animonculory/ADT), used in all my tests.
- [cacophony](https://www.nexusmods.com/skyrimspecialedition/users/1040660) for creating the Wabbajack modlist [Licentia](https://www.nexusmods.com/skyrimspecialedition/mods/68983)
- [coldsun1187](https://www.nexusmods.com/skyrimspecialedition/users/9762372) and [VNDKTR](https://www.nexusmods.com/skyrimspecialedition/users/37717855) for the amazing followers in the screenshots.

This is my first mod, so 🐻 with me.

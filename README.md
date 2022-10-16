# Where Are You?

Lookup discovered NPCs in game. Search by their names, check stats, open inventory, teleport, clone, delete, ask for favors and add tracking markers. MCM available. SE and AE compatible.

## Description

So, you've been wandering the lands, found a few NPCs but you're not sure where they went later?
Maybe you don't remember exactly what their names were?
Don't worry, we'll find them for you!

## Features

- Implemented:
  - **[NEW]** Fast search using [Lua pattern matching](https://www.lua.org/manual/5.1/manual.html#5.4.1)
  - **[NEW]** Customized search result list format
  - **[NEW]** More NPC info available in the older Stats command wheel option
  - Search all unique NPCs you discovered by their names
  - MCM
  - Customizable hotkey for search NPCs
  - Customizable hotkey for tracking NPC at crosshair
  - Customizable hotkey for show command wheel for NPC at crosshair
  - Customizable hotkey for make NPC at crosshair do a favor
  - Support for modifiers (Ctrl, Shift and Alt) in all hotkeys
  - Added option to only delete cloned NPCs
  - Added option to only allow followers to do favors
  - Customizable UI (icons and color)
  - Tracking markers up to 100 NPCs
  - Teleport the NPC to you
  - Teleport you to where the NPC is
  - Check NPC stats
  - Open NPC inventory
  - Delete the NPC
  - Choose the NPC on a list when the search returns multiple results
  - Clone the NPC. It's meant only for testing, taking screenshots and related temporary stuff. Cloning a unique NPC is in general not recommended because only one instance of them is supposed to exist and some AI behaviour won't work properly in the cloned version.
  - Choose the name of the cloned NPC. Remember to pick an unique name so it doesn't conflict with an already registered NPC.
  - Track the NPCs cloned by this mod
  - **ESPFE**
- Planned:
  - Replace the command wheel for a list menu. With command wheel I can only have 8 options. I can allocate one of them to open another command wheel, but it seems more cluttered and less intuitive than showing a full list menu. Any feedback here is helpful.
  - A SKSE version to improve search performance or a [Skyrim Search SE](https://www.nexusmods.com/skyrimspecialedition/mods/45689) integration.
  - Find NPCs still not discovered/spawned in game.
  - Add support to track pets
  - Profiles
  - Extend the search functionality with some patterns, similar to the SPID format.
  - Add dialog option in quests to help find the target NPC (where it lives, works, sleeps, etc). Optionally also add a quest marker to help track it. Thanks [dann1](https://www.nexusmods.com/Users/25568544) for the suggestion!

## Compatibility

No incompatibilities found yet.

## Requirements

- [SKSE64](http://skse.silverlock.org/)
- [UIExtensions](https://www.nexusmods.com/skyrimspecialedition/mods/17561)
- [JContainers](https://www.nexusmods.com/skyrimspecialedition/mods/16495)
- [Spell Perk Item Distributor (SPID)](https://www.nexusmods.com/skyrimspecialedition/mods/36869)
- [MCM Helper](https://www.nexusmods.com/skyrimspecialedition/mods/53000)
- [ConsoleUtilSSE](https://www.nexusmods.com/skyrimspecialedition/mods/24858): Optional.

## Supported versions

- [✔️] AE
- [✔️] SE
- [❌] LE
- [❌] VR

## Alternatives

- If you're still on Skyrim 1.5.97 you can use [NPC Lookup](https://www.nexusmods.com/skyrimspecialedition/mods/43097) or [AreYouThere SE - Actor NPC Follower](https://www.nexusmods.com/skyrimspecialedition/mods/27758) mods. They're SKSE plugins, so they're faster and also have a lot more features. I don't know any other similar alternatives for Skyrim 1.6.xxx, that's why I made this mod.
- If you prefer typing console commands you can use [Skyrim Search SE](https://www.nexusmods.com/skyrimspecialedition/mods/45689). It covers more than NPCs and it's an incredible useful tool.
- If you're only interested in find your current followers you can use [Quick Mass Follower Commands Hotkey](https://www.nexusmods.com/skyrimspecialedition/mods/51362) or the newest [Swiftly Order Squad - Follower Commands UI](https://www.nexusmods.com/skyrimspecialedition/mods/63259) mods. [Nether's Follower Framework](https://www.nexusmods.com/skyrimspecialedition/mods/55653) keeps track of your folllowers history (max 100 followers), so it also might suit your needs.

## FAQ

- How to show the search bar?
- The default key is F3. You can change this via MCM.

---

- Can I install it mid playthrough?
- Yes. Always create a backup save, just in case.

---

- Can I uninstall it mid playthrough?
- It's not recomended, but you can. If you wish to proceed what I would do:
  - 1) Disable the **kxWhereAreYou.esp**
  - 2) Make a new save
  - 3) Clean the new save on [Resaver](https://www.nexusmods.com/skyrimspecialedition/mods/5031)
  - 4) Load the cleaned save

---

- I found a bug, what should I do?
- You can report it here on Nexus or in the Github mod's page in the section below.

---

- It's slow! Any plans to improve the search performance?
- Yeah, this scripted version has its limitations. I tried my best to shift the searching to Lua scripts and that helped a lot performance wise. I still plan to release a SKSE plugin to improve the search performance and also deal with some other script limitations.

---

- I can't find my NPC, what should I do?
- This mod only tracks the NPCs spawned in your location. Did you find the NPC in game after installing this mod? Are you sure he/she wasn't inside an inn or a place you haven't visit before (or visited before you installed the mod)? If you're looking at the NPC, searching using the full name and still doesn't work, try to save and reload to force the script to scan the nearby NPCs again.

---

- I have a very specific case where my NPC is not tracked by this mod at all. Can I change any settings or do some troubleshoot on my own?
- This mod uses SPID to distribute a lookup spell for every unique NPC actor. If this doesn't match what you need you can update the `kxWhereAreYou_DISTR.ini` file and include your own filters. You can `bEnableLogging` and `bEnableTrace` to `1` on your Skyrim.ini file and also enable "Debug mode" on MCM. The logs will appear on your Papyrus.0.log file and also on the game's console. Lua logs will be stored in `Data/kxWhereAreYou/Debug/lua.log`. You can also dump all data stored via the MCM (Mod's MCM > System > Export data). The output file will be generated at `Data/kxWhereAreYou/Debug/dump.json`.

---

- It's not lore-friendly, you can break your quest deleting NPCs or taking something from their inventory. You know this, right?
- I do. This mod is not intended to be lore friendly, just a quality of life mod. It's up to you to decide what commands you'll use to not break your quests or immersion.

---

- What about the previous "I'm feeling lucky" flag?
- It was in experimental phase and it's not needed anymore. Now you can just set the max result count to 1 and you'll have the same behavior.

---

- What happens if I disable the mod via "Mod enabled" toggle?
- All the keys associated with this mod will be unregistered. The mod will still be storing NPCs on the background in case you reenable the mod again if the option "Keep tracking in the background" is enabled.

---

- TL;DR
- F3 > Search > Profit ¯\_(ツ)_/¯

## Source

- [GitHub](https://github.com/k0mp1ex/where-are-you)

## Credits

- Bethesda for Skyrim /(S|A|L)E|VR/
- [SKSE](http://skse.silverlock.org/) team for creating the great platform that a lot of our mods depends on
- [expired6978](https://www.nexusmods.com/skyrimspecialedition/users/2950481) for [UIExtensions](https://www.nexusmods.com/skyrimspecialedition/mods/17561)
- [silvericed](https://www.nexusmods.com/skyrim/users/5355170) and [ryobg](https://www.nexusmods.com/skyrimspecialedition/users/35506715) for [JContainers](https://www.nexusmods.com/skyrimspecialedition/mods/16495)
- [powerofthree](https://www.nexusmods.com/skyrimspecialedition/users/2148728) for [Spell Perk Item Distributor (SPID)](https://www.nexusmods.com/skyrimspecialedition/mods/36869)
- [schlangster](https://www.nexusmods.com/skyrimspecialedition/users/28794) and team for [SkyUI](https://www.nexusmods.com/skyrimspecialedition/mods/12604)
- [Parapets](https://www.nexusmods.com/skyrimspecialedition/users/39501725) for [MCM Helper](https://www.nexusmods.com/skyrimspecialedition/mods/53000)
- [Ryan](https://www.nexusmods.com/skyrimspecialedition/users/5687342) for [ConsoleUtilSSE](https://www.nexusmods.com/skyrimspecialedition/mods/24858)
- [wSkeever](https://www.nexusmods.com/skyrimspecialedition/users/7064860) for the nice way to track NPCs in [Quick Mass Follower Commands Hotkey](https://www.nexusmods.com/skyrimspecialedition/mods/51362)
- [mrowrpurr](https://www.nexusmods.com/skyrimspecialedition/users/121646123) for the fantastic [Skyrim Scripting YouTube channel](https://www.youtube.com/c/SkyrimScripting)
- [Animonculory team](https://github.com/The-Animonculory/ADT#the-animonculory-team) for creating the Wabbajack modlist [ADT](https://github.com/The-Animonculory/ADT), used in all my tests.
- [cacophony](https://www.nexusmods.com/skyrimspecialedition/users/1040660) for creating the Wabbajack modlist [Licentia](https://www.nexusmods.com/skyrimspecialedition/mods/68983), used in all my screenshots.
- [coldsun1187](https://www.nexusmods.com/skyrimspecialedition/users/9762372) and [VNDKTR](https://www.nexusmods.com/skyrimspecialedition/users/37717855) for the amazing followers in the screenshots.
  - [Lyris Titanborn - Part Giant Follower - Patreon Only (free) - 3BA/BHUNP/CBBE](https://www.patreon.com/posts/lyris-titanborn-70789859)
  - [Anaka Winter-Mane - The Nord Warrior Priestess (Healer) - 3BA - BHUNP - CBBE](https://www.nexusmods.com/skyrimspecialedition/mods/66384)
  - [YoRHa 2B - HP Deluxe Follower - 3BA-BHUNP-TBD-Bodyslide - ESPFE](https://www.nexusmods.com/skyrimspecialedition/mods/66836)

This is my first mod, so 🐻 with me.

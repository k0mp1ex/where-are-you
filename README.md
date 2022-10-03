# Where Are You?

Lookup discovered NPCs in game. Search by their names, check stats, open inventory, teleport, clone, delete, ask for favors and add tracking markers. MCM available. SE and AE compatible.

## Description

So, you've been wandering the lands, found a few NPCs but you're not sure where they went later?
Maybe you don't remember exactly what their names were?
Don't worry, we'll find them for you!

![alt text](docs/gifs/simple-search-multiple-results.gif)

## Features

- Implemented:
  - Search all unique NPCs you discovered by their names
  - **[NEW]** MCM
  - **[NEW]** Customizable hotkey for search NPCs
  - **[NEW]** Customizable hotkey for tracking NPC at crosshair
  - **[NEW]** Customizable hotkey for show command wheel for NPC at crosshair
  - **[NEW]** Customizable hotkey for make NPC at crosshair do a favor
  - **[NEW]** Support for modifiers (Ctrl, Shift and Alt) in all hotkeys
  - **[NEW]** Added option to only delete cloned NPCs
  - **[NEW]** Added option to only allow followers to do favors
  - **[NEW]** Customizable UI (icons and color)
  - Search supporting wildcards * and ?
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
  - A SKSE version to improve search performance or a [Skyrim Search SE](https://www.nexusmods.com/skyrimspecialedition/mods/45689) integration.
  - Find NPCs still not discovered/spawned in game.
  - Add support to track pets
  - Show more NPC info (like FormID, EditorID, what mod is from, etc.).
  - Translations (official support for English and pt-BR)
  - Profiles
  - Extend the search functionality with some patterns, similar to the SPID format.
  - Add dialog option in quests to help find the target NPC (where it lives, works, sleeps, etc). Optionally also add a quest marker to help track it. Thanks [dann1](https://www.nexusmods.com/Users/25568544) for the suggestion!

## Compatibility

No incompatibilities found yet.

## Requirements

- [SKSE64](http://skse.silverlock.org/)
- [PapyrusUtil SE - Modders Scripting Utility Functions](https://www.nexusmods.com/skyrimspecialedition/mods/13048)
- [UIExtensions](https://www.nexusmods.com/skyrimspecialedition/mods/17561)
- [JContainers](https://www.nexusmods.com/skyrimspecialedition/mods/16495)
- [Spell Perk Item Distributor (SPID)](https://www.nexusmods.com/skyrimspecialedition/mods/36869)
- [MCM Helper](https://www.nexusmods.com/skyrimspecialedition/mods/53000)

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
- It's not recomended, but you can. What I recommend is reset stored data (Mod's MCM > System > Reset data), disable the mod (Mod's MCM > System > Mod enabled), disable "Keep tracking in the background" too (to avoid store data in background), make a new save, clean the new save on Resaver and load the cleaned save on game.

---

- I found a bug, what should I do?
- You can report it here on Nexus or in the Github mod's page in the section below.

---

- It's slow! Any plans to improve the search performance?
- Yeah, this scripted version has its limitations. In a heavy modded and/or low-end PCs the search time can be pretty high. Try to avoid using wildcards because the searching is way slower with it. I do plan to release a SKSE version to improve the search performance.

---

- I can't find my NPC, what should I do?
- This mod only tracks the NPCs spawned in your location. Did you find the NPC in game after installing this mod? Are you sure he/she wasn't inside an inn or a place you haven't visit before (or visited before you installed the mod)? If you're looking at the NPC, searching using the full name and still doesn't work, try to save and reload to force the script to scan the nearby NPCs again.

---

- I have a very specific case where my NPC is not tracked by this mod at all. Can I change any settings or do some troubleshoot on my own?
- This mod uses SPID to distribute a lookup spell for every unique NPC actor. If this doesn't match what you need you can update the `kxWhereAreYou_DISTR.ini` file and include your own filters. You can `bEnableLogging` and `bEnableTrace` to `1` on your Skyrim.ini file and also enable "Debug mode" on MCM. The logs will appear on your Papyrus.0.log file and also on the game's console. You can also dump all data stored via the MCM (Mod's MCM > System > Export data). The output file will be generated at `Data/kxWhereAreYou/Debug/dump.json`.

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

- What "reset data" does?
- It removes all data stored by this mod from memory, so when you save your game no additional data from this mod will be baked into your save file. Your configuration settings will be untouched.

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
- [schlangster](https://www.nexusmods.com/skyrimspecialedition/users/28794) and team for [SkyUI](https://www.nexusmods.com/skyrimspecialedition/mods/12604)
- [Parapets](https://www.nexusmods.com/skyrimspecialedition/users/39501725) for [MCM Helper](https://www.nexusmods.com/skyrimspecialedition/mods/53000)
- [wSkeever](https://www.nexusmods.com/skyrimspecialedition/users/7064860) for the nice way to track NPCs in [Quick Mass Follower Commands Hotkey](https://www.nexusmods.com/skyrimspecialedition/mods/51362)
- [mrowrpurr](https://www.nexusmods.com/skyrimspecialedition/users/121646123) for the fantastic [Skyrim Scripting YouTube channel](https://www.youtube.com/c/SkyrimScripting)
- [Animonculory team](https://github.com/The-Animonculory/ADT#the-animonculory-team) for creating the Wabbajack modlist [ADT](https://github.com/The-Animonculory/ADT), used in all my tests.
- [cacophony](https://www.nexusmods.com/skyrimspecialedition/users/1040660) for creating the Wabbajack modlist [Licentia](https://www.nexusmods.com/skyrimspecialedition/mods/68983), used in all my screenshots.
- [coldsun1187](https://www.nexusmods.com/skyrimspecialedition/users/9762372) and [VNDKTR](https://www.nexusmods.com/skyrimspecialedition/users/37717855) for the amazing followers in the screenshots.
  - [Lyris Titanborn - Part Giant Follower - Patreon Only (free) - 3BA/BHUNP/CBBE](https://www.patreon.com/posts/lyris-titanborn-70789859)
  - [Anaka Winter-Mane - The Nord Warrior Priestess (Healer) - 3BA - BHUNP - CBBE](https://www.nexusmods.com/skyrimspecialedition/mods/66384)
  - [YoRHa 2B - HP Deluxe Follower - 3BA-BHUNP-TBD-Bodyslide - ESPFE](https://www.nexusmods.com/skyrimspecialedition/mods/66836)

This is my first mod, so 🐻 with me.

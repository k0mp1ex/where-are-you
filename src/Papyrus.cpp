#include "Papyrus.h"

#include "UI.h"
#include "Utils.h"
#include "Settings.h"

using namespace kxWhereAreYou;

namespace {
    struct Command {
        std::string name;
        std::string description;
        std::string icon;
        int slot {};
    };

    bool IsValidNpc(RE::StaticFunctionTag*, RE::Actor* actor) {
        if (actor) {
            if (auto* actorBase = actor->GetBaseObject()->As<RE::TESNPC>(); actorBase)
                return actorBase->IsUnique();
        }
        return false;
    }

    std::optional<std::regex> CreateRegex(const std::string& pattern) {
        try {
            std::regex result(pattern, std::regex_constants::icase);
            return result;
        } catch (const std::regex_error& e) {
            logger::error("Invalid regex: {}", pattern);
            logger::error("Error: {}", e.what());
            return std::nullopt;
        }
    }

    std::vector<RE::Actor*> SearchActorsByName(RE::StaticFunctionTag*, std::string pattern, bool useRegex,
                                               bool sortResults, int maxResultCount) {
        logger::info("> Pattern: {}, useRegex: {}, sortResults: {}, maxResultCount: {}", pattern, useRegex, sortResults,
                     maxResultCount);

        std::vector<RE::Actor*> actors;
        std::optional<std::regex> regexPattern;

        if (useRegex) regexPattern = CreateRegex(pattern);

        if (!useRegex || regexPattern) {
            const auto& [forms, lock] = RE::TESForm::GetAllForms();
            for (auto& [id, form] : *forms) {
                auto* actor = form->As<RE::Actor>();
                if (actor) {
                    auto name = actor->GetDisplayFullName();
                    if (IsValidNpc(nullptr, actor) &&
                        ((!useRegex && Utils::String::IsSubstring(name, pattern)) ||
                         ( useRegex && std::regex_match(name, regexPattern.value())))) {
                        actors.push_back(actor);
                        if (actors.size() == maxResultCount) break;
                    }
                }
            }
        }

        logger::info("[Before Sorting]");
        std::for_each(actors.begin(), actors.end(), [](RE::Actor* actor) {
            logger::info("Name: {}, DisplayFullName: {}", actor->GetName(), actor->GetDisplayFullName());
        });

        if (sortResults) {
            std::sort(actors.begin(), actors.end(), [](RE::Actor* left, RE::Actor* right) {
                auto leftStr = std::string(left->GetDisplayFullName());
                auto rightStr = std::string(right->GetDisplayFullName());
                Utils::String::ConvertToLowerCase(leftStr);
                Utils::String::ConvertToLowerCase(rightStr);
                return leftStr < rightStr;
            });
        }

        logger::info("[After Sorting]");
        std::for_each(actors.begin(), actors.end(), [](RE::Actor* actor) {
            logger::info("Name: {}, DisplayFullName: {}", actor->GetName(), actor->GetDisplayFullName());
        });

        return actors;
    }

    int32_t GetAliasIndexOfActorInQuest(RE::StaticFunctionTag*, RE::Actor* actor, RE::TESQuest* quest) {
        //Alias at 0 is always Player
        for (RE::BSTArray<RE::BGSBaseAlias*>::size_type i = 1; i < quest->aliases.size(); i++) {
            if (auto alias = quest->aliases[i]; alias) {
                if (auto reference = skyrim_cast<RE::BGSRefAlias*>(alias); reference) {
                    if (auto actorReference = reference->GetActorReference(); actorReference) {
                        logger::info("Comparing {} == {}", actor->GetDisplayFullName(),
                                     actorReference->GetDisplayFullName());
                        if (actor == actorReference) {
                            logger::info("They are equal! Returning aliasID {} with aliasName: {}", i,
                                         alias->aliasName);
                            return i;
                        }
                    }
                }
            }
        }
        return -1;
    }

    int32_t GetNextAvailableAliasInQuest(RE::StaticFunctionTag*, RE::TESQuest* quest) {
        //Alias at 0 is always Player
        for (RE::BSTArray<RE::BGSBaseAlias*>::size_type i = 1; i < quest->aliases.size(); i++) {
            if (auto alias = quest->aliases[i]; alias) {
                if (auto reference = skyrim_cast<RE::BGSRefAlias*>(alias); reference) {
                    if (auto actorReference = reference->GetActorReference(); !actorReference) {
                        logger::info("Slot available: {} with aliasName: {}", i, alias->aliasName);
                        return i;
                    }
                }
            }
        }
        return -1;
    }

    bool IsTrackingNpc(RE::Actor* actor, RE::TESQuest* quest) {
        return GetAliasIndexOfActorInQuest(nullptr, actor, quest) != -1;
    }

    std::string GetSummaryDataForActor(RE::StaticFunctionTag*, RE::Actor* actor, RE::TESQuest* quest, const std::string pattern) {
        auto* actorBase = actor->GetBaseObject()->As<RE::TESNPC>();

        auto name = actor->GetDisplayFullName();
        auto refId = std::format("0x{:08X}", actor->GetFormID());
        auto baseId = std::format("0x{:08X}", actorBase->GetFormID());
        auto mod = std::string(actorBase->GetFile(0)->GetFilename());
        auto race = actorBase->GetRace()->GetName();
        auto gender = actorBase->IsFemale() ? "Female" : "Male";
        auto location = actor->GetCurrentLocation() ? actor->GetCurrentLocation()->GetName() : "Tamriel";

        std::string stats;
        if (pattern.empty()) {
            stats = std::format(
                "Name: {}\n"
                "RefId: {}\n"
                "BaseId: {}\n"
                "Mod: {}\n"
                "Race: {}\n"
                "Gender: {}\n"
                "Location: {}\n"
                "Tracking: {}",
                name, refId, baseId, mod, race, gender, location, IsTrackingNpc(actor, quest) ? "Yes" : "No");
        } else {
            stats = pattern;
            stats = std::regex_replace(stats, std::regex("\\[name\\]"), name);
            stats = std::regex_replace(stats, std::regex("\\[refid\\]"), refId);
            stats = std::regex_replace(stats, std::regex("\\[baseid\\]"), baseId);
            stats = std::regex_replace(stats, std::regex("\\[mod\\]"), mod);
            stats = std::regex_replace(stats, std::regex("\\[race\\]"), race);
            stats = std::regex_replace(stats, std::regex("\\[gender\\]"), gender);
            stats = std::regex_replace(stats, std::regex("\\[location\\]"), location);
            stats = std::regex_replace(stats, std::regex("\\[tracking\\]"), IsTrackingNpc(actor, quest) ? "*" : "");
        }
        logger::info("\n{}", stats);
        return stats;
    }

    void PrintToConsole(RE::StaticFunctionTag*, std::string text) {
        UI::Console::Print(text);
    }

    void SelectReferenceInConsole(RE::StaticFunctionTag*, RE::TESObjectREFR* reference) {
        UI::Console::SelectReference(reference);
    }

    unsigned int HexadecimalStringToInteger(RE::StaticFunctionTag*, std::string hexString) {
        std::istringstream converter(hexString);
        unsigned int value;
        converter >> std::hex >> value;
        return value;
    }

    std::vector<Command> GetCommandsForNpc(RE::Actor* actor, RE::TESQuest* quest) {
        bool isTracking = IsTrackingNpc(actor, quest);
        std::vector<Command> commands;

        if (Settings::Commands::bShowStats)
            commands.emplace_back(Command{"show_npc_stats", "Stats", Settings::Icons::sStatsIcon});
        if (Settings::Commands::bShowInfo)
            commands.emplace_back(Command{"show_npc_info", "Info", Settings::Icons::sInfoIcon});
        if (Settings::Commands::bShowEnableDisable)
            commands.emplace_back(Command{"toggle_enable_disable", actor->IsDisabled() ? "Enable" : "Disable", Settings::Icons::sEnableDisableIcon});
        if (Settings::Commands::bShowInventory)
            commands.emplace_back(Command{"open_npc_inventory", "Inventory", Settings::Icons::sInventoryIcon});
        if (Settings::Commands::bShowTeleport)
            commands.emplace_back(Command{"teleport_to_player", "Teleport", Settings::Icons::sTeleportIcon});
        if (Settings::Commands::bShowVisit)
            commands.emplace_back(Command{"move_to_npc", "Visit", Settings::Icons::sVisitIcon});
        if (Settings::Commands::bShowDoFavor && (!Settings::DoFavor::bOnlyFollowers || actor->IsPlayerTeammate()))
            commands.emplace_back(Command{"do_favor", "Do Favor", Settings::Icons::sDoFavorIcon});
        if (Settings::Commands::bShowTrack)
            commands.emplace_back(Command{"toggle_track_npc", isTracking ? "Untrack" : "Track", Settings::Icons::sTrackIcon});

        //Trying to keep the wheel slots as symmetrical as possible
        std::vector<int> slots;
        if (commands.size() == 1)
            slots = {1};
        else if (commands.size() == 2)
            slots = {1, 5};
        else if (commands.size() == 3)
            slots = {1, 2, 5};
        else if (commands.size() == 4)
            slots = {1, 2, 5, 6};
        else if (commands.size() == 5)
            slots = {0, 1, 2, 5, 6};
        else if (commands.size() == 6)
            slots = {0, 1, 2, 4, 5, 6};
        else if (commands.size() == 7)
            slots = {0, 1, 2, 4, 5, 6, 7};
        else if (commands.size() == 8)
            slots = {0, 1, 2, 3, 4, 5, 6, 7};

        for (size_t i {}; i < slots.size(); i++)
            commands[i].slot = slots[i];

        return commands;
    }

    std::vector<int> GetCommandsSlots(RE::StaticFunctionTag*, RE::Actor* actor, RE::TESQuest* quest) {
        std::vector<int> output;
        std::ranges::transform(GetCommandsForNpc(actor, quest), std::back_inserter(output), [](const Command& command) { return command.slot; });
        return output;
    }

    std::vector<std::string> GetCommandsNames(RE::StaticFunctionTag*, RE::Actor* actor, RE::TESQuest* quest) {
        std::vector<std::string> output;
        std::ranges::transform(GetCommandsForNpc(actor, quest), std::back_inserter(output), [](const Command& command) { return command.name; });
        return output;
    }

    std::vector<std::string> GetCommandsDescriptions(RE::StaticFunctionTag*, RE::Actor* actor, RE::TESQuest* quest) {
        std::vector<std::string> output;
        std::ranges::transform(GetCommandsForNpc(actor, quest), std::back_inserter(output), [](const Command& command) { return command.description; });
        return output;
    }

    std::vector<std::string> GetCommandsIcons(RE::StaticFunctionTag*, RE::Actor* actor, RE::TESQuest* quest) {
        std::vector<std::string> output;
        std::ranges::transform(GetCommandsForNpc(actor, quest), std::back_inserter(output), [](const Command& command) { return command.icon; });
        return output;
    }

    void UpdateMcmSettings(RE::StaticFunctionTag*) {
        logger::info("Updating MCM .ini settings...");
        Settings::Setup();
    }

    //Call Papyrus function
    void MoveToTarget(RE::Actor* npc, const std::string& commandStr, bool forceEnableNpc) {
        const auto skyrimVM = RE::SkyrimVM::GetSingleton();
        auto vm = skyrimVM ? skyrimVM->impl : nullptr;
        if (vm) {
            RE::BSTSmartPointer<RE::BSScript::IStackCallbackFunctor> callback;
            RE::BSFixedString command { commandStr };
            auto vmargs = RE::MakeFunctionArguments(const_cast<RE::Actor*>(npc), std::move(command), std::move(forceEnableNpc));
            vm->DispatchStaticCall("kxWhereAreYouNative", "MoveToTarget", vmargs, callback);
            delete vmargs;
        }
    }

    void TeleportAndEnableIfNeeded(RE::StaticFunctionTag*, RE::Actor* npc, std::string command) {
        if (npc->IsDisabled()) {
            std::string pronoun = "it";
            if (auto actorBase = npc->GetBaseObject()->As<RE::TESNPC>(); actorBase)
                pronoun = actorBase->IsFemale() ? "her" : "him";
            UI::Messages::Show(std::format("{} is disabled.\nDo you want to enable {} before teleporting?", npc->GetDisplayFullName(), pronoun),
                               {"Yes, enable " + pronoun + " and teleport", "No, only teleport", "Cancel"},
                               [=](unsigned int result) {
                                    logger::info("question answer: {}", result);
                                    if (result < 2)
                                        MoveToTarget(npc, command, result == 0);
                                });
        } else {
            MoveToTarget(npc, command, false);
        }
    }

}

namespace kxWhereAreYou::Papyrus {
    constexpr std::string_view PapyrusClass = "kxWhereAreYouNative";

    bool RegisterPapyrusFunctions(RE::BSScript::IVirtualMachine* vm) {
        vm->RegisterFunction("PrintToConsole", PapyrusClass, PrintToConsole);
        vm->RegisterFunction("SelectReferenceInConsole", PapyrusClass, SelectReferenceInConsole);
        vm->RegisterFunction("SearchActorsByName", PapyrusClass, SearchActorsByName);
        vm->RegisterFunction("GetSummaryDataForActor", PapyrusClass, GetSummaryDataForActor);
        vm->RegisterFunction("GetAliasIndexOfActorInQuest", PapyrusClass, GetAliasIndexOfActorInQuest);
        vm->RegisterFunction("GetNextAvailableAliasInQuest", PapyrusClass, GetNextAvailableAliasInQuest);
        vm->RegisterFunction("HexadecimalStringToInteger", PapyrusClass, HexadecimalStringToInteger);
        vm->RegisterFunction("GetCommandsSlots", PapyrusClass, GetCommandsSlots);
        vm->RegisterFunction("GetCommandsNames", PapyrusClass, GetCommandsNames);
        vm->RegisterFunction("GetCommandsDescriptions", PapyrusClass, GetCommandsDescriptions);
        vm->RegisterFunction("GetCommandsIcons", PapyrusClass, GetCommandsIcons);
        vm->RegisterFunction("UpdateMcmSettings", PapyrusClass, UpdateMcmSettings);
        vm->RegisterFunction("IsValidNpc", PapyrusClass, IsValidNpc);
        vm->RegisterFunction("TeleportAndEnableIfNeeded", PapyrusClass, TeleportAndEnableIfNeeded);
        return true;
    }

    void Setup() {
        if (SKSE::GetPapyrusInterface()->Register(RegisterPapyrusFunctions)) {
            logger::info("Papyrus functions bound.");
        } else {
            SKSE::stl::report_and_fail("Failure to register Papyrus bindings.");
        }
    }
}

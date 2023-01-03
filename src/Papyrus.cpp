#include "Papyrus.h"
#include "Utils.h"

using namespace kxWhereAreYou;

namespace {
    std::vector<RE::Actor*> SearchActorsByName(RE::StaticFunctionTag*, std::string pattern, bool useRegex,
                                             bool sortResults, int maxResultCount) {
        logger::info("> Pattern: {}, useRegex: {}, sortResults: {}, maxResultCount: {}", pattern, useRegex, sortResults,
                     maxResultCount);

        std::vector<RE::Actor*> actors;

        const auto& [forms, lock] = RE::TESForm::GetAllForms();
        for (auto& [id, form] : *forms) {
            auto* actor = form->As<RE::Actor>();
            if (actor) {
                auto* actorBase = actor->GetBaseObject()->As<RE::TESNPC>();
                auto name = actor->GetDisplayFullName();
                if (actorBase && actorBase->IsUnique() &&
                    ((!useRegex && Utils::String::IsSubstring(name, pattern)) ||
                     (useRegex && std::regex_match(name, std::regex(pattern, std::regex_constants::icase))))) {
                    actors.push_back(actor);
                    if (actors.size() == maxResultCount) break;
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

    std::string GetSummaryDataForActor(RE::StaticFunctionTag*, RE::Actor* actor, const std::string pattern) {
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
                "Location: {}",
                name,
                refId,
                baseId,
                mod,
                race,
                gender,
                location);
        } else {
            stats = pattern;
            stats = std::regex_replace(stats, std::regex("\\[name\\]"), name);
            stats = std::regex_replace(stats, std::regex("\\[refid\\]"), refId);
            stats = std::regex_replace(stats, std::regex("\\[baseid\\]"), baseId);
            stats = std::regex_replace(stats, std::regex("\\[mod\\]"), mod);
            stats = std::regex_replace(stats, std::regex("\\[race\\]"), race);
            stats = std::regex_replace(stats, std::regex("\\[gender\\]"), gender);
            stats = std::regex_replace(stats, std::regex("\\[location\\]"), location);
        }
        logger::info("\n{}", stats);
        return stats;
    }

    void PrintToConsole(RE::StaticFunctionTag*, std::string text) {
        RE::ConsoleLog::GetSingleton()->Print(text.c_str());
        logger::info("{}", text);
    }

    void SelectReferenceInConsole(RE::StaticFunctionTag*, RE::TESObjectREFR* a_reference) {
        using Message = RE::UI_MESSAGE_TYPE;

        if (a_reference) {
            const auto factory = RE::MessageDataFactoryManager::GetSingleton();
            const auto intfcStr = RE::InterfaceStrings::GetSingleton();
            const auto creator =
                factory && intfcStr ? factory->GetCreator<RE::ConsoleData>(intfcStr->consoleData) : nullptr;

            const auto consoleData = creator ? creator->Create() : nullptr;
            const auto msgQ = RE::UIMessageQueue::GetSingleton();
            if (consoleData && msgQ) {
                consoleData->type = static_cast<RE::ConsoleData::DataType>(1);
                consoleData->pickRef = a_reference->CreateRefHandle();
                msgQ->AddMessage(intfcStr->console, Message::kUpdate, consoleData);
            }
        } else {
            const auto ui = RE::UI::GetSingleton();
            const auto console = ui ? ui->GetMenu<RE::Console>() : nullptr;
            if (console) {
                const RE::ObjectRefHandle null;
                console->SetSelectedRef(null);
            }
        }
    }

    unsigned int HexadecimalStringToInteger(RE::StaticFunctionTag*, std::string hexString) {
        std::istringstream converter(hexString);
        unsigned int value;
        converter >> std::hex >> value;
        return value;
    }

    std::int32_t GetAliasIndexOfActorInQuest(RE::StaticFunctionTag*, RE::Actor* actor, RE::TESQuest* quest) {
        for (uint32_t i = 0; i < quest->aliases.size(); i++) {
            if (auto alias = quest->aliases[i]; alias) {
                if (auto reference = static_cast<RE::BGSRefAlias*>(alias); reference) {
                    if (auto actorReference = reference->GetActorReference(); actorReference) {
                        logger::info("Comparing {} == {}", actor->GetDisplayFullName(), actorReference->GetDisplayFullName());
                        if (actor == actorReference) {
                            logger::info("They are equal! Returning aliasID {} with aliasName: {}", i, alias->aliasName);
                            return i;
                        }
                    }
                }
            }
        }
        return -1;
    }

    std::int32_t GetNextAvailableAliasInQuest(RE::StaticFunctionTag*, RE::TESQuest* quest) {
        for (uint32_t i = 0; i < quest->aliases.size(); i++) {
            if (auto alias = quest->aliases[i]; alias) {
                if (auto reference = static_cast<RE::BGSRefAlias*>(alias); reference) {
                    if (auto actorReference = reference->GetActorReference(); !actorReference) {
                        logger::info("Slot available: {} with aliasName: {}", i, alias->aliasName);
                        return i;
                    }
                }
            }
        }
        return -1;
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

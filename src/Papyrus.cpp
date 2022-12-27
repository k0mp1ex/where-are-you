#include "Papyrus.h"

#include "Utils.h"

namespace {
    std::vector<RE::Actor*> SearchNPCsByName(RE::StaticFunctionTag*, std::string pattern, bool useRegex,
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
                    ((!useRegex && Utils::IsSubstring(name, pattern)) ||
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
                Utils::ConvertToLowerCase(leftStr);
                Utils::ConvertToLowerCase(rightStr);
                return leftStr < rightStr;
            });
        }

        logger::info("[After Sorting]");
        std::for_each(actors.begin(), actors.end(), [](RE::Actor* actor) {
            logger::info("Name: {}, DisplayFullName: {}", actor->GetName(), actor->GetDisplayFullName());
        });

        return actors;
    }

    void PrintConsole(RE::StaticFunctionTag*, std::string text) {
        RE::ConsoleLog::GetSingleton()->Print(text.c_str());
        logger::info("{}", text);
    }

    void SetSelectedReference(RE::StaticFunctionTag*, RE::TESObjectREFR* a_reference) {
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
}

namespace Papyrus {
    constexpr std::string_view PapyrusClass = "kxWhereAreYouNative";

    bool RegisterPapyrusFunctions(RE::BSScript::IVirtualMachine* vm) {
        vm->RegisterFunction("PrintConsole", PapyrusClass, PrintConsole);
        vm->RegisterFunction("SetSelectedReference", PapyrusClass, SetSelectedReference);
        vm->RegisterFunction("SearchNPCsByName", PapyrusClass, SearchNPCsByName);
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

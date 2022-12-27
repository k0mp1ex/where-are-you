#include <spdlog/sinks/basic_file_sink.h>

namespace logger = SKSE::log;

namespace PapyrusFunctions {
    bool IsSubstring(const std::string& strHaystack, const std::string& strNeedle) {
        auto it = std::search(strHaystack.begin(), strHaystack.end(), strNeedle.begin(), strNeedle.end(),
                              [](char ch1, char ch2) { return std::tolower(ch1) == std::tolower(ch2); });
        return (it != strHaystack.end());
    }

    std::vector<RE::Actor*> SearchNPCsByName(RE::StaticFunctionTag*, std::string pattern, bool useRegex, bool sortResults, int maxResultCount) {
        logger::info("Looking for /{}/", pattern);

        std::vector<RE::Actor*> actors;
        std::regex pattern_regex(pattern, std::regex_constants::icase);

        const auto& [forms, lock] = RE::TESForm::GetAllForms();
        for (auto& [id, form] : *forms) {
            auto* actor = form->As<RE::Actor>();
            if (actor) {
                auto* actorBase = actor->GetBaseObject()->As<RE::TESNPC>();
                auto name = actor->GetDisplayFullName();
                if (actorBase && actorBase->IsUnique() &&
                    ((!useRegex && PapyrusFunctions::IsSubstring(name, pattern)) ||
                     (useRegex && std::regex_match(name, pattern_regex)))) {
                    actors.push_back(actor);
                    if (actors.size() == maxResultCount) break;
                }
            }
        }

        logger::info("[Before Sorting]");
        std::for_each(actors.begin(), actors.end(),[](RE::Actor* actor){ logger::info("Name: {}, DisplayFullName: {}", actor->GetName(), actor->GetDisplayFullName()); });

        if (sortResults) {
            //TODO: convert to lowercase before compare
            std::sort(actors.begin(), actors.end(), [](RE::Actor* left, RE::Actor* right){ return left->GetDisplayFullName() < right->GetDisplayFullName(); });
        }

        logger::info("[After Sorting]");
        std::for_each(actors.begin(), actors.end(),[](RE::Actor* actor){ logger::info("Name: {}, DisplayFullName: {}", actor->GetName(), actor->GetDisplayFullName()); });

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

void SetupLog() {
    auto logsFolder = SKSE::log::log_directory();
    if (!logsFolder) {
        SKSE::stl::report_and_fail("SKSE log_directory not provided, logs disabled.");
    }
    auto pluginName = SKSE::PluginDeclaration::GetSingleton()->GetName();
    auto logFilePath = *logsFolder / std::format("{}.log", pluginName);
    auto fileLoggerPtr = std::make_shared<spdlog::sinks::basic_file_sink_mt>(logFilePath.string(), true);
    auto loggerPtr = std::make_shared<spdlog::logger>("log", std::move(fileLoggerPtr));
    spdlog::set_default_logger(std::move(loggerPtr));
    spdlog::set_level(spdlog::level::trace);
    spdlog::flush_on(spdlog::level::info);
}

bool RegisterPapyrusFunctions(RE::BSScript::IVirtualMachine* vm) {
    vm->RegisterFunction("PrintConsole", "kxWhereAreYouNative", PapyrusFunctions::PrintConsole);
    vm->RegisterFunction("SetSelectedReference", "kxWhereAreYouNative", PapyrusFunctions::SetSelectedReference);
    vm->RegisterFunction("SearchNPCsByName", "kxWhereAreYouNative", PapyrusFunctions::SearchNPCsByName);
    return true;
}

void SetupPapyrusBindings() {
    if (SKSE::GetPapyrusInterface()->Register(RegisterPapyrusFunctions)) {
        logger::info("Papyrus functions bound.");
    } else {
        SKSE::stl::report_and_fail("Failure to register Papyrus bindings.");
    }
}

SKSEPluginLoad(const SKSE::LoadInterface* skse) {
    SKSE::Init(skse);

    SetupLog();
    SetupPapyrusBindings();

    logger::info("{} initialized!", SKSE::PluginDeclaration::GetSingleton()->GetName());

    return true;
}

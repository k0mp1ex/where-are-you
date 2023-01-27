#include "Logging.h"
#include "Settings.h"

#include <spdlog/sinks/basic_file_sink.h>
#include <spdlog/sinks/msvc_sink.h>

namespace kxWhereAreYou::Logging {
    void Setup() {
        auto logsFolder = SKSE::log::log_directory();
        if (!logsFolder) SKSE::stl::report_and_fail("SKSE log_directory not provided, logs disabled.");
        auto pluginName = SKSE::PluginDeclaration::GetSingleton()->GetName();
        auto logFilePath = *logsFolder / std::format("{}.log", pluginName);
        auto fileLoggerPtr = std::make_shared<spdlog::sinks::basic_file_sink_mt>(logFilePath.string(), true);
        std::shared_ptr<spdlog::logger> loggerPtr;
        if (IsDebuggerPresent()) {
            auto debugLoggerPtr = std::make_shared<spdlog::sinks::msvc_sink_mt>();
            spdlog::sinks_init_list loggers{std::move(fileLoggerPtr), std::move(debugLoggerPtr)};
            loggerPtr = std::make_shared<spdlog::logger>("log", loggers);
        } else {
            loggerPtr = std::make_shared<spdlog::logger>("log", std::move(fileLoggerPtr));
        }
        spdlog::set_default_logger(std::move(loggerPtr));
        spdlog::set_level(spdlog::level::info);
        spdlog::flush_on(spdlog::level::info);
    }

    void Update() {
        auto logLevel = Settings::Debug::bEnabled ? spdlog::level::trace : spdlog::level::info;
        spdlog::set_level(logLevel);
        spdlog::flush_on(logLevel);
    }
}

#include "Settings.h"

#include <Simpleini.h>

namespace kxWhereAreYou {
    void ReadBoolSetting(CSimpleIniA& iniFile, const char* sectionName, const char* settingName, bool& settingValue) {
        if (iniFile.GetValue(sectionName, settingName)) {
            settingValue = iniFile.GetBoolValue(sectionName, settingName);
        }
    }

    void ReadFloatSetting(CSimpleIniA& iniFile, const char* sectionName, const char* settingName, float& settingValue) {
        if (iniFile.GetValue(sectionName, settingName)) {
            settingValue = static_cast<float>(iniFile.GetDoubleValue(sectionName, settingName));
        }
    }

    void ReadInt32Setting(CSimpleIniA& iniFile, const char* sectionName, const char* settingName,
                          int32_t& settingValue) {
        if (iniFile.GetValue(sectionName, settingName)) {
            settingValue = static_cast<int32_t>(iniFile.GetLongValue(sectionName, settingName));
        }
    }

    void ReadStringSetting(CSimpleIniA& iniFile, const char* sectionName, const char* settingName,
                           std::string& settingValue) {
        if (const char* value = iniFile.GetValue(sectionName, settingName); value) {
            settingValue = std::string(value);
        }
    }

    void Settings::Print() {
        // System
        logger::info("[Settings] System::bEnabled = {}", System::bEnabled);
        // Commands
        logger::info("[Settings] Commands::uVisualizationType = {}", Commands::uVisualizationType);
        logger::info("[Settings] Commands::bKeepOpened = {}", Commands::bKeepOpened);
        logger::info("[Settings] Commands::bShowStats = {}", Commands::bShowStats);
        logger::info("[Settings] Commands::bShowInfo = {}", Commands::bShowInfo);
        logger::info("[Settings] Commands::bShowTeleport = {}", Commands::bShowTeleport);
        logger::info("[Settings] Commands::bShowVisit = {}", Commands::bShowVisit);
        logger::info("[Settings] Commands::bShowInventory = {}", Commands::bShowInventory);
        logger::info("[Settings] Commands::bShowTrack = {}", Commands::bShowTrack);
        logger::info("[Settings] Commands::bShowDoFavor = {}", Commands::bShowDoFavor);
        // Console
        logger::info("[Settings] Console::bAutoPickByRefId = {}", Console::bAutoPickByRefId);
        // Search
        logger::info("[Settings] Search::uMaxResultCount = {}", Search::uMaxResultCount);
        logger::info("[Settings] Search::bSortResults = {}", Search::bSortResults);
        logger::info("[Settings] Search::sEntryFormat = {}", Search::sEntryFormat);
        logger::info("[Settings] Search::bUseRegex = {}", Search::bUseRegex);
        // Track
        logger::info("[Settings] Track::bAlwaysActivateQuest = {}", Track::bAlwaysActivateQuest);
        logger::info("[Settings] Track::bNotifyOnDeath = {}", Track::bNotifyOnDeath);
        logger::info("[Settings] Track::bRemoveTrackingOnDeath = {}", Track::bRemoveTrackingOnDeath);
        // Teleport
        logger::info("[Settings] Teleport::fRange = {}", Teleport::fRange);
        // DoFavor
        logger::info("[Settings] DoFavor::bOnlyFollowers = {}", DoFavor::bOnlyFollowers);
        // Debug
        logger::info("[Settings] Debug::bEnabled = {}", Debug::bEnabled);
        // Hotkeys
        logger::info("[Settings] Hotkeys::uTrackKey = {}", Hotkeys::uTrackKey);
        logger::info("[Settings] Hotkeys::bTrackCtrlKey = {}", Hotkeys::bTrackCtrlKey);
        logger::info("[Settings] Hotkeys::bTrackShiftKey = {}", Hotkeys::bTrackShiftKey);
        logger::info("[Settings] Hotkeys::bTrackAltKey = {}", Hotkeys::bTrackAltKey);
        logger::info("[Settings] Hotkeys::uSearchKey = {}", Hotkeys::uSearchKey);
        logger::info("[Settings] Hotkeys::bSearchCtrlKey = {}", Hotkeys::bSearchCtrlKey);
        logger::info("[Settings] Hotkeys::bSearchShiftKey = {}", Hotkeys::bSearchShiftKey);
        logger::info("[Settings] Hotkeys::bSearchAltKey = {}", Hotkeys::bSearchAltKey);
        logger::info("[Settings] Hotkeys::uCommandsKey = {}", Hotkeys::uCommandsKey);
        logger::info("[Settings] Hotkeys::bCommandsCtrlKey = {}", Hotkeys::bCommandsCtrlKey);
        logger::info("[Settings] Hotkeys::bCommandsShiftKey = {}", Hotkeys::bCommandsShiftKey);
        logger::info("[Settings] Hotkeys::bCommandsAltKey = {}", Hotkeys::bCommandsAltKey);
        logger::info("[Settings] Hotkeys::uDoFavorKey = {}", Hotkeys::uDoFavorKey);
        logger::info("[Settings] Hotkeys::bDoFavorCtrlKey = {}", Hotkeys::bDoFavorCtrlKey);
        logger::info("[Settings] Hotkeys::bDoFavorShiftKey = {}", Hotkeys::bDoFavorShiftKey);
        logger::info("[Settings] Hotkeys::bDoFavorAltKey = {}", Hotkeys::bDoFavorAltKey);
        // Colors
        logger::info("[Settings] Colors::sDefaultColor = {}", Colors::sDefaultColor);
        // Icons
        logger::info("[Settings] Icons::sStatsIcon = {}", Icons::sStatsIcon);
        logger::info("[Settings] Icons::sInfoIcon = {}", Icons::sInfoIcon);
        logger::info("[Settings] Icons::sTeleportIcon = {}", Icons::sTeleportIcon);
        logger::info("[Settings] Icons::sVisitIcon = {}", Icons::sVisitIcon);
        logger::info("[Settings] Icons::sInventoryIcon = {}", Icons::sInventoryIcon);
        logger::info("[Settings] Icons::sTrackIcon = {}", Icons::sTrackIcon);
        logger::info("[Settings] Icons::sDoFavorIcon = {}", Icons::sDoFavorIcon);
    }

    void Settings::Setup() {
        constexpr auto path = L"Data/MCM/Settings/kxWhereAreYou.ini";

        logger::info("Reading MCM .ini...");

        CSimpleIniA mcm;
        mcm.SetUnicode();
        mcm.LoadFile(path);

        // System
        ReadBoolSetting(mcm, "System", "bEnabled", System::bEnabled);
        // Commands
        ReadInt32Setting(mcm, "Commands", "uVisualizationType", Commands::uVisualizationType);
        ReadBoolSetting(mcm, "Commands", "bKeepOpened", Commands::bKeepOpened);
        ReadBoolSetting(mcm, "Commands", "bShowStats", Commands::bShowStats);
        ReadBoolSetting(mcm, "Commands", "bShowInfo", Commands::bShowInfo);
        ReadBoolSetting(mcm, "Commands", "bShowTeleport", Commands::bShowTeleport);
        ReadBoolSetting(mcm, "Commands", "bShowVisit", Commands::bShowVisit);
        ReadBoolSetting(mcm, "Commands", "bShowInventory", Commands::bShowInventory);
        ReadBoolSetting(mcm, "Commands", "bShowTrack", Commands::bShowTrack);
        ReadBoolSetting(mcm, "Commands", "bShowDoFavor", Commands::bShowDoFavor);
        // Console
        ReadBoolSetting(mcm, "Console", "bAutoPickByRefId", Console::bAutoPickByRefId);
        // Search
        ReadInt32Setting(mcm, "Search", "uMaxResultCount", Search::uMaxResultCount);
        ReadBoolSetting(mcm, "Search", "bSortResults", Search::bSortResults);
        ReadStringSetting(mcm, "Search", "sEntryFormat", Search::sEntryFormat);
        ReadBoolSetting(mcm, "Search", "bUseRegex", Search::bUseRegex);
        // Track
        ReadBoolSetting(mcm, "Track", "bAlwaysActivateQuest", Track::bAlwaysActivateQuest);
        ReadBoolSetting(mcm, "Track", "bNotifyOnDeath", Track::bNotifyOnDeath);
        ReadBoolSetting(mcm, "Track", "bRemoveTrackingOnDeath", Track::bRemoveTrackingOnDeath);
        // Teleport
        ReadFloatSetting(mcm, "Teleport", "fRange", Teleport::fRange);
        // DoFavor
        ReadBoolSetting(mcm, "DoFavor", "bOnlyFollowers", DoFavor::bOnlyFollowers);
        // Debug
        ReadBoolSetting(mcm, "Debug", "bEnabled", Debug::bEnabled);
        // Hotkeys
        ReadInt32Setting(mcm, "Hotkeys", "uTrackKey", Hotkeys::uTrackKey);
        ReadBoolSetting(mcm, "Hotkeys", "bTrackCtrlKey", Hotkeys::bTrackCtrlKey);
        ReadBoolSetting(mcm, "Hotkeys", "bTrackShiftKey", Hotkeys::bTrackShiftKey);
        ReadBoolSetting(mcm, "Hotkeys", "bTrackAltKey", Hotkeys::bTrackAltKey);
        ReadInt32Setting(mcm, "Hotkeys", "uSearchKey", Hotkeys::uSearchKey);
        ReadBoolSetting(mcm, "Hotkeys", "bSearchCtrlKey", Hotkeys::bSearchCtrlKey);
        ReadBoolSetting(mcm, "Hotkeys", "bSearchShiftKey", Hotkeys::bSearchShiftKey);
        ReadBoolSetting(mcm, "Hotkeys", "bSearchAltKey", Hotkeys::bSearchAltKey);
        ReadInt32Setting(mcm, "Hotkeys", "uCommandsKey", Hotkeys::uCommandsKey);
        ReadBoolSetting(mcm, "Hotkeys", "bCommandsCtrlKey", Hotkeys::bCommandsCtrlKey);
        ReadBoolSetting(mcm, "Hotkeys", "bCommandsShiftKey", Hotkeys::bCommandsShiftKey);
        ReadBoolSetting(mcm, "Hotkeys", "bCommandsAltKey", Hotkeys::bCommandsAltKey);
        ReadInt32Setting(mcm, "Hotkeys", "uDoFavorKey", Hotkeys::uDoFavorKey);
        ReadBoolSetting(mcm, "Hotkeys", "bDoFavorCtrlKey", Hotkeys::bDoFavorCtrlKey);
        ReadBoolSetting(mcm, "Hotkeys", "bDoFavorShiftKey", Hotkeys::bDoFavorShiftKey);
        ReadBoolSetting(mcm, "Hotkeys", "bDoFavorAltKey", Hotkeys::bDoFavorAltKey);
        // Colors
        ReadStringSetting(mcm, "Colors", "sDefaultColor", Colors::sDefaultColor);
        // Icons
        ReadStringSetting(mcm, "Icons", "sStatsIcon", Icons::sStatsIcon);
        ReadStringSetting(mcm, "Icons", "sInfoIcon", Icons::sInfoIcon);
        ReadStringSetting(mcm, "Icons", "sTeleportIcon", Icons::sTeleportIcon);
        ReadStringSetting(mcm, "Icons", "sVisitIcon", Icons::sVisitIcon);
        ReadStringSetting(mcm, "Icons", "sInventoryIcon", Icons::sInventoryIcon);
        ReadStringSetting(mcm, "Icons", "sTrackIcon", Icons::sTrackIcon);
        ReadStringSetting(mcm, "Icons", "sDoFavorIcon", Icons::sDoFavorIcon);

        Print();
        logger::info("All MCM settings read.");
    }
}

#pragma once

namespace kxWhereAreYou {

    struct Settings {
        static void Update();
        static void Print();

        struct System {
            static inline bool bEnabled = true;
        };
        struct Commands {
            static inline int32_t uVisualizationType = 0;
            static inline bool bKeepOpened = false;
            static inline bool bShowStats = true;
            static inline bool bShowInfo = true;
            static inline bool bShowEnableDisable = true;
            static inline bool bShowTeleport = true;
            static inline bool bShowVisit = true;
            static inline bool bShowInventory = true;
            static inline bool bShowTrack = true;
            static inline bool bShowDoFavor = true;
        };
        struct Console {
            static inline bool bAutoPickByRefId = false;
        };
        struct Search {
            static inline int32_t uMaxResultCount = 10;
            static inline bool bSortResults = true;
            static inline std::string sEntryFormat = "[name]|[refid]~[mod]";
            static inline bool bUseRegex = false;
        };
        struct Track {
            static inline bool bAlwaysActivateQuest = true;
            static inline bool bNotifyOnDeath = true;
            static inline bool bRemoveTrackingOnDeath = true;
        };
        struct Teleport {
            static inline float fRange = 100.0;
        };
        struct DoFavor {
            static inline bool bOnlyFollowers = true;
        };
        struct Debug {
            static inline bool bEnabled = false;
        };
        struct Hotkeys {
            static inline int32_t uTrackKey = -1;
            static inline bool bTrackCtrlKey = false;
            static inline bool bTrackShiftKey = false;
            static inline bool bTrackAltKey = false;
            static inline int32_t uSearchKey = 61;  //<F3>
            static inline bool bSearchCtrlKey = false;
            static inline bool bSearchShiftKey = false;
            static inline bool bSearchAltKey = false;
            static inline int32_t uCommandsKey = -1;
            static inline bool bCommandsCtrlKey = false;
            static inline bool bCommandsShiftKey = false;
            static inline bool bCommandsAltKey = false;
            static inline int32_t uDoFavorKey = -1;
            static inline bool bDoFavorCtrlKey = false;
            static inline bool bDoFavorShiftKey = false;
            static inline bool bDoFavorAltKey = false;
        };
        struct Colors {
            static inline std::string sDefaultColor = "FF0000";
        };
        struct Icons {
            static inline std::string sStatsIcon = "default_book_read";
            static inline std::string sInfoIcon = "cat_favorites";
            static inline std::string sEnableDisableIcon = "mag_powers";
            static inline std::string sTeleportIcon = "book_map";
            static inline std::string sVisitIcon = "armor_feet";
            static inline std::string sInventoryIcon = "inv_all";
            static inline std::string sTrackIcon = "magic_shock";
            static inline std::string sDoFavorIcon = "default_scroll";
        };
    };
}

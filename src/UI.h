#pragma once

namespace kxWhereAreYou::UI {
    namespace Messages {
        void Show(const std::string& bodyText, const std::vector<std::string>& buttonTextValues, const std::function<void(unsigned int)>& callback);
    }

    namespace Console {
        void Print(std::string text);
        void SelectReference(RE::TESObjectREFR* reference);
    }
}

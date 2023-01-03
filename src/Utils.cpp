#include "Utils.h"

namespace kxWhereAreYou::Utils::String {
    bool IsSubstring(const std::string& strHaystack, const std::string& strNeedle) {
        auto it = std::search(strHaystack.begin(), strHaystack.end(), strNeedle.begin(), strNeedle.end(),
                              [](char ch1, char ch2) { return std::tolower(ch1) == std::tolower(ch2); });
        return (it != strHaystack.end());
    }

    void ConvertToLowerCase(std::string& text) {
        std::transform(text.begin(), text.end(), text.begin(), [](unsigned char c) { return (char)std::tolower(c); });
    }
}

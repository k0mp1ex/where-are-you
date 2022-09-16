Scriptname kxUtils hidden

; Check if a string match against a pattern. A pattern can use a wildcard 
; Ex:
;   Text    = "baaabab",
;   Pattern = "*****ba*****ab" => output: true
;   Pattern = "baaa?ab"        => output: true
;   Pattern = "ba*a?"          => output: true
;   Pattern = "a*ab"           => output: false 
bool function StringMatch(string text, string pattern, bool patternMatchingEnabled = true) global
  if !patternMatchingEnabled
    return StringUtil.Find(text, pattern) > -1
  else
    ; TODO: implement!
    return StringUtil.Find(text, pattern) > -1
  endIf
endFunction

; Expects a major, minor and patch as an int version, every version part with 2 digits
; Ex: 010000 => 1.0.0
;     025203 => 2.52.3
;     120968 => 12.9.68
string function GetModVersionAsString(int modVersion) global
  int major = modVersion / 10000
  int minor = (modVersion - major * 10000) / 100
  int patch = modVersion - major * 10000 - minor * 100
  return major + "." + minor + "." + patch
endFunction

bool function IsInMenus() global
  return Utility.IsInMenuMode() || \
         UI.IsMenuOpen("Crafting Menu") || \
         UI.IsMenuOpen("RaceSex Menu") || \
         UI.IsMenuOpen("CustomMenu")
endFunction

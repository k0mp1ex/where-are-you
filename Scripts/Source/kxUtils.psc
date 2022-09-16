Scriptname kxUtils hidden

; Krauss wildcard-matching algorithm
; Check if a string match against a pattern. A pattern can use a wildcard 
; Ex:
;   Text    = "baaabab",
;   Pattern = "*****ba*****ab" => output: true
;   Pattern = "baaa?ab"        => output: true
;   Pattern = "ba*a?"          => output: true
;   Pattern = "a*ab"           => output: false 
bool function StringMatch(string text, string pattern) global
  if StringUtil.Find(pattern, "*") > -1 || StringUtil.Find(pattern, "?") > -1
    return StringMatchPattern(text, pattern)
  else
    return StringUtil.Find(text, pattern) > -1
  endIf
endFunction

string function StringOptimizePattern(string pattern) global
  string newPattern = ""
  bool first = true
  int i = 0
  while i < StringUtil.GetLength(pattern)
    if StringUtil.GetNthChar(pattern, i) == "*"
      if first
        newPattern += "*"
        first = false
      endIf
    else
      newPattern += StringUtil.GetNthChar(pattern, i)
      first = true
    endIf
    i += 1
  endWhile
  return newPattern
endFunction

bool function StringMatchPattern(string str, string pattern) global
  int n = StringUtil.GetLength(str)
  int m = StringUtil.GetLength(pattern)

  if (n == 0) && (m == 0)
    return false
  endIf

  int map = JMap.object()
  JValue.retain(map)

  ; Initialization
  int i = 0
  int j = 0
  while i <= n
    while j <= m
      SetJMapBoolValueAtXandY(map, i, j, false)
      j += 1
    endWhile
    j = 0
    i += 1
  endWhile

  SetJMapBoolValueAtXandY(map, 0, 0, true)

  if (m > 0) && StringUtil.GetNthChar(pattern, 0) == "*"
    SetJMapBoolValueAtXandY(map, 0, 1, true)
  endIf

  i = 1
  j = 1
  while i <= n
    while j <= m
      if StringUtil.GetNthChar(pattern, j - 1) == "?" || (StringUtil.GetNthChar(pattern, j - 1) == StringUtil.GetNthChar(str, i - 1))
        SetJMapBoolValueAtXandY(map, i, j, GetJMapBoolValueAtXandY(map, i - 1, j - 1))
      elseIf StringUtil.GetNthChar(pattern, j - 1) == "*" 
        SetJMapBoolValueAtXandY(map, i, j, GetJMapBoolValueAtXandY(map, i - 1, j) || GetJMapBoolValueAtXandY(map, i, j - 1))
      endIf
      j += 1
    endWhile
    j = 1
    i += 1
  endWhile

  ; TODO: Remove
  ; MiscUtil.PrintConsole("Matched " + str + " against " + pattern)
  ; DumpJMapBool(map, n, m)

  bool result = GetJMapBoolValueAtXandY(map, n, m)
  JValue.release(map)
  return result
endFunction

function SetJMapBoolValueAtXandY(int map, int i, int j, bool value) global
  JMap.setInt(map, "["+i+"]"+"["+j+"]", (value as int))
endFunction

bool function GetJMapBoolValueAtXandY(int map, int i, int j) global
  return JMap.getInt(map, "["+i+"]"+"["+j+"]") as bool
endFunction

function DumpJMapBool(int map, int n, int m) global
  int i = 0
  int j = 0
  string line = "\n|"
  while i <= n
    while j <= m
      string text
      if GetJMapBoolValueAtXandY(map, i, j)
        text = "T"
      else
        text = "F"
      endIf
      line += text + "|"
      j += 1
    endWhile
    line += "\n|"
    j = 0
    i += 1
  endWhile
  MiscUtil.PrintConsole(StringUtil.Substring(line, 0, StringUtil.GetLength(line) - 2))
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

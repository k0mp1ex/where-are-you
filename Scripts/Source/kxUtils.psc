Scriptname kxUtils hidden

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

Actor function GetActorAtCrosshair() global
  return Game.GetCurrentCrosshairRef() as Actor
endFunction

bool function IsDynamicObjectReference(ObjectReference reference) global
  return Math.LogicalAnd(Math.RightShift(reference.GetFormID(), 24), 0xFF) == 0xFF
endFunction

string function GetModNameFromForm(Form object) global
  int pluginIndex = Math.LogicalAnd(Math.RightShift(object.GetFormID(), 24), 0xFF)
  if pluginIndex == 0xFF
    ObjectReference ref = object as ObjectReference
    if ref
      return GetModNameFromForm(ref.GetBaseObject())
    endIf
  elseIf pluginIndex == 0xFE
    int lightIndex = Math.LogicalAnd(Math.RightShift(object.GetFormID(), 12), 0xFFF)
    return Game.GetLightModName(lightIndex)
  else
    return Game.GetModName(pluginIndex)
  endif
endFunction

bool function IsInMenus() global
  return Utility.IsInMenuMode() || \
         UI.IsMenuOpen("Crafting Menu") || \
         UI.IsMenuOpen("RaceSex Menu") || \
         UI.IsMenuOpen("CustomMenu") || \
         UI.IsTextInputEnabled()
endFunction

function WaitForMenus() global
  while IsInMenus()
    Utility.Wait(0.5)
  endWhile
endFunction

bool function IsCtrlKeyPressed() global
  return Input.IsKeyPressed(29) || Input.IsKeyPressed(157) ; Left Ctrl || Right Ctrl
endFunction

bool function IsShiftKeyPressed() global
  return Input.IsKeyPressed(42) || Input.IsKeyPressed(54) ; Left Shift || Right Shift
endFunction

bool function IsAltKeyPressed() global
  return Input.IsKeyPressed(56) || Input.IsKeyPressed(184) ; Left Alt || Right Alt
endFunction

bool function IsKeyCombinationPressed(int keyCode, int mappedKeyCode, bool hasCtrlKeyCode, bool hasShiftKeyCode, bool hasAltKeyCode) global
  return (keyCode == mappedKeyCode) && \
         (IsCtrlKeyPressed() == hasCtrlKeyCode) && \
         (IsShiftKeyPressed() == hasShiftKeyCode) && \
         (IsAltKeyPressed() == hasAltKeyCode)
endFunction

string function Coalesce(string string1, string string2) global
  if string1 != ""
    return string1
  else
    return string2
  endIf
endFunction

Scriptname kxWhereAreYouMcm extends MCM_ConfigBase

import kxWhereAreYouLogging
import kxWhereAreYouNative

function OnConfigClose()
  kxWhereAreYouAlias playerAlias = GetNthAlias(0) as kxWhereAreYouAlias
  playerAlias.UnregisterForAllKeys()
  playerAlias.RegisterForAllKeys()
  UpdateMcmSettings()
endFunction

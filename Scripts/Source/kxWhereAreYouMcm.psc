Scriptname kxWhereAreYouMcm extends MCM_ConfigBase

import kxWhereAreYouLogging

function OnConfigClose()
  kxWhereAreYouAlias playerAlias = GetNthAlias(0) as kxWhereAreYouAlias
  playerAlias.UnregisterForAllKeys()
  playerAlias.RegisterForAllKeys()
endFunction

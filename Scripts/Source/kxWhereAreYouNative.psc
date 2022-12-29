scriptName kxWhereAreYouNative hidden

function PrintToConsole(string msg) global native
function SelectReferenceInConsole(ObjectReference ref) global native
Actor[] function SearchActorsByName(string pattern, bool useRegex, bool sortResults, int maxResultCount) global native
string function GetSummaryDataForActor(Actor actor, string format="") global native
int function HexadecimalStringToInteger(string hexString) global native
int function GetAliasIndexOfActorInQuest(Actor npc, Quest currentQuest) global native
int function GetNextAvailableAliasInQuest(Quest currentQuest) global native

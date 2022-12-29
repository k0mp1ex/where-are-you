scriptName kxWhereAreYouNative hidden

function PrintConsole(string msg) global native
function SetSelectedReference(ObjectReference ref) global native
Actor[] function SearchNPCsByName(string pattern, bool useRegex, bool sortResults, int maxResultCount) global native
string function GetStatsTextForNpc(Actor actor, string format="") global native
int function HexStrToDec(string hexString) global native
int function GetTrackingSlotForNpcInQuest(Actor npc, Quest currentQuest) global native
int function GetNextAvailableTrackingSlotInQuest(Quest currentQuest) global native

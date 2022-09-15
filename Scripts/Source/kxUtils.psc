Scriptname kxUtils hidden

{
  Check if a string match against a pattern
  A pattern can use a wildcard 
  
  Text = "baaabab",
  Pattern = “*****ba*****ab", output : true
  Pattern = "baaa?ab", output : true
  Pattern = "ba*a?", output : true
  Pattern = "a*ab", output : false 
}
bool function StringMatch(string text, string pattern, bool patternMatchingEnabled = true) global
  ; TODO: implement when patternMatchingEnabled == true
  return StringUtil.Find(text, pattern) > -1
endFunction

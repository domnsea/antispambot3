diff --git a/ZoomAntiSpamBot/scripts/spam_score_modifiers.ahk b/ZoomAntiSpamBot/scripts/spam_score_modifiers.ahk
index 4b005e7805e9feea46c0d1704b5a9d920ee5f1a5..924ced935ba3524b865a5b82fb6ba177a3e3afe9 100644
--- a/ZoomAntiSpamBot/scripts/spam_score_modifiers.ahk
+++ b/ZoomAntiSpamBot/scripts/spam_score_modifiers.ahk
@@ -1,3 +1,9 @@
-; WRAPPERS_INJECTEDToLower(str) {    StringLower, out, str    return out}ToUpper(str) {    StringUpper, out, str    return out}TrimStr(str) {    StringTrimLeft, temp, str, 0    StringTrimRight, temp, temp, 0    return temp}Split(str, delim="|") {    arr := []    Loop, Parse, str,         arr.Push(A_LoopField)    return arr}InStrCompat(haystack, needle) {    return InStrCompat(haystack, needle)}
-; WRAPPERS_INJECTEDToLower(str) {    StringLower, out, str    return out}ToUpper(str) {    StringUpper, out, str    return out}TrimStr(str) {    StringTrimLeft, temp, str, 0    StringTrimRight, temp, temp, 0    return temp}Split(str, delim="|") {    arr := []    Loop, Parse, str,         arr.Push(A_LoopField)    return arr}InStrCompat(haystack, needle) {    return InStr(haystack, needle)}
-script
+; spam_score_modifiers.ahk
+; Adjustable threshold for spam scoring.
+
+global SpamScoreThreshold := 4
+
+SetSpamThreshold(value) {
+    global SpamScoreThreshold
+    SpamScoreThreshold := value
+}

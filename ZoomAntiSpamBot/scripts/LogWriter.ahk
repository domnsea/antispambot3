 (cd "$(git rev-parse --show-toplevel)" && git apply --3way <<'EOF' 
diff --git a/ZoomAntiSpamBot/scripts/LogWriter.ahk b/ZoomAntiSpamBot/scripts/LogWriter.ahk
index 4b005e7805e9feea46c0d1704b5a9d920ee5f1a5..11c7cde1af33889453e1fa0c8ee7ccc134c5105b 100644
--- a/ZoomAntiSpamBot/scripts/LogWriter.ahk
+++ b/ZoomAntiSpamBot/scripts/LogWriter.ahk
@@ -1,3 +1,7 @@
-; WRAPPERS_INJECTEDToLower(str) {    StringLower, out, str    return out}ToUpper(str) {    StringUpper, out, str    return out}TrimStr(str) {    StringTrimLeft, temp, str, 0    StringTrimRight, temp, temp, 0    return temp}Split(str, delim="|") {    arr := []    Loop, Parse, str,         arr.Push(A_LoopField)    return arr}InStrCompat(haystack, needle) {    return InStrCompat(haystack, needle)}
-; WRAPPERS_INJECTEDToLower(str) {    StringLower, out, str    return out}ToUpper(str) {    StringUpper, out, str    return out}TrimStr(str) {    StringTrimLeft, temp, str, 0    StringTrimRight, temp, temp, 0    return temp}Split(str, delim="|") {    arr := []    Loop, Parse, str,         arr.Push(A_LoopField)    return arr}InStrCompat(haystack, needle) {    return InStr(haystack, needle)}
-script
+; LogWriter.ahk
+; Simple logging helper.
+
+WriteLog(msg) {
+    FormatTime, ts,, yyyy-MM-dd HH:mm:ss
+    FileAppend, % ts " | " msg "`n", %A_ScriptDir% "\\logs\\bot.log"
+}
 
EOF
)

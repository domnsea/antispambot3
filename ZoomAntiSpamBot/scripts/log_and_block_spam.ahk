 (cd "$(git rev-parse --show-toplevel)" && git apply --3way <<'EOF' 
diff --git a/ZoomAntiSpamBot/scripts/log_and_block_spam.ahk b/ZoomAntiSpamBot/scripts/log_and_block_spam.ahk
index 0d4392e7b877081d6920c9118620cca148632162..568b3cfd80d7e310cfb937d4aff91800f2dec03f 100644
--- a/ZoomAntiSpamBot/scripts/log_and_block_spam.ahk
+++ b/ZoomAntiSpamBot/scripts/log_and_block_spam.ahk
@@ -1,18 +1,10 @@
-diff --git a/ZoomAntiSpamBot/scripts/log_and_block_spam.ahk b/ZoomAntiSpamBot/scripts/log_and_block_spam.ahk
-index 4b005e7805e9feea46c0d1704b5a9d920ee5f1a5..95273fec3d5ca92840c4dcd3adc75e75cc45c704 100644
---- a/ZoomAntiSpamBot/scripts/log_and_block_spam.ahk
-+++ b/ZoomAntiSpamBot/scripts/log_and_block_spam.ahk
-@@ -1,3 +1,10 @@
--; WRAPPERS_INJECTEDToLower(str) {    StringLower, out, str    return out}ToUpper(str) {    StringUpper, out, str    return out}TrimStr(str) {    StringTrimLeft, temp, str, 0    StringTrimRight, temp, temp, 0    return temp}Split(str, delim="|") {    arr := []    Loop, Parse, str,         arr.Push(A_LoopField)    return arr}InStrCompat(haystack, needle) {    return InStrCompat(haystack, needle)}
--; WRAPPERS_INJECTEDToLower(str) {    StringLower, out, str    return out}ToUpper(str) {    StringUpper, out, str    return out}TrimStr(str) {    StringTrimLeft, temp, str, 0    StringTrimRight, temp, temp, 0    return temp}Split(str, delim="|") {    arr := []    Loop, Parse, str,         arr.Push(A_LoopField)    return arr}InStrCompat(haystack, needle) {    return InStr(haystack, needle)}
--script
-+; log_and_block_spam.ahk
-+; Logs spam content and flags the participant ID.
-+
-+#Include flagged_ids.ahk
-+
-+log_and_block_spam(participantID, message, name := "") {
-+    FormatTime, ts,, yyyy-MM-dd HH:mm:ss
-+    FileAppend, % ts " | " participantID " | " message "`n", logs\spam_events.log
-+    AddFlaggedID(participantID, name)
-+}
+; log_and_block_spam.ahk
+; Logs spam content and flags the participant ID.
+
+#Include flagged_ids.ahk
+
+log_and_block_spam(participantID, message, name := "") {
+    FormatTime, ts,, yyyy-MM-dd HH:mm:ss
+    FileAppend, % ts " | " participantID " | " message "`n", %A_ScriptDir% "\\logs\\spam_events.log"
+    AddFlaggedID(participantID, name)
+}
 
EOF
)

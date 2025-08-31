 (cd "$(git rev-parse --show-toplevel)" && git apply --3way <<'EOF' 
diff --git a/ZoomAntiSpamBot/scripts/FlagTracker.ahk b/ZoomAntiSpamBot/scripts/FlagTracker.ahk
index 7c867bf36ec2edc83152302b1a5641e69524128a..c59478c6e2d9089cea643fb01c10444f84a632a5 100644
--- a/ZoomAntiSpamBot/scripts/FlagTracker.ahk
+++ b/ZoomAntiSpamBot/scripts/FlagTracker.ahk
@@ -1,26 +1,18 @@
-diff --git a/ZoomAntiSpamBot/scripts/FlagTracker.ahk b/ZoomAntiSpamBot/scripts/FlagTracker.ahk
-index 4b005e7805e9feea46c0d1704b5a9d920ee5f1a5..d6e0c8c944b4829a2ec562107bf5e950d851561d 100644
---- a/ZoomAntiSpamBot/scripts/FlagTracker.ahk
-+++ b/ZoomAntiSpamBot/scripts/FlagTracker.ahk
-@@ -1,3 +1,18 @@
--; WRAPPERS_INJECTEDToLower(str) {    StringLower, out, str    return out}ToUpper(str) {    StringUpper, out, str    return out}TrimStr(str) {    StringTrimLeft, temp, str, 0    StringTrimRight, temp, temp, 0    return temp}Split(str, delim="|") {    arr := []    Loop, Parse, str,         arr.Push(A_LoopField)    return arr}InStrCompat(haystack, needle) {    return InStrCompat(haystack, needle)}
--; WRAPPERS_INJECTEDToLower(str) {    StringLower, out, str    return out}ToUpper(str) {    StringUpper, out, str    return out}TrimStr(str) {    StringTrimLeft, temp, str, 0    StringTrimRight, temp, temp, 0    return temp}Split(str, delim="|") {    arr := []    Loop, Parse, str,         arr.Push(A_LoopField)    return arr}InStrCompat(haystack, needle) {    return InStr(haystack, needle)}
--script
-+; FlagTracker.ahk
-+; Simple helper to log and retrieve flagged participant IDs.
-+
-+#Include flagged_ids.ahk
-+
-+FlagTracker_Log(id) {
-+    AddFlaggedID(id)
-+    FormatTime, ts,, yyyy-MM-dd HH:mm:ss
-+    FileAppend, % ts " | " id "`n", logs\flagged_ids.log
-+}
-+
-+FlagTracker_List() {
-+    ids := GetFlaggedIDs()
-+    list := ""
-+    for index, id in ids
-+        list .= id "`n"
-+    return list
-+}
+; FlagTracker.ahk
+; Simple helper to log and retrieve flagged participant IDs.
+
+#Include flagged_ids.ahk
+
+FlagTracker_Log(id) {
+    AddFlaggedID(id)
+    FormatTime, ts,, yyyy-MM-dd HH:mm:ss
+    FileAppend, % ts " | " id "`n", %A_ScriptDir% "\\logs\\flagged_ids.log"
+}
+
+FlagTracker_List() {
+    ids := GetFlaggedIDs()
+    list := ""
+    for index, obj in ids
+        list .= obj.ID "`n"
+    return list
+}
 
EOF
)


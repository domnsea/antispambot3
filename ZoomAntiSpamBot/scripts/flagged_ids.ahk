 (cd "$(git rev-parse --show-toplevel)" && git apply --3way <<'EOF' 
diff --git a/ZoomAntiSpamBot/scripts/flagged_ids.ahk b/ZoomAntiSpamBot/scripts/flagged_ids.ahk
index 7d5f1c37b7597a642d1400ff901a7bbb660bf82e..9f05627bb47b1fed49d569788897efeff35473e1 100644
--- a/ZoomAntiSpamBot/scripts/flagged_ids.ahk
+++ b/ZoomAntiSpamBot/scripts/flagged_ids.ahk
@@ -1,46 +1,38 @@
-diff --git a/ZoomAntiSpamBot/scripts/flagged_ids.ahk b/ZoomAntiSpamBot/scripts/flagged_ids.ahk
-index 4b005e7805e9feea46c0d1704b5a9d920ee5f1a5..0ddeb01ade79252d2a391dd9cb0cebe8f5272168 100644
---- a/ZoomAntiSpamBot/scripts/flagged_ids.ahk
-+++ b/ZoomAntiSpamBot/scripts/flagged_ids.ahk
-@@ -1,3 +1,38 @@
--; WRAPPERS_INJECTEDToLower(str) {    StringLower, out, str    return out}ToUpper(str) {    StringUpper, out, str    return out}TrimStr(str) {    StringTrimLeft, temp, str, 0    StringTrimRight, temp, temp, 0    return temp}Split(str, delim="|") {    arr := []    Loop, Parse, str,         arr.Push(A_LoopField)    return arr}InStrCompat(haystack, needle) {    return InStrCompat(haystack, needle)}
--; WRAPPERS_INJECTEDToLower(str) {    StringLower, out, str    return out}ToUpper(str) {    StringUpper, out, str    return out}TrimStr(str) {    StringTrimLeft, temp, str, 0    StringTrimRight, temp, temp, 0    return temp}Split(str, delim="|") {    arr := []    Loop, Parse, str,         arr.Push(A_LoopField)    return arr}InStrCompat(haystack, needle) {    return InStr(haystack, needle)}
--script
-+; flagged_ids.ahk
-+; Maintains list of participant IDs flagged for spam activity.
-+
-+if (!IsObject(FlaggedIDs)) {
-+    global FlaggedIDs := {}
-+    path := A_ScriptDir . "\\data\\flagged_ids.txt"
-+    if FileExist(path) {
-+        Loop, Read, %path%
-+        {
-+            parts := StrSplit(A_LoopReadLine, ",")
-+            id := parts[1]
-+            name := (parts.Length() > 1 ? parts[2] : "")
-+            if (id != "")
-+                FlaggedIDs[id] := name
-+        }
-+    }
-+}
-+
-+AddFlaggedID(id, name := "") {
-+    global FlaggedIDs
-+    if (!FlaggedIDs.HasKey(id)) {
-+        FlaggedIDs[id] := name
-+        FileAppend, % id "," name "`n", data\\flagged_ids.txt
-+    }
-+}
-+
-+IsFlaggedID(id) {
-+    global FlaggedIDs
-+    return FlaggedIDs.HasKey(id)
-+}
-+
-+GetFlaggedIDs() {
-+    global FlaggedIDs
-+    ids := []
-+    for id, name in FlaggedIDs
-+        ids.Push({ID: id, Name: name})
-+    return ids
-+}
+; flagged_ids.ahk
+; Maintains list of participant IDs flagged for spam activity.
+
+if (!IsObject(FlaggedIDs)) {
+    global FlaggedIDs := {}
+    path := A_ScriptDir . "\\data\\flagged_ids.txt"
+    if FileExist(path) {
+        Loop, Read, %path%
+        {
+            parts := StrSplit(A_LoopReadLine, ",")
+            id := parts[1]
+            name := (parts.Length() > 1 ? parts[2] : "")
+            if (id != "")
+                FlaggedIDs[id] := name
+        }
+    }
+}
+
+AddFlaggedID(id, name := "") {
+    global FlaggedIDs
+    if (!FlaggedIDs.HasKey(id)) {
+        FlaggedIDs[id] := name
+        FileAppend, % id "," name "`n", %A_ScriptDir% "\\data\\flagged_ids.txt"
+    }
+}
+
+IsFlaggedID(id) {
+    global FlaggedIDs
+    return FlaggedIDs.HasKey(id)
+}
+
+GetFlaggedIDs() {
+    global FlaggedIDs
+    ids := []
+    for id, name in FlaggedIDs
+        ids.Push({ID: id, Name: name})
+    return ids
+}
 
EOF
)

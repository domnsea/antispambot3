diff --git a/ZoomAntiSpamBot/scripts/DetectDuplicateMessages.ahk b/ZoomAntiSpamBot/scripts/DetectDuplicateMessages.ahk
index 08de711f67c7d650bb71c3d5d36c2efce5f1e638..1105f78147a1a481559562355887b795fb687a7d 100644
--- a/ZoomAntiSpamBot/scripts/DetectDuplicateMessages.ahk
+++ b/ZoomAntiSpamBot/scripts/DetectDuplicateMessages.ahk
@@ -1,38 +1,30 @@
-diff --git a/ZoomAntiSpamBot/scripts/DetectDuplicateMessages.ahk b/ZoomAntiSpamBot/scripts/DetectDuplicateMessages.ahk
-index 4b005e7805e9feea46c0d1704b5a9d920ee5f1a5..1105f78147a1a481559562355887b795fb687a7d 100644
---- a/ZoomAntiSpamBot/scripts/DetectDuplicateMessages.ahk
-+++ b/ZoomAntiSpamBot/scripts/DetectDuplicateMessages.ahk
-@@ -1,3 +1,30 @@
--; WRAPPERS_INJECTEDToLower(str) {    StringLower, out, str    return out}ToUpper(str) {    StringUpper, out, str    return out}TrimStr(str) {    StringTrimLeft, temp, str, 0    StringTrimRight, temp, temp, 0    return temp}Split(str, delim="|") {    arr := []    Loop, Parse, str,         arr.Push(A_LoopField)    return arr}InStrCompat(haystack, needle) {    return InStrCompat(haystack, needle)}
--; WRAPPERS_INJECTEDToLower(str) {    StringLower, out, str    return out}ToUpper(str) {    StringUpper, out, str    return out}TrimStr(str) {    StringTrimLeft, temp, str, 0    StringTrimRight, temp, temp, 0    return temp}Split(str, delim="|") {    arr := []    Loop, Parse, str,         arr.Push(A_LoopField)    return arr}InStrCompat(haystack, needle) {    return InStr(haystack, needle)}
--script
-+; DetectDuplicateMessages.ahk
-+; Tracks chat messages per participant and triggers chat disable/enable
-+; when the same message is sent more than once.
-+
-+#Include DisableMeetingChat.ahk
-+#Include EnableMeetingChat.ahk
-+#Include log_and_block_spam.ahk
-+#Include delete_spam_message.ahk
-+
-+; global storage for message history
-+if (!IsObject(DuplicateHistory))
-+    global DuplicateHistory := {}
-+
-+; Checks a message and returns true if it is considered duplicate spam.
-+DetectDuplicateMessage(participantID, message, name := "") {
-+    global DuplicateHistory
-+    key := participantID . ":" . message
-+    count := DuplicateHistory.HasKey(key) ? DuplicateHistory[key] : 0
-+    count++
-+    DuplicateHistory[key] := count
-+
-+    if (count > 1) {
-+        DisableMeetingChat()
-+        log_and_block_spam(participantID, message, name)
-+        DeleteSpamMessage()
-+        EnableMeetingChat()
-+        return true
-+    }
-+    return false
-+}
+; DetectDuplicateMessages.ahk
+; Tracks chat messages per participant and triggers chat disable/enable
+; when the same message is sent more than once.
+
+#Include DisableMeetingChat.ahk
+#Include EnableMeetingChat.ahk
+#Include log_and_block_spam.ahk
+#Include delete_spam_message.ahk
+
+; global storage for message history
+if (!IsObject(DuplicateHistory))
+    global DuplicateHistory := {}
+
+; Checks a message and returns true if it is considered duplicate spam.
+DetectDuplicateMessage(participantID, message, name := "") {
+    global DuplicateHistory
+    key := participantID . ":" . message
+    count := DuplicateHistory.HasKey(key) ? DuplicateHistory[key] : 0
+    count++
+    DuplicateHistory[key] := count
+
+    if (count > 1) {
+        DisableMeetingChat()
+        log_and_block_spam(participantID, message, name)
+        DeleteSpamMessage()
+        EnableMeetingChat()
+        return true
+    }
+    return false
+}

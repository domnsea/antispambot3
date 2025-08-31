 (cd "$(git rev-parse --show-toplevel)" && git apply --3way <<'EOF' 
diff --git a/ZoomAntiSpamBot/scripts/scan_chat_for_spam.ahk b/ZoomAntiSpamBot/scripts/scan_chat_for_spam.ahk
index df8903ed9da64cceefdcdaeb3c3c02904502975e..e2bb5b3e3b4a7e27c8f20a26642b5a0386b2ca63 100644
--- a/ZoomAntiSpamBot/scripts/scan_chat_for_spam.ahk
+++ b/ZoomAntiSpamBot/scripts/scan_chat_for_spam.ahk
@@ -1,64 +1,92 @@
-diff --git a/ZoomAntiSpamBot/scripts/scan_chat_for_spam.ahk b/ZoomAntiSpamBot/scripts/scan_chat_for_spam.ahk
-index 4b005e7805e9feea46c0d1704b5a9d920ee5f1a5..dd17b18f80dacf344156843de6f9904278bc1a26 100644
---- a/ZoomAntiSpamBot/scripts/scan_chat_for_spam.ahk
-+++ b/ZoomAntiSpamBot/scripts/scan_chat_for_spam.ahk
-@@ -1,3 +1,54 @@
--; WRAPPERS_INJECTEDToLower(str) {    StringLower, out, str    return out}ToUpper(str) {    StringUpper, out, str    return out}TrimStr(str) {    StringTrimLeft, temp, str, 0    StringTrimRight, temp, temp, 0    return temp}Split(str, delim="|") {    arr := []    Loop, Parse, str,         arr.Push(A_LoopField)    return arr}InStrCompat(haystack, needle) {    return InStrCompat(haystack, needle)}
--; WRAPPERS_INJECTEDToLower(str) {    StringLower, out, str    return out}ToUpper(str) {    StringUpper, out, str    return out}TrimStr(str) {    StringTrimLeft, temp, str, 0    StringTrimRight, temp, temp, 0    return temp}Split(str, delim="|") {    arr := []    Loop, Parse, str,         arr.Push(A_LoopField)    return arr}InStrCompat(haystack, needle) {    return InStr(haystack, needle)}
--script
-+; scan_chat_for_spam.ahk
-+; High-level chat monitoring routine. Reads the Zoom chat window and
-+; uses duplicate detection and spam scoring to decide when to act.
-+
-+#Include DetectDuplicateMessages.ahk
-+#Include SpamScoreEngine.ahk
-+#Include SendSpammerToWaitRoom.ahk
-+#Include flagged_ids.ahk
-+#Include DisableMeetingChat.ahk
-+#Include EnableMeetingChat.ahk
-+#Include log_and_block_spam.ahk
-+
-+scan_chat_for_spam() {
-+    messages := ReadChatWindow()
-+    for index, msg in messages {
-+        if IsFlaggedID(msg.ParticipantID) {
-+            SendSpammerToWaitRoom(msg.ParticipantID)
-+            continue
-+        }
-+        if HasEmojiSpam(msg.Text) {
-+            DisableMeetingChat()
-+            log_and_block_spam(msg.ParticipantID, msg.Text)
-+            EnableMeetingChat()
-+            SendSpammerToWaitRoom(msg.ParticipantID)
-+            continue
-+        }
-+        if DetectDuplicateMessage(msg.ParticipantID, msg.Text, msg.Name) {
-+            ; Duplicate handler already logs and flags
-+        }
-+        participant := {
-+            Name: msg.Name,
-+            HasCamera: msg.HasCamera,
-+            HasAudio: msg.HasAudio,
-+            CanMultiPin: msg.CanMultiPin,
-+            CanTurnCamOn: msg.CanTurnCamOn
-+        }
-+        if ShouldWaitRoom(participant, SpamThreshold) {
-+            SendSpammerToWaitRoom(msg.ParticipantID)
-+        }
-+    }
-+}
-+
-+HasEmojiSpam(text) {
-+    devil := Chr(0x1F608)
-+    fire := Chr(0x1F525)
-+    return (RegExMatch(text, "(" devil "){3,}") && RegExMatch(text, "(" fire "){3,}"))
-+}
-+
-+; Placeholder to obtain messages from the chat window. Implemented elsewhere
-+; using OCR or API calls. Each message should be an object with fields used
-+; above.
-+ReadChatWindow() {
-+    return []
-+}
-
-
+; scan_chat_for_spam.ahk
+; High-level chat monitoring routine. Reads the Zoom chat window and
+; uses duplicate detection and spam scoring to decide when to act.
+
+#Include DetectDuplicateMessages.ahk
+#Include SpamScoreEngine.ahk
+#Include SendSpammerToWaitRoom.ahk
+#Include flagged_ids.ahk
+#Include name_to_id_map.ahk
+#Include DisableMeetingChat.ahk
+#Include EnableMeetingChat.ahk
+#Include log_and_block_spam.ahk
+
+; Title of the Zoom chat window. Adjust if Zoom localizes the name.
+ChatWindowTitle := "Meeting chat"
+SpamThreshold := 5
+
+scan_chat_for_spam() {
+    messages := ReadChatWindow()
+    for index, msg in messages {
+        if IsFlaggedID(msg.ParticipantID) {
+            SendSpammerToWaitRoom(msg.ParticipantID)
+            continue
+        }
+        if HasEmojiSpam(msg.Text) {
+            DisableMeetingChat()
+            log_and_block_spam(msg.ParticipantID, msg.Text)
+            EnableMeetingChat()
+            SendSpammerToWaitRoom(msg.ParticipantID)
+            continue
+        }
+        if DetectDuplicateMessage(msg.ParticipantID, msg.Text, msg.Name) {
+            ; Duplicate handler already logs and flags
+        }
+        participant := {
+            Name: msg.Name,
+            HasCamera: msg.HasCamera,
+            HasAudio: msg.HasAudio,
+            CanMultiPin: msg.CanMultiPin,
+            CanTurnCamOn: msg.CanTurnCamOn
+        }
+        if ShouldWaitRoom(participant, SpamThreshold) {
+            SendSpammerToWaitRoom(msg.ParticipantID)
+        }
+    }
+}
+
+HasEmojiSpam(text) {
+    devil := Chr(0x1F608)
+    fire := Chr(0x1F525)
+    return (RegExMatch(text, "(" devil "){3,}") && RegExMatch(text, "(" fire "){3,}"))
+}
+
+; Reads the Zoom "Meeting chat" window and returns an array of message objects.
+; Each object includes ParticipantID, Name, Text and capability flags used by
+; the spam scoring engine.  This implementation relies on the chat text being
+; available via standard controls; if OCR is required, integrate with
+; scripts/OCR.ahk instead.
+ReadChatWindow() {
+    global ChatWindowTitle
+    WinGet, hwnd, ID, %ChatWindowTitle%
+    if (!hwnd)
+        return []
+
+    ControlGetText, raw, RichEdit20W1, ahk_id %hwnd%
+    if (ErrorLevel)
+        ControlGetText, raw, Edit1, ahk_id %hwnd%
+
+    lines := []
+    for index, line in StrSplit(raw, "`n") {
+        if (line = "")
+            continue
+        ; Zoom chat lines appear as "Name: message text".
+        parts := StrSplit(line, ":")
+        name := TrimStr(parts[1])
+        text := (parts.Length() > 1) ? TrimStr(SubStr(line, StrLen(parts[1]) + 2)) : ""
+        id := GetIDFromName(name)
+        if (id = "")
+            id := name
+        msg := {
+            ParticipantID: id,
+            Name: name,
+            Text: text,
+            HasCamera: false,
+            HasAudio: false,
+            CanMultiPin: false,
+            CanTurnCamOn: false
+        }
+        lines.Push(msg)
+    }
+    return lines
+}
 
EOF
)

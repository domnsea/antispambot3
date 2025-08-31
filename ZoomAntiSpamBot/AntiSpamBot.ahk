 (cd "$(git rev-parse --show-toplevel)" && git apply --3way <<'EOF' 
diff --git a/ZoomAntiSpamBot/AntiSpamBot.ahk b/ZoomAntiSpamBot/AntiSpamBot.ahk
index b08704fb8984fc7b1cb7b78f30e89953829c22f8..ec84c68258ba5a69bba789d112096f310dab7065 100644
--- a/ZoomAntiSpamBot/AntiSpamBot.ahk
+++ b/ZoomAntiSpamBot/AntiSpamBot.ahk
@@ -1,46 +1,47 @@
-; WRAPPERS_INJECTEDToLower(str) {    StringLower, out, str    return out}ToUpper(str) {    StringUpper, out, str    return out}TrimStr(str) {    StringTrimLeft, temp, str, 0    StringTrimRight, temp, temp, 0    return temp}Split(str, delim="|") {    arr := []    Loop, Parse, str,         arr.Push(A_LoopField)    return arr}InStrCompat(haystack, needle) {    return InStrCompat(haystack, needle)}
-SetWorkingDir %A_ScriptDir%
-
-; === Load Core Modules ===
-#Include, SetBotRoot.ahk
-#Include, RunIncludes.ahk
-#Include, FlagTracker.ahk
-#Include, LogWriter.ahk
-#Include, gallery_view_map.ahk
-#Include, gallery_waitroom.ahk
-#Include, name_to_id_map.ahk
-#Include, flagged_ids.ahk
-#Include, OCR.ahk
-#Include, scan_chat_for_spam.ahk
-#Include, log_and_block_spam.ahk
-#Include, SendSpammerToWaitRoom.ahk
-#Include, ShowChatStatusOverlay.ahk
-
-; === Initialize Bot ===
-botActive := true
-logFile := A_ScriptDir . "\bot_runtime_log.txt"
-FileAppend, Bot started at %A_Now%`n, %logFile%
-
-; === Main Loop ===
-Loop
-{
-    if (!botActive)
-        break
-
-    ; Scan chat for spam indicators
-    scan_chat_for_spam()
-
-    ; Check gallery for flagged users
-    gallery_waitroom()
-
-    ; Update overlay status
-    ShowChatStatusOverlay()
-
-    Sleep, 1000  ; Adjust polling interval as needed
-}
-
-; === Shutdown ===
-FileAppend, Bot stopped at %A_Now%`n, %logFile%
-MsgBox, Anti-Spam Bot stopped.
-ExitApp
-
+; AntiSpamBot.ahk
+; Main entry point for Zoom Anti-Spam Bot.
+
+#Include, includes/Wrappers.ahk
+SetWorkingDir %A_ScriptDir%
+
+; === Load Core Modules ===
+#Include, SetBotRoot.ahk
+#Include, scripts/FlagTracker.ahk
+#Include, scripts/LogWriter.ahk
+#Include, scripts/gallery_view_map.ahk
+#Include, scripts/gallery_waitroom.ahk
+#Include, scripts/name_to_id_map.ahk
+#Include, scripts/flagged_ids.ahk
+#Include, scripts/OCR.ahk
+#Include, scripts/scan_chat_for_spam.ahk
+#Include, scripts/log_and_block_spam.ahk
+#Include, scripts/SendSpammerToWaitRoom.ahk
+#Include, scripts/ShowChatStatusOverlay.ahk
+
+; === Initialize Bot ===
+botActive := true
+logFile := A_ScriptDir . "\\bot_runtime_log.txt"
+FileAppend, Bot started at %A_Now%`n, %logFile%
+
+; === Main Loop ===
+Loop
+{
+    if (!botActive)
+        break
+
+    ; Scan chat for spam indicators
+    scan_chat_for_spam()
+
+    ; Check gallery for flagged users
+    gallery_waitroom()
+
+    ; Update overlay status
+    ShowChatStatusOverlay()
+
+    Sleep, 1000  ; Adjust polling interval as needed
+}
+
+; === Shutdown ===
+FileAppend, Bot stopped at %A_Now%`n, %logFile%
+MsgBox, Anti-Spam Bot stopped.
+ExitApp
 
EOF
)

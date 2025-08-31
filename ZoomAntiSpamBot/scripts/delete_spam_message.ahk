 (cd "$(git rev-parse --show-toplevel)" && git apply --3way <<'EOF' 
diff --git a/ZoomAntiSpamBot/scripts/delete_spam_message.ahk b/ZoomAntiSpamBot/scripts/delete_spam_message.ahk
index d622935660275d722c89d366b1faa5f014f2b731..03e05c9cd23572e6e74474a1ab5c5b770651aa80 100644
--- a/ZoomAntiSpamBot/scripts/delete_spam_message.ahk
+++ b/ZoomAntiSpamBot/scripts/delete_spam_message.ahk
@@ -1,27 +1,19 @@
-diff --git a/ZoomAntiSpamBot/scripts/delete_spam_message.ahk b/ZoomAntiSpamBot/scripts/delete_spam_message.ahk
-index 4b005e7805e9feea46c0d1704b5a9d920ee5f1a5..03e05c9cd23572e6e74474a1ab5c5b770651aa80 100644
---- a/ZoomAntiSpamBot/scripts/delete_spam_message.ahk
-+++ b/ZoomAntiSpamBot/scripts/delete_spam_message.ahk
-@@ -1,3 +1,19 @@
--; WRAPPERS_INJECTEDToLower(str) {    StringLower, out, str    return out}ToUpper(str) {    StringUpper, out, str    return out}TrimStr(str) {    StringTrimLeft, temp, str, 0    StringTrimRight, temp, temp, 0    return temp}Split(str, delim="|") {    arr := []    Loop, Parse, str,         arr.Push(A_LoopField)    return arr}InStrCompat(haystack, needle) {    return InStrCompat(haystack, needle)}
--; WRAPPERS_INJECTEDToLower(str) {    StringLower, out, str    return out}ToUpper(str) {    StringUpper, out, str    return out}TrimStr(str) {    StringTrimLeft, temp, str, 0    StringTrimRight, temp, temp, 0    return temp}Split(str, delim="|") {    arr := []    Loop, Parse, str,         arr.Push(A_LoopField)    return arr}InStrCompat(haystack, needle) {    return InStr(haystack, needle)}
--script
-+; delete_spam_message.ahk
-+; Attempts to remove the most recent chat message using image searches.
-+
-+DeleteSpamMessage() {
-+    ; Locate chat window
-+    ImageSearch, wx, wy, 0, 0, A_ScreenWidth, A_ScreenHeight, %A_ScriptDir%\assets\duplicate_indicator.png
-+    if (ErrorLevel)
-+        return
-+    ; Right click near bottom-right of found window to open context menu
-+    MouseClick, right, wx + 10, wy + 10
-+    ; Click delete button
-+    ImageSearch, dx, dy, 0, 0, A_ScreenWidth, A_ScreenHeight, %A_ScriptDir%\assets\chat_delete_button.png
-+    if (!ErrorLevel)
-+        MouseClick, left, dx, dy
-+    ; Confirm delete
-+    ImageSearch, cx, cy, 0, 0, A_ScreenWidth, A_ScreenHeight, %A_ScriptDir%\assets\confirm_delete_button.png
-+    if (!ErrorLevel)
-+        MouseClick, left, cx, cy
-+}
+; delete_spam_message.ahk
+; Attempts to remove the most recent chat message using image searches.
+
+DeleteSpamMessage() {
+    ; Locate chat window
+    ImageSearch, wx, wy, 0, 0, A_ScreenWidth, A_ScreenHeight, %A_ScriptDir%\assets\duplicate_indicator.png
+    if (ErrorLevel)
+        return
+    ; Right click near bottom-right of found window to open context menu
+    MouseClick, right, wx + 10, wy + 10
+    ; Click delete button
+    ImageSearch, dx, dy, 0, 0, A_ScreenWidth, A_ScreenHeight, %A_ScriptDir%\assets\chat_delete_button.png
+    if (!ErrorLevel)
+        MouseClick, left, dx, dy
+    ; Confirm delete
+    ImageSearch, cx, cy, 0, 0, A_ScreenWidth, A_ScreenHeight, %A_ScriptDir%\assets\confirm_delete_button.png
+    if (!ErrorLevel)
+        MouseClick, left, cx, cy
+}
 
EOF
)

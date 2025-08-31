 (cd "$(git rev-parse --show-toplevel)" && git apply --3way <<'EOF' 
diff --git a/ZoomAntiSpamBot/scripts/ShowChatStatusOverlay.ahk b/ZoomAntiSpamBot/scripts/ShowChatStatusOverlay.ahk
index 05a9056f0951895fa19006d3e98b63df5d37bb12..4f1cae30c020dd8463e4c60dfb6389bc1d8fbe02 100644
--- a/ZoomAntiSpamBot/scripts/ShowChatStatusOverlay.ahk
+++ b/ZoomAntiSpamBot/scripts/ShowChatStatusOverlay.ahk
@@ -1,34 +1,11 @@
-; ShowChatStatusOverlay.ahk — Overlay Prep + String Wrappers
-
-ToLower(str) {
-    StringLower, out, str
-    return out
-}
-
-ToUpper(str) {
-    StringUpper, out, str
-    return out
-}
-
-TrimStr(str) {
-    StringTrimLeft, temp, str, 0
-    StringTrimRight, temp, temp, 0
-    return temp
-}
-
-Split(str, delim = "|") {
-    arr := []
-    Loop, Parse, str, %delim%
-        arr.Push(A_LoopField)
-    return arr
-}
-
-InStrCompat(haystack, needle) {
-    return InStr(haystack, needle)
-}
-
-; === Overlay Logic Placeholder ===
-; You can replace this with actual GUI or tooltip logic
-
-MsgBox, 64, Overlay Triggered, Chat status overlay logic is ready.
-return
+; ShowChatStatusOverlay.ahk
+; Displays a simple tooltip indicating the bot's status.
+
+ShowChatStatusOverlay() {
+    ToolTip, Chat monitoring active
+    SetTimer, __HideOverlay, -1000
+}
+
+__HideOverlay() {
+    ToolTip
+}
 
EOF
)

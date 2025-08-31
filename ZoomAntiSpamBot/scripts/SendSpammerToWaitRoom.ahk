 (cd "$(git rev-parse --show-toplevel)" && git apply --3way <<'EOF' 
diff --git a/ZoomAntiSpamBot/scripts/SendSpammerToWaitRoom.ahk b/ZoomAntiSpamBot/scripts/SendSpammerToWaitRoom.ahk
index 6f20bf1e1c5885bdba97b9489fd79035251d3561..af114a314e23dd5988d53d678eb7fe90831eeb16 100644
--- a/ZoomAntiSpamBot/scripts/SendSpammerToWaitRoom.ahk
+++ b/ZoomAntiSpamBot/scripts/SendSpammerToWaitRoom.ahk
@@ -1,17 +1,9 @@
-diff --git a/ZoomAntiSpamBot/scripts/SendSpammerToWaitRoom.ahk b/ZoomAntiSpamBot/scripts/SendSpammerToWaitRoom.ahk
-index 4b005e7805e9feea46c0d1704b5a9d920ee5f1a5..af114a314e23dd5988d53d678eb7fe90831eeb16 100644
---- a/ZoomAntiSpamBot/scripts/SendSpammerToWaitRoom.ahk
-+++ b/ZoomAntiSpamBot/scripts/SendSpammerToWaitRoom.ahk
-@@ -1,3 +1,9 @@
--; WRAPPERS_INJECTEDToLower(str) {    StringLower, out, str    return out}ToUpper(str) {    StringUpper, out, str    return out}TrimStr(str) {    StringTrimLeft, temp, str, 0    StringTrimRight, temp, temp, 0    return temp}Split(str, delim="|") {    arr := []    Loop, Parse, str,         arr.Push(A_LoopField)    return arr}InStrCompat(haystack, needle) {    return InStrCompat(haystack, needle)}
--; WRAPPERS_INJECTEDToLower(str) {    StringLower, out, str    return out}ToUpper(str) {    StringUpper, out, str    return out}TrimStr(str) {    StringTrimLeft, temp, str, 0    StringTrimRight, temp, temp, 0    return temp}Split(str, delim="|") {    arr := []    Loop, Parse, str,         arr.Push(A_LoopField)    return arr}InStrCompat(haystack, needle) {    return InStr(haystack, needle)}
--script
-+; SendSpammerToWaitRoom.ahk
-+; Placeholder for interacting with Zoom to move a participant to the waiting room.
-+
-+#Include log_and_block_spam.ahk
-+
-+SendSpammerToWaitRoom(participantID) {
-+    ; TODO: Implement UI automation with Zoom.
-+    log_and_block_spam(participantID, "moved to waiting room")
-+}
+; SendSpammerToWaitRoom.ahk
+; Placeholder for interacting with Zoom to move a participant to the waiting room.
+
+#Include log_and_block_spam.ahk
+
+SendSpammerToWaitRoom(participantID) {
+    ; TODO: Implement UI automation with Zoom.
+    log_and_block_spam(participantID, "moved to waiting room")
+}
 
EOF
)

 (cd "$(git rev-parse --show-toplevel)" && git apply --3way <<'EOF' 
diff --git a/ZoomAntiSpamBot/scripts/gallery_waitroom.ahk b/ZoomAntiSpamBot/scripts/gallery_waitroom.ahk
index 4b005e7805e9feea46c0d1704b5a9d920ee5f1a5..cd66a957f37aa703665154f592fcde6098beded9 100644
--- a/ZoomAntiSpamBot/scripts/gallery_waitroom.ahk
+++ b/ZoomAntiSpamBot/scripts/gallery_waitroom.ahk
@@ -1,3 +1,37 @@
-; WRAPPERS_INJECTEDToLower(str) {    StringLower, out, str    return out}ToUpper(str) {    StringUpper, out, str    return out}TrimStr(str) {    StringTrimLeft, temp, str, 0    StringTrimRight, temp, temp, 0    return temp}Split(str, delim="|") {    arr := []    Loop, Parse, str,         arr.Push(A_LoopField)    return arr}InStrCompat(haystack, needle) {    return InStrCompat(haystack, needle)}
-; WRAPPERS_INJECTEDToLower(str) {    StringLower, out, str    return out}ToUpper(str) {    StringUpper, out, str    return out}TrimStr(str) {    StringTrimLeft, temp, str, 0    StringTrimRight, temp, temp, 0    return temp}Split(str, delim="|") {    arr := []    Loop, Parse, str,         arr.Push(A_LoopField)    return arr}InStrCompat(haystack, needle) {    return InStr(haystack, needle)}
-script
+; gallery_waitroom.ahk
+; Scans the Zoom gallery for participants with high spam scores and moves
+; them to the waiting room.  Only the last row of the current gallery page is
+; evaluated, as new participants typically appear there.
+
+#Include gallery_view_map.ahk
+#Include SpamScoreEngine.ahk
+#Include SendSpammerToWaitRoom.ahk
+#Include name_to_id_map.ahk
+#Include flagged_ids.ahk
+#Include OCR.ahk
+
+gallery_waitroom() {
+    tiles := GetGalleryTileMap()
+    for idx, coords in tiles {
+        if (coords.row != 5) ; last row
+            continue
+        name := GetNameAtTile(coords.x, coords.y)
+        if (name = "")
+            continue
+        id := GetIDFromName(name)
+        if (id = "")
+            id := name
+        participant := {Name: name, HasCamera: true, HasAudio: true,
+                        CanMultiPin: true, CanTurnCamOn: true}
+        if (IsFlaggedID(id) || ShouldWaitRoom(participant, 5))
+            SendSpammerToWaitRoom(id)
+    }
+}
+
+GetNameAtTile(x, y) {
+    ; Capture a small area around the provided coordinates and OCR the name.
+    ; This is a placeholder; integrate a real screen grabber for production.
+    tmp := A_Temp "\\tile.png"
+    ; Example: CaptureScreen(x-50, y-10, x+50, y+10, tmp)
+    return PerformOCR(tmp)
+}
 
EOF
)

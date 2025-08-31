 (cd "$(git rev-parse --show-toplevel)" && git apply --3way <<'EOF' 
diff --git a/ZoomAntiSpamBot/scripts/gallery_view_map.ahk b/ZoomAntiSpamBot/scripts/gallery_view_map.ahk
index 4b005e7805e9feea46c0d1704b5a9d920ee5f1a5..19106fae3886e3775d66510bc952ceb3c1b22136 100644
--- a/ZoomAntiSpamBot/scripts/gallery_view_map.ahk
+++ b/ZoomAntiSpamBot/scripts/gallery_view_map.ahk
@@ -1,3 +1,30 @@
-; WRAPPERS_INJECTEDToLower(str) {    StringLower, out, str    return out}ToUpper(str) {    StringUpper, out, str    return out}TrimStr(str) {    StringTrimLeft, temp, str, 0    StringTrimRight, temp, temp, 0    return temp}Split(str, delim="|") {    arr := []    Loop, Parse, str,         arr.Push(A_LoopField)    return arr}InStrCompat(haystack, needle) {    return InStrCompat(haystack, needle)}
-; WRAPPERS_INJECTEDToLower(str) {    StringLower, out, str    return out}ToUpper(str) {    StringUpper, out, str    return out}TrimStr(str) {    StringTrimLeft, temp, str, 0    StringTrimRight, temp, temp, 0    return temp}Split(str, delim="|") {    arr := []    Loop, Parse, str,         arr.Push(A_LoopField)    return arr}InStrCompat(haystack, needle) {    return InStr(haystack, needle)}
-script
+; gallery_view_map.ahk
+; Generates a coordinate map for the Zoom gallery view.
+; Assumes a standard 5x5 grid on the active Zoom Meeting window.
+
+GetGalleryTileMap() {
+    cols := 5
+    rows := 5
+
+    WinGetPos, gx, gy, gw, gh, Zoom Meeting
+    if (ErrorLevel) {
+        ; Fallback to primary screen size if the window isn't found
+        gx := 0, gy := 0, gw := A_ScreenWidth, gh := A_ScreenHeight
+    }
+
+    tileW := gw / cols
+    tileH := gh / rows
+    map := {}
+    index := 1
+    Loop, %rows% {
+        row := A_Index
+        Loop, %cols% {
+            col := A_Index
+            x := gx + ((col-1) * tileW) + (tileW/2)
+            y := gy + ((row-1) * tileH) + (tileH/2)
+            map[index] := {x:x, y:y, row:row, col:col}
+            index++
+        }
+    }
+    return map
+}
 
EOF
)

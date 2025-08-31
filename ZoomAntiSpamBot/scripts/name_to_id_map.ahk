 (cd "$(git rev-parse --show-toplevel)" && git apply --3way <<'EOF' 
diff --git a/ZoomAntiSpamBot/scripts/name_to_id_map.ahk b/ZoomAntiSpamBot/scripts/name_to_id_map.ahk
index 4b005e7805e9feea46c0d1704b5a9d920ee5f1a5..132e34a9e137cdad7504fd4f3bd1949b162da58e 100644
--- a/ZoomAntiSpamBot/scripts/name_to_id_map.ahk
+++ b/ZoomAntiSpamBot/scripts/name_to_id_map.ahk
@@ -1,3 +1,15 @@
-; WRAPPERS_INJECTEDToLower(str) {    StringLower, out, str    return out}ToUpper(str) {    StringUpper, out, str    return out}TrimStr(str) {    StringTrimLeft, temp, str, 0    StringTrimRight, temp, temp, 0    return temp}Split(str, delim="|") {    arr := []    Loop, Parse, str,         arr.Push(A_LoopField)    return arr}InStrCompat(haystack, needle) {    return InStrCompat(haystack, needle)}
-; WRAPPERS_INJECTEDToLower(str) {    StringLower, out, str    return out}ToUpper(str) {    StringUpper, out, str    return out}TrimStr(str) {    StringTrimLeft, temp, str, 0    StringTrimRight, temp, temp, 0    return temp}Split(str, delim="|") {    arr := []    Loop, Parse, str,         arr.Push(A_LoopField)    return arr}InStrCompat(haystack, needle) {    return InStr(haystack, needle)}
-script
+; name_to_id_map.ahk
+; Maintains mapping from participant names to IDs.
+
+if (!IsObject(NameToIDMap))
+    global NameToIDMap := {}
+
+SetNameID(name, id) {
+    global NameToIDMap
+    NameToIDMap[name] := id
+}
+
+GetIDFromName(name) {
+    global NameToIDMap
+    return NameToIDMap.HasKey(name) ? NameToIDMap[name] : ""
+}
 
EOF
)

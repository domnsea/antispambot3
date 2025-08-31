 (cd "$(git rev-parse --show-toplevel)" && git apply --3way <<'EOF' 
diff --git a/ZoomAntiSpamBot/includes/StubModules.ahk b/ZoomAntiSpamBot/includes/StubModules.ahk
index 4b005e7805e9feea46c0d1704b5a9d920ee5f1a5..5da51e7b439f50c58264cfd0af1ed31c7531b7ce 100644
--- a/ZoomAntiSpamBot/includes/StubModules.ahk
+++ b/ZoomAntiSpamBot/includes/StubModules.ahk
@@ -1,3 +1,3 @@
-; WRAPPERS_INJECTEDToLower(str) {    StringLower, out, str    return out}ToUpper(str) {    StringUpper, out, str    return out}TrimStr(str) {    StringTrimLeft, temp, str, 0    StringTrimRight, temp, temp, 0    return temp}Split(str, delim="|") {    arr := []    Loop, Parse, str,         arr.Push(A_LoopField)    return arr}InStrCompat(haystack, needle) {    return InStrCompat(haystack, needle)}
-; WRAPPERS_INJECTEDToLower(str) {    StringLower, out, str    return out}ToUpper(str) {    StringUpper, out, str    return out}TrimStr(str) {    StringTrimLeft, temp, str, 0    StringTrimRight, temp, temp, 0    return temp}Split(str, delim="|") {    arr := []    Loop, Parse, str,         arr.Push(A_LoopField)    return arr}InStrCompat(haystack, needle) {    return InStr(haystack, needle)}
-script
+; StubModules.ahk
+; Placeholder module definitions to satisfy includes during development.
+; Add any required stub functions here.
 
EOF
)

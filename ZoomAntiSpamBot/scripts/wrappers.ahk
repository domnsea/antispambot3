diff --git a//dev/null b/ZoomAntiSpamBot/includes/Wrappers.ahk
index 0000000000000000000000000000000000000000..ec2c22d0117505c62c974913a132b15212b2e9ea 100644
--- a//dev/null
+++ b/ZoomAntiSpamBot/includes/Wrappers.ahk
@@ -0,0 +1,25 @@
+; Utility wrapper functions for compatibility
+ToLower(str) {
+    StringLower, out, str
+    return out
+}
+
+ToUpper(str) {
+    StringUpper, out, str
+    return out
+}
+
+TrimStr(str) {
+    return Trim(str)
+}
+
+Split(str, delim="|") {
+    arr := []
+    Loop, Parse, str, %delim%
+        arr.Push(A_LoopField)
+    return arr
+}
+
+InStrCompat(haystack, needle) {
+    return InStr(haystack, needle)
+}

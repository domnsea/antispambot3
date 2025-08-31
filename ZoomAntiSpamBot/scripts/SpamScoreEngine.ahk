 (cd "$(git rev-parse --show-toplevel)" && git apply --3way <<'EOF' 
diff --git a/ZoomAntiSpamBot/scripts/SpamScoreEngine.ahk b/ZoomAntiSpamBot/scripts/SpamScoreEngine.ahk
index e6dff289dc8d4ba51c559528b7035ef76f75ed27..15e85d06e9f7255c030b23e6b76b58cd6d086b5f 100644
--- a/ZoomAntiSpamBot/scripts/SpamScoreEngine.ahk
+++ b/ZoomAntiSpamBot/scripts/SpamScoreEngine.ahk
@@ -1,55 +1,47 @@
-diff --git a/ZoomAntiSpamBot/scripts/SpamScoreEngine.ahk b/ZoomAntiSpamBot/scripts/SpamScoreEngine.ahk
-index 4b005e7805e9feea46c0d1704b5a9d920ee5f1a5..5364c5fa2766abd8f4b261dd466d1581953d77a1 100644
---- a/ZoomAntiSpamBot/scripts/SpamScoreEngine.ahk
-+++ b/ZoomAntiSpamBot/scripts/SpamScoreEngine.ahk
-@@ -1,3 +1,47 @@
--; WRAPPERS_INJECTEDToLower(str) {    StringLower, out, str    return out}ToUpper(str) {    StringUpper, out, str    return out}TrimStr(str) {    StringTrimLeft, temp, str, 0    StringTrimRight, temp, temp, 0    return temp}Split(str, delim="|") {    arr := []    Loop, Parse, str,         arr.Push(A_LoopField)    return arr}InStrCompat(haystack, needle) {    return InStrCompat(haystack, needle)}
--; WRAPPERS_INJECTEDToLower(str) {    StringLower, out, str    return out}ToUpper(str) {    StringUpper, out, str    return out}TrimStr(str) {    StringTrimLeft, temp, str, 0    StringTrimRight, temp, temp, 0    return temp}Split(str, delim="|") {    arr := []    Loop, Parse, str,         arr.Push(A_LoopField)    return arr}InStrCompat(haystack, needle) {    return InStr(haystack, needle)}
--script
-+; SpamScoreEngine.ahk
-+; Calculates a spam score for a Zoom participant based on heuristics.
-+
-+; Calculates the spam score and stores it in participant.SpamScore.
-+; participant is an object with fields:
-+;   Name, HasCamera, HasAudio, CanMultiPin, CanTurnCamOn
-+; Returns the numeric score.
-+CalculateSpamScore(participant) {
-+    score := 0
-+
-+    if (!participant.HasCamera)
-+        score++
-+    if (!participant.HasAudio)
-+        score++
-+    if (!participant.CanMultiPin)
-+        score++
-+    if (!participant.CanTurnCamOn)
-+        score++
-+    
-+    if RegExMatch(participant.Name, "^[a-z]+$")
-+        score++
-+    if InStr(participant.Name, "0")
-+        score++
-+    if IsShortMaleName(participant.Name)
-+        score++
-+
-+    participant.SpamScore := score
-+    return score
-+}
-+
-+; Determines if the supplied name matches a list of common short male names.
-+IsShortMaleName(name) {
-+    static shortNames := ["bob", "tom", "sam", "joe", "max", "ben", "lee", "dan", "ray", "jay"]
-+    StringLower, lname, name
-+    for index, n in shortNames {
-+        if (lname = n)
-+            return true
-+    }
-+    return false
-+}
-+
-+; Helper that checks if a participant's score exceeds the threshold and
-+; should therefore be moved to the waiting room.
-+ShouldWaitRoom(participant, threshold := 4) {
-+    score := CalculateSpamScore(participant)
-+    return (score >= threshold)
-+}
+; SpamScoreEngine.ahk
+; Calculates a spam score for a Zoom participant based on heuristics.
+
+; Calculates the spam score and stores it in participant.SpamScore.
+; participant is an object with fields:
+;   Name, HasCamera, HasAudio, CanMultiPin, CanTurnCamOn
+; Returns the numeric score.
+CalculateSpamScore(participant) {
+    score := 0
+
+    if (!participant.HasCamera)
+        score++
+    if (!participant.HasAudio)
+        score++
+    if (!participant.CanMultiPin)
+        score++
+    if (!participant.CanTurnCamOn)
+        score++
+
+    if RegExMatch(participant.Name, "^[a-z]+$")
+        score++
+    if InStr(participant.Name, "0")
+        score++
+    if IsShortMaleName(participant.Name)
+        score++
+
+    participant.SpamScore := score
+    return score
+}
+
+; Determines if the supplied name matches a list of common short male names.
+IsShortMaleName(name) {
+    static shortNames := ["bob", "tom", "sam", "joe", "max", "ben", "lee", "dan", "ray", "jay"]
+    StringLower, lname, name
+    for index, n in shortNames {
+        if (lname = n)
+            return true
+    }
+    return false
+}
+
+; Helper that checks if a participant's score exceeds the threshold and
+; should therefore be moved to the waiting room.
+ShouldWaitRoom(participant, threshold := 4) {
+    score := CalculateSpamScore(participant)
+    return (score >= threshold)
+}
 
EOF
)

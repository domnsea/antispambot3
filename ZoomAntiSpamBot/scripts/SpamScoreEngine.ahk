; SpamScoreEngine.ahk
; Calculates a spam score for a Zoom participant based on heuristics.

; Calculates the spam score and stores it in participant.SpamScore.
; participant is an object with fields:
;   Name, HasCamera, HasAudio, CanMultiPin, CanTurnCamOn
; Returns the numeric score.
CalculateSpamScore(participant) {
    score := 0

    if (!participant.HasCamera)
        score++
    if (!participant.HasAudio)
        score++
    if (!participant.CanMultiPin)
        score++
    if (!participant.CanTurnCamOn)
        score++

    if RegExMatch(participant.Name, "^[a-z]+$")
        score++
    if InStr(participant.Name, "0")
        score++
    if IsShortMaleName(participant.Name)
        score++

    participant.SpamScore := score
    return score
}

; Determines if the supplied name matches a list of common short male names.
IsShortMaleName(name) {
    static shortNames := ["bob", "tom", "sam", "joe", "max", "ben", "lee", "dan", "ray", "jay"]
    StringLower, lname, name
    for index, n in shortNames {
        if (lname = n)
            return true
    }
    return false
}

; Helper that checks if a participant's score exceeds the threshold and
; should therefore be moved to the waiting room.
ShouldWaitRoom(participant, threshold := 4) {
    score := CalculateSpamScore(participant)
    return (score >= threshold)
}
 

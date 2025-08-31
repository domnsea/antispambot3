; spam_score_modifiers.ahk
; Adjustable threshold for spam scoring.

global SpamScoreThreshold := 4

SetSpamThreshold(value) {
    global SpamScoreThreshold
    SpamScoreThreshold := value
}

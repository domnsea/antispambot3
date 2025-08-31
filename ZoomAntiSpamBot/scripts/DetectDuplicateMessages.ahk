; DetectDuplicateMessages.ahk
; Tracks chat messages per participant and triggers chat disable/enable
; when the same message is sent more than once.

#Include DisableMeetingChat.ahk
#Include EnableMeetingChat.ahk
#Include log_and_block_spam.ahk
#Include delete_spam_message.ahk

; global storage for message history
if (!IsObject(DuplicateHistory))
    global DuplicateHistory := {}

; Checks a message and returns true if it is considered duplicate spam.
DetectDuplicateMessage(participantID, message, name := "") {
    global DuplicateHistory
    key := participantID . ":" . message
    count := DuplicateHistory.HasKey(key) ? DuplicateHistory[key] : 0
    count++
    DuplicateHistory[key] := count

    if (count > 1) {
        DisableMeetingChat()
        log_and_block_spam(participantID, message, name)
        DeleteSpamMessage()
        EnableMeetingChat()
        return true
    }
    return false
}

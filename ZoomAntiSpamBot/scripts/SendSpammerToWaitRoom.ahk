; SendSpammerToWaitRoom.ahk
; Placeholder for interacting with Zoom to move a participant to the waiting room.

#Include log_and_block_spam.ahk

SendSpammerToWaitRoom(participantID) {
    ; TODO: Implement UI automation with Zoom.
    log_and_block_spam(participantID, "moved to waiting room")
}
 

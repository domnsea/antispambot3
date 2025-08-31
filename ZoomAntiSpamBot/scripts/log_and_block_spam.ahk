; log_and_block_spam.ahk
; Logs spam content and flags the participant ID.

#Include flagged_ids.ahk

log_and_block_spam(participantID, message, name := "") {
    FormatTime, ts,, yyyy-MM-dd HH:mm:ss
    FileAppend, % ts " | " participantID " | " message "`n", %A_ScriptDir% "\\logs\\spam_events.log"
    AddFlaggedID(participantID, name)
}
 

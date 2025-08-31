; scan_chat_for_spam.ahk
; High-level chat monitoring routine. Reads the Zoom chat window and
; uses duplicate detection and spam scoring to decide when to act.

#Include DetectDuplicateMessages.ahk
#Include SpamScoreEngine.ahk
#Include SendSpammerToWaitRoom.ahk
#Include flagged_ids.ahk
#Include name_to_id_map.ahk
#Include DisableMeetingChat.ahk
#Include EnableMeetingChat.ahk
#Include log_and_block_spam.ahk

; Title of the Zoom chat window. Adjust if Zoom localizes the name.
ChatWindowTitle := "Meeting chat"
SpamThreshold := 5

scan_chat_for_spam() {
    messages := ReadChatWindow()
    for index, msg in messages {
        if IsFlaggedID(msg.ParticipantID) {
            SendSpammerToWaitRoom(msg.ParticipantID)
            continue
        }
        if HasEmojiSpam(msg.Text) {
            DisableMeetingChat()
            log_and_block_spam(msg.ParticipantID, msg.Text)
            EnableMeetingChat()
            SendSpammerToWaitRoom(msg.ParticipantID)
            continue
        }
        if DetectDuplicateMessage(msg.ParticipantID, msg.Text, msg.Name) {
            ; Duplicate handler already logs and flags
        }
        participant := {
            Name: msg.Name,
            HasCamera: msg.HasCamera,
            HasAudio: msg.HasAudio,
            CanMultiPin: msg.CanMultiPin,
            CanTurnCamOn: msg.CanTurnCamOn
        }
        if ShouldWaitRoom(participant, SpamThreshold) {
            SendSpammerToWaitRoom(msg.ParticipantID)
        }
    }
}

HasEmojiSpam(text) {
    devil := Chr(0x1F608)
    fire := Chr(0x1F525)
    return (RegExMatch(text, "(" devil "){3,}") && RegExMatch(text, "(" fire "){3,}"))
}

; Reads the Zoom "Meeting chat" window and returns an array of message objects.
; Each object includes ParticipantID, Name, Text and capability flags used by
; the spam scoring engine.  This implementation relies on the chat text being
; available via standard controls; if OCR is required, integrate with
; scripts/OCR.ahk instead.
ReadChatWindow() {
    global ChatWindowTitle
    WinGet, hwnd, ID, %ChatWindowTitle%
    if (!hwnd)
        return []

    ControlGetText, raw, RichEdit20W1, ahk_id %hwnd%
    if (ErrorLevel)
        ControlGetText, raw, Edit1, ahk_id %hwnd%

    lines := []
    for index, line in StrSplit(raw, "`n") {
        if (line = "")
            continue
        ; Zoom chat lines appear as "Name: message text".
        parts := StrSplit(line, ":")
        name := TrimStr(parts[1])
        text := (parts.Length() > 1) ? TrimStr(SubStr(line, StrLen(parts[1]) + 2)) : ""
        id := GetIDFromName(name)
        if (id = "")
            id := name
        msg := {
            ParticipantID: id,
            Name: name,
            Text: text,
            HasCamera: false,
            HasAudio: false,
            CanMultiPin: false,
            CanTurnCamOn: false
        }
        lines.Push(msg)
    }
    return lines
}
 

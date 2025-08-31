; MonitorGalleryForSpammers.ahk
; Scans fixed screen coordinates for potential spam participants.

#Include SpamScoreEngine.ahk
#Include ParticipantLog.ahk
#Include SendSpammerToWaitRoom.ahk
#Include flagged_ids.ahk

; Positions to monitor for new video tiles (sample coordinates)
if (!IsObject(MonitorPositions))
    global MonitorPositions := [
        {x:100, y:100},
        {x:200, y:100},
        {x:300, y:100},
        {x:400, y:100},
        {x:500, y:100}
    ]

CheckGalleryTiles() {
    global MonitorPositions, SpamThreshold
    for index, pos in MonitorPositions {
        PixelGetColor, color, pos.x, pos.y, RGB
        if (color = 0x222222) {
            MouseClick, right, pos.x, pos.y
            info := GetParticipantInfoUnderMouse()
            if (!info)
                continue
            if IsFlaggedID(info.ID) {
                SendSpammerToWaitRoom(info.ID)
                continue
            }
            score := CalculateSpamScore(info)
            LogParticipantInfo(info, score)
            if (score >= SpamThreshold)
                SendSpammerToWaitRoom(info.ID)
        }
    }
}

GetParticipantInfoUnderMouse() {
    ; Placeholder: fetch participant details from Zoom UI.
    return {
        ID: "unknown",
        Name: "unknown",
        HasCamera: false,
        HasAudio: false,
        CanMultiPin: false,
        CanTurnCamOn: false,
        Geo: "unknown",
        Email: "unknown"
    }
}

LogParticipantInfo(info, score) {
    FormatTime, ts,, yyyy-MM-dd HH:mm:ss
    line := ts " | " info.ID " | " info.Geo " | " info.Name " | " info.Email " | score:" score
    FileAppend, % line "`n", logs\participant_checks.log
    participantLine := info.ID "|" info.Name
    FileAppend, % participantLine "`n", data\participant_ids.txt
}

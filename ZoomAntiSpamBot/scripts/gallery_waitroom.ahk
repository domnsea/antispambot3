; gallery_waitroom.ahk
; Scans the Zoom gallery for participants with high spam scores and moves
; them to the waiting room.  Only the last row of the current gallery page is
; evaluated, as new participants typically appear there.

#Include gallery_view_map.ahk
#Include SpamScoreEngine.ahk
#Include SendSpammerToWaitRoom.ahk
#Include name_to_id_map.ahk
#Include flagged_ids.ahk
#Include OCR.ahk

gallery_waitroom() {
    tiles := GetGalleryTileMap()
    for idx, coords in tiles {
        if (coords.row != 5) ; last row
            continue
        name := GetNameAtTile(coords.x, coords.y)
        if (name = "")
            continue
        id := GetIDFromName(name)
        if (id = "")
            id := name
        participant := {Name: name, HasCamera: true, HasAudio: true,
                        CanMultiPin: true, CanTurnCamOn: true}
        if (IsFlaggedID(id) || ShouldWaitRoom(participant, 5))
            SendSpammerToWaitRoom(id)
    }
}

GetNameAtTile(x, y) {
    ; Capture a small area around the provided coordinates and OCR the name.
    ; This is a placeholder; integrate a real screen grabber for production.
    tmp := A_Temp "\\tile.png"
    ; Example: CaptureScreen(x-50, y-10, x+50, y+10, tmp)
    return PerformOCR(tmp)
}
 

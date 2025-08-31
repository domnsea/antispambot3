; flagged_ids.ahk
; Maintains list of participant IDs flagged for spam activity.

if (!IsObject(FlaggedIDs)) {
    global FlaggedIDs := {}
    path := A_ScriptDir . "\\data\\flagged_ids.txt"
    if FileExist(path) {
        Loop, Read, %path%
        {
            parts := StrSplit(A_LoopReadLine, ",")
            id := parts[1]
            name := (parts.Length() > 1 ? parts[2] : "")
            if (id != "")
                FlaggedIDs[id] := name
        }
    }
}

AddFlaggedID(id, name := "") {
    global FlaggedIDs
    if (!FlaggedIDs.HasKey(id)) {
        FlaggedIDs[id] := name
        FileAppend, % id "," name "`n", %A_ScriptDir% "\\data\\flagged_ids.txt"
    }
}

IsFlaggedID(id) {
    global FlaggedIDs
    return FlaggedIDs.HasKey(id)
}

GetFlaggedIDs() {
    global FlaggedIDs
    ids := []
    for id, name in FlaggedIDs
        ids.Push({ID: id, Name: name})
    return ids
}
 

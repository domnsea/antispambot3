; FlagTracker.ahk
; Simple helper to log and retrieve flagged participant IDs.

#Include flagged_ids.ahk

FlagTracker_Log(id) {
    AddFlaggedID(id)
    FormatTime, ts,, yyyy-MM-dd HH:mm:ss
    FileAppend, % ts " | " id "`n", %A_ScriptDir% "\\logs\\flagged_ids.log"
}

FlagTracker_List() {
    ids := GetFlaggedIDs()
    list := ""
    for index, obj in ids
        list .= obj.ID "`n"
    return list
}
 


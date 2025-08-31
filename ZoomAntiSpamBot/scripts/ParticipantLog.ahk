FileRead, currentData, data\participant_ids.txt
FileRead, knownData, data\known_ids.txt

known := {}
Loop, Parse, knownData, `n, `r
    known[A_LoopField] := true

recent := []

Loop, Parse, currentData, `n, `r
{
    line := A_LoopField
    SplitPath := StrSplit(line, "|")  ; Format: ID|Name
    id := Trim(SplitPath[1])
    name := Trim(SplitPath[2])
    namePrefix := SubStr(name, 1, 7)

    if (!known.HasKey(id)) {
        FileAppend, % id "`n", data\known_ids.txt
        FormatTime, ts,, yyyy-MM-dd HH:mm:ss
        FileAppend, % ts " | " id " | " namePrefix "`n", logs\participant_registry.txt
        recent.Push(namePrefix " (" id ")")
    }
}

; Keep only last 5
recentStr := ""
Loop % recent.Length()
{
    recentStr := recent[A_Index] "`n" recentStr
    if (A_Index >= 5)
        break
}
FileDelete, data\recent_entries.txt
FileAppend, % recentStr, data\recent_entries.txt

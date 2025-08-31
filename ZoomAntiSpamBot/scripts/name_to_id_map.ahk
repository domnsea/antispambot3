; name_to_id_map.ahk
; Maintains mapping from participant names to IDs.

if (!IsObject(NameToIDMap))
    global NameToIDMap := {}

SetNameID(name, id) {
    global NameToIDMap
    NameToIDMap[name] := id
}

GetIDFromName(name) {
    global NameToIDMap
    return NameToIDMap.HasKey(name) ? NameToIDMap[name] : ""
}
 

; gallery_view_map.ahk
; Generates a coordinate map for the Zoom gallery view.
; Assumes a standard 5x5 grid on the active Zoom Meeting window.

GetGalleryTileMap() {
    cols := 5
    rows := 5

    WinGetPos, gx, gy, gw, gh, Zoom Meeting
    if (ErrorLevel) {
        ; Fallback to primary screen size if the window isn't found
        gx := 0, gy := 0, gw := A_ScreenWidth, gh := A_ScreenHeight
    }

    tileW := gw / cols
    tileH := gh / rows
    map := {}
    Loop, %rows% {
        row := A_Index
        Loop, %cols% {
            col := A_Index
            x := gx + ((col-1) * tileW) + (tileW/2)
            y := gy + ((row-1) * tileH) + (tileH/2)
            map[index] := {x:x, y:y, row:row, col:col}
            index++
        }
    }
    return map
}
 

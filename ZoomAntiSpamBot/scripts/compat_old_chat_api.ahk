; ======================================================================
; File: scripts/compat_old_chat_api.ahk
; Purpose: Provide old __Chat_* helpers used by tiny legacy scripts.
; ======================================================================
#NoEnv
#SingleInstance, Off
SendMode, Input
SetBatchLines, -1
SetTitleMatchMode, 2
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen

__Chat_FindWindow() {
    if WinExist("Meeting chat ahk_exe Zoom.exe")
        return WinExist()
    if WinExist("Meeting Chat ahk_exe Zoom.exe")
        return WinExist()
    WinGet, L, List
    Loop, %L% {
        id := L%A_Index%
        WinGet, pn, ProcessName, ahk_id %id%
        if (pn != "Zoom.exe")
            continue
        WinGetTitle, t, ahk_id %id%
        tl := __strlower(t)
        if InStr(tl, "meeting chat")
            return id
        if (InStr(tl, " chat") && !InStr(tl, "zoom meeting") && !InStr(tl, "meeting"))
            return id
    }
    if WinExist("Zoom Meeting ahk_exe Zoom.exe")
        return WinExist()
    if WinExist("Meeting ahk_exe Zoom.exe")
        return WinExist()
    return 0
}

__Chat_ClickMore(hwnd := 0, moreX := -108, moreY := 126) {
    if (!hwnd)
        hwnd := __Chat_FindWindow()
    if (!hwnd)
        return 0
    WinGetPos, x, y, w, h, ahk_id %hwnd%
    cx := x + (moreX < 0 ? w + moreX : moreX)
    cy := y + (moreY < 0 ? h + moreY : moreY)
    Click, %cx%, %cy%, 1
    Sleep, 150
    return 1
}

__Chat_StepsToHosts(steps := 3) {
    steps := steps+0
    if (steps < 0)
        steps := 0
    Loop, %steps% {
        SendInput, {Down}
        Sleep, 40
    }
    SendInput, {Enter}
    Sleep, 120
    return 1
}

__Chat_StepsToEveryone(steps := 1) {
    steps := steps+0
    if (steps < 0)
        steps := 0
    Loop, %steps% {
        SendInput, {Down}
        Sleep, 40
    }
    SendInput, {Enter}
    Sleep, 120
    return 1
}

__Chat_ScrollBottom(hwnd := 0) {
    if (!hwnd)
        hwnd := __Chat_FindWindow()
    if (!hwnd)
        return 0
    ControlSend,, ^{End}, ahk_id %hwnd%
    Sleep, 60
    return 1
}

__strlower(s) {
    s := "" . s
    StringLower, s, s
    return s
}
DisableMeetingChat() {
    global LastErrorMessage
    LastErrorMessage := ""

    ; --- config with your exact defaults ---
    ini := A_ScriptDir . "\config.ini"
    IniRead, moreX, %ini%, Chat, ChatMoreBtnX, -108
    IniRead, moreY, %ini%, Chat, ChatMoreBtnY, 126
    IniRead, steps, %ini%, Chat, StepsToHosts, 3

    hwnd := __Chat_FindWindow()
    if (!hwnd) {
        LastErrorMessage := "Zoom Meeting Chat window not found"
        return 0
    }

    if (!__Chat_ClickMore(hwnd, moreX, moreY)) {
        LastErrorMessage := "Failed to click chat menu"
        return 0
    }

    Sleep, 160
    ; navigate to "Hosts and co-hosts"
    Loop, % (steps+0) {
        Send, {Down}
        Sleep, 35
    }
    Send, {Enter}
    Sleep, 80
    return 1
}

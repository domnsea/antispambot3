; ======================================================================
; File: includes/menu_calibrator.ahk
; Purpose: Calibrate the number of ↓ key presses for each menu item.
; Include in gui_main.ahk:  #Include %A_ScriptDir%\includes\menu_calibrator.ahk
; Hotkeys: Ctrl+Alt+M (start), Ctrl+Alt+Up/Down (move),
;          Ctrl+Alt+H (save Hosts), Ctrl+Alt+E (save Everyone), Ctrl+Alt+Q (quit)
; ======================================================================
#NoEnv
#SingleInstance, Off
SendMode, Input
SetBatchLines, -1
SetTitleMatchMode, 2
CoordMode, Mouse, Screen

Cal_Active := 0
Cal_Step := 0
Cal_LastHwnd := 0

Z_Cal_ShowTip() {
    global Cal_Step
    ToolTip, Chat Menu Calibrator`nStep: %Cal_Step%`n↑/↓ move | Ctrl+Alt+H save Hosts | Ctrl+Alt+E save Everyone | Ctrl+Alt+Q cancel, 20, 20
}

Z_Cal_HideTip() {
    ToolTip
}

Z_Cal_Start() {
    global ChatForceX, ChatForceY, ChatForceW, ChatForceH
    global MoreBtnRX, MoreBtnRY
    global Cal_Active, Cal_Step, Cal_LastHwnd

    if (Cal_Active)
        return

    hwnd := Z_EnsureChatAtCoordsForced(ChatForceX, ChatForceY, ChatForceW, ChatForceH)
    if (!hwnd) {
        SoundBeep, 400
        return
    }
    Cal_LastHwnd := hwnd

    Z_ClickRelOnWindow(hwnd, MoreBtnRX, MoreBtnRY)
    Sleep, 150
    SendInput, {Up 40}
    Sleep, 60

    Cal_Step := 0
    Cal_Active := 1
    Z_Cal_ShowTip()
}

Z_Cal_Move(delta) {
    global Cal_Active, Cal_Step
    if (!Cal_Active)
        return
    if (delta > 0) {
        SendInput, {Down %delta%}
        Cal_Step += delta
    } else if (delta < 0) {
        d := -delta
        SendInput, {Up %d%}
        Cal_Step -= d
        if (Cal_Step < 0)
            Cal_Step := 0
    }
    Z_Cal_ShowTip()
}

Z_Cal_Save(which) {
    global Cal_Active, Cal_Step, iniPath
    global StepsToHosts, StepsToEveryone
    if (!Cal_Active)
        return
    if (which = "hosts") {
        StepsToHosts := Cal_Step
        IniWrite, %StepsToHosts%, %iniPath%, Chat, StepsToHosts
    } else if (which = "every") {
        StepsToEveryone := Cal_Step
        IniWrite, %StepsToEveryone%, %iniPath%, Chat, StepsToEveryone
    }
    SoundBeep, 800
    Z_Cal_Stop()
}

Z_Cal_Stop() {
    global Cal_Active
    if (!Cal_Active)
        return
    SendInput, {Esc}
    Sleep, 50
    Cal_Active := 0
    Z_Cal_HideTip()
}

^!m:: Z_Cal_Start()
return
^!Up:: Z_Cal_Move(-1)
return
^!Down:: Z_Cal_Move(1)
return
^!h:: Z_Cal_Save("hosts")
return
^!e:: Z_Cal_Save("every")
return
^!q:: Z_Cal_Stop()
return

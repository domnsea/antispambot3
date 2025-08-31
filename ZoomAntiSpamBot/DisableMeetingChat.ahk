; ======================================================================
; File: scripts/DisableMeetingChat.ahk
; Action: Restrict chat (e.g., To: Hosts & Co‑Hosts) using INI steps.
; ======================================================================
#NoEnv
#SingleInstance, Force
SendMode, Input
SetBatchLines, -1
SetTitleMatchMode, 2
CoordMode, Mouse, Screen

ini := A_ScriptDir . "\\..\\config.ini"
if !FileExist(ini)
    ini := A_ScriptDir . "\\config.ini"

IniRead, moreX, %ini%, Chat, ChatMoreBtnX, -108
IniRead, moreY, %ini%, Chat, ChatMoreBtnY, 126
IniRead, steps, %ini%, Chat, ChatStepsToHosts,  
if (ErrorLevel)
    IniRead, steps, %ini%, Chat, StepsToHosts, 3

hwnd := __Chat_FindWindow()
if (!hwnd) {
    MsgBox, 48, DisableMeetingChat, Zoom Meeting Chat window not found.
    ExitApp
}

if (!__Chat_ClickMore(hwnd, moreX, moreY)) {
    MsgBox, 48, DisableMeetingChat, Failed to click Chat More button.
    ExitApp
}
__Chat_StepsToHosts(steps)
__Chat_ScrollBottom(hwnd)
ExitApp
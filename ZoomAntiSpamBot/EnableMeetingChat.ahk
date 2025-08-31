; ======================================================================
; File: scripts/EnableMeetingChat.ahk
; Action: Re‑enable chat (e.g., To: Everyone) using INI steps.
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
IniRead, steps, %ini%, Chat, ChatStepsToEveryone,  
if (ErrorLevel)
    IniRead, steps, %ini%, Chat, StepsToEveryone, 1

hwnd := __Chat_FindWindow()
if (!hwnd) {
    MsgBox, 48, EnableMeetingChat, Zoom Meeting Chat window not found.
    ExitApp
}

if (!__Chat_ClickMore(hwnd, moreX, moreY)) {
    MsgBox, 48, EnableMeetingChat, Failed to click Chat More button.
    ExitApp
}
__Chat_StepsToEveryone(steps)
__Chat_ScrollBottom(hwnd)
ExitApp
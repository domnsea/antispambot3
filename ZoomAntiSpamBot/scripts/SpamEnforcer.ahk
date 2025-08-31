#NoEnv
#SingleInstance Force
SetWorkingDir %A_ScriptDir%

global ScriptPath := A_ScriptDir "\scripts\"
global AssetPath := A_ScriptDir "\assets\"
global BotActive := false
global LoopActive := false
global StatusText := "Bot Status: Inactive"
global CurrentTask := ""

; GUI Layout — Intentional Design
Gui, +AlwaysOnTop -SysMenu +ToolWindow
Gui, Color, 232323, 232323  ; Dark background
Gui, Font, s10 cFFFFFF, Segoe UI

Gui, Add, Picture, x10 y10 w32 h32, %AssetPath%decal.png
Gui, Add, Text, x52 y12 w200 h20 vStatusText, %StatusText%
Gui, Add, Text, x52 y36 w200 h20 vTaskText, Task: Idle

Gui, Font, s9 cFFFFFF, Segoe UI
Gui, Add, Button, x30 y70 w90 h30 gToggleBot vToggleBtn, Toggle
Gui, Add, Button, x140 y70 w90 h30 gExitBot, Exit

Gui, Show, w260 h120, SpamEnforcer
return

; Toggle Bot On/Off
ToggleBot:
BotActive := !BotActive
StatusText := "Bot Status: " . (BotActive ? "Active" : "Inactive")
GuiControl,, StatusText, %StatusText%

if (BotActive && !LoopActive) {
    LoopActive := true
    SetTimer, BotLoop, 1000
} else {
    LoopActive := false
    SetTimer, BotLoop, Off
    GuiControl,, TaskText, Task: Idle
}
return

; Main Bot Loop
BotLoop:
if (!BotActive)
    return

RunScript("scan_chat_for_spam_event.ahk", "Checking Chat Position")
RunScript("log_and_block_spam.ahk", "Scanning Row O")
RunScript("spam_score_modifiers.ahk", "Applying Spam Modifiers")
RunScript("SendSpamToWaitRoom.ahk", "Redirecting Spam")
RunScript("ParticipantLog.ahk", "Logging Participants")
RunScript("ShowChatStatusOverlay.ahk", "Updating Overlay")
return

; Exit Button
ExitBot:
ExitApp
return

; Utility: Run script with task feedback
RunScript(scriptName, taskLabel) {
    global ScriptPath
    global CurrentTask

    CurrentTask := taskLabel
    GuiControl,, TaskText, Task: %CurrentTask%
    fullPath := ScriptPath . scriptName
    IfExist, %fullPath%
        Run, %fullPath%
}



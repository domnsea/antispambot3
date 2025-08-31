; AntiSpamBot.ahk
; Main entry point for Zoom Anti-Spam Bot.

#Include, includes/Wrappers.ahk
SetWorkingDir %A_ScriptDir%

; === Load Core Modules ===
#Include, SetBotRoot.ahk
#Include, scripts/FlagTracker.ahk
#Include, scripts/LogWriter.ahk
#Include, scripts/gallery_view_map.ahk
#Include, scripts/gallery_waitroom.ahk
#Include, scripts/name_to_id_map.ahk
#Include, scripts/flagged_ids.ahk
#Include, scripts/OCR.ahk
#Include, scripts/scan_chat_for_spam.ahk
#Include, scripts/log_and_block_spam.ahk
#Include, scripts/SendSpammerToWaitRoom.ahk
#Include, scripts/ShowChatStatusOverlay.ahk

; === Initialize Bot ===
botActive := true
logFile := A_ScriptDir . "\\bot_runtime_log.txt"
FileAppend, Bot started at %A_Now%`n, %logFile%

; === Main Loop ===
Loop
{
    if (!botActive)
        break

    ; Scan chat for spam indicators
    scan_chat_for_spam()

    ; Check gallery for flagged users
    gallery_waitroom()

    ; Update overlay status
    ShowChatStatusOverlay()

    Sleep, 1000  ; Adjust polling interval as needed
}

; === Shutdown ===
FileAppend, Bot stopped at %A_Now%`n, %logFile%
MsgBox, Anti-Spam Bot stopped.
ExitApp
 

; ShowChatStatusOverlay.ahk
; Displays a simple tooltip indicating the bot's status.

ShowChatStatusOverlay() {
    ToolTip, Chat monitoring active
    SetTimer, __HideOverlay, -1000
}

__HideOverlay() {
    ToolTip
}
 

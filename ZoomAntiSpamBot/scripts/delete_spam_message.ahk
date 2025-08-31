; delete_spam_message.ahk
; Attempts to remove the most recent chat message using image searches.

DeleteSpamMessage() {
    ; Locate chat window
    ImageSearch, wx, wy, 0, 0, A_ScreenWidth, A_ScreenHeight, %A_ScriptDir%\assets\duplicate_indicator.png
    if (ErrorLevel)
        return
    ; Right click near bottom-right of found window to open context menu
    MouseClick, right, wx + 10, wy + 10
    ; Click delete button
    ImageSearch, dx, dy, 0, 0, A_ScreenWidth, A_ScreenHeight, %A_ScriptDir%\assets\chat_delete_button.png
    if (!ErrorLevel)
        MouseClick, left, dx, dy
    ; Confirm delete
    ImageSearch, cx, cy, 0, 0, A_ScreenWidth, A_ScreenHeight, %A_ScriptDir%\assets\confirm_delete_button.png
    if (!ErrorLevel)
        MouseClick, left, cx, cy
}
 

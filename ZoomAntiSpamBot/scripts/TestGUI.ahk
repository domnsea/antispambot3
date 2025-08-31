#SingleInstance Force
SetWorkingDir %A_ScriptDir%
#Persistent

Gui, Font, s10, Segoe UI
Gui, Add, Text, x10 y10 w300 h20 vStatusText, GUI Test: If you see this, it works.
Gui, Add, Button, x10 y40 w100 h30 gExitApp, Exit
Gui, Show, w320 h100, GUI Test Window
return

ExitApp:
    ExitApp
return

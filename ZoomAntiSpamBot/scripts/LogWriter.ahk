; LogWriter.ahk
; Simple logging helper.

WriteLog(msg) {
    FormatTime, ts,, yyyy-MM-dd HH:mm:ss
    FileAppend, % ts " | " msg "`n", %A_ScriptDir% "\\logs\\bot.log"
}
 

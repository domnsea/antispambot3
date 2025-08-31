#NoEnv
SetWorkingDir %A_ScriptDir%
Loop, Files, %A_ScriptDir%\*.ahk, R
{
    FileRead, content, %A_LoopFileFullPath%
    newContent := ""
    Loop, Parse, content, `n, `r
    {
        line := A_LoopField
        if (RegExMatch(line, "i)^\s*Run(W)?ait,\s*(?!%scriptPath%)\s*([^\s]+\.ahk)"))
        {
            RegExMatch(line, "i)(Run(W)?ait),\s*([^\s]+\.ahk)", m)
            newLine := m1 . ", %scriptPath%\" . m3
            newContent .= newLine "`r`n"
        }
        else
            newContent .= line "`r`n"
    }
    FileDelete, %A_LoopFileFullPath%
    FileAppend, %newContent%, %A_LoopFileFullPath%
}
MsgBox, ✅ All script paths refactored to use `scriptPath`


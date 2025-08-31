; ======================================================================
; Zoom Anti‑Spam Bot (AHK v1.1, Unicode) — FINAL CLEAN — Option 1 (global gBot)
; Part 1/2: Header + Class + All Methods (no labels here)
; Paste Part 2/2 directly after this in the same .ahk file.
; ======================================================================
#NoEnv
#Warn
#SingleInstance, Force
SendMode, Input
SetWorkingDir, %A_ScriptDir%
SetBatchLines, -1
CoordMode, Pixel, Screen
CoordMode, Mouse, Screen
SetTitleMatchMode, 2

; ================================ CLASS =================================
class ZoomAntiSpamBot {
    __New() {
        this.AhkVerStr := "AHK " . A_AhkVersion . (A_IsUnicode ? " U" : " A") . ((A_PtrSize=8) ? " x64" : " x86")

        ; Paths/Assets
        this.baseDir   := A_ScriptDir
        this.assetsDir := this.baseDir . "\\assets"
        this.dataDir   := this.baseDir . "\\data"
        this.logsDir   := this.baseDir . "\\logs"
        this.iniPath   := this.baseDir . "\\config.ini"

        if !FileExist(this.dataDir)
            FileCreateDir, % this.dataDir
        if !FileExist(this.logsDir)
            FileCreateDir, % this.logsDir

        this.file_p_log    := this.logsDir . "\\participant_log.txt"
        this.file_p_hist   := this.logsDir . "\\participant_history.txt"
        this.file_err      := this.logsDir . "\\error_log.txt"
        this.file_waits    := this.logsDir . "\\waitroom_actions.txt"
        this.file_banned   := this.dataDir . "\\banned_ids.txt"
        this.file_debug    := this.logsDir . "\\debug_log.txt"

        this.file_chatlog := this.logsDir . "\\chatlog.txt"
        if (!FileExist(this.file_chatlog) && FileExist(this.logsDir . "\\chatlog.log"))
            this.file_chatlog := this.logsDir . "\\chatlog.log"

        ; OCR + image defaults
        this.OCR_Use := 0  ; set to 1 after wiring OCR_GetText include
        this.OCR_W := 220, this.OCR_H := 42
        this.OCR_XOff := -110, this.OCR_YOff := -50

        this.img_stop_video := ""
        this.img_ask_start  := ""
        this.img_wait1      := ""
        this.img_wait2      := ""
        this.img_dup        := ""
        this.img_del_btn    := ""
        this.img_del_btn2   := ""
        this.img_logo       := ""
        this.img_tile_template := ""
        this.img_menu_multipin := ""
        this.img_no_audio      := ""
        this.img_chat_last     := ""
        this.img_gallery_last  := ""
        this.ImgVariation := 40

        ; State
        this.BotEnabled := 0
        this.Tolerance := "Med"
        this.PassiveMode := 0
        this.DryRunClicks := 0
        this.KeepGalleryLast := 1
        this.KeepChatLast := 1
        this.KeepCooldownMs := 1400
        this.LastKeepTick := 0
        this.TARGET_HEX := 0x222222

        this.DebugAliasDump := 0
        this.GateTolerance := 10
        this.GateSampleRadius := 3
        this.NoHitFallbackLoops := 3
        this.noHitCounter := 0

        this.DuplicateSpamThreshold := 3
        this.WindowMs := 8000
        this.ZapCooldownMs := 15000
        this.lastZapTick := 0

        ; Inline Divert config
        this.ChatForceX := -1419
        this.ChatForceY := 13
        this.ChatForceW := 1384
        this.ChatForceH := 2455
        this.MoreBtnRX  := -106
        this.MoreBtnRY  := 126
        this.StepsToHosts := 7
        this.StepsToEveryone := 1

        ; Name/alias matching
        this.KeywordRegex := "(?i)\b(magic|melaus|adidas|co[- ]?host)\b"
        this.ShortNameRegex := "^(?i)[a-z]{2,4}$"
        this.AliasTopNamesRegex := ""
        this.AliasFuzzyNormalize := 1
        this.AliasExactMatch := 1
        this.AutoWaitroomOnAlias := 1
        this.TileTemplateSearchRadius := 120
        this.AliasTopNamesFile := this.dataDir . "\\top_names.txt"

        ; Per-session tracking
        this.seenKeys := {}
        this.camGateActive := {}
        this.bannedCache := {}
        this.nameToId := {}
        this.AliasTopNames := {}

        ; Menu fallback
        this.Cfg_WaitRoomSteps := 7

        ; Chat placement helpers
        this.ChatManageWindow := 1
        this.ChatPosX := -1100
        this.ChatPosY := 40
        this.ChatW    := 640
        this.ChatH    := 720
        this.ChatRepositionCooldownMs := 6000
        this.ChatPositionTolerancePx  := 16
        this.ChatHwnd := 0
        this.LastChatMoveTick := 0

        ; Participants (optional OCR panel)
        this.UseParticipantsPanel := 0
        this.PartManageWindow := 1
        this.PartPosX := -500, this.PartPosY := 100, this.PartW := 420, this.PartH := 1000
        this.PartNameRX := 80, this.PartNameRY := 80, this.PartNameRW := 260, this.PartNameRH := 32
        this.PartIdRX   := 80, this.PartIdRY   := 116, this.PartIdRW   := 260, this.PartIdRH   := 28

        ; Five gallery probe points (Row 0)
        this.cams := []
        this.cams.Push({name:"cam1", x:1398, y:761})
        this.cams.Push({name:"cam2", x:1247, y:816})
        this.cams.Push({name:"cam3", x:1825, y:280})
        this.cams.Push({name:"cam4", x:673 , y:809})
        this.cams.Push({name:"cam5", x:364 , y:813})

        ; UI / counters
        this.GuiHwnd := 0
        this.LastCamLines := []
        this.scoredCount := 0
        this.loggedCount := 0
        this.waitroomCount := 0
        this.dupBuckets := {}
        this.lastChatSize := 0
        this._lastEnsureBottomTick := 0

        this.LoadConfig()
        this.LoadBannedCache()
        this.BuildGUI()
        SetTimer, Z_MainLoop, 750
    }

    ; ============================== HELPERS ==============================
    Asset(name, ext:="png") {
        p1 := this.assetsDir . "\\" . name
        p2 := p1 . "." . ext
        if FileExist(p1)
            return p1
        if FileExist(p2)
            return p2
        return ""
    }
    Int(v, d) {
        v := "" . v
        if (v="")
            return d
        if RegExMatch(v,"^-?\d+$")
            return v+0
        return d
    }
    GetThreshold() {
        return (this.Tolerance="Low") ? 3 : (this.Tolerance="High") ? 5 : 4
    }
    Lower(s) {
        s := "" . s
        StringLower, s, s
        return s
    }
    OnlyDigits(s) {
        s := "" . s
        return RegExReplace(s, "[^\d]")
    }
    San(s) {
        s := "" . s
        StringReplace, s, s, `r,, All
        StringReplace, s, s, `n,, All
        StringReplace, s, s, |,/, All
        StringReplace, s, s, <, (, All
        StringReplace, s, s, >, ), All
        return Trim(s)
    }
    Abs(v) {
        return (v<0) ? -v : v
    }
    ColorNear(col, tgt, tol) {
        rC := (col >> 16) & 255, gC := (col >> 8) & 255, bC := col & 255
        rtC := (tgt >> 16) & 255, gtC := (tgt >> 8) & 255, btC := tgt & 255
        return (this.Abs(rC-rtC) <= tol && this.Abs(gC-gtC) <= tol && this.Abs(bC-btC) <= tol)
    }
    RectCloseEnough(cx,cy,cw,ch, dx,dy,dw,dh, tol) {
        return ( this.Abs(cx-dx) <= tol && this.Abs(cy-dy) <= tol && this.Abs(cw-dw) <= tol && this.Abs(ch-dh) <= tol )
    }
    AdjustChatOffPrimaryDesiredX(dx, paneW) {
        desiredX := dx
        if (desiredX + paneW > -8)
            desiredX := -(paneW + 12)
        return desiredX
    }
    VirtualBounds(ByRef vx, ByRef vy, ByRef vw, ByRef vh) {
        SysGet, vx, 76
        SysGet, vy, 77
        SysGet, vw, 78
        SysGet, vh, 79
    }
    ImageFind(img, x1,y1,x2,y2, ByRef outX, ByRef outY, variation:=0) {
        if (img="" || !FileExist(img))
            return 0
        opts := (variation>0) ? "*" . variation . " " : ""
        ImageSearch, fx, fy, %x1%, %y1%, %x2%, %y2%, %opts%%img%
        if (ErrorLevel=0) {
            outX := fx, outY := fy
            return 1
        }
        return 0
    }
    StrJoin(arr, sep) {
        out := ""
        for idx, val in arr
            out .= (idx=1 ? "" : sep) . val
        return out
    }

    ; ============================== BANNED LIST =========================
    LoadBannedCache() {
        this.bannedCache := {}
        if !FileExist(this.file_banned)
            return
        Loop, Read, % this.file_banned
        {
            ln := Trim(A_LoopReadLine)
            if (ln="" || SubStr(ln,1,1)="#")
                continue
            p := StrSplit(ln, "|")
            id := Trim(p[1])
            if (id!="")
                this.bannedCache[id] := 1
        }
    }
    BanListAdd(id) {
        id := Trim(id)
        if (id="" || this.bannedCache.HasKey(id))
            return
        FormatTime, ts,, yyyy-MM-dd HH:mm:ss
        FileAppend, % id "|" ts "`r`n", % this.file_banned
        this.bannedCache[id] := 1
    }

    ; ============================== WINDOWS =============================
    FindZoomMainWin() {
        if WinExist("Zoom Meeting ahk_exe Zoom.exe")
            return WinExist()
        if WinExist("Meeting ahk_exe Zoom.exe")
            return WinExist()
        WinGet, L, List
        Loop, %L% {
            id := L%A_Index%
            WinGet, pn, ProcessName, ahk_id %id%
            if (pn != "Zoom.exe")
                continue
            WinGetTitle, t, ahk_id %id%
            titleLower := this.Lower(t)
            if InStr(titleLower, "zoom meeting") || InStr(titleLower, "meeting")
                return id
        }
        return 0
    }
    FindChatWin() {
        if WinExist("Meeting chat ahk_exe Zoom.exe")
            return WinExist()
        if WinExist("Meeting Chat ahk_exe Zoom.exe")
            return WinExist()
        WinGet, L, List
        Loop, %L% {
            id := L%A_Index%
            WinGet, pn, ProcessName, ahk_id %id%
            if (pn != "Zoom.exe")
                continue
            WinGetTitle, t, ahk_id %id%
            titleLower := this.Lower(t)
            if InStr(titleLower, "meeting chat")
                return id
            if (InStr(titleLower, " chat") && !InStr(titleLower, "zoom meeting") && !InStr(titleLower, "meeting"))
                return id
        }
        return 0
    }
    ChatRefHwnd() {
        hwnd := this.FindChatWin()
        if (hwnd)
            return hwnd
        return this.FindZoomMainWin()
    }

    ; Participants (optional)
    ShowParticipants() {
        if WinExist("ahk_exe Zoom.exe")
            ControlSend,, !u, ahk_exe Zoom.exe
        else
            Send, !u
        Sleep, 150
    }
    FindParticipantsWin() {
        if WinExist("Participants ahk_exe Zoom.exe")
            return WinExist()
        WinGet, L, List
        Loop, %L% {
            id := L%A_Index%
            WinGet, pn, ProcessName, ahk_id %id%
            if (pn != "Zoom.exe")
                continue
            WinGetTitle, t, ahk_id %id%
            if InStr(this.Lower(t), "participants")
                return id
        }
        return 0
    }
    EnsureParticipantsShownAndPlaced() {
        if (this.PassiveMode)
            return
        hwnd := this.FindParticipantsWin()
        if (!hwnd) {
            this.ShowParticipants()
            Sleep, 250
            hwnd := this.FindParticipantsWin()
            if (!hwnd)
                return
        }
        if (this.PartManageWindow) {
            WinMove, ahk_id %hwnd%, , % this.PartPosX, % this.PartPosY, % this.PartW, % this.PartH
            Sleep, 40
        }
    }
    OCR_FromPanel(roiX, roiY, roiW, roiH) {
        if !IsFunc("OCR_GetText")
            return ""
        hwnd := this.FindParticipantsWin()
        if (!hwnd)
            return ""
        WinGetPos, wx, wy, ww, wh, ahk_id %hwnd%
        rx := wx + roiX, ry := wy + roiY
        txt := ""
        try txt := "" . Func("OCR_GetText").Call(rx, ry, roiW, roiH)
        return txt
    }
    GetPanelName() {
        return Trim(this.OCR_FromPanel(this.PartNameRX, this.PartNameRY, this.PartNameRW, this.PartNameRH))
    }
    GetPanelId() {
        return Trim(this.OnlyDigits(this.OCR_FromPanel(this.PartIdRX, this.PartIdRY, this.PartIdRW, this.PartIdRH)))
    }

    ; ============================== CHAT MGMT ============================
    ShowChat() {
        hwnd := this.FindChatWin()
        if (hwnd) {
            ControlSend,, ^{End}, ahk_id %hwnd%
            return
        }
        if (this.PassiveMode)
            return
        if WinExist("ahk_exe Zoom.exe")
            ControlSend,, !h, ahk_exe Zoom.exe
        else
            Send, !h
        Sleep, 150
    }
    EnsureChatShownAndPlaced() {
        if (this.PassiveMode)
            return
        hwndChat := this.FindChatWin()
        if (!hwndChat) {
            this.ShowChat()
            hwndChat := this.FindChatWin()
            if (!hwndChat)
                return
        }
        WinGet, mm, MinMax, ahk_id %hwndChat%
        if (mm = -1 || mm = 1)
            WinRestore, ahk_id %hwndChat%
        if (!this.ChatManageWindow) {
            ControlSend,, ^{End}, ahk_id %hwndChat%
            return
        }
        if (this.ChatHwnd != hwndChat) {
            this.ChatHwnd := hwndChat
            desiredX := this.AdjustChatOffPrimaryDesiredX(this.ChatPosX, this.ChatW)
            WinMove, ahk_id %hwndChat%, , % desiredX, % this.ChatPosY, % this.ChatW, % this.ChatH
            this.LastChatMoveTick := A_TickCount
        } else if (A_TickCount - this.LastChatMoveTick >= this.ChatRepositionCooldownMs) {
            WinGetPos, cx, cy, cw, ch, ahk_id %hwndChat%
            if !this.RectCloseEnough(cx, cy, cw, ch, this.ChatPosX, this.ChatPosY, this.ChatW, this.ChatH, this.ChatPositionTolerancePx) {
                desiredX := this.AdjustChatOffPrimaryDesiredX(this.ChatPosX, this.ChatW)
                WinMove, ahk_id %hwndChat%, , % desiredX, % this.ChatPosY, % this.ChatW, % this.ChatH
                this.LastChatMoveTick := A_TickCount
            }
        }
        ControlSend,, ^{End}, ahk_id %hwndChat%
    }
    EnsureChatBottom() {
        if (A_TickCount - this._lastEnsureBottomTick < 1200)
            return
        hwnd := this.FindChatWin()
        if (!hwnd)
            return
        ControlSend,, ^{End}, ahk_id %hwnd%
        this._lastEnsureBottomTick := A_TickCount
    }

    ; ===================== Inline Divert (click path) ===================
    ChatDivertThenEnableImmediate() {
        hwnd := this.EnsureChatAtCoordsForced(this.ChatForceX, this.ChatForceY, this.ChatForceW, this.ChatForceH)
        if (!hwnd) {
            this.LogErr("Chat window not found for divert")
            return 0
        }
        this.ClickRelOnWindow(hwnd, this.MoreBtnRX, this.MoreBtnRY)
        Sleep, 140
        this.MenuSelectBySteps(this.StepsToHosts)
        Sleep, 100
        this.ClickRelOnWindow(hwnd, this.MoreBtnRX, this.MoreBtnRY)
        Sleep, 140
        this.MenuSelectBySteps(this.StepsToEveryone)
        return 1
    }
    ChatDisableThenEnable() {
        return this.ChatDivertThenEnableImmediate()
    }
    EnsureChatAtCoordsForced(winX, winY, winW, winH) {
        hwnd := this.FindChatWin()
        if (!hwnd) {
            if WinExist("ahk_exe Zoom.exe")
                ControlSend,, !h, ahk_exe Zoom.exe
            else
                Send, !h
            Sleep, 250
            hwnd := this.FindChatWin()
            if (!hwnd) {
                this.LogErr("Failed to open chat window")
                return 0
            }
        }
        WinActivate, ahk_id %hwnd%
        WinWaitActive, ahk_id %hwnd%,, 0.6
        if (ErrorLevel) {
            this.LogErr("Failed to activate chat window")
            return 0
        }
        WinGet, mm, MinMax, ahk_id %hwnd%
        if (mm = 1 || mm = -1)
            WinRestore, ahk_id %hwnd%
        WinMove, ahk_id %hwnd%, , %winX%, %winY%, %winW%, %winH%
        Sleep, 50
        return hwnd
    }
    ClickRelOnWindow(hwnd, rx, ry) {
        WinGetPos, wx, wy, ww, wh, ahk_id %hwnd%
        cx := wx + (rx < 0 ? ww + rx : rx)
        cy := wy + (ry < 0 ? wh + ry : ry)
        Click, %cx%, %cy%
    }
    MenuSelectBySteps(stepsFallback) {
        steps := stepsFallback + 0
        if (steps < 0)
            steps := 0
        Loop, %steps% {
            SendInput, {Down}
            Sleep, 28
        }
        SendInput, {Enter}
        Sleep, 70
        return 1
    }

    ; =========================== Duplicate / Divert =====================
    ChatPollAndMitigate() {
        if !FileExist(this.file_chatlog)
            return
        FileGetSize, curSize, % this.file_chatlog
        if (curSize <= this.lastChatSize)
            return
        f := FileOpen(this.file_chatlog, "r")
        if (!f)
            return
        f.Seek(this.lastChatSize, 0)
        while !f.AtEOF {
            L := f.ReadLine()
            if (L = "")
                continue
            s := Trim(L)
            if (s = "")
                continue
            p := StrSplit(s, "|")
            if (p.MaxIndex() >= 4 && p[2] = "MSG") {
                u := Trim(p[3]), m := Trim(p[4])
            } else if (p.MaxIndex() >= 2) {
                u := Trim(p[p.MaxIndex()-1])
                m := Trim(p[p.MaxIndex()])
            } else continue
            uL := this.Lower(u), mL := this.Lower(m)

            if (this.EmojiStorm(m)) {
                nowT := A_TickCount
                if (nowT - this.lastZapTick >= this.ZapCooldownMs) {
                    if (this.ChatDisableThenEnable()) {
                        this.LogSpamOnce(u, m)
                        pid := this.nameToId.HasKey(uL) ? this.nameToId[uL] : ""
                        if (pid!="")
                            this.BanListAdd(pid)
                        this.StatusFlash("Spam diverted (emoji)")
                        this.EnsureChatBottom()
                        this.DeleteSpamQuickLoop()
                        this.lastZapTick := nowT
                    } else this.StatusFlash("Divert failed")
                }
                continue
            }

            if !this.dupBuckets.HasKey(uL)
                this.dupBuckets[uL] := {}
            if !this.dupBuckets[uL].HasKey(mL)
                this.dupBuckets[uL][mL] := []

            nowT := A_TickCount
            i := 1
            while (i <= this.dupBuckets[uL][mL].Length()) {
                if (nowT - this.dupBuckets[uL][mL][i] > this.WindowMs)
                    this.dupBuckets[uL][mL].RemoveAt(i)
                else i++
            }
            this.dupBuckets[uL][mL].Push(nowT)

            if (this.dupBuckets[uL][mL].Length() >= this.DuplicateSpamThreshold) {
                if (nowT - this.lastZapTick >= this.ZapCooldownMs) {
                    if (this.ChatDisableThenEnable()) {
                        this.LogSpamOnce(u, m)
                        pid := this.nameToId.HasKey(uL) ? this.nameToId[uL] : ""
                        if (pid!="")
                            this.BanListAdd(pid)
                        this.StatusFlash("Spam diverted (auto)")
                        this.EnsureChatBottom()
                        this.DeleteSpamQuickLoop()
                        this.lastZapTick := nowT
                    } else this.StatusFlash("Divert failed")
                }
                this.dupBuckets[uL][mL] := []
            }
        }
        this.lastChatSize := f.Pos
        f.Close()
    }
    EmojiStorm(m) {
        c1 := this.CountChar(m, "😈")
        c2 := this.CountChar(m, "🔥")
        return (c1 >= 3 && c2 >= 3)
    }
    CountChar(s, ch) {
        StringReplace, out, s, %ch%, , UseErrorLevel
        return ErrorLevel
    }
    LogSpamOnce(user, msg) {
        FormatTime, ts,, yyyy-MM-dd HH:mm:ss
        su := this.San(user), sm := this.San(msg)
        FileAppend, % ts "|SPAM|" su "|" sm "`r`n", % this.file_p_hist
    }

    ; ============================== SCANNING ============================
    SampleDarkGate(x, y) {
        dx := this.GateSampleRadius, dy := this.GateSampleRadius
        PixelGetColor, col, %x%, %y%, RGB
        if (ErrorLevel)
            return 0
        if (this.ColorNear(col, this.TARGET_HEX, this.GateTolerance))
            return 1
        PixelGetColor, col, % (x+dx), %y%, RGB
        if (this.ColorNear(col, this.TARGET_HEX, this.GateTolerance))
            return 1
        PixelGetColor, col, % (x-dx), %y%, RGB
        if (this.ColorNear(col, this.TARGET_HEX, this.GateTolerance))
            return 1
        PixelGetColor, col, %x%, % (y+dy), RGB
        if (this.ColorNear(col, this.TARGET_HEX, this.GateTolerance))
            return 1
        PixelGetColor, col, %x%, % (y-dy), RGB
        return this.ColorNear(col, this.TARGET_HEX, this.GateTolerance)
    }
    GetMenuFlagsAt(x, y, keepOpen:=0) {
        flags := { "AskStart":0, "StopVideo":0, "MultiPin":0 }
        MouseClick, Right, %x%, %y%, 1, 0
        Sleep, 90
        x1 := x - 20, y1 := y - 20
        x2 := x1 + 360, y2 := y1 + 280
        if (this.ImageFind(this.img_ask_start,  x1,y1,x2,y2, ax,ay, this.ImgVariation))
            flags.AskStart := 1
        if (this.ImageFind(this.img_stop_video, x1,y1,x2,y2, sx,sy, this.ImgVariation))
            flags.StopVideo := 1
        if (this.ImageFind(this.img_menu_multipin, x1,y1,x2,y2, mx,my, this.ImgVariation))
            flags.MultiPin := 1
        if (!keepOpen)
            SendInput, {Esc}
        return flags
    }
    CloseContextMenu() {
        SendInput, {Esc}
        Sleep, 70
    }
    TileTemplateHit(cx, cy) {
        if (this.img_tile_template="")
            return 0
        x1 := cx - this.TileTemplateSearchRadius, y1 := cy - this.TileTemplateSearchRadius
        x2 := cx + this.TileTemplateSearchRadius, y2 := cy + this.TileTemplateSearchRadius
        return this.ImageFind(this.img_tile_template, x1,y1,x2,y2, outX, outY, 0)
    }
    NoAudioIconHit(cx, cy) {
        if (this.img_no_audio="")
            return 0
        x1 := cx - this.TileTemplateSearchRadius, y1 := cy - this.TileTemplateSearchRadius
        x2 := cx + this.TileTemplateSearchRadius, y2 := cy + this.TileTemplateSearchRadius
        return this.ImageFind(this.img_no_audio, x1,y1,x2,y2, outX, outY, 20)
    }
    IsAllLower(s) {
        l := this.Lower(s)
        return (s<>"" && s=l)
    }
    ShortNameScore(name) {
        name := Trim(name)
        if (this.ShortNameRegex<>"" && RegExMatch(name, this.ShortNameRegex))
            return 1
        if RegExMatch(name, "^(?i)[a-z]{2,4}$")
            return 1
        return 0
    }
    NormalizeName(s) {
        s := this.Lower(Trim(s))
        StringReplace, s, s, 0, o, All
        StringReplace, s, s, 1, l, All
        StringReplace, s, s, 3, e, All
        StringReplace, s, s, 5, s, All
        return s
    }
    LoadAliasList(path) {
        this.AliasTopNames := {}
        this.AliasTopNamesRegex := ""
        if !FileExist(path) {
            FileAppend, # top_names (one per line or regex)`n, %path%
            return
        }
        FileRead, t, %path%
        rxPartsL := []
        Loop, Parse, t, `n, `r
        {
            s := Trim(A_LoopField)
            if (s="" || SubStr(s,1,1)="#")
                continue
            if (RegExMatch(s, "[\(\)\^$\[\]\|\?\*\\]"))
                rxPartsL.Push(s)
            else
                this.AliasTopNames[this.Lower(s)] := 1
        }
        len := rxPartsL.Length()
        if (len > 0)
            this.AliasTopNamesRegex := "(" . this.StrJoin(rxPartsL, "|") . ")"
        if (this.DebugAliasDump) {
            cnt := 0, sample := ""
            for k, _ in this.AliasTopNames {
                cnt++
                if (cnt <= 40)
                    sample := (sample="" ? k : sample "," k)
            }
            this.DebugWrite("AliasCount=" . cnt . " Regex=" . this.AliasTopNamesRegex . " Sample=" . sample)
        }
    }
    InAliasList(name) {
        if (name = "")
            return 0
        n := this.AliasFuzzyNormalize ? this.NormalizeName(name) : this.Lower(Trim(name))
        if (this.AliasExactMatch && this.AliasTopNames.HasKey(n))
            return 1
        if (!this.AliasExactMatch) {
            for k, _ in this.AliasTopNames
                if InStr(n, k)
                    return 1
        }
        if (this.AliasTopNamesRegex<>"" && RegExMatch(n, this.AliasTopNamesRegex))
            return 1
        return 0
    }
    NameHasZero(name) {
        return RegExMatch(name, "0") ? 1 : 0
    }
    KeywordHit(name) {
        if (this.KeywordRegex="")
            return 0
        ret := RegExMatch(name, this.KeywordRegex) ? 1 : 0
        return ret
    }

    ComputeSpamScore2(name, cx, cy, flags, ByRef reasons) {
        reasons := []
        offTemplate := this.TileTemplateHit(cx, cy)
        noAudio    := this.NoAudioIconHit(cx, cy)
        score := 0

        if (flags.AskStart || offTemplate) {
            score += 1
            reasons.Push("no_cam_on")
        }
        if (noAudio) {
            score += 1
            reasons.Push("no_or_late_audio")
        }
        if (this.ShortNameScore(name) || this.InAliasList(name)) {
            score += 1
            reasons.Push("short_or_alias")
        }
        if (this.IsAllLower(name)) {
            score += 1
            reasons.Push("all_lowercase")
            if (this.NameHasZero(name)) {
                score += 0.5
                reasons.Push("contains_zero")
            }
        }
        if (!flags.MultiPin) {
            score += 1
            reasons.Push("no_multipin_option")
        }
        if ((offTemplate || !flags.StopVideo) && !flags.AskStart) {
            score += 1
            reasons.Push("missing_ask_start_offcam")
        }
        if (this.KeywordHit(name)) {
            score += 1
            reasons.Push("keyword_hit")
        }
        return score
    }

    ClickWaitRoomFromMenu() {
        if (this.PassiveMode)
            return 0
        if (this.DryRunClicks) {
            this.DebugWrite("DRYRUN: would click Wait Room")
            return 1
        }
        this.VirtualBounds(vx, vy, vw, vh)
        vRight := vx + vw, vBottom := vy + vh
        if ( this.ImageFind(this.img_wait1, vx, vy, vRight, vBottom, dx, dy, 40)
          || this.ImageFind(this.img_wait2, vx, vy, vRight, vBottom, dx, dy, 40) ) {
            Click, %dx%, %dy%
            Sleep, 120
            return 1
        }
        steps := this.Cfg_WaitRoomSteps + 0
        Loop, %steps% {
            SendInput, {Down}
            Sleep, 28
        }
        SendInput, {Enter}
        Sleep, 90
        return 1
    }
    OCRTileNameAt(cx, cy) {
        if (!this.OCR_Use)
            return ""
        if IsFunc("OCR_GetText") {
            rx := cx + this.OCR_XOff, ry := cy + this.OCR_YOff
            txt := ""
            try txt := "" . Func("OCR_GetText").Call(rx, ry, this.OCR_W, this.OCR_H)
            return Trim(txt)
        }
        return ""
    }
    HandleTile(camName, x, y) {
        if (!this.PassiveMode) {
            Click, %x%, %y%, 1
            Sleep, 55
        }

        name := this.OCRTileNameAt(x, y)
        pid := "?"
        if (this.UseParticipantsPanel && !this.PassiveMode) {
            if (Trim(name)="")
                name := this.GetPanelName()
            pid := this.GetPanelId()
            if (Trim(pid)="")
                pid := "?"
        }

        key := (pid != "?" && pid != "") ? pid : (camName . "|" . name)
        if (this.seenKeys.HasKey(key))
            return
        this.seenKeys[key] := 1

        if (pid != "?" && pid != "" && name != "")
            this.nameToId[this.Lower(name)] := pid

        flags := {"AskStart":0, "StopVideo":1, "MultiPin":1}
        if (!this.PassiveMode)
            flags := this.GetMenuFlagsAt(x, y, 1)

        reasons := []
        sc := this.ComputeSpamScore2(name, x, y, flags, reasons)

        this.LogParticipant(pid, name, camName, sc)
        this.LogReasons(pid, name, reasons)
        this.scoredCount++
        this.loggedCount++
        this.UpdateTalliesFn()
        this.PushLine(camName . " | ID:" . pid . " | " . name . " | Score:" . sc)

        if (this.PassiveMode) {
            this.CloseContextMenu()
            return
        }

        if (pid != "?" && this.bannedCache.HasKey(pid)) {
            if (this.ClickWaitRoomFromMenu()) {
                this.LogWaitroom(pid, camName, name, sc)
                this.waitroomCount++
                this.UpdateTalliesFn()
            }
            return
        }

        threshold := this.GetThreshold()
        acted := 0
        if (this.AutoWaitroomOnAlias && this.InAliasList(name) && sc >= threshold) {
            if (this.ClickWaitRoomFromMenu()) {
                if (pid != "?" && pid != "")
                    this.BanListAdd(pid)
                this.LogWaitroom(pid, camName, name, sc)
                this.waitroomCount++
                this.UpdateTalliesFn()
                acted := 1
            }
        }
        if (!acted && sc >= threshold) {
            if (this.ClickWaitRoomFromMenu()) {
                if (pid != "?" && pid != "")
                    this.BanListAdd(pid)
                this.LogWaitroom(pid, camName, name, sc)
                this.waitroomCount++
                this.UpdateTalliesFn()
                acted := 1
            }
        }
        if (!acted)
            this.CloseContextMenu()
    }

    ; ============================== LOGGING =============================
    LogParticipant(id, name, region, score) {
        sid := this.San(id), sname := this.San(name), sreg := this.San(region)
        sc := score + 0
        FormatTime, ts,, yyyy-MM-dd HH:mm:ss
        FileAppend, % sid "|" sname "|" sreg "|" sc "|" ts "`r`n", % this.file_p_log
        FileAppend, % ts "|CHECK|" sid "|" sname "|" sreg "|" sc "`r`n", % this.file_p_hist
    }
    LogWaitroom(id, region, name, score) {
        sid := this.San(id), sreg := this.San(region), sname := this.San(name)
        FormatTime, ts,, yyyy-MM-dd HH:mm:ss
        FileAppend, % ts "|WAITROOM|" sid "|" sname "|" sreg "|" score "`r`n", % this.file_waits
    }
    LogReasons(id, name, reasons) {
        if IsObject(reasons) {
            if (reasons.Length() = 0)
                return
            joined := this.StrJoin(reasons, ",")
        } else {
            joined := "" . reasons
            if (Trim(joined) = "")
                return
        }
        FormatTime, ts,, yyyy-MM-dd HH:mm:ss
        sid := this.San(id), sname := this.San(name)
        FileAppend, % ts "|REASONS|" sid "|" sname "|" joined "`r`n", % this.file_p_hist
    }
    LogErr(text) {
        FormatTime, ts,, yyyy-MM-dd HH:mm:ss
        FileAppend, % ts "|ERR|" this.San(text) "`r`n", % this.file_err
    }
    DebugWrite(text) {
        FormatTime, ts,, yyyy-MM-dd HH:mm:ss
        FileAppend, % ts "|DBG|" this.San(text) "`r`n", % this.file_debug
    }

    ; ============================== GUI (square) ========================
    BuildGUI() {
        global HeaderText, ChatText, LogoPic, BotEnabled, StopBtn, DelBtn, QuickBtn, ExitBtn, TestBtn, TolLow, TolMed, TolHigh, TallyText, KeepGalleryLast, KeepChatLast, LastLB

        this.img_stop_video := this.Asset("stop_video")
        this.img_ask_start  := this.Asset("ask_start_video")
        this.img_wait1      := this.Asset("menu_waitroom")
        this.img_wait2      := this.Asset("waitroom")
        this.img_dup        := this.Asset("duplicate_indicator")
        this.img_del_btn    := this.Asset("chat_delete_button")
        this.img_del_btn2   := this.Asset("delete_button")
        this.img_logo       := this.Asset("logo")
        this.img_tile_template := this.Asset("tile_template")
        this.img_menu_multipin := this.Asset("allow_multi_pin")
        this.img_no_audio      := this.Asset("no_audio")
        this.img_chat_last     := this.Asset("chat_last")
        this.img_gallery_last  := this.Asset("gallery_last")

        Gui, New, +AlwaysOnTop +Resize +MinSize480x420 +OwnDialogs, Zoom Anti‑Spam Bot
        Gui, Color, 262626, 262626
        Gui, Margin, 12, 10

        Gui, Font, s11 cFFFFFF Bold, Segoe UI
        Gui, Add, Text,  vHeaderText x12  y12 w280, Monitoring: OFF - Tol: Med
        Gui, Font, s9  cFFFFFF Bold, Segoe UI
        Gui, Add, Text,  vChatText   x300 y14 w160 Right, Chat: Ready
        if (this.img_logo != "")
            Gui, Add, Picture, vLogoPic x470 y10 w96 h96, % this.img_logo

        Gui, Font, s9 cFFFFFF, Segoe UI
        Gui, Add, Checkbox, vBotEnabled gZ_OnBotToggle x12  y60, BOT
        Gui, Add, Button,   vStopBtn  gZ_StopNow         x90  y58 w64 h24, STOP
        Gui, Add, Button,   vDelBtn   gZ_DeleteSpamQuick x160 y58 w84 h24, DELETE
        Gui, Add, Button,   vQuickBtn gZ_DivertSpam      x250 y58 w88 h24, DIVERT
        Gui, Add, Button,   vExitBtn  gZ_Exit            x344 y58 w64 h24, KILL
        Gui, Add, Button,   vTestBtn  gZ_SelfTest        x320 y110 w56 h24, TEST

        Gui, Font, s8 cFFFFFF, Segoe UI
        Gui, Add, Radio, vTolLow  gZ_TolChange x12  y92, Low
        Gui, Add, Radio, vTolMed  gZ_TolChange x56  y92, Med
        Gui, Add, Radio, vTolHigh gZ_TolChange x104 y92, High
        Gui, Add, Text,  vTallyText x180 y92 w280 Right, Scored: 0 | Logged: 0 | Waitroom: 0

        Gui, Add, Checkbox, vKeepGalleryLast gZ_KeepChange x12  y112, Keep Gallery Last
        Gui, Add, Checkbox, vKeepChatLast    gZ_KeepChange x160 y112, Keep Chat Last

        Gui, Add, ListBox, vLastLB x12 y140 w452 h100, (waiting...)

        if (this.Tolerance = "Low")
            GuiControl,, TolLow, 1
        else if (this.Tolerance = "High")
            GuiControl,, TolHigh, 1
        else
            GuiControl,, TolMed, 1

        Gui, Show, w520 h420
        Gosub, Z_UpdateStatus
        Gui, +LastFound
        WinGet, gh, ID, A
        this.GuiHwnd := gh
    }

    UpdateStatusFn() {
        hdr := "Monitoring: " . (this.BotEnabled ? "ON" : "OFF") . " - Tol: " . (this.Tolerance="Low"?"Low":(this.Tolerance="Med"?"Med":"High"))
        GuiControl,, HeaderText, %hdr%
        GuiControl,, ChatText, % (this.BotEnabled ? "Chat: Monitoring" : "Chat: Ready") . " | " . this.AhkVerStr
        this.UpdateTalliesFn()
    }
    UpdateTalliesFn() {
        GuiControl,, TallyText, % "Scored: " . this.scoredCount . " | Logged: " . this.loggedCount . " | Waitroom: " . this.waitroomCount
    }
    PushLine(line) {
        this.LastCamLines.Push(line)
        while (this.LastCamLines.Length() > 5)
            this.LastCamLines.RemoveAt(1)
        items := ""
        Loop, % this.LastCamLines.Length() {
            e := this.LastCamLines[A_Index]
            items := (A_Index=1) ? e : items . "|" . e
        }
        if (items="")
            items := "(waiting...)"
        GuiControl,, LastLB, |%items%
    }
    StatusFlash(msg) {
        FormatTime, tsFlash,, yyyy-MM-dd HH:mm:ss
        GuiControl,, HeaderText, % "Monitoring: " . (this.BotEnabled ? "ON" : "OFF") . " - " . msg . " @ " . tsFlash
        SetTimer, Z_StatusReset, -1400
    }
    KeepLastClicks() {
        if (this.PassiveMode)
            return
        if (A_TickCount - this.LastKeepTick < this.KeepCooldownMs)
            return
        if (this.KeepChatLast && this.img_chat_last != "") {
            refHwnd := this.ChatRefHwnd()
            if (refHwnd) {
                WinGetPos, cx, cy, cw, ch, ahk_id %refHwnd%
                if (this.ImageFind(this.img_chat_last, cx, cy, cx+cw, cy+ch, lx, ly, 40)) {
                    Click, %lx%, %ly%
                    Sleep, 40
                }
            }
        }
        if (this.KeepGalleryLast && this.img_gallery_last != "") {
            gHwnd := this.FindZoomMainWin()
            if (gHwnd) {
                WinGetPos, gx, gy, gw, gh, ahk_id %gHwnd%
                if (this.ImageFind(this.img_gallery_last, gx, gy, gx+gw, gy+gh, gx1, gy1, 40)) {
                    Click, %gx1%, %gy1%
                    Sleep, 40
                }
            }
        }
        this.LastKeepTick := A_TickCount
    }

    ; ============================ CONFIG I/O ===========================
    LoadConfig() {
        ; Chat
        IniRead, v5,  % this.iniPath, Chat, WaitRoomSteps, % this.Cfg_WaitRoomSteps
        this.Cfg_WaitRoomSteps := this.Int(v5, this.Cfg_WaitRoomSteps)

        IniRead, tol, % this.iniPath, Bot, Tolerance, % this.Tolerance
        tol := Trim(tol)
        if (tol="Low" || tol="Med" || tol="High") this.Tolerance := tol
        IniRead, on , % this.iniPath, Bot, StartEnabled, 0
        this.BotEnabled := (on+0) ? 1 : 0

        IniRead, logp, % this.iniPath, Chat, ChatLogPath, % this.file_chatlog
        if (logp!="") this.file_chatlog := logp

        IniRead, cman, % this.iniPath, Chat, ManageWindow, % this.ChatManageWindow
        IniRead, cx,   % this.iniPath, Chat, X, % this.ChatPosX
        IniRead, cy,   % this.iniPath, Chat, Y, % this.ChatPosY
        IniRead, cw,   % this.iniPath, Chat, W, % this.ChatW
        IniRead, ch,   % this.iniPath, Chat, H, % this.ChatH
        this.ChatManageWindow := this.Int(cman, this.ChatManageWindow)
        this.ChatPosX := this.Int(cx, this.ChatPosX)
        this.ChatPosY := this.Int(cy, this.ChatPosY)
        this.ChatW    := this.Int(cw, this.ChatW)
        this.ChatH    := this.Int(ch, this.ChatH)

        ; Spam burst
        IniRead, th,   % this.iniPath, Bot, DuplicateSpamThreshold, % this.DuplicateSpamThreshold
        IniRead, win,  % this.iniPath, Bot, WindowMs, % this.WindowMs
        IniRead, cd,   % this.iniPath, Bot, ZapCooldownMs, % this.ZapCooldownMs
        this.DuplicateSpamThreshold := Max(3, this.Int(th, this.DuplicateSpamThreshold))
        this.WindowMs := Max(1000, this.Int(win, this.WindowMs))
        this.ZapCooldownMs := Max(1000, this.Int(cd, this.ZapCooldownMs))

        ; Gate
        IniRead, gt, % this.iniPath, Bot, GateTolerance, % this.GateTolerance
        IniRead, gr, % this.iniPath, Bot, GateSampleRadius, % this.GateSampleRadius
        IniRead, nf, % this.iniPath, Bot, NoHitFallbackLoops, % this.NoHitFallbackLoops
        this.GateTolerance := this.Int(gt, this.GateTolerance)
        this.GateSampleRadius := this.Int(gr, this.GateSampleRadius)
        this.NoHitFallbackLoops := this.Int(nf, this.NoHitFallbackLoops)

        ; Participants panel
        IniRead, pmw, % this.iniPath, Participants, ManageWindow, % this.PartManageWindow
        IniRead, px,  % this.iniPath, Participants, X, % this.PartPosX
        IniRead, py,  % this.iniPath, Participants, Y, % this.PartPosY
        IniRead, pw,  % this.iniPath, Participants, W, % this.PartW
        IniRead, ph,  % this.iniPath, Participants, H, % this.PartH
        this.PartManageWindow := this.Int(pmw, this.PartManageWindow)
        this.PartPosX := this.Int(px, this.PartPosX)
        this.PartPosY := this.Int(py, this.PartPosY)
        this.PartW    := this.Int(pw, this.PartW)
        this.PartH    := this.Int(ph, this.PartH)

        IniRead, nrx, % this.iniPath, Participants, NameRX, % this.PartNameRX
        IniRead, nry, % this.iniPath, Participants, NameRY, % this.PartNameRY
        IniRead, nrw, % this.iniPath, Participants, NameRW, % this.PartNameRW
        IniRead, nrh, % this.iniPath, Participants, NameRH, % this.PartNameRH
        this.PartNameRX := this.Int(nrx, this.PartNameRX)
        this.PartNameRY := this.Int(nry, this.PartNameRY)
        this.PartNameRW := this.Int(nrw, this.PartNameRW)
        this.PartNameRH := this.Int(nrh, this.PartNameRH)

        IniRead, irx, % this.iniPath, Participants, IdRX, % this.PartIdRX
        IniRead, iry, % this.iniPath, Participants, IdRY, % this.PartIdRY
        IniRead, irw, % this.iniPath, Participants, IdRW, % this.PartIdRW
        IniRead, irh, % this.iniPath, Participants, IdRH, % this.PartIdRH
        this.PartIdRX := this.Int(irx, this.PartIdRX)
        this.PartIdRY := this.Int(iry, this.PartIdRY)
        this.PartIdRW := this.Int(irw, this.PartIdRW)
        this.PartIdRH := this.Int(irh, this.PartIdRH)

        ; Cam points
        Loop, 5
        {
            idx := A_Index
            IniRead, cx2, % this.iniPath, Cams, Cam%idx%X, % this.cams[idx].x
            IniRead, cy2, % this.iniPath, Cams, Cam%idx%Y, % this.cams[idx].y
            this.cams[idx].x := this.Int(cx2, this.cams[idx].x)
            this.cams[idx].y := this.Int(cy2, this.cams[idx].y)
        }

        ; Aliases/keywords
        IniRead, kx , % this.iniPath, Bot, KeywordRegex, % this.KeywordRegex
        IniRead, sn , % this.iniPath, Bot, ShortNameRegex, % this.ShortNameRegex
        IniRead, tr , % this.iniPath, Bot, AliasTopNamesRegex, % this.AliasTopNamesRegex
        IniRead, tf , % this.iniPath, Bot, AliasTopNamesFile, % this.AliasTopNamesFile
        IniRead, nz , % this.iniPath, Bot, AliasFuzzyNormalize, % this.AliasFuzzyNormalize
        IniRead, em , % this.iniPath, Bot, AliasExactMatch, % this.AliasExactMatch
        IniRead, aw , % this.iniPath, Bot, AutoWaitroomOnAlias, % this.AutoWaitroomOnAlias
        IniRead, rr , % this.iniPath, Bot, TileTemplateSearchRadius, % this.TileTemplateSearchRadius
        this.KeywordRegex := (kx <> "") ? kx : this.KeywordRegex
        this.ShortNameRegex := (sn <> "") ? sn : this.ShortNameRegex
        this.AliasTopNamesRegex := (tr <> "") ? tr : ""
        this.AliasTopNamesFile := (tf <> "") ? tf : this.dataDir . "\\top_names.txt"
        this.AliasFuzzyNormalize := this.Int(nz, this.AliasFuzzyNormalize)
        this.AliasExactMatch := this.Int(em, this.AliasExactMatch)
        this.AutoWaitroomOnAlias := this.Int(aw, this.AutoWaitroomOnAlias)
        this.TileTemplateSearchRadius := this.Int(rr, this.TileTemplateSearchRadius)

        ; Debug/passive/keep
        IniRead, dad, % this.iniPath, Debug, AliasDump, % this.DebugAliasDump
        this.DebugAliasDump := this.Int(dad, this.DebugAliasDump)

        IniRead, pm,  % this.iniPath, Bot, PassiveMode, % this.PassiveMode
        IniRead, dr,  % this.iniPath, Bot, DryRunClicks, % this.DryRunClicks
        IniRead, kgl, % this.iniPath, Bot, KeepGalleryLast, % this.KeepGalleryLast
        IniRead, kcl, % this.iniPath, Bot, KeepChatLast, % this.KeepChatLast
        IniRead, kcd, % this.iniPath, Bot, KeepCooldownMs, % this.KeepCooldownMs
        this.PassiveMode := this.Int(pm, this.PassiveMode)
        this.DryRunClicks := this.Int(dr, this.DryRunClicks)
        this.KeepGalleryLast := this.Int(kgl, this.KeepGalleryLast)
        this.KeepChatLast := this.Int(kcl, this.KeepChatLast)
        this.KeepCooldownMs := this.Int(kcd, this.KeepCooldownMs)

        ; Forced chat rectangle and More menu
        IniRead, fx, % this.iniPath, Chat, ForceX, % this.ChatForceX
        IniRead, fy, % this.iniPath, Chat, ForceY, % this.ChatForceY
        IniRead, fw, % this.iniPath, Chat, ForceW, % this.ChatForceW
        IniRead, fh, % this.iniPath, Chat, ForceH, % this.ChatForceH
        IniRead, mx, % this.iniPath, Chat, MoreRX, % this.MoreBtnRX
        IniRead, my, % this.iniPath, Chat, MoreRY, % this.MoreBtnRY
        IniRead, sh, % this.iniPath, Chat, StepsToHosts, % this.StepsToHosts
        IniRead, se, % this.iniPath, Chat, StepsToEveryone, % this.StepsToEveryone
        this.ChatForceX := this.Int(fx, this.ChatForceX)
        this.ChatForceY := this.Int(fy, this.ChatForceY)
        this.ChatForceW := this.Int(fw, this.ChatForceW)
        this.ChatForceH := this.Int(fh, this.ChatForceH)
        this.MoreBtnRX  := this.Int(mx, this.MoreBtnRX)
        this.MoreBtnRY  := this.Int(my, this.MoreBtnRY)
        this.StepsToHosts := this.Int(sh, this.StepsToHosts)
        this.StepsToEveryone := this.Int(se, this.StepsToEveryone)

        if (!FileExist(this.AliasTopNamesFile))
            FileAppend, # top_names (one per line or regex)`n, % this.AliasTopNamesFile
        this.LoadAliasList(this.AliasTopNamesFile)
    }

    SaveConfig() {
        IniWrite, % this.Cfg_WaitRoomSteps, % this.iniPath, Chat, WaitRoomSteps
        IniWrite, % this.file_chatlog, % this.iniPath, Chat, ChatLogPath
        IniWrite, % this.ChatManageWindow, % this.iniPath, Chat, ManageWindow
        IniWrite, % this.ChatPosX, % this.iniPath, Chat, X
        IniWrite, % this.ChatPosY, % this.iniPath, Chat, Y
        IniWrite, % this.ChatW,   % this.iniPath, Chat, W
        IniWrite, % this.ChatH,   % this.iniPath, Chat, H

        IniWrite, % this.DuplicateSpamThreshold, % this.iniPath, Bot, DuplicateSpamThreshold
        IniWrite, % this.WindowMs,              % this.iniPath, Bot, WindowMs
        IniWrite, % this.ZapCooldownMs,         % this.iniPath, Bot, ZapCooldownMs

        IniWrite, % this.GateTolerance,      % this.iniPath, Bot, GateTolerance
        IniWrite, % this.GateSampleRadius,   % this.iniPath, Bot, GateSampleRadius
        IniWrite, % this.NoHitFallbackLoops, % this.iniPath, Bot, NoHitFallbackLoops

        IniWrite, % this.PartManageWindow, % this.iniPath, Participants, ManageWindow
        IniWrite, % this.PartPosX, % this.iniPath, Participants, X
        IniWrite, % this.PartPosY, % this.iniPath, Participants, Y
        IniWrite, % this.PartW,   % this.iniPath, Participants, W
        IniWrite, % this.PartH,   % this.iniPath, Participants, H
        IniWrite, % this.PartNameRX, % this.iniPath, Participants, NameRX
        IniWrite, % this.PartNameRY, % this.iniPath, Participants, NameRY
        IniWrite, % this.PartNameRW, % this.iniPath, Participants, NameRW
        IniWrite, % this.PartNameRH, % this.iniPath, Participants, NameRH
        IniWrite, % this.PartIdRX, % this.iniPath, Participants, IdRX
        IniWrite, % this.PartIdRY, % this.iniPath, Participants, IdRY
        IniWrite, % this.PartIdRW, % this.iniPath, Participants, IdRW
        IniWrite, % this.PartIdRH, % this.iniPath, Participants, IdRH

        IniWrite, % this.Tolerance, % this.iniPath, Bot, Tolerance
        IniWrite, % (this.BotEnabled?1:0), % this.iniPath, Bot, StartEnabled

        Loop, 5
        {
            idx := A_Index
            IniWrite, % this.cams[idx].x, % this.iniPath, Cams, Cam%idx%X
            IniWrite, % this.cams[idx].y, % this.iniPath, Cams, Cam%idx%Y
        }

        IniWrite, % this.KeywordRegex,        % this.iniPath, Bot, KeywordRegex
        IniWrite, % this.ShortNameRegex,      % this.iniPath, Bot, ShortNameRegex
        IniWrite, % this.AliasTopNamesRegex,  % this.iniPath, Bot, AliasTopNamesRegex
        IniWrite, % this.AliasTopNamesFile,   % this.iniPath, Bot, AliasTopNamesFile
        IniWrite, % this.AliasFuzzyNormalize, % this.iniPath, Bot, AliasFuzzyNormalize
        IniWrite, % this.AliasExactMatch,     % this.iniPath, Bot, AliasExactMatch
        IniWrite, % this.AutoWaitroomOnAlias, % this.iniPath, Bot, AutoWaitroomOnAlias
        IniWrite, % this.TileTemplateSearchRadius, % this.iniPath, Bot, TileTemplateSearchRadius

        IniWrite, % this.PassiveMode,     % this.iniPath, Bot, PassiveMode
        IniWrite, % this.DryRunClicks,    % this.iniPath, Bot, DryRunClicks
        IniWrite, % this.KeepGalleryLast, % this.iniPath, Bot, KeepGalleryLast
        IniWrite, % this.KeepChatLast,    % this.iniPath, Bot, KeepChatLast
        IniWrite, % this.KeepCooldownMs,  % this.iniPath, Bot, KeepCooldownMs

        IniWrite, % this.ChatForceX,   % this.iniPath, Chat, ForceX
        IniWrite, % this.ChatForceY,   % this.iniPath, Chat, ForceY
        IniWrite, % this.ChatForceW,   % this.iniPath, Chat, ForceW
        IniWrite, % this.ChatForceH,   % this.iniPath, Chat, ForceH
        IniWrite, % this.MoreBtnRX,    % this.iniPath, Chat, MoreRX
        IniWrite, % this.MoreBtnRY,    % this.iniPath, Chat, MoreRY
        IniWrite, % this.StepsToHosts, % this.iniPath, Chat, StepsToHosts
        IniWrite, % this.StepsToEveryone, % this.iniPath, Chat, StepsToEveryone

        IniWrite, % this.DebugAliasDump, % this.iniPath, Debug, AliasDump
    }

    RunSelfTest() {
        this.DebugWrite("=== SELFTEST START ===")
        this.DebugWrite("Version=" . this.AhkVerStr)
        this.DebugWrite("Tol=" . this.Tolerance . " Th=" . this.GetThreshold() . " KW=" . this.KeywordRegex . " RX=" . this.AliasTopNamesRegex)
        names := ["adidas", "Co Host", "aa", "L33t", "normal User", "melaus", "Jane"]
        for idx, nm in names
        {
            flags := {"AskStart":0, "StopVideo":1, "MultiPin":1}
            reasons := []
            sc := this.ComputeSpamScore2(nm, 0, 0, flags, reasons)
            this.DebugWrite("name=" . nm . " score=" . sc . " reasons=" . this.StrJoin(reasons, ","))
        }
        cnt := 0
        for k, _ in this.AliasTopNames
            cnt++
        this.DebugWrite("AliasCount=" . cnt)
        this.DebugWrite("=== SELFTEST END ===")
        this.StatusFlash("SelfTest logged")
    }

    MainLoop() {
        if (!this.BotEnabled)
            return
        this.EnsureChatBottom()
        this.ChatPollAndMitigate()
        this.KeepLastClicks()
        if (this.FindZoomMainWin())
            this.ScanFiveCamsAndScore()
    }

    ScanFiveCamsAndScore() {
        hitsThisLoop := 0
        for idx, cam in this.cams
        {
            if (!this.camGateActive.HasKey(cam.name))
                this.camGateActive[cam.name] := 0
            gate := this.SampleDarkGate(cam.x, cam.y)
            if (gate)
            {
                if (!this.camGateActive[cam.name])
                {
                    this.HandleTile(cam.name, cam.x, cam.y)
                    this.camGateActive[cam.name] := 1
                    hitsThisLoop++
                }
            }
            else
            {
                this.camGateActive[cam.name] := 0
            }
        }
        if (hitsThisLoop = 0)
        {
            this.noHitCounter++
            if (this.noHitCounter >= this.NoHitFallbackLoops)
            {
                cam := this.cams[1]
                this.HandleTile(cam.name, cam.x, cam.y)
                this.noHitCounter := 0
            }
        }
        else
            this.noHitCounter := 0
    }

    DeleteSpamQuickLoop() {
        refHwnd := this.ChatRefHwnd()
        if (!refHwnd)
            return
        WinGetPos, cx, cy, cw, ch, ahk_id %refHwnd%
        Loop, 5
        {
            if !this.ImageFind(this.img_dup, cx, cy, cx+cw, cy+ch, fx, fy, 40)
                break
            PixelGetColor, col, %fx%, %fy%, RGB
            if (col != this.TARGET_HEX)
                break
            MouseClick, Right, % (fx+30), % (fy+18), 1, 0
            Sleep, 120
            this.VirtualBounds(vx, vy, vw, vh)
            vRight := vx + vw, vBottom := vy + vh
            if ( this.ImageFind(this.img_del_btn,  vx, vy, vRight, vBottom, dx, dy, 40)
              || this.ImageFind(this.img_del_btn2, vx, vy, vRight, vBottom, dx, dy, 40) )
            {
                Click, %dx%, %dy%
            }
            else
            {
                SendInput, {Enter}
            }
            Sleep, 160
        }
    }

    ResetSession() {
        this.seenKeys := {}
        this.camGateActive := {}
        this.scoredCount := 0
        this.loggedCount := 0
        this.waitroomCount := 0
        this.LastCamLines := []
        this.noHitCounter := 0
        Gosub, Z_UpdateTallies
        this.PushLine("(session reset)")
    }

gBot := new ZoomAntiSpamBot()
if !FileExist(gBot.file_chatlog) {
    gBot.StatusFlash("Monitoring ON | chatlog MISSING")
    gBot.ScanFiveCamsAndScore()
}
Gosub, Z_UpdateStatus
Return



Z_TolChange:
Gui, Submit, NoHide
GuiControlGet, tolLowVal,, TolLow
GuiControlGet, tolMedVal,, TolMed
gBot.Tolerance := (tolLowVal?"Low":(tolMedVal?"Med":"High"))
Gosub, Z_UpdateStatus
Return


Z_DivertSpam:
if (gBot.ChatDisableThenEnable())
gBot.StatusFlash("Diverted (inline)")
else
gBot.StatusFlash("Divert failed (no chat)")
Return


Z_DeleteSpamQuick:
gBot.DeleteSpamQuickLoop()
Return


Z_SelfTest:
gBot.RunSelfTest()
Return


Z_StopNow:
gBot.BotEnabled := 0
GuiControl,, BotEnabled, 0
Gosub, Z_UpdateStatus
Return


^r::
Z_ReloadConfig:
gBot.LoadConfig()
GuiControl,, BotEnabled, % (gBot.BotEnabled ? 1 : 0)
GuiControl,, TolLow, % (gBot.Tolerance="Low" ? 1 : 0)
GuiControl,, TolMed, % (gBot.Tolerance="Med" ? 1 : 0)
GuiControl,, TolHigh, % (gBot.Tolerance="High" ? 1 : 0)
Gosub, Z_UpdateStatus
gBot.StatusFlash("Config reloaded")
Return


F10::
gBot.BotEnabled := !gBot.BotEnabled
if (gBot.BotEnabled)
gBot.ResetSession()
GuiControl,, BotEnabled, % (gBot.BotEnabled ? 1 : 0)
Gosub, Z_UpdateStatus
Return


F11::Gosub, Z_Exit


Z_Exit:
gBot.SaveConfig()
ExitApp
Return


Z_MainLoop:
SetTimer, Z_MainLoop, Off
gBot.MainLoop()
SetTimer, Z_MainLoop, 750
Return

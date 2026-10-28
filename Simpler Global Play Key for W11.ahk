#NoEnv
SendMode Input
#InstallKeybdHook
#UseHook On
Menu, Tray, Icon, shell32.dll, 138 ;play icon
#SingleInstance force 
#MaxHotkeysPerInterval 2000
#WinActivateForce ;might prevent task bar buttons from flashing when different windows are activated quickly one after the other. https://www.autohotkey.com/docs/v1/lib/_WinActivateForce.htm

;OutputDebug tool requires opening windows DebugView

; Make title matching simpler (partial match)
SetTitleMatchMode, 2
	
; ####################################################################
; ## CONTEXT: Onshape in Firefox (Pixel-Checking Method)
; ####################################################################
; This directive makes the hotkeys below it conditional.
#If IsOnshapeActive_ByPixel()
    ; When PgUp is pressed in Onshape, send the Escape key.
    PgUp::
		Send, {Esc}
		OutputDebug, %A_Hour%:%A_Min%:%A_Sec%: Onshape detected, ESC sent
	Return
; Reset the context for subsequent hotkeys.
#If


;Timestamp Tools
^#m::
    if WinActive("Save") or WinActive("Export") ; matches “Save” or “Save As”
        FormatTime, TimeString,, HHmm
    else
        FormatTime, TimeString, T14, Time  ; or use “HH:mm” if you prefer
    Send, %TimeString% -
Return

^+p::
    if WinActive("Save") or WinActive("Export")
        FormatTime, TheDateToday,, yyyy-MM-dd HHmm
    else
        FormatTime, TheDateToday,, yyyy-MM-dd HH:mm
    Send, %TheDateToday%
Return

;SemiColon
^+SC027::
    if WinActive("Save") or WinActive("Export")
        FormatTime, TheDateToday,, yyyy-MM-dd HHmm
    else
        FormatTime, TheDateToday,, yyyy-MM-dd HH:mm
    Send, %TheDateToday%
Return


; ####################################################################
; ## CONTEXT: Visual Studio Code or NanoGPT - wrap clipboard in a
; ## markdown code block (Ctrl+Shift+V)
; ####################################################################
; Shift+Enter is used for the newlines (not plain Enter) so that this also
; works in the opencode terminal, where plain Enter would submit the message.
; Opens a ``` fence, pastes the clipboard, then closes the fence on a new
; line. Only active when the active window title contains
; "Visual Studio Code" or "NanoGPT".
#If WinActive("Visual Studio Code") or WinActive("NanoGPT")
^+v::
	; The backtick is AHK v1's escape character, so writing the fence literally
	; ("```") sends only one backtick: the first two act as an escape pair and
	; the third is a dangling escape. Neither {Raw} nor {Text} changes that.
	; Building the fence with Chr(96) keeps it exact, three backticks long.
	fenceMarker := Chr(96) Chr(96) Chr(96)
	SendInput, +{Enter} ; newline without submitting in the opencode terminal
	SendInput, %fenceMarker%
	SendInput, +{Enter}
	Sleep, 40
	SendInput, ^v
	Sleep, 400 ; give the target app time to finish pasting before closing the fence
	SendInput, +{Enter}
	SendInput, %fenceMarker%
	Return
#If


;Media play key functions.
$Media_Play_Pause::
{
filedelete, %A_ScriptDir%\keypressed.txt
fileappend, numMult, %A_ScriptDir%\keypressed.txt
;Don't return here - want to trigger next set of code as if F23 was pressed.
Goto MediaPlayPauseReplacementScript
Exit
}

;Open the emoji keyboard
$Media_Stop::
{
Send {LWin Down}{vkBE}{LWin Up}
}
Return

~F23::
MediaPlayPauseReplacementScript:
FileRead, key, %A_ScriptDir%\keypressed.txt
If (key = "sample_keyname")
{
	Send {Volume_Down}
} else if(key = "numMult") {
	FileAppend, Consumed, %A_ScriptDir%\keypressed.txt
}


OutputDebug, %A_Hour%:%A_Min%:%A_Sec%: Starting Play key script
;RestartTheMediaKey:
OutputDebug, %A_Hour%:%A_Min%:%A_Sec%: Script Started
WinGet, WorkingWin ,, A ;Get current window ID
SetTitleMatchMode 2 ; 2: A window's title can contain WinTitle anywhere inside it to be a match. 

; Do nothing while a game is in the foreground. This check must come before the
; branches below, because every one of them returns.
IfWinActive Team Fortress
{
	OutputDebug, %A_Hour%:%A_Min%:%A_Sec%: Team Fortress Active. Exiting
	Exit
}

IfWinExist, VirtualDJ
{
    WinActivate, VirtualDJ
    WinWaitActive, VirtualDJ,,1
    If ErrorLevel
    {
        ; Never send the play key to the wrong window.
        OutputDebug, %A_Hour%:%A_Min%:%A_Sec%: VirtualDJ did not activate, aborting
        WinActivate, ahk_id %WorkingWin%
        Return
    }
    WinGet, MusicWin ,, A
    Send, {Space}
    WinActivate, ahk_id %WorkingWin%
    Return
}
else IfWinExist, ahk_exe audacity.exe
{
    ; Debug message (optional)
    OutputDebug, %A_Hour%:%A_Min%:%A_Sec%: Audacity Is Open

    ; Switch to Audacity
    WinActivate, ahk_exe audacity.exe
	WinWaitActive, ahk_exe audacity.exe,,1
    If ErrorLevel
    {
        ; Never send the play key to the wrong window.
        OutputDebug, %A_Hour%:%A_Min%:%A_Sec%: Audacity did not activate, aborting
        WinActivate, ahk_id %WorkingWin%
        Return
    }
    WinGet, MusicWin ,, A

    ; Send "s" to Audacity
    ; p to play/pause without marking
	; s to stop and leave marker to restore to, then s again to restart from marker
	Send, s
	

    ; Switch back to the previously active window
    WinActivate, ahk_id %WorkingWin%
	WinWaitActive, ahk_id %WorkingWin%,,1
    Return
}
else
{
    ; If neither VirtualDJ nor Audacity are open
    OutputDebug, %A_Hour%:%A_Min%:%A_Sec%: Neither VirtualDJ nor Audacity is open, sending media key
    Send, {Media_Play_Pause}
    Return
}

; ####################################################################
; ##ONshape HELPER FUNCTION
; ####################################################################

; This function checks if the active window is Firefox and if specific
; pixels match the Onshape interface colors.
IsOnshapeActive_ByPixel() {
    ; Cheap title check first: a page must actually be Onshape before any
    ; pixel sampling happens, so ordinary white pages in Firefox are never
    ; mistaken for Onshape (which used to swallow PgUp on most websites).
    if !WinActive("Onshape") {
        return false ; Title does not mention Onshape.
    }

    ; Then check if a Firefox window is active. This is fast and
    ; avoids running pixel checks on other applications.
    if !WinActive("ahk_class MozillaWindowClass") {
        return false ; Not Firefox, so definitely not Onshape.
    }

    ; --- DEBUGGING STEP ---
    ; To find the correct color and coordinates, use AHK's Window Spy.
    ; Activate your Onshape window, move your mouse to a stable part of
    ; the UI (like a logo or toolbar), and note the Client coordinates
    ; and the pixel's RGB color.

    ; Get the color of the pixel at two locations in the active window.
    ; Using two points makes the detection more reliable.
    ; The coordinates are relative to the window's client area (the webpage).
    PixelGetColor, color1, 1500, 140, RGB
    PixelGetColor, color2, 10, 1000, RGB

    ; Define the target colors. Replace these with the actual colors from
    ; your Onshape interface, which you can get from Window Spy.
    targetColor1 := 0xFAFAFA
    targetColor2 := 0xFAFAFA

    ; Compare the detected colors to your target colors.
    if (color1 = targetColor1) && (color2 = targetColor2) {
        OutputDebug, %A_Hour%:%A_Min%:%A_Sec% --- Colors match. Onshape is active.
        return true ; The colors match, so enable the hotkey.
    }

    ; If the colors don't match, log the detected colors for debugging.
    OutputDebug, %A_Hour%:%A_Min%:%A_Sec% --- Color mismatch. C1: %color1% | C2: %color2%
    return false ; The colors do not match.
}

;END SCRIPT


Return ;from luamacros F23

;Media Skip Key skips track
$Media_Next::
{
	; Without VirtualDJ this must do nothing at all, otherwise the "m"
	; below would be typed into whatever window is focused.
	IfWinNotExist, VirtualDJ
		Return
	WinGet, winid ,, A
	WinActivate, VirtualDJ,
	WinWaitActive, VirtualDJ,,1
	If ErrorLevel
		Return
	Send, {Shift Down}{Tab}{Shift Up}
	Send, {m}
	WinActivate ahk_id %winid%
	Return
}

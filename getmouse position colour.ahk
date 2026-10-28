#NoEnv
;===Description========================================================================
/*
Screen measuring script. Reports position and size of selected rectangle

To select area:
1. position crosshair and right click mouse to anchor it
2. drag box over area to capture
3. left click mouse to capture the area
MessageBox will display results

Press Esc to exit.
*/
Menu, Tray, Icon, shell32.dll, 16 ; this changes the tray icon to a little keyboard!
SetWinDelay 0
CoordMode, ToolTip, Screen
Coordmode, Mouse, Screen
Restart:
Selecting := False
MouseGetPos, ,,InitPos   ;save where mouse started for window
OldX := -1, OldY := -1

ID1 := Box(2,1,40)
ID2 := Box(3,40,1)
WinActivate, ahk_id %InitPos%

SetTimer Ruler, 10
Return

;KeyWait, RButton, D
RButton::             ;using hotkey instead of waiting for a key keeps the right click from calling other behavior during script
SetTimer Ruler, Off
Selecting := True
Tooltip

MouseGetPos, MX, MY, InitPos
MX := MX - 5  ;correct for mouse pointer offset relative to crosshairs
MY := MY - 5
Gui, +AlwaysOnTop -caption +Border +ToolWindow +LastFound
WinSet, Transparent, 80
Gui, Color, lime

ID4 := Box(4,1,40)   ;create second set of crosshairs
ID5 := Box(5,40,1)
WinActivate, ahk_id %InitPos%

While, ( !(GetKeyState("LButton", "p")) && (Selecting = True) )
{
   MouseGetPos, MXend, MYend
   WinMove ahk_id %ID4%,, % MXend+1, % MYend-20     ;create crosshair by moving 1/2 length of segment
   WinMove ahk_id %ID5%,, % MXend-20, % MYend+1
   w := abs(MX - MXend)
   h := abs(MY - MYend)
   If ( MX < MXend )
   	  X := MX
   Else
   	  X := MXend
   If ( MY < MYend )
   	  Y := MY
   Else
      Y := MYend
   Gui, Show, x%X% y%Y% w%w% h%h%
   PointX := -(MX - MXend)
   PointY := -(MY - MYend)
   ToolTip, %PointX%`,%PointY%
   Sleep, 10
}
if (Selecting = False)
	Goto, Restart
ToolTip
MouseGetPos, MXend, MYend
if (PointX < 0)
	{
		RulerX := RulerX + PointX
		PointX := Abs(PointX)
	}
	if (PointY < 0)
	{
		RulerY := RulerY + PointY
		PointY := Abs(PointY)
	}
; output
WinGetTitle, TitleRel, ahk_id %RelativeTo%
OutputMessage = Location absolute: %RulerX%`,%RulerY%`nLocation relative: %RulerRelX%`,%RulerRelY%`nRelative to: %TitleRel%`nSize: %PointX%`,%PointY%`n`n This has been placed on the clipboard.
Clipboard = %OutputMessage%
Msgbox, %OutputMessage%
Gui, Destroy
Gui 2:Destroy
Gui 3:Destroy
Gui 4:Destroy
Gui 5:Destroy
Goto, Restart  ;OutOfHere

Escape::
if ( Selecting = True )
{
	Selecting := False
	Gui, Destroy
	Gui 2:Destroy
	Gui 3:Destroy
	Gui 4:Destroy
	Gui 5:Destroy
	Return
}
OutOfHere:
ExitApp

;===Subroutines=========================================================================
Ruler:
	CoordMode, Mouse, Relative
	MouseGetPos, RulerRelX, RulerRelY, RelativeTo
	PixelGetColor, Color3,  RulerRelX, RulerRelY, RGB
	CoordMode, Mouse, Screen
   MouseGetPos, RulerX, RulerY
   RulerX := RulerX -5  ;offset the mouse pointer a bit
   RulerY := RulerY -5
	RulerRelX := RulerRelX - 5  ;offset the mouse pointer a bit
   RulerRelY := RulerRelY - 5
   If (OldX <> RulerX)
	  OldX := RulerX
   If (OldY <> RulerY)
      OldY := RulerY
   WinMove ahk_id %ID1%,, %RulerX%, % RulerY-20    ;create crosshair by moving 1/2 length of segment
   WinMove ahk_id %ID2%,, % RulerX-20, %RulerY%
   ToolTip Abs: %RulerX%`,%RulerY%`nRel: %RulerRelX%`,%RulerRelY%`nRGB %Color3% ;ScreenClip (R-click to anchor)
Return

;===Functions==========================================================================
Box(n,wide,high)
{
   Gui %n%:Color, 0,0                  ; Black
   Gui %n%:-Caption +ToolWindow +E0x20 ; No title bar, No taskbar button, Transparent for clicks
   Gui %n%: Show, Center W%wide% H%high%      ; Show it
   WinGet ID, ID, A                    ; ...with HWND/handle ID
   Winset AlwaysOnTop,ON,ahk_id %ID%   ; Keep it always on the top
   WinSet Transparent,255,ahk_id %ID%  ; Opaque
   Return ID
}
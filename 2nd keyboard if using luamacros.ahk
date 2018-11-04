#NoEnv
SendMode Input
#InstallKeybdHook
#UseHook On
Menu, Tray, Icon, shell32.dll, 283 ; this changes the tray icon to a little keyboard!
#SingleInstance force ;only one instance of this script may run at a time!
#MaxHotkeysPerInterval 2000
#WinActivateForce ;https://autohotkey.com/docs/commands/_WinActivateForce.htm
;;
;WARNING, CURRENTLY UNTESTED - WILL TEST SOON.

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; HELLO, poeple who want info about making a second keyboard, using LUAmacros!

; Here's my LTT video about how I use the 2nd keyboard with Luamacros: https://www.youtube.com/watch?v=Arn8ExQ2Gjg
; And Tom's video, which unfortunately does not have info on how to actually DO it: https://youtu.be/lIFE7h3m40U?t=16m9s
; so you also need LUAmacros as well, of course.
; Luamacros: http://www.hidmacros.eu/forum/viewtopic.php?f=10&t=241#p794
; AutohotKey: https://autohotkey.com/

; Lots of other explanatory videos other AHK scripts can be found on my youtube channel! https://www.youtube.com/user/TaranVH/videos 
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


;-------------2ND KEYBOARD USING LUAMACROS-----------------

#IfWinActive ;---- This will allow for everything below this line to work in ANY application.
~F24::
FileRead, key, %A_WorkingDir%\keypressed.txt
If (key = "numMinus")
Send {Volume_Down}{Volume_Down}
else if(key = "numPlus")
Send {Volume_Up}{Volume_Up}
else if(key = "num0") ;just mirroring the normal numpad - IDK how else to do this.
Send {Numpad0}
else if(key = "num1")
Send {Numpad1}
else if(key = "num2")
Send {Numpad2}
else if(key = "num3")
Send {Numpad3}
else if(key = "num4")
Send {Numpad4}
else if(key = "left")
Send {\}
else if(key = "num5")
Send {Numpad5}
else if(key = "num6")
Send {Numpad6}
else if(key = "num7")
Send {Numpad7}
else if(key = "num8")
Send {Numpad8}
else if(key = "backspace")
Send {Volume_Mute}
else if(key = "numDiv")
	{
		WinGet, winid ,, A
		WinActivate, VirtualDJ, 
		Send, {m}
		WinActivate ahk_id %winid%
		Return
	}

;else if(key = "pagedown") ;used for photo cropping in irfan.
;		{
;		send ^{y}
;		send ^{s}
;		send {enter}
;		send {right
;		}
;else if(key = "numMult")
;Send {Volume_Mute}


Return ;from luamacros F24

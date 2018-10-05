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
Send {Volume_Down}
else if(key = "numPlus")
Send {Volume_Up}

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
else if(key = "numMult")
{

MsgBox, "This should not be operating"
Return
;START SCRIPT
$Media_Play_Pause::
WinGet, WorkingWin ,, A ;Get current window ID
SetTitleMatchMode 2 ; 2: A window's title can contain WinTitle anywhere inside it to be a match. 


IfWinExist, Radio 1,
	{
		WinActivate, Radio 1,
		Send, {Space}{PgUp 5}
		WinActivate ahk_id %WorkingWin%
	Return
	}

IfWinExist, Firefox,
	{
		WinActivate, Firefox,
		WinGet, MusicWin ,, A ;Get current window ID
		Send, {Space}
		WinActivate ahk_id %WorkingWin%
		Goto, Restartplay
	}
	
IfWinExist, VLC,
	{
		WinActivate, VLC,
		WinGet, MusicWin ,, A ;Get current window ID
		Send, {Space}
		WinActivate ahk_id %WorkingWin%
	Return
	}
	
IfWinExist, YouTube,
	{
		IfWinNotExist, VirtualDJ,
		{
			WinActivate, YouTube,
			Send, k
			WinActivate ahk_id %WorkingWin%
			return
		}
	}	

;Check for silence
;Set up sound measurement
#SingleInstance, Force
audioMeter := VA_GetAudioMeter()
VA_IAudioMeterInformation_GetPeakValue(audioMeter, peakValue)
tooltip Sound level: %peakvalue%
Sleep, 100
VA_IAudioMeterInformation_GetPeakValue(audioMeter, peakValue2)
peakValue += peakValue2
peakValue /= 2

;Everything after this point is used to monitor sound volume in Virtual DJ. If you don't use it then you can delete it all safely.	
IfWinExist, VirtualDJ, 
	{
	WinActivate, VirtualDJ, 
	WinGet, MusicWin ,, A ;Get current window ID
	Sleep 10
	Send, {space} 
	WinActivate ahk_id %WorkingWin%
	}
	
	;If there was silence at the start of the script, play the music and then exit the script immediately. 
	if (peakvalue < 0.001 )
		{
			tooltip Silence detected at start. Exiting.
			Sleep 2000
			tooltip
			Exit		
		}	
		
	;While sound is playing, do not prompt to restart playback.
	SleptTime := 0
	Restartplay:
	
	;tooltip Check peak sound level every 10s %SleptTime%
	;If the SleptTime is complete or there is silence, ignore this loop
	while (peakvalue > 0.001 and SleptTime < 180000)
	{
		; Get the peak audioMeter value across all channels.
		VA_IAudioMeterInformation_GetPeakValue(audioMeter, peakValue)
		;tooltip, %SleptTime% %peakValue%
		tooltip, marker1 %peakvalue% 
		Sleep, 1000
		tooltip
		SleptTime += 10000
		Sleep, 9000
	}
	;Tooltip Music is not playing. Rest for another 5s then recheck soundlevel
	sleep, 5000
	VA_IAudioMeterInformation_GetPeakValue(audioMeter, peakValue)
	
	
	Tooltip Second check %peakValue%
	Sleep 1000
	Tooltip
	if (peakvalue > 0.001 and SleptTime < 180000)
	{
		;tooltip Sound level %peakvalue%. Restartplay
		;Sleep 1000
		;tooltip
		GoTo Restartplay		
	}
	
	;If the sleep timer has been fulfilled then check if
	;the original media player is playing and quit if so
	;msgbox %SleptTime%
	
	Tooltip
	if (SleptTime > 179000) 
	{
		;If user is active, run the script for another 20s 
		;to prevent disturbing them with media player check;
		
		while (A_TimeIdle < 1000) ;While user is active ;Timeidle is used instead of timeidlephysical because the main user is using a networked (non-physical) mouse and keyboard.
		{	
			Tooltip User active.
			Sleep 200
			Tooltip
			Sleep 800
		}
		;If user is not active, mute the main player and measure sound output
		WinGet, WorkingWin ,, A ;Get current window ID
		WinActivate ahk_id %MusicWin%
		;This key combination mutes virtual dj and pause/plays others.
		Send, {Ctrl Down}.{Ctrl Up}{space}
		Sleep, 50
		WinActivate ahk_id %WorkingWin%
		
		
		Sleep, 50
		VA_IAudioMeterInformation_GetPeakValue(audioMeter, VDJmutedVol)
		Sleep, 100
		VA_IAudioMeterInformation_GetPeakValue(audioMeter, peakValue2)
		;tooltip %VDJmutedVol% 
		VDJmutedVol += peakValue2
		;If sound is playing it must not be coming from VDJ as that just got muted.
		;Therefore no need to keep measuring.
		if VDJmutedVol > 0.001
		{
		GoTo Finishmeasurement
		}
		Sleep, 100
		VA_IAudioMeterInformation_GetPeakValue(audioMeter, peakValue2)
		VDJmutedVol += peakValue2
		Sleep, 100
		VA_IAudioMeterInformation_GetPeakValue(audioMeter, peakValue2)
		VDJmutedVol += peakValue2
		;Tooltip %VDJmutedVol%
		VDJmutedVol /= 4
		tooltip
Finishmeasurement:		
		;If sound was zero after the above then the VDJ must have been started manually.
		;If sound was playing while the above was running, it must be coming from somewhere else.
		WinActivate ahk_id %MusicWin%
		;tooltip %MusicWin%
		Send, {space}{Ctrl Down}.{Ctrl Up}
		Sleep, 50
		WinActivate ahk_id %WorkingWin%
		VA_IAudioMeterInformation_GetPeakValue(audioMeter, Currentvolume)
			Tooltip Current volume is %Currentvolume% 
		;So if the sound is now coming from VDJ, quit the script. 
		if (VDJmutedVol < 0.001 and Currentvolume > 0.001)
		{
			Tooltip It appears VDJ is playing sound. Current Volume %Currentvolume% Exiting.
			Sleep 2000
			Tooltip
			Exit		
		}
	}

	
	IfWinExist YouTube
;Restart the script if youtube is open - VDJ should obviously not be played
	{
		Tooltip YouTube detected, restarting
		Sleep 2000
		Tooltip
		while (A_TimeIdle > 1000) ;While user is INactive
		{
			;Tooltip User active
			Sleep 500
			;Tooltip
		}
		SleptTime = 0
		GoTo Restartplay		
	}
	

	ifWinExist Duolingo
		{
		Tooltip Duolingo detected, restarting
		Sleep 2000
		Tooltip
		while (A_TimeIdle > 1000) ;While user is INactive
		{
			;Tooltip User active
			Sleep 500
			;Tooltip
		}
		SleptTime = 0
		GoTo Restartplay		
	}
	
	VA_IAudioMeterInformation_GetPeakValue(audioMeter, Currentvolume)
	Sleep, 100
	VA_IAudioMeterInformation_GetPeakValue(audioMeter, peakValue2)
	;tooltip %Currentvolume% 
	Currentvolume += peakValue2

	Tooltip YouTube not detected. %Currentvolume%
	sleep 900
	Tooltip

if (Currentvolume > 0.001)
		{
			Tooltip Sound playing at %Currentvolume%. Relooping.
			Sleep 1000
			Tooltip
			SleptTime = 0
			GoTo Restartplay		
		}

		;Wait until user is active	
		while (A_TimeIdle > 5000) ;While user is active ;Timeidle is used instead of timeidlephysical because the main user is using a networked (non-physical) mouse and keyboard.
		{
			;Tooltip User inactive
			Sleep 2500
			Tooltip
		}
		while (A_TimeIdle < 1000) ;While user is active ;Timeidle is used instead of timeidlephysical because the main user is using a networked (non-physical) mouse and keyboard.
		{
			;Tooltip User active
			Sleep 500
			Tooltip
		}
	
	;msgbox Still silent after second check. Ask if music playback desired.
	WinGet, WorkingWin ,, A ;Get current window ID
		MsgBox, 3, , Main media player not detected? Do you want to restart playback?, 60
	IfMsgBox Timeout
	{
		tooltip Messagebox timeout. Exiting %peakvalue%
		Sleep 5000
		tooltip
		Exit
	}
	Else IfMsgBox No ;Don't restart play
	{
		SleptTime := 0
		Sleep 30000
		while (A_TimeIdle > 1000) ;While user is INactive
				{
					;Tooltip User active
					Sleep 500
					;Tooltip
				}
		Goto, Restartplay
	}
	Else IfMsgBox Cancel 
	{ 
		;Tooltip Leave all settings as they are currently. 
		Exit
	}

	IfMsgBox Yes 
	{
	WinActivate ahk_id %MusicWin%
	IfWinActive VirtualDJ	
	{
		tooltip test
		WinActivate VirtualDJ ;Sometimes VDJ wasn't activating properly
		sleep 10
		Send, ^b ;I have coded this to set the crossfader to 0% and then slide it back, to prevent any mistakes with changing the volume while paused.
		Sleep, 250
		tooltip
		WinActivate ahk_id %WorkingWin%
		tooltip End Script
		Sleep 100
		tooltip	
		Exit
	}
	IfWinNotActive VirtualDJ
	{
		WinActivate ahk_id %MusicWin%
		Tooltip other media player
		sleep 100
		Send,{Space}
		tooltip
	}
	}
WinActivate ahk_id %WorkingWin%
tooltip End Script
Sleep 500
tooltip			
Exit
;END SCRIPT
}


Return ;from luamacros F24

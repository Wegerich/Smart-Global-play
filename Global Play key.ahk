#NoEnv
SendMode Input
#InstallKeybdHook
#UseHook On
Menu, Tray, Icon, shell32.dll, 138 ; this changes the tray icon to a little play icon
#SingleInstance force ;only one instance of this script may run at a time!
#MaxHotkeysPerInterval 2000
#WinActivateForce ;https://autohotkey.com/docs/commands/_WinActivateForce.htm

#IfWinActive

;Media play key functions.
$Media_Play_Pause::
{
filedelete, %A_WorkingDir%\keypressed.txt
fileappend, numMult, %A_WorkingDir%\keypressed.txt
;Don't return here - want to trigger next set of code as if F23 was pressed.
}

~F23::
FileRead, key, %A_WorkingDir%\keypressed.txt
If (key = "sample_keyname")
Send {Volume_Down}
else if(key = "enter")
{
	SoundGet, OriginalVolSndGet
	;msgbox, %OriginalVolSndGet% ;allows you to check when debugging
	SoundSet, OriginalVolSndGet / 2
	Sleep 600
	SoundSet, OriginalVolSndGet / 3
	Sleep 600
	SoundSet, OriginalVolSndGet / 4
	Sleep 20000
	SoundSet, OriginalVolSndGet / 2
	Sleep 600
	SoundSet, OriginalVolSndGet / 1.5
	Sleep 600
	SoundSet, OriginalVolSndGet 
}
else if(key = "numMult")
{
WinGet, WorkingWin ,, A ;Get current window ID
SetTitleMatchMode 2 ; 2: A window's title can contain WinTitle anywhere inside it to be a match. 


IfWinExist, Radio 1,
	{
		WinActivate, Radio 1,
		Send, {Space}{PgUp 4}
		Sleep 20
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
	Sleep 800
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
			Sleep 800
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
		Sleep, 450
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
		sleep 200
		Send,{Space}
		sleep 400
		tooltip
	}
	}
WinActivate ahk_id %WorkingWin%
tooltip End Script
Sleep 800
tooltip			
Exit
;END SCRIPT
}

Return ;from luamacros F23


;Media Skip Key skips track
$Media_Next::
{
WinGet, winid ,, A
WinActivate, VirtualDJ, 
Send, {m}
WinActivate ahk_id %winid%
Return
}


;Home button skips track
$Browser_Home::
;Get current window
WinGet, winid ,, A
{
WinActivate, VirtualDJ, 
Send, {m}
WinActivate ahk_id %winid%
Return
}
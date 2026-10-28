#NoEnv
SendMode Input
#InstallKeybdHook
#UseHook On
Menu, Tray, Icon, shell32.dll, 138 ; this changes the tray icon to a little play icon
#SingleInstance force ;only one instance of this script may run at a time!
#MaxHotkeysPerInterval 2000
#WinActivateForce ;https://autohotkey.com/docs/commands/_WinActivateForce.htm12:44 -
#Include %A_ScriptDir%\VA.ahk

	
#IfWinActive

;Media play key functions.
$Media_Play_Pause::
{
filedelete, %A_ScriptDir%\keypressed.txt
fileappend, numMult, %A_ScriptDir%\keypressed.txt
;Don't return here - want to trigger next set of code as if F23 was pressed.
Goto MediaPlayPauseReplacementScript
Exit
}

^#m::
FormatTime, TimeString, T14, Time
Send, %TimeString% - 
Return

^+p::
FormatTime, TheDateToday,, yyyy-MM-dd hh:mm
Send, %TheDateToday%
Return

;SemiColon
^+SC027::
FormatTime, TheDateToday,, yyyy-MM-dd hh:mm
Send, %TheDateToday%
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
RestartTheMediaKey:
OutputDebug, %A_Hour%:%A_Min%:%A_Sec%: Script Started
WinGet, WorkingWin ,, A ;Get current window ID
SetTitleMatchMode 2 ; 2: A window's title can contain WinTitle anywhere inside it to be a match. 

;Capture the volume at the start
startsound := 0
startsound := GetAverageSoundLevel()
OutputDebug, %A_Hour%:%A_Min%:%A_Sec%: startsound was %startsound%



IfWinExist, Radio 1,
	{
		WinActivate, Radio 1,
		WinGet, MusicWin ,, A ;Get current window ID
		sleep 50
		;MouseMove, 50, 1000
		;MouseClick, Left,  50, 1000
		;Send, {LControl down}m{LControl up}
		Send, {PgUp}{PgUp}{PgUp}
		;Click, WheelUp 10
		Sleep 100
		Click, 535, 595
		WinActivate ahk_id %WorkingWin%
		MouseMove, 1250, 500
		Return
	}
	
IfWinExist, Mixcloud,
	{
		
		WinActivate, Mixcloud,
		WinGet, MusicWin ,, A ;Get current window ID
		sleep 50
		;MouseMove, 50, 1000
		;MouseClick, Left,  300, 1000
		;Sleep 100
		;Mute to be certain that silcence will commence.
		;Send, {LControl down}m{LControl up}
		MouseClick, Left,  1040, 1800 ;Prevent issues from playlist
		Sleep 200
		MouseClick, Left,  45, 1860
		Sleep 10
		WinActivate ahk_id %WorkingWin%
		MouseMove, 1250, 500
		;ExitIfSilentAtStart(startsound)
		;VolumeAfterAction := GetAverageSoundLevel()
		;Goto, Restartplay
		Return
	}
	
	
IfWinExist, MIRACLE,
	{
		
		WinActivate, MIRACLE,
		WinGet, MusicWin ,, A ;Get current window ID
		sleep 50
		;MouseMove, 50, 1000
		;MouseClick, Left,  300, 1000
		;Sleep 100
		;Mute to be certain that silcence will commence.
		;Send, {LControl down}m{LControl up}
		MouseClick, Left,  66, 1848
		Sleep 10
		WinActivate ahk_id %WorkingWin%
		MouseMove, 1250, 500
		;ExitIfSilentAtStart(startsound)
		;VolumeAfterAction := GetAverageSoundLevel()
		;Goto, Restartplay
		Return
	}	
	
IfWinExist, SoundCloud,
	{
		
		WinActivate, SoundCloud,
		WinGet, MusicWin ,, A ;Get current window ID
		sleep 50
		;MouseMove, 50, 1000
		;MouseClick, Left,  300, 1000
		;Sleep 100
		;Mute to be certain that silcence will commence.
		;Send, {LControl down}m{LControl up}
		MouseClick, Left,  66, 1848
		Sleep 10
		WinActivate ahk_id %WorkingWin%
		MouseMove, 1250, 500
		;ExitIfSilentAtStart(startsound)
		;VolumeAfterAction := GetAverageSoundLevel()
		;Goto, Restartplay
		Return
	}		

IfWinExist, Firefox,
	{
		WinActivate, Firefox,
		WinGet, MusicWin ,, A ;Get current window ID
		Send, {Space}{PgUp}
		WinActivate ahk_id %WorkingWin%
		;ExitIfSilentAtStart(startsound)
		;VolumeAfterAction := GetAverageSoundLevel()
		;Goto, Restartplay
		Return
	}


IfWinExist, VLC,
	{
		WinActivate, VLC,
		WinGet, MusicWin ,, A ;Get current window ID
		Send, {Space}
		WinActivate ahk_id %WorkingWin%
		;ExitIfSilentAtStart(startsound)
		;VolumeAfterAction := GetAverageSoundLevel()
		Return
	}
	
IfWinExist, YouTube,
	{
		IfWinNotExist, VirtualDJ,
		{
			WinActivate, YouTube,
			Send, k
			WinActivate ahk_id %WorkingWin%
			ExitIfSilentAtStart(startsound)
			VolumeAfterAction := GetAverageSoundLevel()
			Return
		}
	}	


 

If (VolumeAfterAction < startsound) && (VolumeAfterAction < 0.001 )
	{
	ScriptStoppedSoundCompletely := true
	} else {
	ScriptStoppedSoundCompletely := false
	}
	


IfWinExist, VirtualDJ, 
	{
	WinActivate, VirtualDJ, 
	WinGet, MusicWin ,, A ;Get current window ID
	Sleep 10
	Send, {space} 
	WinActivate ahk_id %WorkingWin%
	Return
	VolumeAfterAction := GetAverageSoundLevel()
	;If sound did not start, try again but tab out of search.
	If (VolumeAfterAction < 0.001 && startsound < 0.001) 
		{
		WinActivate, VirtualDJ, 
		WinGet, MusicWin ,, A ;Get current window ID
		Sleep 10
		Send, {tab}{space}
		}
	}
	
	;If there was silence at the start of the script, play the music and then exit the script immediately. 
	ExitIfSilentAtStart(startsound)	
		
	;While sound is playing, do not prompt to restart playback.
	SleptTime := 0 ;Reset
Restartplay:

IfWinExist Zoiper
{
	OutputDebug, %A_Hour%:%A_Min%:%A_Sec%: Zoiper active. Sleep for 1min and restart
	Sleep, 60000
	GoTo Restartplay	
}
IfWinActive Team Fortress
{
	OutputDebug, %A_Hour%:%A_Min%:%A_Sec%: Team Fortress Active. Exiting
	Exit
}
	
	;tooltip Check peak sound level every 10s %SleptTime%
	;If the SleptTime is complete or there is silence, ignore this loop
	peakValue := GetAverageSoundLevel()
	while (peakvalue > 0.001 and SleptTime < 180000)
	{
		; Get the peak audioMeter value across all channels.
		peakValue := GetAverageSoundLevel()
		;tooltip, %SleptTime% %peakValue%
		tooltip, marker1 %peakvalue% 
		Sleep, 500
		tooltip
		
		OutputDebug, %A_Hour%:%A_Min%:%A_Sec%: SleptTime is %SleptTime% and volume is %peakValue%
		
		CheckOverridesTimer := 0
		While (CheckOverridesTimer < 10000)
		{
			OverrideRequested := CheckForOverride()
			If (OverrideRequested = True)
			{
				Goto RestartTheMediaKey
			}
			Sleep, 1000
			CheckOverridesTimer += 1000
			SleptTime += 1000
		}
	}

OverrideRequested := CheckForOverride()
		If (OverrideRequested = True)
		{
			Goto RestartTheMediaKey
		}

OutputDebug, %A_Hour%:%A_Min%:%A_Sec%: No override. Going slowly. 
peakValue := GetAverageSoundLevel()
OutputDebug, %A_Hour%:%A_Min%:%A_Sec%: Second check volume: %peakValue%

	peakValue := GetAverageSoundLevel()
	If (peakvalue > 0.001 and SleptTime < 180000)
	{
		OutputDebug, %A_Hour%:%A_Min%:%A_Sec%: Sound is playing. Go back to waiting. 
		;tooltip Sound level %peakvalue%. Restartplay
		;Sleep 1000
		;tooltip
		GoTo Restartplay		
	}
	
	If (SleptTime > 179000) 
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
		OutputDebug, %A_Hour%:%A_Min%:%A_Sec%: User inactive - muting to check vdj
		
		;If user is not active, mute the main player and measure sound output
		WinGet, WorkingWin ,, A ;Get current window ID
		IfWinExist, VirtualDJ, 
		{
			WinActivate ahk_id %MusicWin%
			;This key combination mutes virtual dj and pause/plays others.
			Send, {Ctrl Down}.{Ctrl Up}{space}
			Sleep 200
			VDJmutedVol := GetInstantSoundLevel(VDJmutedVol)
			OutputDebug, %A_Hour%:%A_Min%:%A_Sec%: VDJ Volume when muted: %VDJmutedVol%
			Send, {Ctrl Down}.{Ctrl Up}{space}
		}
		
		;If sound is playing it must not be coming from VDJ as that just got muted.
		;Therefore no need to keep measuring.
		If (VDJmutedVol > 0.001)
		{
			OutputDebug, %A_Hour%:%A_Min%:%A_Sec%: Sound is playing while VDJ is muted, therefore sound must be from another app.
		}
		Else
		{
			OutputDebug, %A_Hour%:%A_Min%:%A_Sec%:  Computer is silent when VDJ is muted, therefore sound must be from VDJ
		}
		
		Sleep, 50
		GoTo Finishmeasurement
		WinActivate ahk_id %WorkingWin%
		
	} Else {	;If the timer did not complete
			
			OutputDebug, %A_Hour%:%A_Min%:%A_Sec%: Detailed check to see if VDJ is source of sound. 
			WinGet, WorkingWin ,, A ;Get current window ID
			WinActivate ahk_id %MusicWin%
			Send, {Ctrl Down}.{Ctrl Up}{space}
			Sleep, 100
			VDJmutedVol2 := GetInstantSoundLevel(VDJmutedVol2)
			VDJmutedVol += VDJmutedVol2
			Sleep, 100
			VDJmutedVol2 := GetInstantSoundLevel(VDJmutedVol2)
			VDJmutedVol += VDJmutedVol2
			Sleep, 100
			VDJmutedVol2 := GetInstantSoundLevel(VDJmutedVol2)
			VDJmutedVol += VDJmutedVol2
			VDJmutedVol /= 3
			Send, {Ctrl Down}.{Ctrl Up}{space}
			Sleep, 50
			WinActivate ahk_id %WorkingWin%
			
			If (VDJmutedVol > 0.001) 
			{
				OutputDebug, %A_Hour%:%A_Min%:%A_Sec%: Sound is playing while VDJ is muted. SleptTime: %SleptTime%
			} Else {
				OutputDebug, %A_Hour%:%A_Min%:%A_Sec%: VDJ is silent when muted. SleptTime: %SleptTime%
			}
	}
	
Finishmeasurement:		
	;If sound was zero after the above then the VDJ must have been started manually.
	;If sound was playing while the above was running, it must be coming from somewhere else.

	while (A_TimeIdle < 1000) ;While user is active ;Timeidle is used instead of timeidlephysical because the main user is using a networked (non-physical) mouse and keyboard.
	{	
		Tooltip User active.
		Sleep 200
		Tooltip
		Sleep 800
	}
	
		
	Currentvolume := GetAverageSoundLevel()
		Tooltip Current volume is %Currentvolume% 
	;So if the sound is now coming from VDJ, quit the script. 
	
	If (VDJmutedVol < 0.001 and Currentvolume > 0.001)
	{
		Tooltip It appears VDJ is playing sound. Current volume %Currentvolume% Exiting.
		OutputDebug, %A_Hour%:%A_Min%:%A_Sec%: It appears VDJ is playing sound and is the main source of sound. Current volume %Currentvolume% Exiting.
		Sleep 2000
		Tooltip
		Exit		
	}

	
	;Restart the script if youtube is open - VDJ should obviously not be played
	IfWinExist YouTube
	{	
		IfWinActive YouTube
		{
			SoundStatus := "SoundIsPlayingFromYoutube"
			Sleep 10000
			Goto restartplay
		}
		else
		{
			while (A_TimeIdle < 2000) ;While user is active ;Timeidle is used instead of timeidlephysical because the main user is using a networked (non-physical) mouse and keyboard.
			{	
				Tooltip User active.
				Sleep 200
				Tooltip
				Sleep 1800
			}
			PreCheckVolume := GetAverageSoundLevel()
			OutputDebug, %A_Hour%:%A_Min%:%A_Sec%: PreCheckVolume of youtube is %PreCheckVolume%  
			
			If (OverrideRequested = True)
			{
				Goto RestartTheMediaKey
			}
			
			IfWinNotActive YouTube - Google Chrome
			{
				WinActivate YouTube - Google Chrome
			}
			Else
			{
				YoutubeWasTheActiveWindow := true
			}
			Send, {k}
			Sleep 300
			YTMutedVolume := GetInstantSoundLevel("YTMutedVolume")
			;WinActivate YouTube - Google Chrome
			;WinWait YouTube - Google Chrome
			Send, {k}
			
			while (A_TimeIdle < 2000) ;While user is active ;Timeidle is used instead of timeidlephysical because the main user is using a networked (non-physical) mouse and keyboard.
			{	
				Tooltip User active.
				Sleep 200
				Tooltip
				Sleep 800
			}
			
			
			If (PreCheckVolume < 0.001) && (YTMutedVolume < 0.001)
			{ 
				SoundStatus := "NoSoundIsPlaying"
			}
			Else If (PreCheckVolume > 0.001) && (YTMutedVolume > 0.001)
			{ 	
				SoundStatus := "SoundIsComingFromSomewhereNotYoutube" 
			}
			Else If (PreCheckVolume > 0.001) && (YTMutedVolume < 0.001)
			{ 
				SoundStatus := "SoundIsPlayingFromYoutube" 
				OutputDebug, %A_Hour%:%A_Min%:%A_Sec%: Computer goes silent when youtube is muted. 
			}
			Else If (PreCheckVolume < 0.001) && (YTMutedVolume > 0.001)
			{ 
				SoundStatus := "YoutubeWasAlreadyMuted" 
				OutputDebug, %A_Hour%:%A_Min%:%A_Sec%: Youtube was already muted when AHK checked. This is not supposed to happen. Exiting.
				Exit
			}
			
			;Don't mess with windows if the YT window was active.
			If (YoutubeWasTheActiveWindow != True)
			{
				WinActivate ahk_id %WorkingWin%
			}
			If (SoundStatus = "SoundIsComingFromSomewhereNotYoutube")
			{
				Goto PresentUnusedYoutubeWindow
			}

			
			OutputDebug, %A_Hour%:%A_Min%:%A_Sec%: YouTube detected - restarting. SoundStatus = %SoundStatus%
			Sleep 30000
			while (A_TimeIdle > 1000) ;While user is INactive
			{
				;Tooltip User active
				Sleep 500
				;Tooltip
			}
			SleptTime = 0
			GoTo Restartplay
		}
	}
	

	ifWinExist Duolingo
		{
		OutputDebug, %A_Hour%:%A_Min%:%A_Sec%: Duolingo detected, restarting
		while (A_TimeIdle > 1000) ;While user is INactive
		{
			;Tooltip User active
			Sleep 5000
			;Tooltip
		}
		SleptTime = 0
		GoTo Restartplay		
	}
	
	Currentvolume := GetAverageSoundLevel()

	OutputDebug, %A_Hour%:%A_Min%:%A_Sec%: YouTube not detected. CurrVolume %Currentvolume%

if (Currentvolume > 0.001)
	{
		OutputDebug, %A_Hour%:%A_Min%:%A_Sec%: Sound playing at %Currentvolume%. Relooping.
		SleptTime = 0
		GoTo Restartplay		
	}


;msgbox Still silent after second check. Ask if music playback desired.
WinGet, WorkingWin ,, A ;Get current window ID
	
LastKeypressedContents := GetKeypressedTXTContents(True)
If (LastKeypressedContents = "NumMult")
	{
		OutputDebug, %A_Hour%:%A_Min%:%A_Sec%: Not asking permission due to finding "NumMult"
		MsgBoxWasYes := true
		Goto SkipAskingAndJustPlay
	} 	

	;Wait until user is active	
	while (A_TimeIdle > 5000) ;While user is active ;Timeidle is used instead of timeidlephysical because the main user is using a networked (non-physical) mouse and keyboard.
	{
		;Tooltip User inactive
		Sleep 2500
		Tooltip
	}

CheckForOverrideWhileShowingMsgBox:	
	while (A_TimeIdle < 1000) ;While user is active ;Timeidle is used instead of timeidlephysical because the main user is using a networked (non-physical) mouse and keyboard.
	{
		;Tooltip User active
		Sleep 500
		Tooltip
	}


LastKeypressedContents := GetKeypressedTXTContents(True)
If (LastKeypressedContents = "NumMult")
	{
		OutputDebug, %A_Hour%:%A_Min%:%A_Sec%: Not asking permission due to finding "NumMult"
		MsgBoxWasYes := true
		Goto SkipAskingAndJustPlay
	} 	

MsgBox, 3, , Main media player not detected? Do you want to restart playback?, 1
	IfMsgBox Timeout
	{
		If (MsgTimer >= 60) ;Allow x timeouts until quitting.
		{
			Exit
		} Else {
			MsgTimer =+ 1
			Goto CheckForOverrideWhileShowingMsgBox
		}
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
		MsgBoxWasYes := true
	} Else {
		MsgBoxWasYes := false
	}



SkipAskingAndJustPlay:

If (MsgBoxWasYes = true)
	{
		WinActivate ahk_id %MusicWin%
		IfWinActive VirtualDJ	
		{
			OutputDebug, %A_Hour%:%A_Min%:%A_Sec%: Restarting VDJ and ending the script
			WinActivate VirtualDJ ;Sometimes VDJ wasn't activating properly
			sleep 5
			Send,  z ;I have coded this to set the crossfader to 0% and then slide it back, to prevent any mistakes with changing the volume while paused.
			WinActivate ahk_id %WorkingWin%
			Exit
		}
		IfWinNotActive VirtualDJ
		{
			WinActivate ahk_id %MusicWin%
			OutputDebug, %A_Hour%:%A_Min%:%A_Sec%: Restarting media player (not VDJ)
			sleep 50
			Send,{Space}
		}
	}
WinActivate ahk_id %WorkingWin%
tooltip End Script
Sleep 800
tooltip			
Exit
Return

;Check for sound level
;Set up sound measurement
GetAverageSoundLevel()
{
	#SingleInstance, Force
	audioMeter := VA_GetAudioMeter()
	peakValue := 0
	VA_IAudioMeterInformation_GetPeakValue(audioMeter, peakValue)
	Sleep, 200
	VA_IAudioMeterInformation_GetPeakValue(audioMeter, peakValue2)
	peakValue += peakValue2
	peakValue /= 2
	tooltip Sound level: %peakvalue%
	sleep 100
	tooltip 
	return %peakvalue%
}

GetInstantSoundLevel(ReasonForRequest:= "No origin given")
{
	#SingleInstance, Force
	audioMeter := VA_GetAudioMeter()
	VA_IAudioMeterInformation_GetPeakValue(audioMeter, peakValue)
	;OutputDebug, %A_Hour%:%A_Min%:%A_Sec%: Instant Sound Level %peakValue% requested by %ReasonForRequest% section
	return %peakvalue%
}

ExitIfSilentAtStart(startsound)
{
	If (startsound < 0.001)
		{
			tooltip Silence detected at start. Exiting.
			Sleep 500
			tooltip
			Exit
		}
	Return startsound
}

GetKeypressedTXTContents(AppendConsumption)
{
	FileRead, key, %A_ScriptDir%\keypressed.txt
	If (key = "sample_keyname")
	{
		Send {Volume_Down}
	} else if(key = "numMult") && (AppendConsumption = True) {
		FileAppend, Consumed, %A_ScriptDir%\keypressed.txt
	}
	Return key
}

PresentUnusedYoutubeWindow:
	{
		IfWinNotActive YouTube - Google Chrome
		{
			WinActivate YouTube - Google Chrome
			Sleep 10
		}
		
		IfWinActive YouTube - Google Chrome
		{
		ToolTip Are you finished with this Youtube Tab?
		Sleep 1000
		Tooltip
		}
	Return
	}
CheckForOverride()
	{
		LastKeypressedContents := GetKeypressedTXTContents(False)
		If (LastKeypressedContents = "NumMult")
		{
			IfWinNotActive YouTube - Google Chrome
			{
				WinActivate YouTube - Google Chrome
				WinWait, YouTube - Google Chrome, , 0.01
			}
			IfWinActive YouTube - Google Chrome
			{
				ToolTip Are you finished with this Youtube Tab?
				Sleep 1000
				Tooltip
			}
			OutputDebug, %A_Hour%:%A_Min%:%A_Sec%: Override detected. Restarting sequence.
			Return True
		} Else{
			Return False
		}		
		
	}
;END SCRIPT


Return ;from luamacros F23


;Media Skip Key skips track
$Media_Next::
{
WinGet, winid ,, A
WinActivate, VirtualDJ, 
Send, {Shift Down}{Tab}{Shift Up}
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
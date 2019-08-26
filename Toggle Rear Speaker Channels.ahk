#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force ;only one instance of this script may run at a time!
#MaxHotkeysPerInterval 2000
#WinActivateForce ;https://autohotkey.com/docs/commands/_WinActivateForce.htm

#SingleInstance		; Only allows one instance of the script to run.

;Get the rear-right speaker volume
Clipboard = 
Run, %A_WorkingDir%\GetChannel5Vol.bat
ClipWait, 0.5
Chan5Vol := Clipboard
StringReplace, Chan5Vol,Chan5Vol, `r,, All
StringReplace, Chan5Vol,Chan5Vol, `n,, All
Chan5Vol := Chan5Vol + 100.34



;Msgbox, %Chan4Vol%
;Ignore channel 5 if it is silent. Check Channel 4
if (Chan5Vol = 100.34){

	Clipboard = 
	Run, %A_WorkingDir%\GetChannel4Vol.bat
	ClipWait, 0.5
	Chan4Vol := Clipboard
	StringReplace, Chan4Vol,Chan4Vol, `r,, All
	StringReplace, Chan4Vol,Chan4Vol, `n,, All
	Chan4Vol := Chan4Vol + 100.34

	;If channel 5 is already 0 then Mute channel 6
	If (Chan4Vol > 100.34)   {
		Run SoundVolumeView.exe /ChangeVolumeChannel "Rear Panel Speakers" 4 -100 
		}
		else 		{
		;If both channels are 0 then  is 0 then Mute channel 6
		SoundGet, OriginalVolSndGet
		Run SoundVolumeView.exe /SetVolumeChannels "Rear Panel Speakers" * * * * %OriginalVolSndGet% %OriginalVolSndGet% * *
		}
	
	;If both speakers were muted then set them back to the volume of the device
}
else {
	;If channel 5 was loud then mute it
	Run SoundVolumeView.exe /ChangeVolumeChannel "Rear Panel Speakers" 5 -100 
}
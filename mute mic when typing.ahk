#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force ;only one instance of this script may run at a time!
Menu, Tray, Icon, shell32.dll, 31 ; this changes the tray icon
Menu,Tray,Tip, Mute Mic When Typing



SetTimer, KeypressMicMute

KeypressMicMute:
	Input, SingleKey, T0.2 L1 V, {LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{Capslock}{Numlock}{PrintScreen}{Pause}{Volume_Up}{Volume_Down}
	SoundSet, % (ErrorLevel == "Timeout") ? "0" : "1", , mute, 14
	return
	

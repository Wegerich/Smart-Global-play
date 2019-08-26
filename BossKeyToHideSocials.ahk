#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


SetTitleMatchMode 2
WinActivate, Franz
IfWinActive, Franz,
{
Send, ^4
}
WinActivate, Discord
IfWinActive, Discord,
{
Send, ^2
}
WinActivate, Facebook
IfWinActive, Facebook,
{
Send, {F5}
}
WinClose, Franz
WinClose, Discord
WinClose, Whatsapp
WinMinimize, Outlook,
WinActivate, erowid
WinActivate, VirtualDJ
WinActivate, Firefox,
WinActivate, GJ - Yah
IfWinActive, GJ - Yah,
{
Send, ^w
}
WinActivate, Reddit
	
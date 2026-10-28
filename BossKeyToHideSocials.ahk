#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


SetTitleMatchMode 2
WinActivate, Ferdi
IfWinActive, Ferdi,
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
WinClose, Ferdi
WinClose, Discord
WinClose, Whatsapp
WinMinimize, Outlook,
WinMinimize, rasset split,
WinActivate, erowid,
WinActivate, VirtualDJ
sleep 20
WinActivate, Firefox,
WinActivate, Mixcloud,


WinActivate, Reddit
sleep 20

Run, chrome.exe, C:\Program Files (x86)\Google\Chrome\Application

	sleep 10
WinActivate, New Tab
	sleep 100
IfWinActive, New Tab
{
	Send, reddit.com
	sleep 10
	Send, {Enter}
	return
}
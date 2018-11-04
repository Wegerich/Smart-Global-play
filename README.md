# Smart Global play

Key features

-- Run a second keyboard as a media controller keyboard
-- After pausing, check for user activity and prompt user to restart music (only if no audio is playing)
	-- Give option to stay silent, of course
-- Dip volume button (numpad enter) to drop volume for 20 seconds


Pre-requisites
-- The smartest of the audio functions require the Vista Audio Meter for AutoHotKey https://autohotkey.com/board/topic/21984-vista-audio-control-functions/

When you start for the first time you will need to do the following in LuaMacros
-- start the luamacros script
-- press a key on your second keyboard and then record its unique identifier. 
	-- Edit the script to put this in as the variable and you won't have to edit it again in the future. 
-- Change the save location of your keypressed.txt file. Currently it points to a folder in my dropbox.

If you want the scripts to run when you start the PC then you will need to copy the shortcuts to your "startup" folder.

This is a fork of Taran VH's 2nd keyboard script but set up more neatly in GitHub and specifically designed for using a second keyboard as a media controller which is able to play or pause any pre-set media player (eg smart management of pausing VLC vs Youtube Vs media player)
It is currently particularly set up for my use of Virtual DJ as an everyday media player but can be simplified and adapted.

It also creates a number of fixes and improvements

 - Detects downstrokes of keys instead of upstrokes for faster responses and press-and-hold functionality
 - Allows permanent setting of keyboard ID between restarts
 - No need to manually set the location of keypressed.txt in the AHK script
 
 Notable changes
 - The smart play key detects whether sound is playing and prompts the user to restart play from the last media player.
 - Two AHK scripts are required to allow sound monitoring to happen while retaining control of volume and other hotkeys.
 
 
 
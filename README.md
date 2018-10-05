# Smart Global play

This is a fork of Taran VH's 2nd keyboard script but set up more neatly in GitHub and specifically designed for using a second keyboard as a media controller which is able to play or pause any pre-set media player (eg smart management of pausing VLC vs Youtube Vs media player)
It is currently particularly set up for my use of Virtual DJ as an everyday media player but can be simplified and adapted.

It also creates a number of fixes and improvements

 - Detects downstrokes of keys instead of upstrokes for faster responses and press-and-hold functionality
 - Allows permanent setting of keyboard ID between restarts
 -No need to manually set the location of keypressed.txt in the AHK script
 
 Notable changes
 - The smart play key detects whether sound is playing and prompts the user to restart play from the last media player.
 - Two AHK scripts are required to allow sound monitoring to happen while retaining control of volume and other hotkeys.
 
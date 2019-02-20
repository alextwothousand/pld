# Player Location Display
Player Location Display for SAMP, based off of it's GTA V counterpart.

<i>PLD–Player Location Display SAMP is a filterscript that displays the player's current location (including street name or intersection, area name, and region) at the bottom-left corner of the user's screen. It also shows the player's current compass point depending on what direction they are facing.</i>

## Description
* PLD displays your current compass point. At the moment it only supports North, East, South and West however I do plan on adding support for North East, South East, South West and North West in the future.
* PLD displays the player's current location. (Only caveat is that you have to provide XY coordinates)
* Location includes Street Name, Geographical Area & City.

## Dependencies
* streamer by Incognito
* izcmd by Yashas

## Installation
<b><i>Please ensure you have the dependencies installed before attempting to compile the project!</i></b>
* Download the full project and extract it.
* Drop the .pwn files inside of the filterscripts folder into your gamemode's filterscripts folder.
* Compile main.pwn
* Add 'main' to the filterscripts line inside of your server.cfg
* If streamer isn't added to your plugins line, add it!
For more in-depth installation please see the wiki.

## Notes
* This is not an .ASI script like the GTA V Player Location Display, this is completely server-sided. Please do not contact me about making it into an ASI.
* This is for San Andreas Multiplayer, not any GTA 5 Multiplayer platform.

## Credits
* Gravityfalls/Logic for helping me out with the streamer aspect of this.
* Incognito for streamer.
* Yashas for izcmd.
* Lt.Caine for inspiration and for part of this readme.md (specifically the paragraph under the first header).

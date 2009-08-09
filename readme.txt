Run blankmap.exe to generate the map FIRST. Save it as "testmap.dat" ONLY.

Controls for sdltest:
IN MAP EDITOR:
L - load testmap.dat
S - save testmap.dat
R - make random map
C - switch between tile/color editor
Z - clear map
D - toggle between maps
mousewheel - select tiles
left mouse button - place tile
arrow keys - scroll map (if bigger than 40x30)

IN COLOR EDITOR:
C - switch between tile/color editor
R - make the colors back to B&W
1/2/3/4/5/6 - store colors in slots 1-6
F1/F2/F3/F4/F5/F6 - load colors in slots 1-6
S - swap BG and FG color
arrow up/down - change block type

NOTE: feel free to edit the tilemap.bmp but leave it as MS Paint monochrome!!!

Changelog:

+ - added/changed
- - removed
* - bugfix
x - other

PREALPHA 3
+ Greatly improved RAM use! (a 256x256 map took about 140mb of ram in Prealpha 2, it takes about 7mb of ram in this version)
* mask map is now cleared before exit
* The saving function saves in version 2 now (forgot to change a number)
+ You can use D to toggle between maps
* more than 1 map/file works now
* Fixed a blankmap bug.
x Added 2 extra slots.
+ Water support added! Use up/down arrow keys to change it IN THE COLOR SCREEN.
- Removed ESC to exit, click "X" on the window to exit now. The ESC button interrupted me A LOT.
* Fixed a bug with map scrolling and drawing.
* clicking on the tile box does NOT draw a tile now.
+ Added pause/unpause support.
x We're now on GIT!

PREALPHA 2
* fixed a slider-related bug
+ holding the left mouse button keeps moving sliders/drawing objects
+ made moving sliders easier
+ you can see the colors you're editing near the sliders of the color now
+ ability to store up to 4 color combos
+ color swapping abilities
+ color screen now shows the X, Y, width, height and amount of maps.
+ you can now input a map name with the 1st param. All the other params WILL be ignored.
+ you can now have maps up to 1024x1024 (though they take A LOT of memory at the moment)
+ maps are compressed now! (old maps WILL NOT work)
* fixed a blankmap bug causing sdltest to crash
x BUG: if map is too large it doesn't run (keep to 256x256 plz) (memory leak? must debug it more)

PREALPHA 1
x the first version released
x the first version to be called a "version"
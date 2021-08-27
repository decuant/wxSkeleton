#  **wxSkeleton**


## wxSkeleton - rel. 0.0.1 (2021/08/26)

This set of files is meant to be a skeleton for building wxWidgets' applications in Lua (with wxLua in the middle).


This implementation does not use any particular feature of Lua so it shall run with Lua 5.1 and wxWidgets 2.8.12.2 onwards.

I choose the Neko icon (https://en.wikipedia.org/wiki/Neko_(software)) because I could not find any skeleton icon in my database.


## Files


### .1 **main.lua**

The main application file, the place where to put the logic of the application in a MVC paradigm.


### .2 **lib/window.lua**

The main window with basic handlers and settings save/restore facility.


### .3 **lib/random.lua**

An implementation of a random number generator, a replacement of Lua's builtin library.


### .4 **lib/trace.lua**

Implementation of a logging class.


### .5 **lib/ticktimer.lua**

Implementation of a timer class, note that this won't substitute a wxWidgets' window timer, but is an aid at keeping multiple timers in a single window.


### .6 **lib/wxX11Palette.lua**

A class that mimics X11 colours, kept in a comfortable Lua array.


## Author

decuant


## License

The standard MIT license applies.



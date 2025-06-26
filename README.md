# Hot View

A class for AHK v2 that allows you to view the active hotkeys and hotstrings in the current script.  
Either hotkeys, hotstrings, or both can be displayed in a gui.

Properties:  
* `hot_view.show_coords` - An object containing and `x` and `y` property.  
  Set the x and y values to numbers if you want the gui to be displayed in a specific, static spot.  
  If `x` or `y` is a non-number, the gui will display right of the mouse cursor.  

Methods:  
* `hot_view.toggle_view(hot_type)`  
  Toggles the view of the gui.  
  If showing, the gui is destroyed.  
  If not showing, the gui will be shown.  

  The `hot_type` parameter should be one of the following: 'hotkey', 'hotstring', or 'both'
  If omitted, 'both` is used by default.  

* `hot_view.toggle_view(hot_type)`  
  Hold key or button to view the script's hotkeys and/or hotstrings.  
  Upon release, the gui will be destroyed.  

  The `hot_type` parameter should be one of the following: 'hotkey', 'hotstring', or 'both'  
  If omitted, 'both` is used by default.  

***

Example of using Hot View:

```
#Include hot_view.ahk

; Give these hotkeys and hotstrings a try
*F1::hot_view.toggle_view('both')                 ; Toggle view of both hotkeys and hotstrings
*F2::hot_view.hold_to_view('hotkeys')             ; Hold to show only hotkeys
*F3::hot_view.hold_to_view('hotstrings')          ; Hold to show only hotstrings
:*?X:/showhot::hot_view.toggle_view()             ; Hotstring to toggle view
```

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

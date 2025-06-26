class hot_view {
    #Requires AutoHotkey v2.0.19+
    
    /**
        * Object containing x and y coords to show hotkeys
        * If x or y is a non-number, the gui will appear right of the mouse
        * If an x and y number are provided, that will be the static location of the displayed gui
        * By default, the gui appears by the mouse
        */
    static show_coords := {
        x : '',
        y : ''
    }
    
    /**
        * Toggle view of the script's hotkeys and/or hotstrings
        * hot_type should be: 'hotkey', 'hotstring', or 'both'
        * If no hot_type is provided, 'both' is used by default
        * @param {String} [hot_type]  
        * Should be the word 'hotkey', 'hotstring', or 'both'  
        * If omitted, 'both' is used by default
        */
    static toggle_view(hot_type := 'both') => this.gui ? this.gui_destroy() : this.make_gui(hot_type)
    
    /**
        * Hold-to-view the script's hotkeys and/or hotstrings
        * hot_type should be: 'hotkey', 'hotstring', or 'both'
        * If no hot_type is provided, 'both' is used by default
        * @param {String} [hot_type]  
        * Should be the word 'hotkey', 'hotstring', or 'both'  
        * If omitted, 'both' is used by default
        */
    static hold_to_view(hot_type := 'both') {
        key := this.strip_mod(A_ThisHotkey)
        if this.gui
            return
        this.make_gui(hot_type)
        KeyWait(key)
        this.gui_destroy()
    }
    
    ; === Internal ===
    static hotkeys := 'HOTKEYS:'
    static hotstrings := 'HOTSTRINGS:'
    static gui := 0
    static rgx := {
            hotkey    : 'i)^([#!\^+<>*~$]*\S+(?: Up)?::.*?)$',
            hotstring : 'i)^[ \t]*(:[*?\dBCEIKOPRSTXZ]*:[^\n\r]+::.*?)$',
            eoc       : '^.*?\*\/[\s]*$',
            slc       : '^[ \t]*;',
            mlc       : '^[ \t]*\/\*',
            include   : '^[ \t]*#Include\s+(.*?)\s*$',
        }
    
    static __New() => this.generate_hot_lists()
    
    static generate_hot_lists(path:=A_ScriptFullPath) {
        if !FileExist(newpath)
            newpath := A_ScriptDir '\' newpath
        if !FileExist(newpath)
            continue
        rgx := this.rgx
        rgx := {
            hotkey: 'i)^([#!\^+<>*~$]*\S+(?: Up)?::.*?)$',
            hotstring: 'i)^[ \t]*(:[*?\dBCEIKOPRSTXZ]*:[^\n\r]+::.*?)$',
            eoc: '^.*?\*\/[\s]*$',
            slc: '^[ \t]*;',
            mlc: '^[ \t]*\/\*',
            include: '^[ \t]*#Include\s+(.*?)\s*$',
        }
        in_comment := 0
        hotkeys := hotstrings := ''
        
        loop parse FileRead(path), '`n', '`r' {                                                     ; Parse through each line of current script
            if in_comment                                                                           ; Comment block checking
                if RegExMatch(A_LoopField, rgx.eoc)
                    in_comment := 0
                else continue
            else if RegExMatch(A_LoopField, rgx.slc)                                                ; New single line comment
                continue
            else if RegExMatch(A_LoopField, rgx.mlc)                                                ; New comment block
                in_comment := 1
            else if RegExMatch(A_LoopField, rgx.hotstring, &match)                                  ; Hotstring check need to be first
                hotstrings .= '`n' match[]
            else if RegExMatch(A_LoopField, rgx.hotkey, &match)                                     ; Hotkey check after hotstrings (easier matching)
                hotkeys .= '`n' match[]
            else if RegExMatch(A_LoopField, rgx.include, &match) {                                  ; Process #included files
                newpath := match[1]
                this.generate_hot_lists(newpath)
            }
        }
        
        this.hotkeys .= hotkeys
        this.hotstrings .= hotstrings
    }
    
    static make_gui(hot_type) {
        goo := Gui('-Caption')
        goo.MarginX := goo.MarginY := 0
        goo.SetFont('S10 cWhite', 'Courier New')
        goo.SetFont(, 'Consolas')
        options := 'x0 y0 +BackgroundBlack -VScroll -Wrap +Border'
        goo.AddText(options, this.get_text(hot_type))
        if (this.show_coords.x is Number && this.show_coords.y is Number)
        MouseGetPos(&mx, &my)
        goo.Show('x' (mx + 10) ' y' (my + 10) ' AutoSize')
        this.gui := goo
    }
    
    static get_text(hot_type) {
        switch {
            case InStr(hot_type, 'key', 0): return this.hotkeys
            case InStr(hot_type, 'str', 0): return this.hotstrings
            default: return this.hotkeys '`n`n' this.hotstrings
        }
    }
    
    static gui_destroy() => (this.gui is Gui) ? this.gui.Destroy() this.gui := 0 : 0
    static strip_mod(key) => RegExReplace(key, '[\#|\^|\$|!|+|<|>|*|~|`]*(\S+)(?: Up)?', '$1')
}

#Requires AutoHotkey v2.0
#SingleInstance Force
#HotIf WinActive("ahk_exe javaw.exe")	; if this doesn't work try "ahk_exe java.exe" or use ahk window spy
;#NoTrayIcon

global seed 		:= 0	; 0 for rsg
global catagory 	:= "DiamondPick"
global worldName 	:= catagory . "% Attempt "
global delay 		:= 80	; time in between input in ms caution: below 50ms can cause missed inputs
global LHeld := false
global RHeld := false

; Define the path to the INI file
iniFile := A_ScriptDir "\BTWResetStatistics.ini"

*XButton1:: ;hold right click
{
	if(RHeld) {
        Click "Up Right"
		global RHeld := false
    } else {
		Click "Down Right"
		global RHeld := true
	}
}

*XButton2:: ;hold left click
{
	if(LHeld) {
        Click "Up Left"
		global LHeld := false
    } else {
		Click "Down Left"
		global LHeld := true
	}
}

~*LButton Up::global LHeld := false

~*RButton Up::global RHeld := false

;stop holding mouse buttons if the inventory or esc menu is opened
~*e::StopHolding()

~*Esc::StopHolding()

StopHolding()
{
	if(GetKeyState("LButton")) {
        Click "Up Left"
		global LHeld := false
    }
	if(GetKeyState("RButton")) {
        Click "Up Right"
		global RHeld := false
    }
}

!t:: ;get in game time and seed to end run
{
	KeyWait "Alt"
	Send "{Esc}"
	Sleep delay
	ClickSlow(1100, 535)
	ClickSlow(1190, 325)
	ClickSlow(715, 1000)
	Send "/"
	Sleep delay
	Send "time"
	Send "{Enter}"
	Sleep delay
	Send "/"
	Sleep delay
	Send "seed"
	Send "{Enter}"
}

;Seed reseting
^!Enter::
{	
	KeyWait "Alt"
	Send "{Esc}"
	Sleep delay
	ClickSlow(958, 604)		; save and quit
	ClickSlow(959, 440)		; singleplayer
	
/*	delete world code ommited
	x := 1260				; click most recently played world
	y := 120
	While (y < 500){
		ClickSlow(x, y)
		if (PixelGetColor(x, y) == "0x000000"){
			Break
		}
		y += 110
	}

	ClickSlow(840, 1003)	; delete 
	KeyWait "LButton", "D"	; wait for the user to confirm the delete
	KeyWait "LButton"
	Sleep delay
*/

	ClickSlow(1187, 931)	; create new world
	Send "^a"
	Sleep delay
	
	try	; create an attempt counter if none exsist
	{
		attempt := IniRead( iniFile, catagory, "Attempts")
	}
	catch
	{
		attempt := 0
		IniWrite attempt, iniFile, catagory, "Attempts"
	}
	attempt++
	Send worldName . attempt
	IniWrite attempt, iniFile, catagory, "Attempts"
	
	Sleep delay
	ClickSlow(966, 587)		; more world options
	if (seed != 0) {		; set seed code
		ClickSlow(952, 209)
		Send seed
	}
	Sleep 20
	ClickSlow(712, 997)		; done
}

ClickSlow(x, y)
{	
	Click x, y, 0
	Sleep delay
	Click x, y, "D"
	Sleep delay
	Click x, y, "U"
	Sleep delay
}
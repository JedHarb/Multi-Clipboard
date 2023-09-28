#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance, Force ; Reloading the script replaces the previous running script without a prompt.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.

SendText(num){
	GuiControlGet, Edit%num% ; Get the text contents of the Edit(number) and save it as a variable also named Edit(number)
	if (Edit%num%) {
		if WinActive("ClipboardGUI") {
			Send {alt up}!{tab} ; If you're in the GUI, Alt+Tab back to the previous program.
			WinWaitNotActive, ClipboardGUI,, 2
			Sleep 20
		}
		ClipSaved := ClipboardAll ; Save current clipboard contents to variable.
		Clipboard := Edit%num% ; Change the clipboard to the selected text field.
		Send ^v ; Paste rather than sending the text. (Paste is much more instant than any AHK send method.)

;		Sleep 100 ; I need to repeatedly send the text boxes rapid fire.
		Sleep 500 ; Feel free to adjust this! This is just time until you can use another button (sending the paste is still instant). 500 ms is a good balance. 
;		Sleep 1000 ; My program is getting the wrong paste beacuse it takes a moment to process pasting.

		Clipboard := ClipSaved ; Set the original clipboard contents back to the clipboard.
	}
}

^9:: ; Ctrl 9 -- create the GUI
	Gui, Destroy ; if other GUIs exist, we have to stop them before creating this one.

	IniRead, Load0, AHK-Clipboard.ini, values, box0, Set these boxes to any text you want. You can click the button or press its keys, and it will paste that text!
	Gui, Add, Button, gBtn0 xm w50 h49, Alt + 0
	Gui, Add, Edit, vEdit0 r3 xp+55 yp+1 w535 Multi Section, % Load0

	Gui, Add, Button, gBtnSave xp+540 yp-1 w175 h49, Save all boxes
	Gui, Add, Button, gBtnReload xp+180 yp w120, Reload from save
	Gui, Add, Button, gBtnDel xp yp+26 w120, Delete all saves

	Loop, Parse, % "012345qwertasdfgzxcvb" 
	{
		ProperIndex := A_Index-1
		Hotkey, % "!" . A_LoopField, % "Btn" . ProperIndex ; Create a hotkey (Alt + character) for each of these characters, match them to Btn0-Btn20.
		if (ProperIndex <= 5)
			Hotkey, % "!Numpad" . ProperIndex, % "Btn" . ProperIndex ; Also create a hotkey (Alt + numberpad) for numbers 0-5, match them to Btn0-Btn5.

		if (ProperIndex > 0) { ; We created button 0 previously.
			IniRead, Load%ProperIndex%, AHK-Clipboard.ini, values, box%ProperIndex%, %A_Space%
			if (Mod(ProperIndex, 5) = 1)
				Gui, Add, Button, gBtn%ProperIndex% xm w50 h49, Alt + %A_LoopField% ; Buttons 1, 6, 11, and 16 start on a new row.
			else
				Gui, Add, Button, gBtn%ProperIndex% xp+125 yp-1 w50 h49, Alt + %A_LoopField%

			Gui, Add, Edit, vEdit%ProperIndex% r3 xp+55 yp+1 w120 Multi Section, % Load%ProperIndex%
		}
	}
	Gui, +AlwaysOnTop
	Gui, Show,, ClipboardGUI
return

GuiClose:
	Gui, Destroy
return

BtnSave:
	Gui, Submit, NoHide ; Save all controls to their respective variables
	Loop, 21
	{
		ProperIndex := A_Index-1
		IniWrite, % Edit%ProperIndex%, AHK-Clipboard.ini, values, box%ProperIndex%
	}
return

BtnReload:
	Send ^9 ; Send Ctrl + 9 to reload the Gui.
return

BtnDel:
	Loop, 21
	{
		ProperIndex := A_Index-1
		IniDelete, AHK-Clipboard.ini, values, box%ProperIndex%
	}
return

#IfWinExist, ClipboardGUI ; Make the below hotkeys context-sensitive. (They only work if ClipboardGUI is open.)
Btn0:
Btn1:
Btn2:
Btn3:
Btn4:
Btn5:
Btn6:
Btn7:
Btn8:
Btn9:
Btn10:
Btn11:
Btn12:
Btn13:
Btn14:
Btn15:
Btn16:
Btn17:
Btn18:
Btn19:
Btn20:
	RegExMatch(A_ThisLabel, "\d+", num)
	SendText(num)
return
#IfWinExist ; Turn off the context sensitivity.

; Features I might add at some point...
; 1. Give options of different clipboard sizes (number of buttons)
; 2. Add a "compatibility mode" checkbox/slider that increases the sleep time rather than adjusting code
; 3. Make an "always on top" button so it's optional instead of forced

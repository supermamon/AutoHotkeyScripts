; <COMPILER: v1.0.48.5>
#SingleInstance force





APPID=OneKeyLock

GoSub, INIREAD
GoSub, MENU







+ScrollLock::ScrollLock


ScrollLock::
	If (LockBehavior = 0)
		Send {ScrollLock}
	Else if (LockBehavior = 1)
		DllCall("LockWorkStation")
	Else if (LockBehavior = 2)
		GoSub, MonitorOff
	else if (LockBehavior = 3) {
		GoSub, MonitorOff
		DllCall("LockWorkStation")
	}
return

MonitorOff:
		Sleep 500
		SendMessage, 0x112, 0xF170, %LockMonitorOffType%,, Program Manager

RETURN







Reload_AllSettings:

	IniRead,LockBehavior,%APPID%.ini,Lock,Behavior
	If LockBehavior=Error
	  LockBehavior:=1

	IniRead,LockMonitorOffType,%APPID%.ini,Lock,MonitorOffType
	If MonitorOffType=Error
	  MonitorOffType:=1
RETURN

MENU:

	Menu,Tray,DeleteAll
	Menu,Tray,NoStandard




	Menu,Tray,Add,&Settings...,Settings
	Menu,Tray,Add,&Reload Settings,Reload_AllSettings
	Menu,Tray,Add
	Menu,Tray,Add,&About %APPID%,About
	Menu,Tray,Add,E&xit,EXIT
Return



INIREAD:
	GoSub, Reload_AllSettings
Return

Settings:
	Run %A_ScriptDir%\%APPID%.ini
RETURN

EXIT:
	ExitApp
Return



About:
	Gui -SysMenu
	Gui, Add, Text, x66 y7 w160 h20 , %APPID%
	Gui, Add, Picture, x6 y7 w50 h50 , %A_ScriptDir%\%APPID%.exe
	Gui, Add, Text, x66 y27 w160 h20 , Version 1.0.0
	Gui, Add, Button, x176 y87 w50 h20 default , OK
	Gui, Font, underline
	Gui, Add, Text, x66 y47 w160 h20 cBlue gLaunchNJAG, http://notjustageek.weebly.com
	Gui, Font, normal
	Gui, Add, Text, x66 y67 w70 h20 , Lock icons by
	Gui, Font, underline
	Gui, Add, Text, x136 y67 w90 h20 cBlue gLaunchDryIcons, DryIcons
	Gui, Show, h114 w234, About %APPID%
Return

GuiClose:
GuiEscape:
ButtonOK:
	Gui, Destroy
RETURN

LaunchNJAG:
	Run, http://notjustageek.weebly.com
Return
LaunchDryIcons:
	Run, http://dryicons.com
Return




APPID=HeadsUpConsole
VERSION=1.1.0

ScrollUntil=-375
AnimationDelay=0
SmoothStop=0

GoSub, INIREAD
GoSub, MENU






IsVisble = 0

`::
DetectHiddenWindows, on

If IsVisible=0
{
	WinGet, active_id, ID, A
	PrevActive=%active_id%
}
IfWinExist ahk_class Console_2_Main
{

	If IsVisible=1
	{

		WinMoveVert("ahk_class Console_2_Main", 0, 0, ScrollUntil, AnimationDelay, SmoothStop)
		WinHide ahk_class Console_2_Main
		WinActivate ahk_id %PrevActive%
		IsVisible=0

	}
	else
	{

		WinShow ahk_class Console_2_Main
		WinMoveVert("ahk_class Console_2_Main", 0,ScrollUntil, 0, AnimationDelay, SmoothStop)
		WinActivate ahk_class Console_2_Main
		IsVisible = 1
	}

}
else {


	Run %Console2Path%
	Sleep 100
	WinMove, "ahk_class Console_2_Main",, 0, 0

	IsVisible = 1

}

DetectHiddenWindows, off
return













WinMoveVert(title, x, y1, y2, delay, smoothstop)
{
	SetWinDelay 0
	dir := 1
	if (y2 < y1)
	{
		dir := -1
	}

	step := y1
	speed := 40

	LOOP
	{


		If (delay > 0) {
				Sleep delay
		}






		if ( (y2<y1 AND step < y2) OR (y2>y1 AND step > y2) )
		{

			WinMove, %title%,, x, y2
			break
		}
		else
			WinMove, %title%,, x, step



		if ( (ABS(ABS(y2)-ABS(step))) < 101) AND (smoothstop=1)
		{
			speed := 10
		}


		step := step + speed*dir



	}
	return
}




Reload_AllSettings:

	IniRead,Console2Path,%APPID%.ini,Settings,Console2Path
	If Console2Path=Error
	{
		MsgBox, Cannot read Console2Path from .ini file. Exiting...
		ExitApp
	}

	IniRead,ScrollUntil,%APPID%.ini,Settings,ScrollUntil
	If ScrollUntil=Error
	{
		ScrollUntil=-375
	}

	IniRead,AnimationDelay,%APPID%.ini,Optimize,AnimationDelay
	If AnimationDelay=Error
		AnimationDelay=0

	IniRead,SmoothStop,%APPID%.ini,Optimize,SmoothStop
	If AnimationDelay=Error
		SmoothStop=0




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
	Gui, Add, Text, x66 y27 w160 h20 , Version %VERSION%
	Gui, Add, Button, x176 y87 w50 h20 default , OK
	Gui, Font, underline
	Gui, Add, Text, x66 y47 w160 h20 cBlue gLaunchNJAG, http://notjustageek.weebly.com
	Gui, Font, normal
	Gui, Add, Text, x66 y67 w70 h20 , Lock icons by
	Gui, Font, underline
	Gui, Add, Text, x136 y67 w90 h20 cBlue gLaunchDryIcons, Drycons
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





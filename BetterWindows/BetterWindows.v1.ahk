#SingleInstance force
SetTitleMatchMode, 2


APPID=BetterWindows

GoSub, INIREAD
GoSub, MENU




winHotKeys=2


#n::
~^n::
if ( WinActive("ahk_class ExploreWClass") OR WinActive("ahk_class CabinetWClass") )
{
	Send !f

	Send w
	Send f
}
Return


#t::
~^t::
if ( WinActive("ahk_class ExploreWClass") OR WinActive("ahk_class CabinetWClass") )
{
	Send !f

	Send w
	Send t
}
Return

#w::
	EnvGet, SD, SystemDrive
	args = /e,/root,%SD%\
	Run %windir%\explorer.exe %args%
return


~F8::
if ( WinActive("ahk_class ExploreWClass") OR WinActive("ahk_class CabinetWClass") )
{
	Send !v

	Send e
	Send o
}
Return



#h::
	RegRead, HiddenFiles_Status, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden
	If HiddenFiles_Status = 2
		RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden, 1
	Else
		RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden, 2
	WinGetClass, eh_Class,A
	If (eh_Class = "#32770" OR A_OSVersion = "WIN_VISTA")
		Send, {F5}
	Else
		PostMessage, 0x111, 28931,,, A
Return

#y::
	RegRead, HiddenFiles_Status, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, HideFileExt
	If HiddenFiles_Status = 1
		RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, HideFileExt, 0
	Else
		RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, HideFileExt, 1
	WinGetClass, eh_Class,A
	If (eh_Class = "#32770" OR A_OSVersion = "WIN_VISTA")
		Send, {F5}
	Else
		PostMessage, 0x111, 28931,,, A
Return

Alt & LButton::
~LButton & RButton::
	CoordMode, Mouse
	MouseGetPos, EWD_MouseStartX, EWD_MouseStartY, EWD_MouseWin
	WinActivate ahk_id %EWD_MouseWin%
	WinGetPos, EWD_OriginalPosX, EWD_OriginalPosY,,, ahk_id %EWD_MouseWin%
	WinGet, EWD_WinState, MinMax, ahk_id %EWD_MouseWin%
	if EWD_WinState = 0
		SetTimer, EWD_WatchMouse, 10
	return

	EWD_WatchMouse:
	GetKeyState, EWD_LButtonState, LButton, P
	if EWD_LButtonState = U
	{
		SetTimer, EWD_WatchMouse, off
		return
	}
	GetKeyState, EWD_EscapeState, Escape, P
	if EWD_EscapeState = D
	{
		SetTimer, EWD_WatchMouse, off
		WinMove, ahk_id %EWD_MouseWin%,, %EWD_OriginalPosX%, %EWD_OriginalPosY%
		return
	}


	CoordMode, Mouse
	MouseGetPos, EWD_MouseX, EWD_MouseY
	WinGetPos, EWD_WinX, EWD_WinY,,, ahk_id %EWD_MouseWin%
	SetWinDelay, -1
	WinMove, ahk_id %EWD_MouseWin%,, EWD_WinX + EWD_MouseX - EWD_MouseStartX, EWD_WinY + EWD_MouseY - EWD_MouseStartY
	EWD_MouseStartX := EWD_MouseX
	EWD_MouseStartY := EWD_MouseY
return


#IfWinActive ahk_class ConsoleWindowClass
^V::
SendInput {Raw}%clipboard%
return
#IfWinActive



Sub_Hotkeys:

	Gui,%winHotKeys%:+LabelHotKeysGui

	Gui,%winHotKeys%:Margin, 10,10

	Gui,%winHotKeys%:Add,GroupBox, w380 h60 section, Explorer Only
	Gui,%winHotKeys%:Add,Text,yp+20 xp+10,CTRL + N : New Folder
	Gui,%winHotKeys%:Add,Text,x+80,CTRL + T : New Text File
	Gui,%winHotKeys%:Add,Text,xp-190 y+10,F8 : Toggle Explorer Folder View

	Gui,%winHotKeys%:Add,GroupBox, w380 h200 xs, Global
	Gui,%winHotKeys%:Add,Text,yp+20 xp+10,WIN + H : Toggle hidden files/folders
	Gui,%winHotKeys%:Add,Text,y+10,WIN + Y : Toggle file extensions

	Gui,%winHotKeys%:Add,Text,y+10,ALT + LeftMouse Drag : Move window without titlebar (Not valid for maximized window)
	Gui,%winHotKeys%:Add,Text,y+10,CTRL + V : Paste (in Command Prompt)
	Gui,%winHotKeys%:Add,Text,y+10,CTRL + RWIN : Boss Key (See .ini file for exclusions)
	Gui,%winHotKeys%:Add,Text,y+10,*MouseRock Right*: Move window titlebar (Not valid for maximized window)

	Gui,%winHotKeys%:Add,Text,y+30,*MouseRock Right = LButton Down + Right Button Down

	Gui,%winHotKeys%:Add, Button,x340 y+20 w50 h20 default,OK
	Gui,%winHotKeys%:Show,w400 h320, Hotkeys

Return

HotKeysGuiClose:
HotKeysGuiEscape:
2ButtonOK:
	Gui,%winHotKeys%:Destroy
RETURN



Ctrl & RWIN::
Ctrl & LWIN::
{

   IfGreater, B, 0
   {

      WinGet, id, list,,, Program Manager


      Loop, %id%
      {
		this_id:=id%a_index%


        WinGetTitle,title,ahk_id %this_id%


        WinGetClass,class,ahk_id %this_id%


        ToHide = y

		IfEqual,title,,
			IfEqual,class,,
				Continue

		Loop, Parse, ExcludeWindows,|
		{
			CWin = %A_LoopField%


			IfEqual,CWin,,
				Continue
			else
			{



				IfInString, title, %CWin%, SetEnv, ToHide, n
				IfEqual, ToHide, n, Break

				IfInString, class, %CWin%, SetEnv, ToHide, n
				IfEqual, ToHide, n, Break
			}
		}


         IfEqual, ToHide, y
         {

			WinHide, ahk_id %this_id%
            HWins = %HWins%|%this_id%
         }

      }
   }



   IfLess, B, 0
   {

      Loop, Parse, HWins, |

        WinShow, ahk_id %A_LoopField%
   }


	B *= -1
	Return
}









Reload_AllSettings:

	GoSub, Reload_BosskeyExclusions

RETURN

Reload_BosskeyExclusions:
	IniRead,ExcludeWindows,%APPID%.ini,BossKey,ExcludeWindows
	If ExcludeWindows=Error
		ExcludeWindows:=Shell_TrayWnd
	Else
		ExcludeWindows=Shell_TrayWnd|%ExcludeWindows%

RETURN
MENU:
	Menu,Tray,DeleteAll
	Menu,Tray,NoStandard


	Menu,Tray,Add,&Hotkeys...,Sub_Hotkeys
	Menu,Tray,Add

	Menu,Tray,Add,&Settings...,Settings
	Menu,Tray,Add,&Reload Settings,Reload_AllSettings
	Menu,Tray,Add
	Menu,Tray,Add,&About %APPID%,About
	Menu,Tray,Add,E&xit,EXIT
Return




INIREAD:
	B = 1
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




; <COMPILER: v1.0.48.5>
#SingleInstance force

APPID=QACW

~^w::
if ( WinActive("ahk_class ISQLWWindowClass") )
{
	Send {Escape}
	Send ^{F4}
}
RETURN
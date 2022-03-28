#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
; Ensures a consistent starting directory.
#SingleInstance,Force ; Ensures only 1 instance of this script is running
startup()


settingsINI:="EasyErodeSettings.ini"
cErode:=""
settingsTXT:=
(
"[FileLocations]
profileINI=Not Selected
gameEXE=Not Selected

[ErodeMultiplier]
Erode=1.0
"
)
error1:=
(
"Unable to create a backup - Possile issue: `nprofile.ini not selected `nCant find `n%A_MyDocuments%\PiBoSo4\MX Bikes\profiles\`%YourProfileName`%\profile.ini"
)


; Script start
settingsCheck: ; check for already created ini file
IfNotExist,%settingsINI%, FileAppend,%settingsTXT%,%settingsINI%
	;if(!FileExist(settingsINI))
	

start: ; Reading .ini files to variables
if(FileExist(A_MyDocuments "\PiBoSo\MX Bikes\profiles\unnamedProfile\profile.ini"))
{ 
	ProfileINI:=A_MyDocuments "\PiBoSo\MX Bikes\profiles\unnamedProfile\profile.ini"
	cErode:=readini(ProfileINI,"testing","deformation_multiplier")	
}
else
	ProfileINI:=readini(settingsINI,"FileLocations","profileINI") 
GameEXE:=readini(settingsINI,"FileLocations","gameEXE")
ErodeMulti:=readini(settingsINI,"ErodeMultiplier","Erode")
(cErode!><=0) ? (cErode:="profile.ini Not Set")

Gui, Add, Button, x282 y9 w120 h30 gBrowseProfileINI, Set Profile.ini
Gui, Add, Button, x312 y189 w130 h40 gBrowseGame, Set Game .exe
Gui, Add, Text, x12 y9 w270 h40 vProfileINI, %ProfileINI%
Gui, Add, Text, x42 y199 w270 h40 vGameEXE, %GameEXE%
Gui, Add, Edit, x187 y89 w80 h20 r1 vErodeMulti g_ErodeMulti, %ErodeMulti%
Gui, Add, Text, x82 y90 w100  +Center, deformation_multiplier
Gui, Add, Button, x70 y119 w250 h30 Default gsetErode, Set Erode
Gui, Add, Button, x312 y229 w130 h20 gRunGame, Run Game
Gui, Add, Button, x402 y9 w40 h30 gOpenProfileINI, Open
Gui, Add, Text, x320 y125 w130 h20 vcErode +Center, Current Erode= %cErode%
; Generated using SmartGUI Creator 4.0
Gui, Show, x304 y226 h271 w458, MX Bikes EasyErodeChange
Return

GuiClose:
ExitApp


;Labels

setErode:
ErodeMulti:=RegExReplace(ErodeMulti, "[^0-9.]+")
if(ProfileINI="Not Selected")
{
	msgbox,,Error,Browse profile.ini First
	return
}
if(FileExist(ProfileINI ".bak"))
{
	writeini(ErodeMulti,ProfileINI,"testing","deformation_multiplier")
	writeini(ErodeMulti,settingsINI,"ErodeMultiplier","Erode")
	cErode:=readini(ProfileINI,"testing","deformation_multiplier")
	Filecopy,%ProfileINI%,%ProfileINI%.bak,1
	GuiControl,Text,cErode,Current Erode= %cErode%
	Gui Submit,NoHide
	quicktip("Set")
	return
}
if !(FileExist(ProfileINI ".bak"))
{
	Filecopy,%ProfileINI%,%ProfileINI%.bak,1
	writeini(ErodeMulti,ProfileINI,"testing","deformation_multiplier")
	writeini(ErodeMulti,settingsINI,"ErodeMultiplier","Erode")
	cErode:=readini(ProfileINI,"testing","deformation_multiplier")
	GuiControl,Text,cErode,Current Erode= %cErode%
	Gui Submit,NoHide
	quicktip("Set")
	return
}
IfNotExist,%ProfileINI%.bak, MsgBox,,ERROR, %error1%
return


BrowseGame:
FileSelectFile,v,,\\,Select game .exe,*.exe;*.lnk; *.bat
if(ErrorLevel)
	return
gameEXE:=v
GuiControl,Text,GameEXE,%GameEXE%
writeini(GameEXE,settingsINI,"FileLocations","GameEXE")
gui, Submit, NoHide
return


BrowseProfileINI:
FileSelectFile,v,,%A_MyDocuments%\PiBoSo\MX Bikes\profiles\,Select Profile.ini,profile.ini
if(ErrorLevel)
	return
ProfileINI:=v
cErode:=readini(ProfileINI,"testing","deformation_multiplier")
writeini(ProfileINI,settingsINI,"FileLocations","profileINI")
GuiControl,Text,ProfileINI,%ProfileINI%)
GuiControl,Text,cErode,Current Erode= %cErode%
Gui, Submit , NoHide
return


_ErodeMulti:
ErodeMulti:=RegExReplace(ErodeMulti, "[^0-9.]+")
writeini(ErodeMulti,settingsINI,"ErodeMultiplier","Erode")
Gui, Submit,Nohide
return


OpenProfileINI:
Run,%ProfileINI%
gui Submit, NoHide
return

RunGame:
Run,%GameEXE%
gui Submit, NoHide
return


;Functions

readini(file,section,key){
	IniRead,output,%file%,%section%,%key%
	return output
}

writeini(value,file,section,key){
	IniWrite,%value%,%file%,%section%,%key%
	return 
}


startup(){
	
	if(!FileExist(A_MyDocuments "\MX Bikes EasyErodeChange"))
		FileCreateDir,%A_MyDocuments%\MX Bikes EasyErodeChange
	SetWorkingDir %A_MyDocuments%\MX Bikes EasyErodeChange
	if(ErrorLevel)
	{
		try 
		{
			FileCreateDir,%A_MyDocuments%\MX Bikes EasyErodeChange
			SetWorkingDir %A_MyDocuments%\MX Bikes EasyErodeChange
			
		} catch _jibberish {
			
			msgbox,,Error,Error when trying to create settings directory exiting app
			ExitApp
		} finally {
			;
		}
	}
	return
}

quicktip(text:="",time:=750){
	Tooltip,%text%
	sleep,%time%
	tooltip
}

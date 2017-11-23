#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <StaticConstants.au3>
#include <GuiComboBox.au3>
#include <String.au3>
#include <Array.au3>
#include <Timers.au3>
#include <Misc.au3>
#include <File.au3>
#include <Crypt.au3>
#include <ButtonConstants.au3>
#include <GUIListBox.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <Date.au3>
#include <ScreenCapture.au3>
#include <Color.au3>
#include <ColorConstants.au3>

#region global variables and hotkeys
Global $version = "0.01"
Global $tooltipx = 0
Global $tooltipy = 0
Global $pauseBot = 0
Global $stopBot = "True"
Global $tbcWindowTitle = "World of Warcraft"
Global $botTitle
Global $tbcProcess
Global $tbcSize[2]
$tbcSize[0] = 800
$tbcSize[1] = 600
Global $timerAFK

Global $timerUptime
Global $timerBreaktime
Global $timerTooltipWait
Global $timerTooltipWaitMin

Global $timeUptimeNow
Global $timeUptimeHour
Global $timeUptimeMinute
Global $timeUptimeSecond

Global $timeBreaktimeNow
Global $timeBreaktimeHour
Global $timeBreaktimeMinutes
Global $timeBreaktimeSecond

Global $timeInputRandSec
Global $timeInputRandSecPlus
Global $timeInputRandSecMinus

Global $timeInputRandMin
Global $timeInputRemaining
Global $timeRemainder

Global $timeBreaktimeRemainder

HotKeySet("{F2}","startBot")
HotKeySet("{F3}","closeBot")
HotKeySet("{F4}","stopBot")
HotKeySet("{F5}", "pauseBot")
HotKeySet("{F6}","resizeTBC")
mainGui()
#endregion

#region gui functions
Func mainGui()
   ;create main gui and main tab
	Global $mainGui = GUICreate("TBC_Bot " & $version, 580, 580)
    ;home tab
	$botTitle = "TBC BOT " & $version
	Global $homeTab = GUICtrlCreateTabItem("Home/Instructions")

	Local $labelHotkeys = GUICtrlCreateLabel("Hotkeys:",10,30)
	Local $labelHotkeyF1 = GUICtrlCreateLabel("F2: Start botting",10,50)
	Local $labelHotkeyF2 = GUICtrlCreateLabel("F4: Stop botting",10,65)
	Local $labelHotkeyF4 = GUICtrlCreateLabel("F3: Close bot",10,95)
	Local $labelHotkeyF5 = GUICtrlCreateLabel("F5: Pause bot",10,95)
	Local $labelHotkeyF6 = GUICtrlCreateLabel("F6: Resize TBC window",10,110)

	Local $labelImportant = GUICtrlCreateLabel("!!!!!!IMPORTANT!!!!!!111one", 10, 140)
	Local $labelTips1 = GUICtrlCreateLabel("GRAPHICS need to be set to VERY LOW and WINDOWED (bot will resize and activate window for you).",10,160)
	Local $labelTips2 = GUICtrlCreateLabel("Make sure all your characters are using the DEFAULT INTERFACE, otherwise none of this will work.",10,180)
	Local $labelTips3 = GUICtrlCreateLabel("Make sure your power options are not set to turn off hard disks/system on idle times.",10, 200)

	GUICtrlSetColor($labelImportant, 0x0038BA)
	GUICtrlSetColor($labelTips1, 0x0038BA)
	GUICtrlSetColor($labelTips2, 0x0038BA)
	GUICtrlSetColor($labelTips3, 0x0038BA)

	GUICtrlCreateGroup("", 10, 220,435, 170)

    Global $labelTimeRunning = GUICtrlCreateLabel("Uptime:", 460,380)
	Global $labelTimeHours = GUICtrlCreateLabel("00 :", 510, 380)
	Global $labelTimeMinutes = GUICtrlCreateLabel("00 :", 530, 380)
	Global $labelTimeSeconds = GUICtrlCreateLabel("00", 550, 380)
    Global $labelIdleTime = GUICtrlCreateLabel("Idle time (in ms): ", 420, 400, 200,20)
	Global $labelShowIdleTime = GUICtrlCreateLabel("0", 510, 400, 200, 20)

	Global $labelNotes = GUICtrlCreateLabel("Notes: Only tested with windows aero theme and english client. Works in Windows 8.", 10, 490)

	GUICtrlSetColor($labelNotes, 0x0038BA)
    Global $labelBotStatus = GUICtrlCreateLabel("...**--STOPPED--**...", 420, 425, 150, 20, -1, $SS_ETCHEDFRAME)
	GUICtrlSetColor($labelBotStatus, 0xff0000)
	GUICtrlSetFont($labelBotStatus, 12)
	While 1

	WEnd
EndFunc

#EndRegion

#region main functions
Func startBot()
If $stopBot = "True" Then
			$stopBot = "False"
			GUISetState(@SW_SHOW, $mainGui)
			WinMove($botTitle, "", @DesktopWidth - 590, 5)
			resizeTBC()
			waitSleep()

			doWork()
	EndIf
EndFunc

Func pauseBot()
	if $pauseBot = "False" Then
		$pauseBot = "True"
		custTooltip("Bot paused, press F5 to resume...")
	Else
		$pauseBot = "False"
	EndIf

	While ($pauseBot <> "False")
	WEnd

	custTooltip("Resuming bot...")
	waitSleep()
EndFunc

Func stopBot()
	waitSleep()
	$stopBot = "True"

EndFunc

Func closeBot()
	Exit
EndFunc

Func doWork()
   While ($stopBot = "False")

	  focusTBC()
	  custTooltip("Attempting to run tbcBot...")

	  preventAFK()
	  getTime()
	  ;start breaktime timer
	  $timerBreaktime = TimerInit()
	  ;start tooltip timer
	  $timerTooltipWait = TimerInit()
	  ;start afk timer
	  $timerAFK = TimerInit()
	  $timeInputRandSec = 2
	  $timeInputRandMin = $timeInputRandSec / 60
	  $randomIntervalTime = Random(5,12,1) * 60000
	   waitSleepLong()
	   ;conver current break time to seconds
	   $timeBreaktimeNow = Int((TimerDiff($timerBreaktime)/1000))
	   ;add range to user input in seconds
	   $timeInputRandSecMinus = $timeInputRandSec - 3
	   $timeInputRandSecPlus = $timeInputRandSec + 3
	  While 1:
	   ;conver current break time to seconds
	   $timeBreaktimeNow = Int((TimerDiff($timerBreaktime)/1000))
	   ;add range to user input in seconds
	   $timeInputRandSecMinus = $timeInputRandSec - 3
	   $timeInputRandSecPlus = $timeInputRandSec + 3
		 If $timeBreaktimeNow < $timeInputRandSecPlus  And $timeBreaktimeNow > $timeInputRandSecMinus Then
			ExitLoop
		 EndIf
		 If Int(TimerDiff($timerAFK)) > ($randomIntervalTime - 5000) And Int(TimerDiff($timerAFK)) < ($randomIntervalTime + 5000) Then
				preventAFK()
				;reinitialize timer to begin waiting again
				$timerAFK = TimerInit()
				$randomIntervalTime = Random(5,12,1) * 60000
			;if timer exceeds or is equal to 15 minutes, something went wrong, make one last attempt to prevent afk
			ElseIf Int(TimerDiff($timerAFK)) > 600000 Then
				preventAFK()
				;reinitialize timer to begin waiting again
				$timerAFK = TimerInit()
				$randomIntervalTime = Random(5,12,1) * 60000
			 EndIf
		  WEnd
   WEnd
EndFunc

Func focusTBC()
	;check if tbc is open
	If WinExists($tbcWindowTitle) Then
		custTooltip("Activating TBC window...")
		WinActivate($botTitle)
		WinActivate($tbcWindowTitle)
		waitSleep()
	Else
		custTooltip("TBC is not running, or window couldn't be found...")
		waitSleep()
		;closeProcess()
		;closeCrashError()
		;openTBC()
	EndIf
EndFunc

Func checkIfActive()

	;check if tbc is running
	If WinExists($tbcWindowTitle) Then
		If WinActive($tbcWindowTitle) Then
			;do nothing, game is running and in focus
		Else
			;game is running, but window needs to be focused
			custTooltip("Game lost focus, refocusing...")
			WinActivate($tbcWindowTitle)
			MouseMove(400,300, 1)
		EndIf
	Else
		;game is not running, open it and continue
		custTooltip("Game appears to have crashed, stopping...")
		$stopBot = "True"

		waitSleep()
	EndIf

EndFunc

Func idleCheck($icTime)

	If WinExists($tbcWindowTitle) Then
		Local $idleTime = _Timer_GetIdleTime()
		If $idleTime > $icTime Then
			custTooltip("Something went wrong, stopping...")
			waitSleep()
			stopBot()
		EndIf
	EndIf

EndFunc

Func escClose()
	Send("{ESCAPE 3}")
	waitSleep()
 EndFunc

Func clickLeft($x, $y)
	MouseMove($x, $y, 2)
	Sleep(200 + Random(0, 200))
	MouseClick("primary", $x, $y, 1, 5)
	Sleep(200 + Random(0, 200))
	Local $newx = $x + Random(0, 150)
	Local $newy = $y + Random(0, 150)
	If ($newx > 800) Then $newx = 1600 - $newx
	If ($newy > 600) Then $newy = 1200 - $newy
	MouseMove($newx, $newy, 2)
	Sleep(200 + Random(0, 200))
EndFunc

Func clickRight($x, $y)
	MouseMove($x, $y, 2)
	Sleep(100 + Random(0, 200))
	MouseClick("secondary", $x, $y, 1, 5)
	Sleep(100 + Random(0, 200))
	MouseMove($x + Random(200, 400), $y + Random(200, 300), 2)
	Sleep(100 + Random(0, 200))
EndFunc

Func clickDouble($x, $y)
	MouseMove($x, $y, 3)
	Sleep(100 + Random(0, 200))
	MouseClick("primary", $x, $y, 2)
	Local $newx = $x + Random(0, 400)
	Local $newy = $y + Random(0, 400)
	If ($newx > 800) Then $newx = 1600 - $newx
	If ($newy > 600) Then $newy = 1200 - $newy
	MouseMove($newx, $newy, 2)
	Sleep(200)
 EndFunc

Func resizeTBC()

	custTooltip("Looking for TBC window...")
	waitSleep()

	If WinActive($tbcWindowTitle) = False And WinExists($tbcWindowTitle) Then
		WinActivate($tbcWindowTitle)
		WinWaitActive($tbcWindowTitle)
		custTooltip("Resizing TBC window to 800x600...")
		WinActivate($tbcWindowTitle)
		WinWaitActive($tbcWindowTitle)
		WinMove($tbcWindowTitle,"", 0, 0, 800, 600, 3)
	ElseIf WinActive($tbcWindowTitle) = True And WinExists($tbcWindowTitle) Then
		WinActivate($tbcWindowTitle)
		WinWaitActive($tbcWindowTitle)
		custTooltip("Resizing TBC window to 800x600...")
		WinActivate($tbcWindowTitle)
		WinWaitActive($tbcWindowTitle)
		WinMove($tbcWindowTitle,"", 0, 0, 800, 600, 3)
	Else
		custTooltip("TBC doesn't appear to be running, cannot resize...")
		waitSleep()
	EndIf

EndFunc

Func waitSleep()
	Sleep(400 + Random(0,100))
EndFunc

Func waitSleepLong()
	Sleep(2000 + Random(0,100))
EndFunc

Func waitSleepLonger()
	Sleep(4000 + Random(0,100))
EndFunc

Func custTooltip($message)
	ToolTip($message, $tooltipx, $tooltipy)
 EndFunc

Func _arraysize($array)
	SetError(0)
	Local $index = 0
	Do
		Local $pop = _ArrayPop($array)
		$index = $index + 1
	Until @error = 1
	Return $index - 1
EndFunc

Func getTime()

Local $timeRound

	waitSleep()
	$timeUptimeNow = TimerDiff($timerUptime) / 1000; e.g. 4500 = 4.5 seconds, or 560000 => 560 seconds
	;round up or down
	$timeRound = $timeUptimeNow - Int($timeUptimeNow)	; e.g. 4.5 - 4 = .5, or 4.2 - 4 => .2
	If $timeRound >= .5 Then
		;round up
		$timeUptimeNow = Int($timeUptimeNow) + 1
	Else
		;round down
		$timeUptimeNow = Int($timeUptimeNow)
	EndIf

	;get hours
	If $timeUptimeNow >= 3600 Then
		$timeUptimeHour = Int($timeUptimeNow / 3600) ; e.g. 54500 / 3600 = 15.13 => 15 hours
		If $timeUptimeHour < 10 Then
			GUICtrlSetData($labelTimeHours, "0" & $timeUptimeHour & " :")
		Else
			GUICtrlSetData($labelTimeHours, $timeUptimeHour & " :")
		EndIf
	EndIf

	;get minutes
	If $timeUptimeHour >= 1 Then ; if more than or equal to 1 hour, find out remainder of time
		$timeUptimeSecond = $timeUptimeNow - ($timeUptimeHour * 3600) ; e.g. 57000 - (15 * 3600 = 54500) = 2500 seconds
		If $timeUptimeSecond >= 60 Then ; if remainder of time is more than or equal to 60 seconds
			$timeUptimeMinute = Int($timeUptimeSecond / 60) ; e.g. 2500 / 60 = 41.6 => 41 minutes
			If $timeUptimeMinute < 10 Then
				GUICtrlSetData($labelTimeMinutes, "0" & $timeUptimeMinute & " :")
			Else
				GUICtrlSetData($labelTimeMinutes, $timeUptimeMinute & " :")
			EndIf
		Else
			$timeUptimeMinute = 0
			GUICtrlSetData($labelTimeMinutes, "00:")
		EndIf
	Else ;time is less than an hour, check seconds
		$timeUptimeSecond = $timeUptimeNow ; e.g. 57000 - (15 * 3600 = 54500) = 2500 seconds
		If $timeUptimeSecond >= 60 Then ; time is more than or equal to 60 seconds
			$timeUptimeMinute = Int($timeUptimeSecond / 60) ; e.g. 2500 / 60 = 41.6 => 41 minutes
			If $timeUptimeMinute < 10 Then
				GUICtrlSetData($labelTimeMinutes, "0" & $timeUptimeMinute & " :")
			Else
				GUICtrlSetData($labelTimeMinutes, $timeUptimeMinute & " :")
			EndIf
		EndIf
	EndIf

	;get seconds
	If $timeUptimeMinute >= 1 Then
		$timeUptimeSecond = $timeUptimeNow - ($timeUptimeHour * 3600) ;subtract seconds of hours
		$timeUptimeSecond = $timeUptimeSecond - ($timeUptimeMinute * 60) ;subtract seconds of minutes
		If $timeUptimeSecond < 10 Then
			GUICtrlSetData($labelTimeSeconds, "0" & Int($timeUptimeSecond))
		Else
			GUICtrlSetData($labelTimeSeconds, Int($timeUptimeSecond))
		EndIf
	Else
		If $timeUptimeHour >= 1 Then
			$timeUptimeSecond = $timeUptimeNow - ($timeUptimeHour * 3600) ;subtract seconds of hours
			If $timeUptimeSecond < 10 Then
				GUICtrlSetData($labelTimeSeconds, "0" & Int($timeUptimeSecond))
			Else
				GUICtrlSetData($labelTimeSeconds, Int($timeUptimeSecond))
			EndIf
		Else
			$timeUptimeSecond = $timeUptimeNow
			If $timeUptimeNow < 10 Then
				GUICtrlSetData($labelTimeSeconds, "0" & Int($timeUptimeNow))
			Else
				GUICtrlSetData($labelTimeSeconds, Int($timeUptimeNow))
			EndIf
		EndIf
	EndIf

EndFunc

Func preventAFK()

	custTooltip("Preventing afk with random action...")

	Local $getRandomNumb = 0

	$getRandomNumb = Random(1,7,1)

	If $getRandomNumb = 1 Then
		;do first action
		checkIfActive()
		Send("{w down}")
		Send("{a down}")
		Send("{SPACE}")
		Sleep(200 + Random(0,100))
		Send("{w up}")
		Send("{a up}")
		Send("{SPACE}")
	ElseIf $getRandomNumb = 2 Then
		;do second action
		checkIfActive()
		Send("{SPACE}")
	ElseIf $getRandomNumb = 3 Then
		;do third action
		checkIfActive()
		Send("{w down}")
		Send("{SPACE}")
		Sleep(200 + Random(0,100))
		Send("{w up}")
		Send("{SPACE}")
	ElseIf $getRandomNumb = 4 Then
		;do fourth action
		checkIfActive()
		Send("{w down}")
		Send("{d down}")
		Sleep(200 + Random(0,100))
		Send("{w up}")
		Send("{d up}")
	ElseIf $getRandomNumb = 5 Then
		;do fifth action
		checkIfActive()
		Send("{d down}")
		Send("{SPACE}")
		Sleep(200 + Random(0,100))
		Send("{d up}")
		Send("{SPACE}")
	ElseIf $getRandomNumb = 6 Then
		;do sixth action
		checkIfActive()
		Send("q")
		Sleep(100 + Random(0,100))
		Send("e")
	ElseIf $getRandomNumb = 7 Then
		;do sixth action
		checkIfActive()
		Send("{SPACE DOWN}")
		Sleep(100 + Random(0,100))
		Send("{SPACE UP}")
	EndIf

EndFunc
#EndRegion

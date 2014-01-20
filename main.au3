#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#ConsoleWrite('@@ Debug('   & @ScriptLineNumber & ') : #Region = ' & #Region & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console
#AutoIt3Wrapper_Icon=lib\ico\icon.ico
#AutoIt3Wrapper_Compression=0
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****
$checkx64 = @AutoItX64
If $checkx64 = 1 Then
	WinSetOnTop("Diablo III", "", 0)
	MsgBox(0, "Erreur : ", "Script lancé en x64, merci de lancer en x86 ")
	Terminate()
EndIf


$icon = @ScriptDir & "\lib\ico\icon.ico"
TraySetIcon($icon)



;;--------------------------------------------------------------------------------
;;      Initialize MouseCoords
;;--------------------------------------------------------------------------------"
Opt("MouseCoordMode", 2) ;1=absolute, 0=relative, 2=client

#include "variables.au3"

CheckWindowD3()
;;--------------------------------------------------------------------------------
;;      Include some files
;;--------------------------------------------------------------------------------
#include "lib\sequence.au3"
#include "lib\settings.au3"
#include "lib\skills.au3"
#include "toolkit.au3"
#include "GDI_scene.au3"
#include <WinAPI.au3>


; Automatisation des séquences
#include <File.au3>
#include "lib\GestionMenu.au3"
#include "lib\GestionPause.au3"


;;================================================================================
;; Set Some Hotkey
;;================================================================================
HotKeySet("{F2}", "Terminate")
HotKeySet("{F3}", "TogglePause")

;;--------------------------------------------------------------------------------
;;      Initialize the offsets
;;--------------------------------------------------------------------------------
AdlibRegister("Die2Fast", 1200000)
offsetlist()
LoadingSNOExtended()
Func _dorun()
	_log("======== new run ==========")
	While Not offsetlist()
		Sleep(40)
	WEnd

	If $GameFailed = 0 Then
		$success += 1
	EndIf
	$successratio = $success / $Totalruns


	$GameFailed = 0
	$SkippedMove = 0
	$IgnoreItemList = ""

	StatsDisplay()

	If $hotkeycheck = 0 Then
		CheckHotkeys()
		Auto_spell_init()
		GestSpellInit()
		Load_Attrib_GlobalStuff()
		$maxhp = GetAttribute($_MyGuid, $Atrib_Hitpoints_Max_Total) ; dirty placement
		_log("Max HP : " & $maxhp)
		GetMaxResource($_MyGuid, $namecharacter)
		Send("t")
		Sleep(500)
		Detect_Str_full_inventory()
	EndIf

	GetAct()
	Global $shrinebanlist = ""
	EmergencyStopCheck()

	If _checkRepair() Then
		NeedRepair()
	Else
		$NeedRepairCount = 0
	EndIf

	Sleep(100)

	enoughtPotions()

	init_sequence()
	sequence()

	Global $shrinebanlist = ""
	_log("End Run" & " gamefailled: " & $GameFailed)
	Return True
EndFunc   ;==>_dorun

Func _botting()
	_log("Start Botting")
	$bottingtime = TimerInit()
	While 1
		_log("new main loop")
		offsetlist()

		If _onloginscreen() Then
			_log("LOGIN")
			_logind3()
			Sleep(Random(60000, 120000))
		EndIf

		;Lancement de la partie

		; Si Choix_Act_Run <> 0 le bot passe en mode automatique
		If $Choix_Act_Run <> 0 Then
			_gestionDesQuete()
		EndIf

		If _inmenu() And _onloginscreen() = False Then
			RandSleep()
			$DeathCountToggle = True
		EndIf

		;TCHAT
		If ($PartieSolo = 'false') Then
			Switch Random(1, 2, 1)
				Case 1
					dialTchat("Bonjour c'est partie pour un run")
				Case 2
					dialTchat("Je vous souhaite LA bienvenuE")
			EndSwitch
		EndIf
		_resumegame()

		While _onloginscreen() = False And _ingame() = False
			_log("Ingame False")
			If _checkdisconnect() Then
				$disconnectcount += 1
				_log("Disconnected dc4")
				Sleep(1000)
				_randomclick(398, 349)
				Sleep(1000)
				While Not (_onloginscreen() Or _inmenu())
					Sleep(Random(10000, 15000))
				WEnd
				ContinueLoop 2
			EndIf
			;TCHAT
			If ($PartieSolo = 'false') Then
				Switch Random(1, 2, 1)
					Case 1
						dialTchat("En avant l'aventure")
					Case 2
						dialTchat("La chasse au montres est ouverte")
				EndSwitch
			EndIf
			_resumegame()
		WEnd

		If _onloginscreen() = False And _playerdead() = False And _ingame() = True Then
			Global $timermaxgamelength = TimerInit()
			Global $GameOverTime = False
			If _dorun() = True Then
				$handle_banlist1 = ""
				$handle_banlist2 = ""
				$handle_banlistdef = ""
				$Try_ResumeGame = 0
				$Try_Logind3 = 0
				$BreakCounter += 1;on ce met a compter les games avant la pause
				$games += 1
				$gamecounter += 1
			EndIf
		EndIf


		If _onloginscreen() = False And _intown() = False And _playerdead() = False Then
			GoToTown()
		EndIf

		_log("start GoToTown from main 2")
		If _intown() Or _playerdead() And _onloginscreen() = False Then
			If _playerdead() = False And $games >= ($repairafterxxgames + Random(-2, 2, 1)) Then
				StashAndRepair()
				$games = 0
			EndIf

			If Not _checkdisconnect() Then
				_leavegame()
			Else
				_log("Disconnected dc2")
				$disconnectcount += 1
				Sleep(1000)
				_randomclick(398, 349)
				_randomclick(398, 349)
			EndIf

			If _playerdead() Then
				Sleep(Random(11000, 13000))
			EndIf
		EndIf

		Sleep(1000)
		_log('loop _inmenu() = False And _onloginscreen()')

		While _inmenu() = False And _onloginscreen() = False
			Sleep(10)
		WEnd

	WEnd
EndFunc   ;==>_botting

Func MarkPos()
	$currentloc = GetCurrentPos()
	ConsoleWrite($currentloc[0] & ", " & $currentloc[1] & ", " & $currentloc[2] & ",1,25" & @CRLF);
EndFunc   ;==>MarkPos

HotKeySet("{ù}", "MarkPos")

Func MonsterListing()
	$Object = IterateObjectList(0)
	$foundtarget = 0
	ConsoleWrite("monster listing ===========================" & @CRLF)
	For $i = 0 To UBound($Object, 1) - 1
		_ArraySort($Object, 0, 0, 0, 8)
		ConsoleWrite($Object[$i][2] & @CRLF)
		If $Object[$i][1] <> 0xFFFFFFFF And $Object[$i][7] <> -1 And $Object[$i][8] < 100 Then
			ConsoleWrite($Object[$i][2] & @CRLF)
		EndIf
	Next
EndFunc   ;==>MonsterListing

HotKeySet("{µ}", "MonsterListing")

Func Testing_IterateObjetcsList()

	Local $index, $offset, $count, $item[10]
	startIterateObjectsList($index, $offset, $count)

	While iterateObjectsList($index, $offset, $count, $item)

		For $i = 0 To UBound($item) - 1
			_log($item[$i])
		Next

		$ACD = GetACDOffsetByACDGUID($item[0])
		$CurrentIdAttrib = _memoryread($ACD + 0x120, $d3, "ptr");
		$quality = GetAttribute($CurrentIdAttrib, $Atrib_Item_Quality_Level)

		_log('quality : ' & $quality)
		_log("--------")
		_log("--------")
	WEnd
EndFunc   ;==>Testing_IterateObjetcsList



Func Testing()

	offsetlist()
	GetRepairTab()
	StashAndRepair()

EndFunc   ;==>Testing


;###########################################################################
;###########################################################################
;###########################################################################
;###########################################################################
;###########################################################################
;###########################################################################


Global $Scene_table_totale[1][10]
Global $NavCell_table_totale[1][10]
Global $Scene_table_id_scene[1]

Func Read_Scene()

	$nb_totale_scene_record = 0
	$up = False

	While 1

		$ObManStoragePtr = _MemoryRead($ofs_objectmanager, $d3, "ptr")
		$offset = $ObManStoragePtr + 0x794 + 0x178
		$sceneCountPtr = _MemoryRead($offset, $d3, "ptr") + 0x108
		$countScene = _MemoryRead($sceneCountPtr, $d3, "int")

		$sceneFirstPtr = _MemoryRead($offset, $d3, "ptr") + 0x148
		Dim $obj_scene[1][10]
		$count = 0

		;################################## ITERATION OBJ SCENE ########################################
		For $i = 0 To $countScene
			$scenePtr = _MemoryRead($sceneFirstPtr, $d3, "ptr") + $i * 0x2A8

			$temp_id_world = _MemoryRead($scenePtr + 0x008, $d3, "ptr") ;id world
			$temp_id_scene = _MemoryRead($scenePtr, $d3, "ptr") ;id world
			$correlation = True



			If $temp_id_world = $_MyACDWorld And $temp_id_scene <> 0xFFFFFFFF Then;id world

				If $nb_totale_scene_record = 0 Then
					$Scene_table_id_scene[0] = $temp_id_scene
					$nb_totale_scene_record += 1
				Else
					For $a = 0 To UBound($Scene_table_id_scene) - 1
						If $Scene_table_id_scene[$a] = $temp_id_scene Then
							$correlation = False
							ExitLoop
						EndIf
					Next
					If $correlation = True Then
						$Ucount = UBound($Scene_table_id_scene)
						ReDim $Scene_table_id_scene[$Ucount + 1]
						$Scene_table_id_scene[$Ucount] = $temp_id_scene
					EndIf
				EndIf

				If $correlation = True Then

					$nb_totale_scene_record += 1
					$count += 1
					ReDim $obj_scene[$count][10]

					$obj_scene[$count - 1][0] = $temp_id_scene ;id_scene
					$scenePtr += 0x004
					$obj_scene[$count - 1][1] = $temp_id_world ;id world
					$obj_scene[$count - 1][2] = _MemoryRead($scenePtr + 0x014, $d3, "int") ;sno_levelarea
					$obj_scene[$count - 1][3] = _MemoryRead($scenePtr + 0x0D8, $d3, "ptr") ;id_sno_scene

					$obj_scene[$count - 1][4] = _MemoryRead($scenePtr + 0x0EC, $d3, "float") ;Vec2 Meshmin x
					$obj_scene[$count - 1][5] = _MemoryRead($scenePtr + 0x0F0, $d3, "float") ;Vec2 Meshmin y
					$obj_scene[$count - 1][6] = _MemoryRead($scenePtr + 0x0F4, $d3, "float") ;Vec2 Meshmin z

					$obj_scene[$count - 1][7] = _MemoryRead($scenePtr + 0x164, $d3, "float") ;Vec2 Meshmax x
					$obj_scene[$count - 1][8] = _MemoryRead($scenePtr + 0x168, $d3, "float") ;Vec2 Meshmax y
					$obj_scene[$count - 1][9] = _MemoryRead($scenePtr + 0x16C, $d3, "float") ;Vec2 Meshmax z


					ReDim $Scene_table_totale[$nb_totale_scene_record][10]

					$Scene_table_totale[$nb_totale_scene_record - 1][0] = $obj_scene[$count - 1][0]
					$Scene_table_totale[$nb_totale_scene_record - 1][1] = $obj_scene[$count - 1][1]
					$Scene_table_totale[$nb_totale_scene_record - 1][2] = $obj_scene[$count - 1][2]
					$Scene_table_totale[$nb_totale_scene_record - 1][3] = $obj_scene[$count - 1][3]
					$Scene_table_totale[$nb_totale_scene_record - 1][4] = $obj_scene[$count - 1][4]
					$Scene_table_totale[$nb_totale_scene_record - 1][5] = $obj_scene[$count - 1][5]
					$Scene_table_totale[$nb_totale_scene_record - 1][6] = $obj_scene[$count - 1][6]
					$Scene_table_totale[$nb_totale_scene_record - 1][7] = $obj_scene[$count - 1][7]
					$Scene_table_totale[$nb_totale_scene_record - 1][8] = $obj_scene[$count - 1][8]
					$Scene_table_totale[$nb_totale_scene_record - 1][9] = $obj_scene[$count - 1][9]


				EndIf


			EndIf

		Next
		;################################################################################################


		Dim $list_sno_scene = IndexSNO(0x18EDF60, 0)


		;############################## ITERATION DU SNO ################################################
		For $i = 1 To UBound($list_sno_scene) - 1
			$correlation = False
			$current_obj_scene = 0

			For $x = 0 To UBound($obj_scene) - 1
				If $list_sno_scene[$i][1] = $obj_scene[$x][3] Then
					$correlation = True
					$current_obj_scene = $x
				EndIf
			Next

			If $correlation Then
				$NavMeshDef = $list_sno_scene[$i][0] + 0x040
				$NavZoneDef = $list_sno_scene[$i][0] + 0x280

				;############## ITERATION DES NAVCELL ################
				$CountNavCell = _memoryRead($NavZoneDef, $d3, "int")
				$NavCellPtr = _memoryRead($NavZoneDef + 0x08, $d3, "ptr")

				If $CountNavCell <> 0 Then
					Dim $Navcell_Table[$CountNavCell][9]
					Local $NavCellStruct = DllStructCreate("float;float;float;float;float;float;short;short;int")

					For $t = 0 To $CountNavCell - 1

						DllCall($d3[0], 'int', 'ReadProcessMemory', 'int', $d3[1], 'int', $NavCellPtr + ($t * 0x20), 'ptr', DllStructGetPtr($NavCellStruct), 'int', DllStructGetSize($NavCellStruct), 'int', '')

						If Mod(DllStructGetData($NavCellStruct, 7), 2) = 1 Then
							$flag = 1
						Else
							$flag = 0
						EndIf

						If UBound($NavCell_table_totale) - 1 = 0 And $up = False Then
							$up = True
						Else
							ReDim $NavCell_table_totale[UBound($NavCell_table_totale) + 1][10]
						EndIf

						$num = UBound($NavCell_table_totale) - 1
						$NavCell_Table_Totale[$num][0] = DllStructGetData($NavCellStruct, 1)
						$NavCell_Table_Totale[$num][1] = DllStructGetData($NavCellStruct, 2)
						$NavCell_Table_Totale[$num][2] = DllStructGetData($NavCellStruct, 3)
						$NavCell_Table_Totale[$num][3] = DllStructGetData($NavCellStruct, 4)
						$NavCell_Table_Totale[$num][4] = DllStructGetData($NavCellStruct, 5)
						$NavCell_Table_Totale[$num][5] = DllStructGetData($NavCellStruct, 6)
						$NavCell_Table_Totale[$num][6] = $flag
						$NavCell_Table_Totale[$num][7] = DllStructGetData($NavCellStruct, 8)
						$NavCell_Table_Totale[$num][8] = DllStructGetData($NavCellStruct, 9)
						$NavCell_Table_Totale[$num][9] = $obj_scene[$current_obj_scene][0]
					Next
				Else

					For $a = 0 To UBound($Scene_table_id_scene) - 1
						If $Scene_table_id_scene[$a] = $obj_scene[$current_obj_scene][0] Then
							_ArrayDelete($Scene_table_id_scene, $a)
							ExitLoop
						EndIf
					Next

					For $a = 0 To UBound($Scene_table_totale) - 1
						If $Scene_table_totale[$a][0] = $obj_scene[$current_obj_scene][0] Then
							_Array2DDelete($Scene_table_totale, $a)
							$nb_totale_scene_record -= 1
							ExitLoop
						EndIf
					Next

				EndIf

			EndIf
		Next

		_log("fin Iteration")
		Sleep(500)
	WEnd

EndFunc   ;==>Read_Scene


Func Drawn()
	_log("taille du tab Scene-> " & UBound($Scene_table_totale))
	_log("taille du tab NavCell-> " & UBound($NavCell_Table_Totale))
	;_ArrayDisplay($Scene_table_id_scene)
	Dim $buffMax[2] = [0, 0]
	Dim $buffMin[2] = [999999999, 99999999]
	Dim $indexMax[2] = [0, 0] ; 0 -> Index MeshMax X le plus grand | 1 -> Index MEshMax Y le plus grand
	Dim $indexMin[2] = [999999999, 99999999]

	For $i = 0 To UBound($Scene_table_totale) - 1
		If $buffMax[0] < $Scene_table_totale[$i][7] Then
			$buffMax[0] = $Scene_table_totale[$i][7]
			$indexMax[0] = $i
		EndIf

		If $buffMin[0] > $Scene_table_totale[$i][4] Then
			$buffMin[0] = $Scene_table_totale[$i][4]
			$indexMin[0] = $i
		EndIf


		If $buffMax[1] < $Scene_table_totale[$i][8] Then
			$buffMax[1] = $Scene_table_totale[$i][8]
			$indexMax[1] = $i
		EndIf

		If $buffMin[1] > $Scene_table_totale[$i][5] Then
			$buffMin[1] = $Scene_table_totale[$i][5]
			$indexMin[1] = $i
		EndIf
	Next

	Initiate_GDIpicture($Scene_table_totale[$indexMax[1]][8] - $Scene_table_totale[$indexMin[1]][5], $Scene_table_totale[$indexMax[0]][7] - $Scene_table_totale[$indexMin[0]][4])



	For $i = 0 To UBound($Scene_table_totale) - 1
		For $y = 0 To UBound($NavCell_Table_Totale) - 1

			If $Scene_table_totale[$i][0] = $NavCell_Table_Totale[$y][9] Then

				;_arraydisplay($NavCell_Table_Totale)

				$vx = ($Scene_table_totale[$i][4] - $Scene_table_totale[$indexMin[0]][4]) + $NavCell_Table_Totale[$y][0]
				$vy = ($Scene_table_totale[$i][5] - $Scene_table_totale[$indexMin[1]][5]) + $NavCell_Table_Totale[$y][1]

				;_log($i & "-" &  $y)
				;_arraydisplay($NavCell_Table_Totale)
				$tx = $NavCell_Table_Totale[$y][3] - $NavCell_Table_Totale[$y][0]
				$ty = $NavCell_Table_Totale[$y][4] - $NavCell_Table_Totale[$y][1]
				$flag = $NavCell_Table_Totale[$y][6]

				;_log($vx & " - " & $vy)
				;_log($tx & " - " & $ty)

				Draw_Nav($vy, $vx, $flag, $ty, $tx)

			EndIf
		Next

		;Draw_Nav(($Scene_table_totale[$i][5] - $Scene_table_totale[$indexMin[1]][5]), ($Scene_table_totale[$i][4] - $Scene_table_totale[$indexMin[0]][4]), 3, $Scene_table_totale[$i][8] - $Scene_table_totale[$i][5], $Scene_table_totale[$i][7] - $Scene_table_totale[$i][4])
	Next

	Save_GDIpicture()
	Load_GDIpicture()
EndFunc   ;==>Drawn

HotKeySet("{F1}", "Testing")
HotKeySet("{F4}", "Testing_IterateObjetcsList")

HotKeySet("{F6}", "Read_Scene")
HotKeySet("{F7}", "Drawn")

If $Devmode <> "true" Then
	_botting()
EndIf
While 1

WEnd

;;--------------------------------------------------------------------------------
;;     Check KeyTo avoid sell of equiped stuff
;;--------------------------------------------------------------------------------
Func CheckHotkeys()
	Sleep(2000)
	Send("i")
	Sleep(500)
	If _checkInventoryopen() = False Then
		WinSetOnTop("Diablo III", "", 0)
		MsgBox(0, "Mauvais Hotkey", "La touche pour ouvrir l'inventaire doit être i" & @CRLF)
		Terminate()
	EndIf
	Sleep(185)
	Send("{SPACE}") ; make sure we close everything
	Sleep(170)
	If _checkInventoryopen() = True Then
		WinSetOnTop("Diablo III", "", 0)
		MsgBox(0, "Mauvais Hotkey", "La touche pour fermer les fenêtres doit être ESPACE" & @CRLF)
		Terminate()
	EndIf
	ConsoleWrite("Check des touches OK" & @CRLF)
	$hotkeycheck = 1
EndFunc   ;==>CheckHotkeys


;;--------------------------------------------------------------------------------
;;     Initialise Buffs while in training Area
;;--------------------------------------------------------------------------------
Func Buffinit()
	If $delaiBuff1 Then
		AdlibRegister("buff1", $delaiBuff1 * Random(1, 1.2))

	EndIf
	If $PreBuff1 = "true" Then
		buff1()
		Sleep(400)
	EndIf
	If $delaiBuff2 Then
		AdlibRegister("buff2", $delaiBuff2 * Random(1, 1.2))

	EndIf
	If $PreBuff2 = "true" Then
		buff2()
		Sleep(400)
	EndIf
	If $delaiBuff3 Then
		AdlibRegister("buff3", $delaiBuff3 * Random(1, 1.2))

	EndIf
	If $PreBuff3 = "true" Then
		buff3()
		Sleep(400)
	EndIf
	If $delaiBuff4 Then
		AdlibRegister("buff4", $delaiBuff4 * Random(1, 1.2))

	EndIf
	If $PreBuff4 = "true" Then
		buff4()
		Sleep(400)
	EndIf
EndFunc   ;==>Buffinit



;;--------------------------------------------------------------------------------
;;     Stop All buff timers
;;--------------------------------------------------------------------------------
Func UnBuff()
	If $delaiBuff1 Then
		AdlibUnRegister("buff1")
	EndIf
	If $delaiBuff2 Then
		AdlibUnRegister("buff2")
	EndIf
	If $delaiBuff3 Then
		AdlibUnRegister("buff3")
	EndIf
	If $delaiBuff4 Then
		AdlibUnRegister("buff4")
	EndIf
EndFunc   ;==>UnBuff
Func buff1()
	Send($ToucheBuff1)
EndFunc   ;==>buff1
Func buff2()
	Send($ToucheBuff2)
EndFunc   ;==>buff2
Func buff3()
	Send($ToucheBuff3)
EndFunc   ;==>buff3
Func buff4()
	Send($ToucheBuff4)
EndFunc   ;==>buff4

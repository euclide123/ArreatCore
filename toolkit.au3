#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****
;;================================================================================
;;================================================================================
;;      Diablo 3 Au3 ToolKit
;;  Based on Unkn0wned, voxatu & the RE community works
;;
;;  By Opkllhibus, Leo11173, Kickbar
;;================================================================================
;;================================================================================
;;================================================================================
;; PRE FUNCTIONS
;;================================================================================
;;--------------------------------------------------------------------------------
;;      Make sure you are running as admin
;;--------------------------------------------------------------------------------

$_debug = 1
#RequireAdmin
$Admin = IsAdmin()
If $Admin <> 1 Then
	MsgBox(0x30, "ERROR", "This program require administrative rights you fool!")
	Exit
EndIf

;;--------------------------------------------------------------------------------
;;      Includes
;;--------------------------------------------------------------------------------
#include <Math.au3>
#include <String.au3>
#include <Array.au3>
#include "lib\memory\NomadMemory.au3" ;THIS IS EXTERNAL, GET IT AT THE AUTOIT WEBSITE
#include "lib\memory\constants.au3"

;;--------------------------------------------------------------------------------
;;      Initialize Options
;;--------------------------------------------------------------------------------

; mouse coords
Opt("MouseCoordMode", 2) ;1=absolute, 0=relative, 2=client
Opt("MouseClickDownDelay", Random(10, 20))
Opt("SendKeyDownDelay", Random(10, 20))

; windows
Opt("WinTitleMatchMode", -1)

#region openprocess
;;--------------------------------------------------------------------------------
SetPrivilege("SeDebugPrivilege", 1)
Global $ProcessID = WinGetProcess("[CLASS:D3 Main Window Class]", "")
Local $d3 = _MemoryOpen($ProcessID)
If @error Then
	WinSetOnTop("[CLASS:D3 Main Window Class]", "", 0)
	MsgBox(4096, "ERROR", "Failed to open memory for process;" & $ProcessID)
	Exit
EndIf
;;--------------------------------------------------------------------------------
#endregion openprocess

;;--------------------------------------------------------------------------------
;;	OffsetList()
;;--------------------------------------------------------------------------------
Func OffsetList()
	_Log("OffsetList")
	;//FILE DEFS
	Global $ofs_MonsterDef = 0x18EC4C0 ; 0x18CBE70 ;1.0.6 0x15DBE00 ;0x015DCE00 ;0x15DBE00
	Global $ofs_StringListDef = 0x18DD188;0x18DC188;0x18A2558 ; 0x0158C240 ;0x015E8808 ;0x015E9808
	Global $ofs_ActorDef = 0x18E73F0 ; 0x18C6AD8 ;1.0.6 0x15EC108 ;0x015ED108 ;0x15EC108
	Global $_defptr = 0x10
	Global $_defcount = 0x108
	Global $_deflink = 0x148
	Global $_ofs_FileMonster_StrucSize = 0x50
	Global $_ofs_FileActor_LinkToMonster = 0x6C
	Global $_ofs_FileMonster_MonsterType = 0x18
	Global $_ofs_FileMonster_MonsterRace = 0x1C
	Global $_ofs_FileMonster_LevelNormal = 0x44
	Global $_ofs_FileMonster_LevelNightmare = 0x48
	Global $_ofs_FileMonster_LevelHell = 0x4c
	Global $_ofs_FileMonster_LevelInferno = 0x50

	;//GET ACTORATRIB
	Global $ofs_ActorAtrib_Base = 0x0196644C ;0x1544E54 ;0x15A1EA4 ;0x015A2EA4;0x015A1EA4
	Global $ofs_ActorAtrib_ofs1 = 0x390
	Global $ofs_ActorAtrib_ofs2 = 0x2E8
	Global $ofs_ActorAtrib_ofs3 = 0x148
	Global $ofs_ActorAtrib_Count = 0x108 ; 0x0 0x0
	Global $ofs_ActorAtrib_Indexing_ofs1 = 0x10
	Global $ofs_ActorAtrib_Indexing_ofs2 = 0x8
	Global $ofs_ActorAtrib_Indexing_ofs3 = 0x250
	Global $ofs_ActorAtrib_StrucSize = 0x180
	Global $ofs_LocalPlayer_HPBARB = 0x34
	Global $ofs_LocalPlayer_HPWIZ = 0x38


	;//GET LOCAL ACTOR STRUC
	Global $ofs_LocalActor_ofs1 = 0x378 ;instead of $ofs_ActorAtrib_ofs2
	Global $ofs_LocalActor_ofs2 = 0x148
	Global $ofs_LocalActor_Count = 0x108
	Global $ofs_LocalActor_atribGUID = 0x120
	Global $ofs_LocalActor_StrucSize = 0x2D0 ; 0x0 0x0


	;//OBJECT MANAGER
	Global $ofs_objectmanager = 0x18CE394;0x018CD394 ;0x18939C4 ;0x1873414 ;0x0186FA3C ;0x1543B9C ;0x15A0BEC ;0x015A1BEC;0x15A0BEC
	Global $ofs__ObjmanagerActorOffsetA = 0x900 ;0x8C8 ;0x8b0
	Global $ofs__ObjmanagerActorCount = 0x108
	Global $ofs__ObjmanagerActorOffsetB = 0x148 ;0x148
	Global $ofs__ObjmanagerActorLinkToCTM = 0x384
	Global $_ObjmanagerStrucSize = 0x42C ;0x42C ;0x428


	;//CameraDef
	Global $VIewStatic = 0x015A0BEC
	Global $DebugFlags = $VIewStatic + 0x20
	Global $vftableSubA = _MemoryRead($VIewStatic, $d3, 'ptr')
	Global $vftableSubA = _MemoryRead($vftableSubA + 0x928, $d3, 'ptr')
	Global $ViewOffset = $vftableSubA
	Global $Ofs_CameraRotationA = $ViewOffset + 0x4
	Global $Ofs_CameraRotationB = $ViewOffset + 0x8
	Global $Ofs_CameraRotationC = $ViewOffset + 0xC
	Global $Ofs_CameraRotationD = $ViewOffset + 0x10
	Global $Ofs_CameraPosX = $ViewOffset + 0x14
	Global $Ofs_CameraPosY = $ViewOffset + 0x18
	Global $Ofs_CameraPosZ = $ViewOffset + 0x1C
	Global $Ofs_CameraFOV = $ViewOffset + 0x30
	Global $Ofs_CameraFOVB = $ViewOffset + 0x30
	Global $ofs_InteractBase = 0x18CD364 ;0x1543B84 ;0x15A0BD4 ;0x015A1BD4;0x15A0BD4
	Global $ofs__InteractOffsetA = 0xC4 ;0xA8
	Global $ofs__InteractOffsetB = 0x58
	Global $ofs__InteractOffsetUNK1 = 0x7F20 ;Set to 777c
	Global $ofs__InteractOffsetUNK2 = 0x7F44 ;Set to 1 for NPC interaction
	Global $ofs__InteractOffsetUNK3 = 0x7F7C ;Set to 7546 for NPC interaction, 7545 for loot interaction
	Global $ofs__InteractOffsetUNK4 = 0x7F80 ;Set to 7546 for NPC interaction, 7545 for loot interaction
	Global $ofs__InteractOffsetMousestate = 0x7F84 ;Mouse state 1 = clicked, 2 = mouse down
	Global $ofs__InteractOffsetGUID = 0x7F88 ;Set to the GUID of the actor you want to interact with
	$FixSpeed = 0x20 ;69736
	$ToggleMove = 0x34
	$MoveToXoffset = 0x40
	$MoveToYoffset = 0x44
	$MoveToZoffset = 0x48
	$CurrentX = 0xA8
	$CurrentY = 0xAc
	$CurrentZ = 0xb0
	$RotationOffset = 0x174
	Global $_ActorAtrib_Base = _MemoryRead($ofs_ActorAtrib_Base, $d3, 'ptr')
	Global $_ActorAtrib_1 = _MemoryRead($_ActorAtrib_Base + $ofs_ActorAtrib_ofs1, $d3, 'ptr')
	Global $_ActorAtrib_2 = _MemoryRead($_ActorAtrib_1 + $ofs_ActorAtrib_ofs2, $d3, 'ptr')
	Global $_ActorAtrib_3 = _MemoryRead($_ActorAtrib_2 + $ofs_ActorAtrib_ofs3, $d3, 'ptr')
	Global $_ActorAtrib_4 = _MemoryRead($_ActorAtrib_3, $d3, 'ptr')
	Global $_ActorAtrib_Count = $_ActorAtrib_2 + $ofs_ActorAtrib_Count
	Global $_LocalActor_1 = _MemoryRead($_ActorAtrib_1 + $ofs_LocalActor_ofs1, $d3, 'ptr')
	Global $_LocalActor_2 = _MemoryRead($_LocalActor_1 + $ofs_LocalActor_ofs2, $d3, 'ptr')
	Global $_LocalActor_3 = _MemoryRead($_LocalActor_2, $d3, 'ptr')
	Global $_LocalActor_Count = $_LocalActor_1 + $ofs_LocalActor_Count
	Global $_itrObjectManagerA = _MemoryRead($ofs_objectmanager, $d3, 'ptr')
	Global $_itrObjectManagerB = _MemoryRead($_itrObjectManagerA + $ofs__ObjmanagerActorOffsetA, $d3, 'ptr')
	Global $_itrObjectManagerCount = $_itrObjectManagerB + $ofs__ObjmanagerActorCount
	Global $_itrObjectManagerC = _MemoryRead($_itrObjectManagerB + $ofs__ObjmanagerActorOffsetB, $d3, 'ptr')
	Global $_itrObjectManagerD = _MemoryRead($_itrObjectManagerC, $d3, 'ptr')
	Global $_itrObjectManagerE = _MemoryRead($_itrObjectManagerD, $d3, 'ptr')
	Global $_itrInteractA = _MemoryRead($ofs_InteractBase, $d3, 'ptr')
	Global $_itrInteractB = _MemoryRead($_itrInteractA, $d3, 'ptr')
	Global $_itrInteractC = _MemoryRead($_itrInteractB, $d3, 'ptr')
	Global $_itrInteractD = _MemoryRead($_itrInteractC + $ofs__InteractOffsetA, $d3, 'ptr')
	Global $_itrInteractE = $_itrInteractD + $ofs__InteractOffsetB


	If LocateMyToon() Then
		Global $ClickToMoveMain = _MemoryRead($_Myoffset + $ofs__ObjmanagerActorLinkToCTM, $d3, 'ptr')
		Global $ClickToMoveRotation = $ClickToMoveMain + $RotationOffset
		Global $ClickToMoveCurX = $ClickToMoveMain + $CurrentX
		Global $ClickToMoveCurY = $ClickToMoveMain + $CurrentY
		Global $ClickToMoveCurZ = $ClickToMoveMain + $CurrentZ
		Global $ClickToMoveToX = $ClickToMoveMain + $MoveToXoffset
		Global $ClickToMoveToY = $ClickToMoveMain + $MoveToYoffset
		Global $ClickToMoveToZ = $ClickToMoveMain + $MoveToZoffset
		Global $ClickToMoveToggle = $ClickToMoveMain + $ToggleMove
		Global $ClickToMoveFix = $ClickToMoveMain + $FixSpeed
		If $_debug Then _Log("My toon located at: " & $_Myoffset & ", GUID: " & $_MyGuid & ", NAME: " & $_MyCharType & @CRLF)
		Return True
	Else
		Return False
	EndIf

EndFunc   ;==>OffsetList

;;================================================================================
;; FUNCTIONS
;;================================================================================

Func CheckWindowD3()
	If WinExists("[CLASS:D3 Main Window Class]") Then
		WinActivate("[CLASS:D3 Main Window Class]")
		WinSetOnTop("[CLASS:D3 Main Window Class]", "", 1)
		Sleep(300)
	Else
		MsgBox(0, Default, "Fenêtre Diablo III absente.")
		Terminate()
	EndIf
	Global $sized3 = WinGetClientSize("[CLASS:D3 Main Window Class]")
	If $sized3[0] <> 800 Or $sized3[1] <> 600 Then
		WinSetOnTop("[CLASS:D3 Main Window Class]", "", 0)
		MsgBox(0, Default, "Erreur Dimension : Il faut être en 800 x 600 et non pas en " & $sized3[0] & " x " & $sized3[1] & ".")
		Terminate()
	Else
		_Log("Setting Window Diablo III OK")
	EndIf
	$posd3 = WinGetPos("Diablo III")
	$DebugX = $posd3[0] + $posd3[2] + 10
	$DebugY = $posd3[1]
EndFunc   ;==>CheckWindowD3

Func CheckWindowD3Size()
	Global $sized3 = WinGetClientSize("[CLASS:D3 Main Window Class]")
	If $sized3[0] <> 800 Or $sized3[1] <> 600 Then
		WinSetOnTop("[CLASS:D3 Main Window Class]", "", 0)
		MsgBox(0, Default, "Erreur Dimension : Il faut être en 800 x 600 et non pas en " & $sized3[0] & " x " & $sized3[1] & ".")
		Terminate()

	EndIf
EndFunc   ;==>CheckWindowD3Size
;;--------------------------------------------------------------------------------
; Function:                     FindActor()
; Description:          Check if an actor is present or not
;
; Note(s):              Return 1 if found in range or 0 if absent
;;--------------------------------------------------------------------------------
Func FindActor($name, $maxRange = 400)

	If IsInGame() Then
		Local $hTimer = TimerInit()
		While Not OffsetList() And TimerDiff($hTimer) < 30000 ; 30secondes
			Sleep(10)
		WEnd
		If TimerDiff($hTimer) >= 30000 Then
			_Log("OffsetList in FindActor impossible : " & TimerDiff($hTimer) & @CRLF)
			return 0
		EndIf
	Else
		OffsetList()
	EndIf

	$hTimer = TimerInit()
	Local $index, $offset, $count, $item[10], $find = 0
	StartIterateObjectsList($index, $offset, $count)
	_Log("FindActor -> number -> " & $count)
	While IterateObjectsList($index, $offset, $count, $item)
		If StringInStr($item[1], $name) And $item[9] < $maxRange Then
			$find = 1
			_Log("Mesure FindActor Trouvé" & TimerDiff($hTimer) & @CRLF)
			Return 1
		EndIf
	WEnd

	_Log("Mesure FindActor introuvable" & TimerDiff($hTimer) & @CRLF)

	Return 0
EndFunc   ;==>FindActor

Func FastCheckUiItemVisible($valuetocheckfor, $visibility, $bucket)
	$ptr1 = _memoryread($ofs_objectmanager, $d3, "ptr")
	$ptr2 = _memoryread($ptr1 + 2420, $d3, "ptr")
	$ptr3 = _memoryread($ptr2 + 0, $d3, "ptr")
	$ofs_uielements = _memoryread($ptr3 + 8, $d3, "ptr")
	$uielementpointer = _memoryread($ofs_uielements + 4 * $bucket, $d3, "ptr")
	While $uielementpointer <> 0
		$npnt = _memoryread($uielementpointer + 528, $d3, "ptr")
		$name = BinaryToString(_memoryread($npnt + 56, $d3, "byte[256]"), 4)
		If StringInStr($name, $valuetocheckfor) Then
			If _memoryread($npnt + 40, $d3, "int") = $visibility Then
				Return True
			Else
				Return False
			EndIf
		EndIf
		$uielementpointer = _memoryread($uielementpointer, $d3, "ptr")
	WEnd
	Return False
EndFunc   ;==>FastCheckUiItemVisible

;;--------------------------------------------------------------------------------
; Function:                     FastCheckUiValue()
; Description: Get value of an UI element
;
; Note(s): Return checked UI value or return Fasle
;;--------------------------------------------------------------------------------
Func FastCheckUiValue($valuetocheckfor, $visibility, $bucket)
	$ptr1 = _memoryread($ofs_objectmanager, $d3, "ptr")
	$ptr2 = _memoryread($ptr1 + 2420, $d3, "ptr")
	$ptr3 = _memoryread($ptr2 + 0, $d3, "ptr")
	$ofs_uielements = _memoryread($ptr3 + 8, $d3, "ptr")
	$uielementpointer = _memoryread($ofs_uielements + 4 * $bucket, $d3, "ptr")
	While $uielementpointer <> 0
		$npnt = _memoryread($uielementpointer + 528, $d3, "ptr")
		$name = BinaryToString(_memoryread($npnt + 56, $d3, "byte[1024]"), 4)
		If StringInStr($name, $valuetocheckfor) Then
			If _memoryread($npnt + 40, $d3, "int") = $visibility Then
				$uitextptr = _memoryread($npnt + 0xAE0, $d3, "ptr")
				$uitext = BinaryToString(_memoryread($uitextptr, $d3, "byte[1024]"), 4)
				; _Log(@CRLF & $uitext)
				Return $uitext

			Else
				_Log($valuetocheckfor & " is invisible")
				Return False
			EndIf
		EndIf
		$uielementpointer = _memoryread($uielementpointer, $d3, "ptr")
	WEnd
	_Log($valuetocheckfor & " not found")
	Return False
EndFunc   ;==>FastCheckUiValue


Func IsPlayerDead()
	$return = FastCheckUiItemVisible($uiPlayerDead, 1, 969)
	If ($return And $DeathCountToggle) Then
		$Death += 1
		$DieTooFastCount += 1
		$DeathCountToggle = False
	EndIf
	Return $return
EndFunc   ;==>IsPlayerDead

Func IsInMenu()
	Local $uiLobby = "Menu.PlayGameButton"
	Return FastCheckUiItemVisible($uiLobby, 1, 654)
EndFunc   ;==>IsInMenu

Func IsDisconnected()
	Local $uiDisconnect = "Root.TopLayer.BattleNetModalNotifications_main.ModalNotification.Buttons.ButtonList.OkButton"
	Return FastCheckUiItemVisible($uiDisconnect, 1, 1073)
EndFunc   ;==>IsDisconnected

Func IsItemDamaged()
	Local $uiRepair = "Root.NormalLayer.DurabilityIndicator"
	Return FastCheckUiItemVisible($uiRepair, 1, 239)
EndFunc   ;==>IsItemDamaged

Func IsOnLoginScreen()
	Local $uiLogin = "Root.NormalLayer.BattleNetLogin_main.LayoutRoot"
	Return FastCheckUiItemVisible($uiLogin, 1, 174)
EndFunc   ;==>IsOnLoginScreen

Func IsEscapeMenuOpened()
	Local $uiEscapeMenu = "Root.TopLayer.gamemenu_dialog.gamemenu_bkgrnd.ButtonStackContainer.button_leaveGame"
	Return FastCheckUiItemVisible($uiEscapeMenu, 1, 1447)
EndFunc   ;==>IsEscapeMenuOpened

Func IsInGame()
	Local $uiInGame = "Root.NormalLayer.minimap_dialog_backgroundScreen.minimap_dialog_pve.area_name"
	Return FastCheckUiItemVisible($uiInGame, 1, 1403)
EndFunc   ;==>IsInGame

Func IsWaypointSelectionOpened()
	Local $uiWaypointSelection = "Root.NormalLayer.waypoints_dialog_mainPage"
	Return FastCheckUiItemVisible($uiWaypointSelection, 1, 1398)
EndFunc   ;==>IsWaypointSelectionOpened

Func IsVendorOpened()
	Local $uiVendorWindow = "Root.NormalLayer.shop_dialog_mainPage"
	Return FastCheckUiItemVisible($uiVendorWindow, 1, 1814)
EndFunc   ;==>IsVendorOpened

Func IsStashOpened()
	Local $uiStashWindow = "Root.NormalLayer.stash_dialog_mainPage"
	Return FastCheckUiItemVisible($uiStashWindow, 1, 1291)
EndFunc   ;==>IsStashOpened

Func IsInventoryOpened()
	Local $uiInventoryWindow = "Root.NormalLayer.inventory_dialog_mainPage"
	Return FastCheckUiItemVisible($uiInventoryWindow, 1, 1622)
EndFunc   ;==>IsInventoryOpened


;;--------------------------------------------------------------------------------
; Function:			TownStateCheck()
; Description:		Check if we are in town or not by comparing distance from stash
;
;;--------------------------------------------------------------------------------
Func IsInTown()
	If $_debug Then _Log("-----Checking if In Town------")
	$town = FindActor($actorStash, 448)
	If $town = 1 Then
		_Log("We are in town ")
		Return True
	Else
		_Log("We are NOT in town ")
		Return False
	EndIf
EndFunc   ;==>IsInTown
;==>TownStateCheck


Func GetLevelAreaId()
	Return _MemoryRead(_MemoryRead(0x183E9E4, $d3, "int") + 0x44, $d3, "int")
EndFunc   ;==>GetLevelAreaId

;~ unused
Func LevelAreaConstants()
	Global $A1_C6_SpiderCave_01_Entrance = 0xE3A6
	Global $A1_C6_SpiderCave_01_Main = 0x132EC
	Global $A1_C6_SpiderCave_01_Queen = 0xF506
	Global $A1_Dun_Crypt_Dev_Hell = 0x36581
	Global $A1_Fields_Cave_SwordOfJustice_Level01 = 0x1D455
	Global $A1_Fields_Den = 0x21045
	Global $A1_Fields_Den_Level02 = 0x2F6b8
	Global $A1_Fields_RandomDRLG_CaveA_Level01 = 0x141C4
	Global $A1_Fields_RandomDRLG_CaveA_Level02 = 0x141C5
	Global $A1_Fields_RandomDRLG_ScavengerDenA_Level01 = 0x13D0D
	Global $A1_Fields_RandomDRLG_ScavengerDenA_Level02 = 0x13D17
	Global $A1_Fields_Vendor_Tinker_Exterior = 0x2bC0C
	Global $A1_Highlands_RandomDRLG_GoatmanCaveA_Level01 = 0x14286
	Global $A1_Highlands_RandomDRLG_GoatmanCaveA_Level02 = 0x14287
	Global $A1_Highlands_RandomDRLG_WestTower_Level01 = 0x14196
	Global $A1_Highlands_RandomDRLG_WestTower_Level02 = 0x14197
	Global $A1_Random_Level01 = 0x33A17
	Global $A1_trDun_Blacksmith_Cellar = 0x144A6
	Global $A1_trDun_ButchersLair_02 = 0x16301
	Global $A1_trDun_Cain_Intro = 0xED2A
	Global $A1_trDun_Cave_Highlands_Random01_VendorRescue = 0x21310
	Global $A1_trdun_Cave_Nephalem_01 = 0xEBEC
	Global $A1_trdun_Cave_Nephalem_02 = 0xEBED
	Global $A1_trdun_Cave_Nephalem_03 = 0xEBEE
	Global $A1_trDun_Cave_Old_Ruins_Random01 = 0x278AC
	Global $A1_trDun_CrownRoom = 0x18FDA
	Global $A1_trDun_Crypt_Event_Tower_Of_Power = 0x138F4
	Global $A1_trDun_Crypt_Flooded_Memories_Level01 = 0x18F9c
	Global $A1_trDun_Crypt_Flooded_Memories_Level02 = 0x287A6
	Global $A1_trdun_Crypt_Special_00 = 0x25BDC
	Global $A1_trdun_Crypt_Special_01 = 0xECB9
	Global $A1_trDun_Event_JarOfSouls = 0x2371E
	Global $A1_trDun_FalseSecretPassage_01 = 0x14540
	Global $A1_trDun_FalseSecretPassage_02 = 0x14541
	Global $A1_trDun_FalseSecretPassage_03 = 0x14542
	Global $A1_trDun_Jail_Level01 = 0x171d0
	Global $A1_trDun_Jail_Level01_Cells = 0x1783D
	Global $A1_trDun_Leoric01 = 0x4D3E
	Global $A1_trDun_Leoric02 = 0x4D3F
	Global $A1_trDun_Leoric03 = 0x4D40
	Global $A1_trDun_Level01 = 0x4D44
	Global $A1_trDun_Level04 = 0x4D47
	Global $A1_trDun_Level05_Templar = 0x15763
	Global $A1_trDun_Level06 = 0x4D49
	Global $A1_trDun_Level07B = 0x4D4B
	Global $A1_trDun_Level07D = 0x4D4D
	Global $A1_trDun_Tyrael_Level09 = 0x1CAA3
	Global $A1_trDun_TyraelJail = 0x24447
	Global $A1_trOut_AdriasCellar = 0xF5F8
	Global $A1_trOUT_AdriasHut = 0x4DD9
	Global $A1_trOut_BatesFarmCellar = 0x248A5
	Global $A1_trOUT_Church = 0x4DDD
	Global $A1_trOut_Fields_Vendor_Curios = 0x1A3B7
	Global $A1_trOut_Fields_Vendor_Curios_Exterior = 0x2BE7B
	Global $A1_trOUT_FishingVillage = 0x4DDF
	Global $A1_trOUT_FishingVillageHeights = 0x1FB03
	Global $A1_trOut_ForlornFarm = 0x20B72
	Global $A1_trOUT_Graveyard = 0x4DE2
	Global $A1_trOUT_Highlands = 0x4DE4
	Global $A1_trOUT_Highlands_Bridge = 0x16DC0
	Global $A1_trOut_Highlands_DunExterior_A = 0x15718
	Global $A1_trOUT_Highlands_ServantHouse_Cellar_Vendor = 0x29CD1
	Global $A1_trOUT_Highlands_Sub240_GoatmanGraveyard = 0x1F95F
	Global $A1_trOUT_Highlands2 = 0x4DE5
	Global $A1_trOUT_Highlands3 = 0x4AF
	Global $A1_trOut_Leoric_Manor_Int = 0x189F6
	Global $A1_trOUT_LeoricsManor = 0x4DE7
	Global $A1_trOut_MysticWagon = 0x20F08
	Global $A1_trOUT_NewTristram = 0x4DEB
	Global $A1_trOUT_NewTristram_AttackArea = 0x316CE
	Global $A1_trOUT_NewTristramOverlook = 0x26186
	Global $A1_trOut_Old_Tristram = 0x163FD
	Global $A1_trOut_Old_Tristram_Road = 0x164BC
	Global $A1_trOut_Old_Tristram_Road_Cath = 0x18BE7
	Global $A1_trOut_OldTristram_Cellar = 0x1A22B
	Global $A1_trOut_OldTristram_Cellar_1 = 0x1A104
	Global $A1_trOut_OldTristram_Cellar_2 = 0x1A105
	Global $A1_trOut_OldTristram_Cellar_3 = 0x19322
	Global $A1_trOut_oldTristram_TreeCave = 0x19C87
	Global $A1_trOut_Scoundrel_Event_Old_Mill_2 = 0x35556
	Global $A1_trOut_TownAttack_ChapelCellar = 0x1D43E
	Global $A1_trOut_Tristram_CainsHouse = 0x1FC73
	Global $A1_trOut_Tristram_Inn = 0x1AB91
	Global $A1_trOut_Tristram_LeahsRoom = 0x15349
	Global $A1_trOut_TristramFields_A = 0x4DF0
	Global $A1_trOut_TristramFields_B = 0x4DF1
	Global $A1_trOut_TristramFields_ExitA = 0xF085
	Global $A1_trOut_TristramFields_Forsaken_Grounds = 0x2BD6F
	Global $A1_trOut_TristramFields_Secluded_Grove = 0x2BD6E
	Global $A1_trOut_TristramWilderness = 0x4DF2
	Global $A1_trOut_TristramWilderness_SubScenes = 0x236AA
	Global $A1_trOut_Vendor_Tinker_Room = 0x19821
	Global $A1_trOut_Wilderness_BurialGrounds = 0x11C08
	Global $A1_trOut_Wilderness_CorpseHouse = 0x30ADF
	Global $A1_trOut_Wilderness_Sub80_FamilyTree = 0x236A1
	Global $A2_Belial_Room_01 = 0xED55
	Global $A2_Belial_Room_Intro = 0x13D1A
	Global $A2_c1Dun_Swr_Caldeum_01 = 0x4D4F
	Global $A2_c2dun_Zolt_TreasureHunter = 0x4D53
	Global $A2_c3Dun_Aqd_Oasis_Level01 = 0xE069
	Global $A2_cadun_Zolt_Timed01_Level01 = 0x4D52
	Global $A2_cadun_Zolt_Timed01_Level02 = 0x29108
	Global $A2_Caldeum = 0x19234
	Global $A2_Caldeum_Uprising = 0x33613
	Global $A2_caOut_Alcarnus_RandomCellar_1 = 0x245A7
	Global $A2_caOut_Alcarnus_RandomCellar_2 = 0x245A8
	Global $A2_caOut_Alcarnus_RandomCellar_3 = 0x245A9
	Global $A2_caOUT_Boneyard_01 = 0xD24A
	Global $A2_caOUT_Borderlands_Khamsin_Mine = 0xEE8A
	Global $A2_caOUT_BorderlandsKhamsin = 0xF8B2
	Global $A2_caOut_Cellar_Alcarnus_Main = 0x2FAC4
	Global $A2_caOut_CT_RefugeeCamp = 0xD811
	Global $A2_caOut_CT_RefugeeCamp_Gates = 0x318FD
	Global $A2_caOut_CT_RefugeeCamp_Hub = 0x2917A
	Global $A2_caOut_Hub_Inn = 0x2AA00
	Global $A2_caOut_Interior_C_DogBite = 0x2D7BB
	Global $A2_caOut_Interior_H_RockWorm = 0x232F5
	Global $A2_caOut_Mine_Abandoned_Cellar = 0x4D81
	Global $A2_caOut_Oasis = 0xE051
	Global $A2_caOut_Oasis_Exit = 0x2ACE2
	Global $A2_caOut_Oasis_Exit_A = 0x2AD07
	Global $A2_caOut_Oasis_Rakanishu = 0x33BDD
	Global $A2_caOut_Oasis_RandomCellar_1 = 0x27099
	Global $A2_caOut_Oasis_RandomCellar_2 = 0x2709A
	Global $A2_caOut_Oasis_RandomCellar_3 = 0x2709B
	Global $A2_caOut_Oasis_RandomCellar_4 = 0x27bE7
	Global $A2_caOut_Oasis1_Water = 0xE664
	Global $A2_caOut_Oasis2 = 0xE058
	Global $A2_caOut_OasisCellars = 0x1B100
	Global $A2_caOUT_StingingWinds = 0x4D7F
	Global $A2_caOUT_StingingWinds_Alcarnus_Tier1 = 0x4D71
	Global $A2_caOUT_StingingWinds_Alcarnus_Tier2 = 0x4D72
	Global $A2_caOUT_StingingWinds_Bridge = 0x29886
	Global $A2_caOUT_StingingWinds_Canyon = 0x4D7C
	Global $A2_caOUT_StingingWinds_FallenCamp01 = 0x288EF
	Global $A2_caOUT_StingingWinds_PostBridge = 0x4D7E
	Global $A2_caOUT_StingingWinds_PreAlcarnus = 0x4D7B
	Global $A2_caOUT_StingingWinds_PreBridge = 0x4D7D
	Global $A2_caOut_Stranded2 = 0x1DA4A
	Global $A2_caOut_ZakarwaMerchantCellar = 0x1BEBB
	Global $A2_Cave_Random01 = 0x26F64
	Global $A2_Cave_Random01_Level02 = 0x35E85
	Global $A2_CultistCellarEast = 0x19218
	Global $A2_CultistCellarWest = 0x19214
	Global $A2_dun_Aqd_Control_A = 0xF9F3
	Global $A2_dun_Aqd_Control_B = 0xF9F4
	Global $A2_dun_Aqd_Oasis_RandomFacePuzzle_Large = 0x26B82
	Global $A2_dun_Aqd_Oasis_RandomFacePuzzle_Small = 0x26AB0
	Global $A2_dun_Aqd_Special_01 = 0xF520
	Global $A2_dun_Aqd_Special_A = 0xF53A
	Global $A2_dun_Aqd_Special_B = 0xF53C
	Global $A2_Dun_Aqd_Swr_to_Oasis_Level01 = 0x23D96
	Global $A2_dun_Cave_BloodVial_01 = 0x31F55
	Global $A2_dun_Cave_BloodVial_02 = 0x31F83
	Global $A2_dun_Oasis_Cave_MapDungeon = 0x29616
	Global $A2_dun_Oasis_Cave_MapDungeon_Level02 = 0x2F6bF
	Global $A2_dun_PortalRoulette_A = 0x1B37F
	Global $A2_Dun_Swr_Adria_Level01 = 0xE47E
	Global $A2_Dun_Swr_Caldeum_Sewers_01 = 0x1B205
	Global $A2_dun_Zolt_Blood02_Level01_Part1 = 0x1E12E
	Global $A2_dun_Zolt_Blood02_Level01_Part2 = 0x25872
	Global $A2_Dun_Zolt_BossFight_Level04 = 0xEB22
	Global $A2_dun_Zolt_Head_Random01 = 0xF0C0
	Global $A2_Dun_Zolt_Level01 = 0x4D55
	Global $A2_Dun_Zolt_Level02 = 0x4D56
	Global $A2_Dun_Zolt_Level03 = 0x4D57
	Global $A2_Dun_Zolt_Lobby = 0x4D58
	Global $A2_Dun_Zolt_LobbyCenter = 0x2AFBA
	Global $A2_Dun_Zolt_Random_Level01 = 0x4D59
	Global $A2_Dun_Zolt_Random_Level02 = 0x36571
	Global $A2_dun_Zolt_Random_PortalRoulette_02 = 0x2FDCF
	Global $A2_Dun_Zolt_ShadowRealm_Level01 = 0x13AD0
	Global $A2_Event_DyingManMine = 0x2270B
	Global $A2_Event_PriceOfMercy_Cellar = 0x2FD9E
	Global $A2_Rockworm_Cellar_Cave = 0x2FE81
	Global $A2_trDun_Boneyard_Spider_Cave_01 = 0x1B437
	Global $A2_trDun_Boneyard_Spider_Cave_02 = 0x35758
	Global $A2_trDun_Boneyard_Worm_Cave_01 = 0x1B433
	Global $A2_trDun_Boneyard_Worm_Cave_02 = 0x35759
	Global $A2_trDun_Cave_Oasis_Random01 = 0xF46F
	Global $A2_trDun_Cave_Oasis_Random01_Level02 = 0x2F6C2
	Global $A2_trDun_Cave_Oasis_Random02 = 0xF46E
	Global $A2_trDun_Cave_Oasis_Random02_Level02 = 0x27551
	Global $A2_dun_Aqd_Oasis_Level00 = 0x2F0B6
	Global $A2_dun_Aqd_Oasis_Level01 = 0x2F0B1
	Global $A3_AzmodanFight = 0x1B39C
	Global $A3_Battlefield_A = 0x1B7A4
	Global $A3_Battlefield_B = 0x1B7B5
	Global $A3_Battlefield_C = 0x1B7C4
	Global $A3_Bridge_01 = 0x10F80
	Global $A3_Bridge_Choke_A = 0x25DA8
	Global $A3_Dun_Battlefield_Gate = 0x25C14
	Global $A3_dun_Bridge_Interior_Random01 = 0x224ad
	Global $A3_dun_Bridge_Interior_Random02 = 0x32270
	Global $A3_Dun_Crater_Level_01 = 0x15040
	Global $A3_Dun_Crater_Level_02 = 0x1d209
	Global $A3_Dun_Crater_Level_03 = 0x1d20a
	Global $A3_dun_Crater_ST_Level01 = 0x13b97
	Global $A3_dun_Crater_ST_Level01B = 0x1d365
	Global $A3_dun_Crater_ST_Level02 = 0x13b98
	Global $A3_dun_Crater_ST_Level02B = 0x2200a
	Global $A3_dun_Crater_ST_Level04 = 0x14cd2
	Global $A3_dun_Crater_ST_Level04B = 0x1d368
	Global $A3_dun_IceCaves_Random_01 = 0x2e3a1
	Global $A3_dun_IceCaves_Random_01_Level_02 = 0x36206
	Global $A3_dun_IceCaves_Timed_01 = 0x2ea66
	Global $A3_dun_IceCaves_Timed_01_Level_02 = 0x36207
	Global $A3_Dun_Keep_Hub = 0x16b11
	Global $A3_Dun_Keep_Hub_Inn = 0x2d38c
	Global $A3_Dun_Keep_Level03 = 0x126ac
	Global $A3_Dun_Keep_Level04 = 0x16baf
	Global $A3_Dun_Keep_Level05 = 0x21500
	Global $A3_Dun_Keep_Random_01 = 0x2aa4a
	Global $A3_Dun_Keep_Random_01_Level_02 = 0x36238
	Global $A3_Dun_Keep_Random_02 = 0x2c7f2
	Global $A3_Dun_Keep_Random_02_Level_02 = 0x36239
	Global $A3_Dun_Keep_Random_03 = 0x2c802
	Global $A3_Dun_Keep_Random_03_Level_02 = 0x3623a
	Global $A3_Dun_Keep_Random_04 = 0x2c8e6
	Global $A3_Dun_Keep_Random_04_Level_02 = 0x36241
	Global $A3_Dun_Keep_Random_Cellar_01 = 0x35ee9
	Global $A3_Dun_Keep_Random_Cellar_02 = 0x35ee8
	Global $A3_Dun_Keep_Random_Cellar_03 = 0x303f7
	Global $A3_Dun_Keep_TheBreach_Level04 = 0x3558f
	Global $A3_dun_rmpt_Level01 = 0x16b20
	Global $A3_dun_rmpt_Level02 = 0x16bf5
	Global $A3_Gluttony_Boss = 0x1b280
	Global $A3_dun_Hub_Adria_Tower = 0x31222
	Global $A3_dun_hub_AdriaTower_Intro_01 = 0x3253e
	Global $A4_dun_Diablo_Arena = 0x1abfb
	Global $A4_dun_Diablo_Arena_Phase3 = 0x348c3
	Global $A4_dun_Garden_of_Hope_01 = 0x1abca
	Global $A4_dun_Garden_of_Hope_02 = 0x1abcc
	Global $A4_dun_Garden3_SpireEntrance = 0x1d44a
	Global $A4_dun_Heaven_1000_Monsters_Fight = 0x1aa5d
	Global $A4_dun_Heaven_1000_Monsters_Fight_Entrance = 0x2f169
	Global $A4_dun_Hell_Portal_01 = 0x1abd6
	Global $A4_dun_Hell_Portal_02 = 0x1abdb
	Global $A4_Dun_Keep_Hub = 0x301ed
	Global $A4_dun_LibraryOfFate = 0x23120
	Global $A4_dun_Spire_00 = 0x307a4
	Global $A4_dun_Spire_01 = 0x1abe2
	Global $A4_dun_Spire_02 = 0x1abe4
	Global $A4_dun_Spire_03 = 0x1abe6
	Global $A4_dun_Spire_04 = 0x33728
	Global $A4_dun_Spire_SigilRoom_A = 0x313c4
	Global $A4_dun_Spire_SigilRoom_B = 0x2ae7a
	Global $A4_dun_Spire_SigilRoom_C = 0x313c6
	Global $A4_dun_Spire_SigilRoom_D = 0x313c7
	Global $A4_dun_Diablo_ShadowRealm_01 = 0x25845
	Global $A4_dun_spire_DiabloEntrance = 0x3227a
	Global $A4_dun_spire_exterior = 0x34964
	Global $Axe_Bad_Data = 0x4d60
	Global $PvP_Maze_01 = 0x4da2
	Global $PvP_Octogon_01 = 0x4da3
	Global $PvP_Pillar_01 = 0x4da4
	Global $PvP_Stairs_01 = 0x4da5
	Global $PvP_Test_BlueTeam = 0x4da6
	Global $PvP_Test_Neutral = 0x4da7
	Global $PvP_Test_RedTeam = 0x4da8
	Global $PvPArena = 0x4d9c
EndFunc   ;==>LevelAreaConstants

;;--------------------------------------------------------------------------------
;;     Find which Act we are in
;;--------------------------------------------------------------------------------
Func GetAct()
	If $Act = 0 Then
		$arealist = FileRead("lib\memory\area.txt")
		$area = GetLevelAreaId()

		_Log(" We are in map : " & $area)
		Local $pattern = "([\w'-]{5,80})\t\W\t" & $area
		$asResult = StringRegExp($arealist, $pattern, 1)
		If @error == 0 Then
			Global $MyArea = $asResult[0]

			If StringInStr($MyArea, "a1") Then
				$Act = 1
			ElseIf StringInStr($MyArea, "a2") Then
				$Act = 2
			ElseIf StringInStr($MyArea, "a3") Then
				$Act = 3
			ElseIf StringInStr($MyArea, "a4") Then
				$Act = 4

			EndIf
			;  _Log("We are in map : " & $area &" " & $asResult[0])


			;set our vendor aaccording to the act we are in as we know it.
			Switch $Act
				Case 1
					Global $RepairVendor = "UniqueVendor_minerIsInTown"

				Case 2
					Global $RepairVendor = "UniqueVendor_PeddlerIsInTown" ; act 2 fillette

				Case 3
					Global $RepairVendor = "UniqueVendor_CollectorIsInTown" ; act 3

				Case 4
					Global $RepairVendor = "UniqueVendor_CollectorIsInTown" ; act 3

			EndSwitch
			_Log("Our Current Act is : " & $Act & " ---> So our vendor is : " & $RepairVendor)

		EndIf
	EndIf
EndFunc   ;==>GetAct

;;--------------------------------------------------------------------------------
;;     Adapt repair tab aaccording to MP act and diff
;;--------------------------------------------------------------------------------
Func GetRepairTab()
	GetMonsterPow()
	GetDifficulty()
	GetAct()

	If $MP > 0 And $GameDifficulty = 4 Then
		Switch $Act
			Case 1
				Global $RepairTab = 2
			Case 2 To 4
				Global $RepairTab = 3
		EndSwitch
	Else
		Switch $Act
			Case 1
				Global $RepairTab = 2
			Case 2 To 4
				Global $RepairTab = 3
		EndSwitch

	EndIf
	_Log("RepairTab : " & $RepairTab & " ---> MP : " & $MP & " GameDiff : " & $GameDifficulty)

EndFunc   ;==>GetRepairTab

;;--------------------------------------------------------------------------------
;;     Find MonsterPower
;;	   Get it Via UI element
;;
;;--------------------------------------------------------------------------------
Func GetMonsterPow()

	$GetMonsterPow = FastCheckUiValue('Root.NormalLayer.minimap_dialog_backgroundScreen.minimap_dialog_pve.clock', 1, 28)
	$asMpResult = StringRegExp($GetMonsterPow, '(\()([0-9]{1,2})(\))', 1)
	If @error == 0 Then
		$MP = Number($asMpResult[1])
	Else
		$MP = 0
	EndIf
	_Log("Power monster : " & $MP)
	;_Log("Power monster : " & $GetMonsterPow)
EndFunc   ;==>GetMonsterPow


;;--------------------------------------------------------------------------------
;;     Find Difficulty from vendor
;;	   Get vendor Level and deduce game difficulty from it
;;		$GameDifficulty = not yet determined, 1 = Norm, 2 = Nm, 3 = Hell, 4 = Inferno
;;--------------------------------------------------------------------------------
Func GetDifficulty()
	If $GameDifficulty = 0 Then

		Local $index, $offset, $count, $item[4]
		StartIterateLocalActor($index, $offset, $count)
		While IterateLocalActorList($index, $offset, $count, $item)
			If StringInStr($item[1], $RepairVendor) Then
				Global $npclevel = IterateActorAttributes($item[0], $Atrib_Level)

				Switch $npclevel
					Case 1 To 59
						Global $GameDifficulty = 1
					Case 60 To 70
						Global $GameDifficulty = 4
				EndSwitch

				ExitLoop
			EndIf
		WEnd
		_Log("Game Difficulty is : " & $GameDifficulty)
	EndIf
EndFunc   ;==>GetDifficulty


;;--------------------------------------------------------------------------------
;;	Getting Backpack Item Info
;;--------------------------------------------------------------------------------
Func IterateBackpack($bag = 0, $rlvl = 0)
	;$bag = 0 for backpack and 15 for stash
	;$rlvl = 1 for actual level requirement of item and 0 for base required level
	$ptr1 = _memoryread($ofs_objectmanager, $d3, "ptr")
	$ptr2 = _memoryread($ptr1 + 0x8a0, $d3, "ptr")
	$ptr3 = _memoryread($ptr2 + 0x0, $d3, "ptr")
	$_Count = _memoryread($ptr3 + 0x108, $d3, "int")
	$CurrentOffset = _memoryread(_memoryread($ptr3 + 0x148, $d3, "ptr") + 0x0, $d3, "ptr");$_LocalActor_3
	Local $__ACDACTOR[$_Count + 1][9]
	;_Log(" IterateBackpack 1 ")
	For $i = 0 To $_Count
		Local $iterateItemListStruct = DllStructCreate("ptr;char[64];byte[112];int;byte[92];int;int;int;ptr")

		DllCall($d3[0], 'int', 'ReadProcessMemory', 'int', $d3[1], 'int', $CurrentOffset, 'ptr', DllStructGetPtr($iterateItemListStruct), 'int', DllStructGetSize($iterateItemListStruct), 'int', '')


		$__ACDACTOR[$i][0] = DllStructGetData($iterateItemListStruct, 1)
		$__ACDACTOR[$i][1] = DllStructGetData($iterateItemListStruct, 2)
		$__ACDACTOR[$i][8] = DllStructGetData($iterateItemListStruct, 4)
		$__ACDACTOR[$i][2] = DllStructGetData($iterateItemListStruct, 6)
		$__ACDACTOR[$i][3] = DllStructGetData($iterateItemListStruct, 7)
		$__ACDACTOR[$i][4] = DllStructGetData($iterateItemListStruct, 8)
		$__ACDACTOR[$i][5] = 0
		$__ACDACTOR[$i][6] = DllStructGetData($iterateItemListStruct, 9)
		$__ACDACTOR[$i][7] = $CurrentOffset
		$CurrentOffset = $CurrentOffset + $ofs_LocalActor_StrucSize
		$iterateItemListStruct = ""

	Next


	For $i = $_Count To 0 Step -1
		If $__ACDACTOR[$i][2] <> $bag Then
			_ArrayDelete($__ACDACTOR, $i)
		EndIf
	Next

	;_Arraydisplay($__ACDACTOR)
	Return $__ACDACTOR

EndFunc   ;==>IterateBackpack

Func IterateStuff()
	$ptr1 = _memoryread($ofs_objectmanager, $d3, "ptr")
	$ptr2 = _memoryread($ptr1 + 0x8a0, $d3, "ptr")
	$ptr3 = _memoryread($ptr2 + 0x0, $d3, "ptr")
	$_Count = _memoryread($ptr3 + 0x108, $d3, "int")
	$count = 0
	$CurrentOffset = _memoryread(_memoryread($ptr3 + 0x148, $d3, "ptr") + 0x0, $d3, "ptr");$_LocalActor_3
	Local $__ACDACTOR[1][9]
	;_Log(" IterateBackpack 1 ")
	For $i = 0 To $_Count
		Local $iterateItemListStruct = DllStructCreate("ptr;char[64];byte[112];int;byte[92];int;int;int;ptr")
		DllCall($d3[0], 'int', 'ReadProcessMemory', 'int', $d3[1], 'int', $CurrentOffset, 'ptr', DllStructGetPtr($iterateItemListStruct), 'int', DllStructGetSize($iterateItemListStruct), 'int', '')

		If DllStructGetData($iterateItemListStruct, 6) >= 1 And DllStructGetData($iterateItemListStruct, 6) <= 13 Then
			ReDim $__ACDACTOR[$count + 1][9]
			$__ACDACTOR[$count][0] = DllStructGetData($iterateItemListStruct, 1)
			$__ACDACTOR[$count][1] = DllStructGetData($iterateItemListStruct, 2)
			$__ACDACTOR[$count][8] = DllStructGetData($iterateItemListStruct, 4)
			$__ACDACTOR[$count][2] = DllStructGetData($iterateItemListStruct, 6)
			$__ACDACTOR[$count][3] = DllStructGetData($iterateItemListStruct, 7)
			$__ACDACTOR[$count][4] = DllStructGetData($iterateItemListStruct, 8)
			$__ACDACTOR[$count][5] = 0
			$__ACDACTOR[$count][6] = DllStructGetData($iterateItemListStruct, 9)
			$__ACDACTOR[$count][7] = $CurrentOffset
			$count += 1
		EndIf

		$CurrentOffset = $CurrentOffset + $ofs_LocalActor_StrucSize
		$iterateItemListStruct = ""

	Next

	Return $__ACDACTOR
EndFunc   ;==>IterateStuff

Func LoadAttributeGlobalStuff()

	Global $Check_HandLeft_Seed = 0
	Global $Check_HandRight_Seed = 0
	Global $Check_RingLeft_Seed = 0
	Global $Check_RingRight_Seed = 0
	Global $Check_Amulet_Seed = 0
	Global $Check_ArmorTotal = 0

	$table = IterateStuff()
	For $i = 0 To UBound($table) - 1
		If ($table[$i][2] >= 3 And $table[$i][2] <= 4) Or $table[$i][2] >= 11 Then
			If $table[$i][2] = 3 Then ;Weapon1
				$Check_HandLeft_Seed = GetAttribute(_memoryread(GetACDOffsetByACDGUID($table[$i][0]) + 0x120, $d3, "ptr"), $Atrib_Seed)
			ElseIf $table[$i][2] = 4 Then ;Weapon2
				$Check_HandRight_Seed = GetAttribute(_memoryread(GetACDOffsetByACDGUID($table[$i][0]) + 0x120, $d3, "ptr"), $Atrib_Seed)
			ElseIf $table[$i][2] = 11 Then ;Ring1
				$Check_RingLeft_Seed = GetAttribute(_memoryread(GetACDOffsetByACDGUID($table[$i][0]) + 0x120, $d3, "ptr"), $Atrib_Seed)
			ElseIf $table[$i][2] = 12 Then ;Ring
				$Check_RingRight_Seed = GetAttribute(_memoryread(GetACDOffsetByACDGUID($table[$i][0]) + 0x120, $d3, "ptr"), $Atrib_Seed)
			ElseIf $table[$i][2] = 13 Then ;Amulette
				$Check_Amulet_Seed = GetAttribute(_memoryread(GetACDOffsetByACDGUID($table[$i][0]) + 0x120, $d3, "ptr"), $Atrib_Seed)
			EndIf
		EndIf
	Next
	$Check_ArmorTotal = GetAttribute($_myguid, $Atrib_Armor_Item_Total)

	_Log("LoadAttributeGlobalStuff() Result :")
	_Log("$Check_HandLeft_Seed -> " & $Check_HandLeft_Seed)
	_Log("$Check_HandRight_Seed -> " & $Check_HandRight_Seed)
	_Log("$Check_RingLeft_Seed -> " & $Check_RingLeft_Seed)
	_Log("$Check_RingRight_Seed -> " & $Check_RingRight_Seed)
	_Log("$Check_Amulet_Seed -> " & $Check_Amulet_Seed)
	_Log("$Check_ArmorTotal -> " & $Check_ArmorTotal)

EndFunc   ;==>LoadAttributeGlobalStuff

Func VerifAttributeGlobalStuff()

	If Trim(StringLower($InventoryCheck)) = "true" Then

		Local $HandLeft_Seed = 0
		Local $HandRight_Seed = 0
		Local $RingLeft_Seed = 0
		Local $RingRight_Seed = 0
		Local $Amulet_Seed = 0
		Local $ArmorTotal = 0

		$table = IterateStuff()
		For $i = 0 To UBound($table) - 1
			If ($table[$i][2] >= 3 And $table[$i][2] <= 4) Or $table[$i][2] >= 11 Then
				If $table[$i][2] = 3 Then ;Weapon1
					$HandLeft_Seed = GetAttribute(_memoryread(GetACDOffsetByACDGUID($table[$i][0]) + 0x120, $d3, "ptr"), $Atrib_Seed)
				ElseIf $table[$i][2] = 4 Then ;Weapon2
					$HandRight_Seed = GetAttribute(_memoryread(GetACDOffsetByACDGUID($table[$i][0]) + 0x120, $d3, "ptr"), $Atrib_Seed)
				ElseIf $table[$i][2] = 11 Then ;Ring1
					$RingLeft_Seed = GetAttribute(_memoryread(GetACDOffsetByACDGUID($table[$i][0]) + 0x120, $d3, "ptr"), $Atrib_Seed)
				ElseIf $table[$i][2] = 12 Then ;Ring
					$RingRight_Seed = GetAttribute(_memoryread(GetACDOffsetByACDGUID($table[$i][0]) + 0x120, $d3, "ptr"), $Atrib_Seed)
				ElseIf $table[$i][2] = 13 Then ;Amulette
					$Amulet_Seed = GetAttribute(_memoryread(GetACDOffsetByACDGUID($table[$i][0]) + 0x120, $d3, "ptr"), $Atrib_Seed)
				EndIf
			EndIf
		Next
		$ArmorTotal = GetAttribute($_myguid, $Atrib_Armor_Item_Total)

		If $HandLeft_Seed <> $Check_HandLeft_Seed Then
			If $HandLeft_Seed = 0 And $Check_HandLeft_Seed <> 0 Then
				_Log("-> Weapon Left Dropped")
			Else
				_Log("-> Weapon Left switched")
			EndIf
			Return False
		ElseIf $HandRight_Seed <> $Check_HandRight_Seed Then
			If $HandRight_Seed = 0 And $Check_HandRight_Seed <> 0 Then
				_Log("-> Weapon Right Dropped")
			Else
				_Log("-> Weapon Right switched")
			EndIf
			Return False
		ElseIf $RingLeft_Seed <> $Check_RingLeft_Seed Then
			If $RingLeft_Seed = 0 And $Check_RingLeft_Seed <> 0 Then
				_Log("-> Ring Left Dropped")
			Else
				_Log("-> Ring Left switched")
			EndIf
			Return False
		ElseIf $RingRight_Seed <> $Check_RingRight_Seed Then
			If $RingRight_Seed = 0 And $Check_RingRight_Seed <> 0 Then
				_Log("-> Ring Right Dropped")
			Else
				_Log("-> Ring Right switched")
			EndIf
			Return False
		ElseIf $ArmorTotal <> $Check_ArmorTotal Then
			_Log("-> Armor Total changed")
			Return False
		EndIf

		_Log("Checking stuff successful")
		Return True

	Else
		_Log("Checking stuff Disable")
		Return True
	EndIf
EndFunc   ;==>VerifAttributeGlobalStuff

Func AntiIdle()
	Global $CheckTakeShrinebanlist = 0
	$warnloc = GetCurrentPos()
	$warnarea = GetLevelAreaId()
	_Log("Lost detected at : " & $warnloc[0] & ", " & $warnloc[1] & ", " & $warnloc[2], 1);
	_Log("Lost area : " & $warnarea, 1);


	If IsInventoryOpened() = False Then
		Send("i")
		Sleep(150)
	EndIf

	Send("{PRINTSCREEN}")
	Sleep(150)
	Send("{SPACE}")

	ToolTip("Detection de stuff modifié !" & @CRLF & "Zone : " & $warnarea & @CRLF & "Position : " & $warnloc[0] & ", " & $warnloc[1] & ", " & $warnloc[2] & @CRLF & "Un screenshot a été pris, il se situe dans document/diablo 3", 15, 15)


	While Not IsInTown() And IsInGame()
		UseTownPortal()
		Sleep(100)
	WEnd

	;idleing
	While 1
		MouseClick("middle", Random(100, 200), Random(100, 200), 1, 6)
		Sleep(Random(40000, 180000))
		MouseClick("middle", Random(600, 700), Random(100, 200), 1, 6)
		Sleep(Random(40000, 180000))
		MouseClick("middle", Random(600, 700), Random(400, 500), 1, 6)
		Sleep(Random(40000, 180000))
		MouseClick("middle", Random(100, 200), Random(400, 500), 1, 6)
		Sleep(Random(40000, 180000))
	WEnd

EndFunc   ;==>AntiIdle

;;--------------------------------------------------------------------------------
;;	Gets levels from Gamebalance file, returns a list with snoid and lvl
;;--------------------------------------------------------------------------------
Func GetLevels($offset)
	If $offset <> 0 Then
		$ofs = $offset + 0x218;
		$read = _MemoryRead($ofs, $d3, 'int')
		While $read = 0
			$ofs += 0x4
			$read = _MemoryRead($ofs, $d3, 'int')
		WEnd
		$size = _MemoryRead($ofs + 0x4, $d3, 'int')
		$size -= 0x5F8
		$ofs = $offset + _MemoryRead($ofs, $d3, 'int')
		$nr = $size / 0x5F8
		Local $snoItems[$nr + 1][10]
		$j = 0
		For $i = 0 To $size Step 0x5F8
			$ofs_address = $ofs + $i
			$snoItems[$j][0] = _MemoryRead($ofs_address, $d3, 'ptr')
			$snoItems[$j][1] = _MemoryRead($ofs_address + 0x114, $d3, 'int') ;lvl
			$snoItems[$j][2] = _MemoryRead($ofs_address + 0x1C8, $d3, 'float') ;min dmg
			$snoItems[$j][3] = $snoItems[$j][2] + _MemoryRead($ofs_address + 0x1CC, $d3, 'float') ;max dmg
			$snoItems[$j][4] = _MemoryRead($ofs_address + 0x224, $d3, 'float') ;min armor
			$snoItems[$j][5] = $snoItems[$j][4] + _MemoryRead($ofs_address + 0x228, $d3, 'float') ;max armor
			$snoItems[$j][6] = _MemoryRead($ofs_address + 0x32C, $d3, 'float') ;min dmg modifier
			$snoItems[$j][7] = $snoItems[$j][4] + _MemoryRead($ofs_address + 0x330, $d3, 'float') ;max dmg modifier
			$snoItems[$j][8] = _MemoryRead($ofs_address + 0x12C, $d3, 'int') ;gold price
			$snoItems[$j][9] = _MemoryRead($ofs_address + 0x2D4, $d3, 'float') ;wpn speed
			$j += 1
		Next
	EndIf
	Return $snoItems
EndFunc   ;==>GetLevels

Func SortBackPack($avArray)

	Dim $tab0[1][8]
	Dim $tab1[1][8]
	Dim $tab2[1][8]
	Dim $tab3[1][8]
	Dim $tab4[1][8]
	Dim $tab5[1][8]

	Dim $tab_final[1][8]

	Local $compt5 = 0, $compt4 = 0, $compt3 = 0, $compt2 = 0, $compt1 = 0, $compt0 = 0, $compt_total = 0

	_ArraySort($avArray, 0, 0, 0, 4)


	For $i = 0 To UBound($avArray) - 1

		If $avArray[$i][4] = 0 Then
			$compt0 += 1
			ReDim $tab0[$compt0][8]
			For $y = 0 To 7
				$tab0[$compt0 - 1][$y] = $avArray[$i][$y]
			Next
		ElseIf $avArray[$i][4] = 1 Then
			$compt1 += 1
			ReDim $tab1[$compt1][8]
			For $y = 0 To 7
				$tab1[$compt1 - 1][$y] = $avArray[$i][$y]
			Next
		ElseIf $avArray[$i][4] = 2 Then
			$compt2 += 1
			ReDim $tab2[$compt2][8]
			For $y = 0 To 7
				$tab2[$compt2 - 1][$y] = $avArray[$i][$y]
			Next
		ElseIf $avArray[$i][4] = 3 Then
			$compt3 += 1
			ReDim $tab3[$compt3][8]
			For $y = 0 To 7
				$tab3[$compt3 - 1][$y] = $avArray[$i][$y]
			Next
		ElseIf $avArray[$i][4] = 4 Then
			$compt4 += 1
			ReDim $tab4[$compt4][8]
			For $y = 0 To 7
				$tab4[$compt4 - 1][$y] = $avArray[$i][$y]
			Next
		ElseIf $avArray[$i][4] = 5 Then
			$compt5 += 1
			ReDim $tab5[$compt5][8]
			For $y = 0 To 7
				$tab5[$compt5 - 1][$y] = $avArray[$i][$y]
			Next
		EndIf
	Next

	_ArraySort($tab0, 0, 0, 0, 3)
	_ArraySort($tab1, 0, 0, 0, 3)
	_ArraySort($tab2, 0, 0, 0, 3)
	_ArraySort($tab3, 0, 0, 0, 3)
	_ArraySort($tab4, 0, 0, 0, 3)
	_ArraySort($tab5, 0, 0, 0, 3)

	For $i = 0 To UBound($tab0) - 1

		If $tab0[$i][0] <> "" Then
			$compt_total += 1
			ReDim $tab_final[$compt_total][8]
			For $y = 0 To 7
				$tab_final[$compt_total - 1][$y] = $tab0[$i][$y]
			Next
		EndIf
	Next

	For $i = 0 To UBound($tab1) - 1

		If $tab1[$i][0] <> "" Then
			$compt_total += 1
			ReDim $tab_final[$compt_total][8]
			For $y = 0 To 7
				$tab_final[$compt_total - 1][$y] = $tab1[$i][$y]
			Next
		EndIf
	Next

	For $i = 0 To UBound($tab2) - 1

		If $tab2[$i][0] <> "" Then
			$compt_total += 1
			ReDim $tab_final[$compt_total][8]
			For $y = 0 To 7
				$tab_final[$compt_total - 1][$y] = $tab2[$i][$y]
			Next
		EndIf
	Next

	For $i = 0 To UBound($tab3) - 1

		If $tab3[$i][0] <> "" Then
			$compt_total += 1
			ReDim $tab_final[$compt_total][8]
			For $y = 0 To 7
				$tab_final[$compt_total - 1][$y] = $tab3[$i][$y]
			Next
		EndIf
	Next

	For $i = 0 To UBound($tab4) - 1

		If $tab4[$i][0] <> "" Then
			$compt_total += 1
			ReDim $tab_final[$compt_total][8]
			For $y = 0 To 7
				$tab_final[$compt_total - 1][$y] = $tab4[$i][$y]
			Next
		EndIf
	Next

	For $i = 0 To UBound($tab5) - 1

		If $tab5[$i][0] <> "" Then
			$compt_total += 1
			ReDim $tab_final[$compt_total][8]
			For $y = 0 To 7
				$tab_final[$compt_total - 1][$y] = $tab5[$i][$y]
			Next
		EndIf
	Next

	Return $tab_final
EndFunc   ;==>SortBackPack

Func FilterBackpack()

	$Uni_manuel = False
	Local $__ACDACTOR = SortBackPack(IterateBackpack(0))
	Local $iMax = UBound($__ACDACTOR)

	If $iMax > 0 Then

		Local $return[$iMax][4]

		Send("{SPACE}") ; make sure we close everything
		Send("i") ; open the inventory
		Sleep(100)

		CheckWindowD3Size()
		CheckBackpackSize()

		UseBookOfCain()

		For $i = 0 To $iMax - 1 ;c'est ici que l'on parcour (tours a tours) l'ensemble des items contenut dans notres bag

			$ACD = GetACDOffsetByACDGUID($__ACDACTOR[$i][0])
			$CurrentIdAttrib = _memoryread($ACD + 0x120, $d3, "ptr")
			$quality = GetAttribute($CurrentIdAttrib, $Atrib_Item_Quality_Level) ;on definit la quality de l'item traiter ici
			If ($quality = 9) Then
				;Tchat
				If ($PartieSolo = 'false') Then
					Switch Random(1, 2, 1)
						Case 1
							WriteInChat("Et encore un souffre dans le coffre")
						Case 2
							WriteInChat("YES j'ai trouvé un legendaire")
					EndSwitch
				EndIf
				$nbLegs += 1 ; on definit les legendaire et on compte les legs id au coffre
			ElseIf ($quality = 6) Then
				$nbRares += 0 ; on definit les rares
			EndIf

			$itemDestination = CheckItem($__ACDACTOR[$i][0], $__ACDACTOR[$i][1], 1) ;on recupere ici ce que l'on doit faire de l'objet (stash/inventaire/trash)

			$return[$i][0] = $__ACDACTOR[$i][3] ;definit la collone de l'item
			$return[$i][1] = $__ACDACTOR[$i][4] ;definit la ligne de l'item
			$return[$i][3] = $quality

			;;;       If $itemDestination = "Stash_Filtre" And trim(StringLower($Unidentified)) = "false" Then ;Si c'est un item à filtrer et que l'on a definit Unidentified sur false (il faudra juste changer le nom de la variable Unidentifier)
			If $itemDestination = "Stash_Filtre" Then ;Si c'est un item à filtrer
				If CheckFilterFromTable($GrabListTab, $__ACDACTOR[$i][1], $CurrentIdAttrib) Then ;on lance le filtre sur l'item
					_Log('valide', 1)
					_Log(' - ', 1)
					$return[$i][2] = "Stash"
					$nbRares += 1 ; on conte les rares id qu'on met au coffre
				Else
					$return[$i][2] = "Trash"
					_Log('invalide', 1)
					_Log(' - ', 1)
				EndIf

			Else
				$return[$i][2] = $itemDestination ;row
			EndIf

		Next
		;debut Recyclage Item
		If $Recycle = "true" Then
			For $i = 0 To UBound($return) - 1
				If $return[$i][2] = "Trash" And $return[$i][3] > 2 And $return[$i][3] < $QualityRecycle Then ; si trash + qualité >2, soit les bleus et jaunes, mettre 5 pour ne recycler que les jaunes.
					;Recyle les bleus et vend les jaunes >2 <6
					$return[$i][2] = "Recycle"
				EndIf
			Next
		EndIf
		; Fin Recyclage Item

		Send("{SPACE}") ; make sure we close everything

		Return $return
	EndIf
	Return False
EndFunc   ;==>FilterBackpack

Func FilterBackpack2()

	$Uni_manuel = False
	Local $__ACDACTOR = SortBackPack(IterateBackpack(0))
	Local $iMax = UBound($__ACDACTOR)

	If $iMax > 0 Then

		Local $return[$iMax][4]

		Send("{SPACE}") ; make sure we close everything
		Send("i") ; open the inventory
		Sleep(100)

		CheckWindowD3Size()
		CheckBackpackSize()

		MoveToPointZero()

		If $Unidentified = "false" And $Identified = "false" Then
			UseBookOfCain()
			Sleep(Random(100, 200))
			Send("{SPACE}")
			Sleep(Random(100, 200))
		EndIf

		For $i = 0 To $iMax - 1 ;c'est ici que l'on parcour (tours a tours) l'ensemble des items contenut dans notres bag

			$ACD = GetACDOffsetByACDGUID($__ACDACTOR[$i][0])
			$CurrentIdAttrib = _memoryread($ACD + 0x120, $d3, "ptr")
			$quality = GetAttribute($CurrentIdAttrib, $Atrib_Item_Quality_Level) ;on definit la quality de l'item traiter ici
			If ($quality = 9) Then
				$nbLegs += 1 ; on definit les legendaire et on compte les legs unid au coffre
			ElseIf ($quality = 6) Then
				$nbRaresUnid += 0 ; on definit les rares
			EndIf

			$itemDestination = CheckItem($__ACDACTOR[$i][0], $__ACDACTOR[$i][1], 1) ;on recupere ici ce que l'on doit faire de l'objet (stash/inventaire/trash)

			$return[$i][0] = $__ACDACTOR[$i][3] ;definit la collone de l'item
			$return[$i][1] = $__ACDACTOR[$i][4] ;definit la ligne de l'item
			$return[$i][3] = $quality

			If $Unidentified = "false" And $Identified = "false" Then ;ajouter pour ne rien filtrer
				If $itemDestination = "Stash_Filtre" Then ;on traite la qualité
					If ($quality < 9) Then;si la qualité est plus petite que 9 on jette
						$return[$i][2] = "Trash"
						_Log('invalide', 1)
						_Log(' - ', 1)
					EndIf

				Else
					$return[$i][2] = $itemDestination ;row
				EndIf

			EndIf


			If $Unidentified = "true" Then
				If $itemDestination = "Stash_Filtre" Then ;Si c'est un item à filtrer
					If CheckFilterFromTable($GrabListTab, $__ACDACTOR[$i][1], $CurrentIdAttrib) Then ;on lance le filtre sur l'item
						_Log('valide', 1)
						_Log(' - ', 1)
						$return[$i][2] = "Stash"
						$nbRaresUnid += 1 ; on conte les rare unid quon met au coffre
					Else
						$return[$i][2] = "Trash"
						_Log('invalide', 1)
						_Log(' - ', 1)
					EndIf

				Else
					$return[$i][2] = $itemDestination ;row
				EndIf

			EndIf

		Next

		; Recyclage Item
		If $Recycle = "true" And $Identified = "false" Then
			For $i = 0 To UBound($return) - 1
				If $return[$i][2] = "Trash" And $return[$i][3] > 2 And $return[$i][3] < $QualityRecycle Then ; si trash + qualité >2, soit les bleus et jaunes, mettre 5 pour ne recycler que les jaunes.
					$return[$i][2] = "Recycle"
				EndIf
			Next
		EndIf
		; Fin Recyclage Item

		Send("{SPACE}") ; make sure we close everything

		Return $return
	EndIf
	Return False
EndFunc   ;==>FilterBackpack2

Func FilterToAttribute($CurrentIdAttrib, $filter2read)
	If StringInStr($filter2read, "DPS") Then
		;_Log("Handling special attrib : "& $filter2read)
		$result = GetAttribute($CurrentIdAttrib, $Atrib_Damage_Weapon_Average_Total_All) * GetAttribute($CurrentIdAttrib, $Atrib_Attacks_Per_Second_Item_Total)
		;_Log("the value you search is : "& $result)
		Return $result
	Else
		;_Log("will find : "& $filter2read)
		$currattrib = Eval($filter2read)
		If IsArray($currattrib) Then
			$result = Round((GetAttribute($CurrentIdAttrib, $currattrib[0])) * $currattrib[1], 2)
			; _Log("the value you search is : "& $result)
			Return $result
		Else
			Return 0
		EndIf
	EndIf
EndFunc   ;==>FilterToAttribute


;;================================================================================
; Function:                     LocateMyToon
; Note(s):                      This function is used by the OffsetList to
;                                               get the current player data.
;==================================================================================
Func LocateMyToon()
	$count_locatemytoon = 0
	$idarea = 0
	If IsInGame() Then

		While $count_locatemytoon <= 1000

			$idarea = GetLevelAreaId()

			If $idarea <> -1 Then
				If $_debug Then _Log("Looking for local player")
				$_Myoffset = "0x" & Hex(GetPlayerOffset(), 8) ; pour convertir valeur
				$_MyGuid = _MemoryRead($_Myoffset + 0x4, $d3, 'ptr')
				$_NAME = _MemoryRead($_Myoffset + 0x8, $d3, 'char[64]')
				$_SNO = _MemoryRead($_Myoffset + 0x88, $d3, 'ptr')
				SetCharacter($_NAME)


				$ACD = GetACDOffsetByACDGUID($_MyGuid)
				$name_by_acd = _MemoryRead($ACD + 0x4, $d3, 'char[64]')

				$_MyGuid = _memoryread($ACD + 0x120, $d3, "ptr")
				$_MyACDWorld = _memoryread($ACD + 0x108, $d3, "ptr")

				If Not trim($_NAME) = "" Then
					If trim($_NAME) = trim($name_by_acd) Then
						$_MyCharType = $_NAME

						If $hotkeycheck = 1 Then
							If VerifAttributeGlobalStuff() Then
								Return True
							Else
								_Log("CHANGEMENT DE STUFF ON TOURNE EN ROND (locatemytoon)!!!!!")
								AntiIdle()
							EndIf
						Else
							Return True
						EndIf
					Else
						;_Log("Fail LocateMyToon, $_NAME <> $name_by_acd -> " & $count_locatemytoon)
						$count_locatemytoon += 1
					EndIf
				Else
					;_Log("Fail LocateMyToon, Empty $_NAME  -> " & $count_locatemytoon)
					$count_locatemytoon += 1
				EndIf

			Else
				;_Log("Fail LocateMyToon, Fail AreaId -> " & $idarea)
				$count_locatemytoon += 1
			EndIf

			Sleep(50)


		WEnd




	EndIf
	Return False
EndFunc   ;==>LocateMyToon

;;================================================================================
; Function:			IterateLocalActor
; Note(s):			Iterates through all the local actors.
;						Used by IterateActorAttributes
;					This is bad use of variables, should be fixed!
;==================================================================================
Func IterateLocalActor()
	$ptr1 = _memoryread($ofs_objectmanager, $d3, "ptr")
	$ptr2 = _memoryread($ptr1 + 0x8a0, $d3, "ptr")
	$ptr3 = _memoryread($ptr2 + 0x0, $d3, "ptr")
	$_Count = _memoryread($ptr3 + 0x108, $d3, "int")
	$CurrentOffset = _memoryread(_memoryread($ptr3 + 0x148, $d3, "ptr") + 0x0, $d3, "ptr");$_LocalActor_3
	Global $__ACTOR[$_Count + 1][4]
	For $i = 0 To $_Count
		$__ACTOR[$i][1] = _MemoryRead($CurrentOffset, $d3, 'ptr')
		$__ACTOR[$i][2] = _MemoryRead($CurrentOffset + 0x4, $d3, 'char[64]')
		$__ACTOR[$i][3] = _MemoryRead($CurrentOffset + $ofs_LocalActor_atribGUID, $d3, 'ptr')
		;_Log($__ACTOR[$i][1] & " : " & $__ACTOR[$i][2] & " : " & $__ACTOR[$i][3])
		$CurrentOffset = $CurrentOffset + $ofs_LocalActor_StrucSize
	Next
EndFunc   ;==>IterateLocalActor

Func StartIterateLocalActor(ByRef $index, ByRef $offset, ByRef $count)
	$ptr1 = _memoryread($ofs_objectmanager, $d3, "ptr")
	$ptr2 = _memoryread($ptr1 + 0x8a0, $d3, "ptr")
	$ptr3 = _memoryread($ptr2 + 0x0, $d3, "ptr")
	$count = _memoryread($ptr3 + 0x108, $d3, "int")
	$index = 0
	$offset = _memoryread(_memoryread($ptr3 + 0x148, $d3, "ptr") + 0x0, $d3, "ptr")
EndFunc   ;==>StartIterateLocalActor

Func IterateLocalActorList(ByRef $index, ByRef $offset, ByRef $count, ByRef $item)
	Local $IterateLocalActorListStruct = DllStructCreate("ptr;char[64];byte[" & Int($ofs_LocalActor_atribGUID) - 68 & "];ptr")
	If $index > $count Then Return False
	$index += 1
	DllCall($d3[0], 'int', 'ReadProcessMemory', 'int', $d3[1], 'int', $offset, 'ptr', DllStructGetPtr($IterateLocalActorListStruct), 'int', DllStructGetSize($IterateLocalActorListStruct), 'int', '')
	$item[0] = DllStructGetData($IterateLocalActorListStruct, 1)
	$item[1] = DllStructGetData($IterateLocalActorListStruct, 2)
	$item[2] = DllStructGetData($IterateLocalActorListStruct, 4)

	$item[3] = $offset ; Item Offset
	;_Log('kick: ' &$item[0] & " : " & $item[1] & " : " & $item[2] & " : " & $item[3])
	$offset = $offset + $ofs_LocalActor_StrucSize
	Return True
EndFunc   ;==>IterateLocalActorList

;;================================================================================
; Function:			IterateActorAttributes($_GUID,$_REQ)
; Description:		Read the requested attribute data from a actor defined by GUID
; Parameter(s):		$_GUID - The GUID of the object you want the data from
;					$_REQ - The data you want to request (the variable)
;
; Note(s):			You can find a list of all the $_REQ variables in the Constants() function
;					It should be noted that i have not checked them all through
;						so the type ("float" or "int") might be wrong.
;					This function will always return "false" if the requested atribute does not exsist
;==================================================================================
Func IterateActorAttributes($_GUID, $_REQ)
	Local $index, $offset, $count, $item[4]
	StartIterateLocalActor($index, $offset, $count)
	While IterateLocalActorList($index, $offset, $count, $item)
		If $item[0] = "0x" & Hex($_GUID) Then
			If $_REQ[1] = 'float' Then
				Return GetAttributeFloat($item[2], $_REQ[0])
			Else
				Return GetAttributeInt($item[2], $_REQ[0])
			EndIf
			ExitLoop
		EndIf
	WEnd
	Return False


EndFunc   ;==>IterateActorAttributes

;;================================================================================
; Function:			IndexSNO($_offset[,$_displayInfo = 0])
; Description:		Read and index data from the specified offset
; Parameter(s):		$_offset - The offset linking to the file def
;								be in hex format (0x00000000).
;					$_displayInfo - Setting this to 1 will make the function spit
;								out the results while running
; Note(s):			This function is used to index data from the MPQ files that
;					that have been loaded into memory.
;					Im not sure why the count doesnt go beyond 256.
;					So for the time being if the count goes beyond 256 the size
;					is set to a specified count and then the array will be scaled
;					after when data will stop being available.
;==================================================================================
Func IndexSNO($_offset, $_displayInfo = 0)

	Local $CurrentSnoOffset = 0x0
	$_MainOffset = _MemoryRead($_offset, $d3, 'ptr')
	$_Pointer = _MemoryRead($_MainOffset + $_defptr, $d3, 'ptr')
	$_SnoCount = _MemoryRead($_Pointer + $_defcount, $d3, 'ptr') ;//Doesnt seem to go beyond 256 for some wierd reason
	If $_SnoCount >= 256 Then ;//So incase it goes beyond...
		$ignoreSNOcount = 1 ;//This enables a redim after the for loop
		$_SnoCount = 4056 ;//We put a limit to avoid overflow here
	Else
		$ignoreSNOcount = 0
	EndIf

	$_SnoIndex = _MemoryRead($_Pointer + $_deflink, $d3, 'ptr') ;//Moving from the static into the index
	$_SNOName = _MemoryRead($_Pointer, $d3, 'char[64]') ;//Usually something like "Something" + Def
	$TempWindex = $_SnoIndex + 0xC ;//The header is 0xC in size
	If $_displayInfo = 1 Then _Log("-----* Indexing " & $_SNOName & " *-----" & @CRLF)
	Dim $_OutPut[$_SnoCount + 1][2] ;//Setting the size of the output array

	For $i = 1 To $_SnoCount Step +1 ;//Iterating through all the elements
		$_CurSnoOffset = _MemoryRead($TempWindex, $d3, 'ptr') ;//Getting the offset for the item
		$_CurSnoID = _MemoryRead($_CurSnoOffset, $d3, 'ptr') ;//Going into the item and grapping the GUID which is located at 0x0
		If $ignoreSNOcount = 1 And $_CurSnoOffset = 0x00000000 And $_CurSnoID = 0x00000000 Then ExitLoop ;//Untill i find a way to get the real count we do this instead.
		If $ignoreSNOcount = 1 Then $CurIndex = $i
		$_OutPut[$i][0] = $_CurSnoOffset ;//Poping the data into the output array
		$_OutPut[$i][1] = $_CurSnoID
		If $_displayInfo = 1 Then _Log($i & " Offset: " & $_CurSnoOffset & " SNOid: " & $_CurSnoID & @CRLF)
		$TempWindex = $TempWindex + 0x10 ;//Next item is located 0x10 later
	Next

	If $ignoreSNOcount = 1 Then ReDim $_OutPut[$CurIndex][2] ;//Here we do the resizing of the array, to minimize memory footprint!?.

	Return $_OutPut
EndFunc   ;==>IndexSNO

;;--------------------------------------------------------------------------------
;;	IterateObjectList()
;;--------------------------------------------------------------------------------
Func IterateObjectList($_displayInfo = 0)
	;	Local $mesureobj = TimerInit() ;;;;;;;;;;;;;;
	If $_displayInfo = 1 Then _Log("-----Iterating through Actors------" & @CRLF)
	If $_displayInfo = 1 Then _Log("First Actor located at: " & $_itrObjectManagerD & @CRLF)
	$_CurOffset = $_itrObjectManagerD
	$_Count = _MemoryRead($_itrObjectManagerCount, $d3, 'int')
	Dim $OBJ[$_Count + 1][13]
	If $_displayInfo = 1 Then _Log("Number of Actors : " & $_Count & @CRLF)
	;$init = TimerInit()
	For $i = 0 To $_Count Step +1
		$_GUID = _MemoryRead($_CurOffset + 0x4, $d3, 'ptr')
		If $_GUID = 0xffffffff Then ;no need to go through objects without a GUID!
			$_PROXY_NAME = -1
			$_REAL_NAME = -1
			$_ACTORLINK = -1
			$_POS_X = -1
			$_POS_Y = -1
			$_POS_Z = -1
			$_DATA = -1
			$_DATA2 = -1
		Else
			$_PROXY_NAME = _MemoryRead($_CurOffset + 0x8, $d3, 'char[64]')
			$TmpString = StringSplit($_PROXY_NAME, "-")
			If IsDeclared("__" & $TmpString[1]) Then
				$_REAL_NAME = Eval("__" & $TmpString[1])
			Else
				$_REAL_NAME = $_PROXY_NAME
			EndIf
			$_ACTORLINK = _MemoryRead($_CurOffset + 0x88, $d3, 'ptr')
			$_POS_X = _MemoryRead($_CurOffset + 0xB0, $d3, 'float')
			$_POS_Y = _MemoryRead($_CurOffset + 0xB4, $d3, 'float')
			$_POS_Z = _MemoryRead($_CurOffset + 0xB8, $d3, 'float')
			$_DATA = _MemoryRead($_CurOffset + 0x200, $d3, 'int')
			$_DATA2 = _MemoryRead($_CurOffset + 0x1D0, $d3, 'int')
			If $_displayInfo = 1 Then _Log($i & @TAB & " : " & $_CurOffset & " " & $_GUID & " " & $_ACTORLINK & " : " & $_DATA & " " & $_DATA2 & " " & @TAB & $_POS_X & " " & $_POS_Y & " " & $_POS_Z & @TAB & $_REAL_NAME & @CRLF)
		EndIf

		;Im too lazy to do this but the following code needs cleanup and restructure more than anything.
		;You want to include all the data into this one structure rather than having it at multiple locations
		;and the useless things should be removed.
		$CurrentLoc = GetCurrentPos()
		$xd = $_POS_X - $CurrentLoc[0]
		$yd = $_POS_Y - $CurrentLoc[1]
		$zd = $_POS_Z - $CurrentLoc[2]
		$Distance = Sqrt($xd * $xd + $yd * $yd + $zd * $zd)
		$OBJ[$i][0] = $_CurOffset
		$OBJ[$i][1] = $_GUID
		$OBJ[$i][2] = $_PROXY_NAME
		$OBJ[$i][3] = $_POS_X
		$OBJ[$i][4] = $_POS_Y
		$OBJ[$i][5] = $_POS_Z
		$OBJ[$i][6] = $_DATA
		$OBJ[$i][7] = $_DATA2
		$OBJ[$i][8] = $Distance
		$OBJ[$i][9] = $_ACTORLINK
		$OBJ[$i][10] = $_REAL_NAME
		$OBJ[$i][11] = -1
		$OBJ[$i][12] = -1
		$_CurOffset = $_CurOffset + $_ObjmanagerStrucSize
	Next
	IterateLocalActor()
	Return $OBJ
EndFunc   ;==>IterateObjectList


;;--------------------------------------------------------------------------------
;;      Function to iterate all objects()
;;--------------------------------------------------------------------------------
Func StartIterateObjectsList(ByRef $index, ByRef $offset, ByRef $count)
	$count = _MemoryRead($_itrObjectManagerCount, $d3, 'int')
	$index = 0
	$offset = $_itrObjectManagerD
EndFunc   ;==>StartIterateObjectsList

;;--------------------------------------------------------------------------------
;;      FromD3ToScreenCoords()
;;--------------------------------------------------------------------------------
Func FromD3ToScreenCoords($_x, $_y, $_z)
	Dim $return[2]
	$size = WinGetClientSize("[CLASS:D3 Main Window Class]")
	$resolutionX = $size[0]
	$resolutionY = $size[1]
	$aspectChange = ($resolutionX / $resolutionY) / (800 / 600)
	$CurrentLoc = GetCurrentPos()
	$xd = $_x - $CurrentLoc[0]
	$yd = $_y - $CurrentLoc[1]
	$zd = $_z - $CurrentLoc[2]
	$w = -0.515 * $xd + -0.514 * $yd + -0.686 * $zd + 97.985
	$x = (-1.682 * $xd + 1.683 * $yd + 0 * $zd + 7.045E-3) / $w
	$y = (-1.54 * $xd + -1.539 * $yd + 2.307 * $zd + 6.161) / $w
	$Z = (-0.515 * $xd + -0.514 * $yd + -0.686 * $zd + 97.002) / $w
	$x /= $aspectChange
	While Abs($x) >= 1 Or Abs($y) >= 0.7 Or $Z <= 0
		; specified point is not on screen
		$xd = $xd / 2
		$yd = $yd / 2
		$zd = $zd / 2
		$w = -0.515 * $xd + -0.514 * $yd + -0.686 * $zd + 97.985
		$x = (-1.682 * $xd + 1.683 * $yd + 0 * $zd + 7.045E-3) / $w
		$y = (-1.54 * $xd + -1.539 * $yd + 2.307 * $zd + 6.161) / $w
		$Z = (-0.515 * $xd + -0.514 * $yd + -0.686 * $zd + 97.002) / $w
		$x /= $aspectChange
	WEnd
	$return[0] = ($x + 1) / 2 * $resolutionX
	$return[1] = (1 - $y) / 2 * $resolutionY
	If $return[0] > 790 Then
		$return[0] = 790
	ElseIf $return[0] < 40 Then ;car on a pas l'envie de cliquer dans les icone du chat
		$return[0] = 40
	EndIf
	If $return[1] > 540 Then ;car on a pas l'envie de cliquer dans la bare des skills
		$return[1] = 540
	ElseIf $return[1] < 10 Then
		$return[1] = 10
	EndIf
	Return $return
EndFunc   ;==>FromD3ToScreenCoords


;;--------------------------------------------------------------------------------
;;      UiRatio()
;;--------------------------------------------------------------------------------
Func UiRatio($_x, $_y)
	Dim $return[2]
	$size = WinGetClientSize("[CLASS:D3 Main Window Class]")
	$return[0] = $size[1] * ($_x / 600)
	$return[1] = $size[1] * ($_y / 600)
	Return $return
EndFunc   ;==>UiRatio


;;--------------------------------------------------------------------------------
;;      GetCurrentPos()
;;--------------------------------------------------------------------------------
Func GetCurrentPos()
	Dim $return[3]

	$return[0] = _MemoryRead($_Myoffset + 0x0A0, $d3, 'float')
	$return[1] = _MemoryRead($_Myoffset + 0x0A4, $d3, 'float')
	$return[2] = _MemoryRead($_Myoffset + 0x0A8, $d3, 'float')

	$Current_Hero_X = $return[0]
	$Current_Hero_Y = $return[1]
	$Current_Hero_Z = $return[2]

	;		Local $difmesurepos = TimerDiff($mesurepos) ;;;;;;;;;;;;;
	;_Log("Mesure getcurrentpos :" & $difmesurepos &@crlf) ;FOR DEBUGGING;;;;;;;;;;;;
	Return $return
EndFunc   ;==>GetCurrentPos



;;--------------------------------------------------------------------------------
;;      MoveToPos()
;;--------------------------------------------------------------------------------
Func MoveToPos($_x, $_y, $_z, $_a, $m_range)
	Local $TimeOut = TimerInit()
	$grabtimeout = 0
	$killtimeout = 0
	If IsPlayerDead() Or $CheckGameLength = True Or $GameFailed = 1 Or $SkippedMove > 6 Then
		$GameFailed = 1
		Return
	EndIf
	Local $toggletry = 0
	Global $lastwp_x = $_x
	Global $lastwp_y = $_y
	Global $lastwp_z = $_z
	If $_a = 1 Then Attack()
	$Coords = FromD3ToScreenCoords($_x, $_y, $_z)
	MouseMove($Coords[0], $Coords[1], 3)
	$LastCP = GetCurrentPos()
	MouseDown("middle")
	Sleep(10)
	While 1

		CheckGameLength()
		If $CheckGameLength = True Then
			ExitLoop
		EndIf

		ManageSpellCasting(0, 0, 0)

		$CurrentLoc = GetCurrentPos()
		$xd = $lastwp_x - $CurrentLoc[0]
		$yd = $lastwp_y - $CurrentLoc[1]
		$zd = $lastwp_z - $CurrentLoc[2]
		$Distance = Sqrt($xd * $xd + $yd * $yd + $zd * $zd)
		If $Distance < $m_range Then ExitLoop
		Local $angle = 1
		Local $Radius = 25


		While _MemoryRead($ClickToMoveToggle, $d3, 'float') = 0
			;_Log("Togglemove : " & _MemoryRead($ClickToMoveToggle, $d3, 'float'))
			$Coords = FromD3ToScreenCoords($_x, $_y, $_z)
			$angle += $Step
			$Radius += 45


			; ci desssous du dirty code pour eviter de cliquer n'importe ou hos de la fenetre du jeu
			$Coords[0] = $Coords[0] - (Cos($angle) * $Radius)
			$Coords[1] = $Coords[1] - (Sin($angle) * $Radius)

			Switch $Coords[0] ;car on a pas l'envie de cliquer dans les icone du chat
				Case 791 To 800
					$Coords[0] = 790
				Case 0 To 39
					$Coords[0] = 40
			EndSwitch
			Switch $Coords[1] ;car on a pas l'envie de cliquer dans la bare des skills
				Case 541 To 600
					$Coords[1] = 540
				Case 0 To 9
					$Coords[1] = 10
			EndSwitch

			MouseMove($Coords[0], $Coords[1], 3)
			$toggletry += 1
			;_Log("Tryin move :" & " x:" & $_x & " y:" & $_y & "coords: " & $Coords[0] & "-" & $Coords[1] & " angle: " & $angle & " Toggle try: " & $toggletry)

			If RevivePlayerDead() Then
				ExitLoop 2
			EndIf

			If $angle >= 2.0 * $PI Or $toggletry > 9 Or IsPlayerDead() Then
				$SkippedMove += 1
				_Log("Toggle try: " & $toggletry & " Movement Skipped : " & $SkippedMove)
				ExitLoop 2 ; le 2 signifie que l'on quitte 2 loop
			EndIf
			Sleep(10)
		WEnd
		Sleep(10)
		$Coords = FromD3ToScreenCoords($lastwp_x, $lastwp_y, $lastwp_z)
		;_Log("currentloc: " & $_Myoffset & " - "&$CurrentLoc[0] & " : " & $CurrentLoc[1] & " : " & $CurrentLoc[2] &@CRLF)
		;_Log("distance/m range: " & $Distance & " : " & $m_range & @CRLF)
		If $_a = 1 And GetDistance($LastCP[0], $LastCP[1], $LastCP[2]) >= $a_range / 2 Then
			MouseUp("middle")
			$LastCP = GetCurrentPos()
			If $_a = 1 Then Attack()
			;_Log("Last check: " & $Distance & @CRLF)

			$Coords_RndX = $Coords[0] + Random(-17, 17)
			$Coords_RndY = $Coords[1] + Random(-17, 17)

			If $Coords_RndX < 40 Then
				$Coords_RndX = 40
			ElseIf $Coords_RndX > 790 Then
				$Coords_RndX = 790
			EndIf

			If $Coords_RndY < 10 Then
				$Coords_RndY = 10
			ElseIf $Coords_RndY > 540 Then
				$Coords_RndY = 540
			EndIf


			MouseMove($Coords_RndX, $Coords_RndY, 3) ;little randomisation
			MouseDown("middle")
		EndIf
		MouseMove($Coords[0], $Coords[1], 3)
		If TimerDiff($TimeOut) > 75000 Then
			_Log("MoveToPos Timed out ! ! ! ")
			If IsDisconnected() Then
				$GameFailed = 1
			EndIf

			ExitLoop
		EndIf
	WEnd
	MouseUp("middle")
	;;
	;Sleep(100)
EndFunc   ;==>MoveToPos

;;--------------------------------------------------------------------------------
;;      Interact()
;;--------------------------------------------------------------------------------
Func Interact($_x, $_y, $_z)
	$Coords = FromD3ToScreenCoords($_x, $_y, $_z)
	MouseClick("left", $Coords[0], $Coords[1], 1, 2)
EndFunc   ;==>Interact

;;--------------------------------------------------------------------------------
;;   InteractByActorName()
;;--------------------------------------------------------------------------------
Func InteractByActorName($a_name, $dist = 300)
	Local $index, $offset, $count, $item[10], $foundobject = 0
	Local $maxtry = 0
	StartIterateObjectsList($index, $offset, $count)
	If IsPlayerDead() = False Then
		While IterateObjectsList($index, $offset, $count, $item)
			If StringInStr($item[1], $a_name) And $item[9] < $dist Then
				_Log($item[1] & " distance : " & $item[9])
				While GetDistance($item[2], $item[3], $item[4]) > 40 And $maxtry <= 15
					$Coords = FromD3ToScreenCoords($item[2], $item[3], $item[4])
					MouseClick("middle", $Coords[0], $Coords[1], 1, 10)
					$maxtry += 1
					_Log('interactbyactor: click x : ' & $Coords[0] & " y : " & $Coords[1])
					Sleep(800)
				WEnd
				Sleep(800)
				Interact($item[2], $item[3], $item[4])
				$foundobject = 1
				Sleep(100)
				ExitLoop
			EndIf
		WEnd
	EndIf
	Return $foundobject
EndFunc   ;==>InteractByActorName


;;--------------------------------------------------------------------------------
;;      GetLifeLeftPercent()
;;--------------------------------------------------------------------------------
Func GetLifeLeftPercent()
	$curhp = GetAttribute($_MyGuid, $Atrib_Hitpoints_Cur)
	Return ($curhp / $maxhp)
EndFunc   ;==>GetLifeLeftPercent

Func GetAttribute($idAttrib, $attrib)
	Return _memoryread(GetAttributeOfs($idAttrib, BitOR($attrib[0], 0xFFFFF000)), $d3, $attrib[1])
EndFunc   ;==>GetAttribute

Func GetACDOffsetByACDGUID($Guid)
	$ptr1 = _memoryread($ofs_objectmanager, $d3, "ptr")
	$ptr2 = _memoryread($ptr1 + 0x8a0, $d3, "ptr")
	$ptr3 = _memoryread($ptr2 + 0x0, $d3, "int")
	$index = BitAND($Guid, 0xFFFF)

	$bitshift = _memoryread($ptr3 + 0x18C, $d3, "int")
	$group1 = 4 * BitShift($index, $bitshift)
	$group2 = BitShift(1, -$bitshift) - 1
	$group3 = _memoryread(_memoryread($ptr3 + 0x148, $d3, "int"), $d3, "int")
	$group4 = 0x2D0 * BitAND($index, $group2)
	Return $group3 + $group1 + $group4
EndFunc   ;==>GetACDOffsetByACDGUID

;----------------------------------------------------------------------------------------------------------------------
;   Fuction         _Array2DDelete(ByRef $ARRAY, $iDEL, $bCOL=False)
;
;   Description     Delete one row on a given index in an 1D/2D -Array
;
;   Parameter       $ARRAY      the array, where one row will deleted
;                   $iDEL       Row(Column)-Index to delete
;                   $bCOL       If True, delete column instead of row (default False)
;
;   Return          Succes      0   ByRef $ARRAY
;                   Failure     1   set @error = 1; given array are not array
;                                   set @error = 2; want delete column, but not 2D-array
;                                   set @error = 3; index is out of range
;
; Author            BugFix (bugfix@autoit.de)
;----------------------------------------------------------------------------------------------------------------------
Func _Array2DDelete(ByRef $ARRAY, $iDEL, $bCOL = False)
	If (Not IsArray($ARRAY)) Then Return SetError(1, 0, 1)
	Local $UBound2nd = UBound($ARRAY, 2), $k
	If $bCOL Then
		If $UBound2nd = 0 Then Return SetError(2, 0, 1)
		If ($iDEL < 0) Or ($iDEL > $UBound2nd - 1) Then Return SetError(3, 0, 1)
	Else
		If ($iDEL < 0) Or ($iDEL > UBound($ARRAY) - 1) Then Return SetError(3, 0, 1)
	EndIf
	If $UBound2nd = 0 Then
		Local $arTmp[UBound($ARRAY) - 1]
		$k = 0
		For $i = 0 To UBound($ARRAY) - 1
			If $i <> $iDEL Then
				$arTmp[$k] = $ARRAY[$i]
				$k += 1
			EndIf
		Next
	Else
		If $bCOL Then
			Local $arTmp[UBound($ARRAY)][$UBound2nd - 1]
			For $i = 0 To UBound($ARRAY) - 1
				$k = 0
				For $l = 0 To $UBound2nd - 1
					If $l <> $iDEL Then
						$arTmp[$i][$k] = $ARRAY[$i][$l]
						$k += 1
					EndIf
				Next
			Next
		Else
			Local $arTmp[UBound($ARRAY) - 1][$UBound2nd]
			$k = 0
			For $i = 0 To UBound($ARRAY) - 1
				If $i <> $iDEL Then
					For $l = 0 To $UBound2nd - 1
						$arTmp[$k][$l] = $ARRAY[$i][$l]
					Next
					$k += 1
				EndIf
			Next
		EndIf
	EndIf
	$ARRAY = $arTmp
	Return $ARRAY
EndFunc   ;==>_Array2DDelete


Func IterateObjectsList(ByRef $index, ByRef $offset, ByRef $count, ByRef $item)
	If $index > $count Then
		Return False
	EndIf
	$index += 1
	Local $IterateObjectsListStruct = DllStructCreate("byte[4];ptr;char[64];byte[104];float;float;float;byte[264];int;byte[8];int;byte[44];int")
	DllCall($d3[0], 'int', 'ReadProcessMemory', 'int', $d3[1], 'int', $offset, 'ptr', DllStructGetPtr($IterateObjectsListStruct), 'int', DllStructGetSize($IterateObjectsListStruct), 'int', '')
	$item[0] = DllStructGetData($IterateObjectsListStruct, 2) ; Guid
	$item[1] = DllStructGetData($IterateObjectsListStruct, 3) ; Name
	$item[2] = DllStructGetData($IterateObjectsListStruct, 5) ; x
	$item[3] = DllStructGetData($IterateObjectsListStruct, 6) ; y
	$item[4] = DllStructGetData($IterateObjectsListStruct, 7) ; z
	$item[5] = DllStructGetData($IterateObjectsListStruct, 13) ; data 1
	$item[6] = DllStructGetData($IterateObjectsListStruct, 11) ; data 2
	$item[7] = DllStructGetData($IterateObjectsListStruct, 9) ; data 3
	$item[8] = $offset
	$item[9] = GetDistance($item[2], $item[3], $item[4]) ; Distance
	$IterateObjectsListStruct = ""

	$offset = $offset + $_ObjmanagerStrucSize

	Return True

EndFunc   ;==>IterateObjectsList

Func IterateFilterAttack($IgnoreList)
	Local $index, $offset, $count, $item[10]
	StartIterateObjectsList($index, $offset, $count)
	Dim $item_buff_2D[1][10]
	Local $i = 0

	$compt = 0

	While IterateObjectsList($index, $offset, $count, $item)
		$compt += 1
		If IsInteractable($item, $IgnoreList) Then
			If IsShrine($item) Or IsMonster($item) Or IsLoot($item) Or IsDecorBreakable($item) Then
				ReDim $item_buff_2D[$i + 1][10]
				For $x = 0 To 9
					$item_buff_2D[$i][$x] = $item[$x]
				Next
				$i += 1
			EndIf

		EndIf
	WEnd

	If $i = 0 Then
		Return False
	Else

		If trim(StringLower($MonsterTri)) = "true" Then
			_ArraySort($item_buff_2D, 0, 0, 0, 9)
		EndIf

		If trim(StringLower($MonsterPriority)) = "true" Then
			Dim $item_buff_2D_buff = SortObjectMonster($item_buff_2D)
			Dim $item_buff_2D = $item_buff_2D_buff
		EndIf
		Return $item_buff_2D
	EndIf

EndFunc   ;==>IterateFilterAttack

Func IterateFilterZone($dist, $n = 2)
	Local $index, $offset, $count, $item[10]
	StartIterateObjectsList($index, $offset, $count)
;~ 	Dim $item_buff_2D[1][10]
	Local $i = 0
	$my_pos_zone = GetCurrentPos()
	$compt = 0

	While IterateObjectsList($index, $offset, $count, $item)
		$compt += 1
		If IsInteractable($item, "") Then
			If IsMonster($item) And Sqrt(($item[2] - $my_pos_zone[0]) ^ 2 + ($item[3] - $my_pos_zone[1]) ^ 2) < $dist And $item[4] < 10 Then

				$i += 1
			EndIf

		EndIf
	WEnd
	;= 0 or ubound($item_buff_2D)
	If $i < 2 Then
;~ 	   _Log("pas assez de mob proche")
		Return False
	Else
;~ 		 _Log("nombre : " & $i)
		Return True

	EndIf
EndFunc   ;==>IterateFilterZone

Func UpdateArrayAttack($array_obj, $IgnoreList, $update_attrib = 0)

	If UBound($array_obj) <= 1 Or Not IsArray($array_obj) Then
		Return False
	EndIf


	If $update_attrib = 0 Then
		Return UpdateObjectsList(_Array2DDelete($array_obj, 0))
	Else

		Local $buff2 = IterateFilterAttack($IgnoreList)
		If trim(StringLower($MonsterTri)) = "true" Then
			_ArraySort($buff2, 0, 0, 0, 9)
		EndIf

		If trim(StringLower($MonsterPriority)) = "true" Then
			Dim $buff2_buff = SortObjectMonster($buff2)
			Dim $buff2 = $buff2_buff
		EndIf

		Return $buff2
	EndIf
EndFunc   ;==>UpdateArrayAttack

Func SortObjectMonster($item)

	Dim $tab_monster[1][10]
	Dim $tab_other[1][10]
	Dim $tab_mixte[1][10]
	Dim $tab_elite[1][10]
	Dim $item_temp[10]
	$compt_monster = 0
	$compt_other = 0
	$compt_elite = 0
	$compt_mixte = 0

	For $i = 0 To UBound($item) - 1

		For $Z = 0 To 9
			$item_temp[$Z] = $item[$i][$Z]
		Next

		If IsMonster($item_temp) Then

			If UBound($tab_monster) > 1 Or $compt_monster <> 0 Then
				ReDim $tab_monster[UBound($tab_monster) + 1][10]
			EndIf
			For $y = 0 To 9
				$tab_monster[UBound($tab_monster) - 1][$y] = $item[$i][$y]
			Next
			$compt_monster += 1

		Else

			If UBound($tab_other) > 1 Or $compt_other <> 0 Then
				ReDim $tab_other[UBound($tab_other) + 1][10]
			EndIf
			For $y = 0 To 9
				$tab_other[UBound($tab_other) - 1][$y] = $item[$i][$y]
			Next
			$compt_other += 1
		EndIf

	Next

;~ 	For $i = 0 To UBound($tab_elite) - 1

;~ 		If UBound($tab_mixte) > 1 Or $compt_mixte <> 0 Then
;~ 			ReDim $tab_mixte[UBound($tab_mixte) + 1][10]
;~ 		EndIf
;~ 		For $y = 0 To 9
;~ 			$tab_mixte[UBound($tab_mixte) - 1][$y] = $tab_elite[$i][$y]
;~ 		Next
;~ 		$compt_mixte += 1
;~ 	Next


	For $i = 0 To UBound($tab_monster) - 1

		If UBound($tab_mixte) > 1 Or $compt_mixte <> 0 Then
			ReDim $tab_mixte[UBound($tab_mixte) + 1][10]
		EndIf
		For $y = 0 To 9
			$tab_mixte[UBound($tab_mixte) - 1][$y] = $tab_monster[$i][$y]
		Next
		$compt_mixte += 1
	Next

	For $i = 0 To UBound($tab_other) - 1

		If UBound($tab_mixte) > 1 Or $compt_mixte <> 0 Then
			ReDim $tab_mixte[UBound($tab_mixte) + 1][10]
		EndIf
		For $y = 0 To 9
			$tab_mixte[UBound($tab_mixte) - 1][$y] = $tab_other[$i][$y]
		Next
		$compt_mixte += 1
	Next

	Return $tab_mixte

EndFunc   ;==>SortObjectMonster

Func UpdateObjectsList($item)
	For $i = 0 To UBound($item) - 1
		Dim $buff_item[4]
		Local $pos = DllStructCreate("byte[176];float;float;float")
		DllCall($d3[0], 'int', 'ReadProcessMemory', 'int', $d3[1], 'int', $item[$i][8], 'ptr', DllStructGetPtr($pos), 'int', DllStructGetSize($pos), 'int', '')
		$item[$i][2] = DllStructGetData($pos, 2)
		$item[$i][3] = DllStructGetData($pos, 3)
		$item[$i][4] = DllStructGetData($pos, 4)
		$item[$i][9] = GetDistance($item[$i][2], $item[$i][3], $item[$i][4]) ; Distance
		$pos = ""
	Next
	Return $item
EndFunc   ;==>UpdateObjectsList

Func UpdateObjectsPos($offset)
	Local $obj_pos[4]
	Local $pos = DllStructCreate("byte[176];float;float;float")
	DllCall($d3[0], 'int', 'ReadProcessMemory', 'int', $d3[1], 'int', $offset, 'ptr', DllStructGetPtr($pos), 'int', DllStructGetSize($pos), 'int', '')
	$obj_pos[0] = DllStructGetData($pos, 2)
	$obj_pos[1] = DllStructGetData($pos, 3)
	$obj_pos[2] = DllStructGetData($pos, 4)
	$obj_pos[3] = GetDistance($obj_pos[0], $obj_pos[1], $obj_pos[2]) ; Distance
	$pos = ""
	Return $obj_pos
EndFunc   ;==>UpdateObjectsPos

Func IsShrine($item)
	If StringInStr($item[1], "shrine") And $item[9] < 35 Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>IsShrine

Func IsMonster($item)
	If CheckFromList($BanmonsterList, $item[1]) = 0 And CheckFromList($monsterList, $item[1]) And $item[6] <> -1 And $item[9] < $a_range Or CheckFromList($SpecialmonsterList, $item[1]) And $item[9] < $a_range Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>IsMonster

Func IsDecorBreakable($item)
	If CheckFromList($bandecorlist, $item[1]) = 0 And CheckFromList($decorlist, $item[1]) And $item[6] <> -1 And $item[9] < 18 Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>IsDecorBreakable

Func IsLoot($item)

	If ($item[5] = 2 And $item[6] = -1) Or (StringInStr($item[1], "orb") And StringInStr($item[1], "unique")) Or (StringInStr($item[1], "Spear") And StringInStr($item[1], "unique")) Then
		;_Log("IsLoot de l'item -> " & $item[0] & "-" & $item[1] & "-" & $item[2] & " - " & $item[3] & " - " & $item[4] & " - " & $item[5] & " - " & $item[6] & " - " & $item[8] & " - " & $item[9])
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>IsLoot

Func IsInteractable($item, $IgnoreList)
	If $item[0] <> "" And $item[0] <> 0xFFFFFFFF And ($item[9] < $g_range Or $item[9] < $a_range) And StringInStr($IgnoreList, $item[8]) == 0 And StringInStr($HandleBanListdef, $item[2] & "-" & $item[3] & "-" & $item[4]) == 0 And StringInStr($IgnoreItemList, $item[1]) = 0 And CheckFromList($CheckTakeShrinebanlist, $item[8]) = 0 And Abs($Current_Hero_Z - $item[4]) <= $Hero_Axe_Z Then
		If Not CheckStartListRegex($Ban_startstrItemList, $item[1]) And Not CheckEndListRegex("_projectile", $item[1]) Then
			Return True
		Else
			Return False
		EndIf
	Else
		Return False
	EndIf
EndFunc   ;==>IsInteractable

Func HandleCheckTakeShrine(ByRef $item)
	If $takeShrines = "True" Then
		$CurrentACD = GetACDOffsetByACDGUID($item[0]); ###########
		$CurrentIdAttrib = _memoryread($CurrentACD + 0x120, $d3, "ptr"); ###########
		If GetAttribute($CurrentIdAttrib, $Atrib_gizmo_state) <> 1 Then
			If CheckTakeShrine($item[1], $item[8], $item[0]) = False Then
				$CheckTakeShrinebanlist = $CheckTakeShrinebanlist & "|" & $item[8]
			EndIf
		EndIf
	EndIf
EndFunc   ;==>HandleCheckTakeShrine

Func HandleMonster(ByRef $item, ByRef $IgnoreList, ByRef $test_iterateallobjectslist)
	; we have a monster
	$CurrentACD = GetACDOffsetByACDGUID($item[0]); ###########
	$CurrentIdAttrib = _memoryread($CurrentACD + 0x120, $d3, "ptr"); ###########
	If GetAttribute($CurrentIdAttrib, $Atrib_Hitpoints_Cur) > 0 And GetAttribute($CurrentIdAttrib, $Atrib_Invulnerable) = 0 Then

		$foundobject = 1
		If KillMob($item[1], $item[8], $item[0], $test_iterateallobjectslist) = False Then
			_Log('ignoring ' & $item[1])
			$IgnoreList = $IgnoreList & $item[8]

			If $killtimeout > 2 Or $grabtimeout > 2 Then
				_Log("_checkdisconnect Cuz :If $killtimeout > 2 or $grabtimeout > 2 Then")
				If IsDisconnected() Or IsPlayerDead() Then
					$GameFailed = 1
				EndIf
			EndIf
		EndIf
		If trim(StringLower($MonsterRefresh)) = "true" Then
			Dim $buff_array = UpdateArrayAttack($test_iterateallobjectslist, $IgnoreList, 1)
			$test_iterateallobjectslist = $buff_array
		EndIf
	Else
		_Log('ignoring ' & $item[1])
		$IgnoreList = $IgnoreList & $item[8]
		;_Log("Grabtimeout : " & $grabtimeout & " killtimeout: "& $killtimeout)
		If $killtimeout > 2 Or $grabtimeout > 2 Then
			If IsDisconnected() Or IsPlayerDead() Then
				$GameFailed = 1
			EndIf
		EndIf
	EndIf
EndFunc   ;==>HandleMonster

Func CheckQuality($_GUID)
	; _Log("guid: "&$_GUID &" name: "& $_NAME & " qual: "&IterateActorAttributes($_GUID, $Atrib_Item_Quality_Level))
	$ACD = GetACDOffsetByACDGUID($_GUID)
	$CurrentIdAttrib = _memoryread($ACD + 0x120, $d3, "ptr");
	$quality = GetAttribute($CurrentIdAttrib, $Atrib_Item_Quality_Level)


	Return $quality
EndFunc   ;==>CheckQuality

Func HandleLoot(ByRef $item, ByRef $IgnoreList, ByRef $test_iterateallobjectslist)
	$GrabIt = False
	If _MemoryRead($item[8] + 0x4, $d3, 'ptr') <> 0xFFFFFFFF Then
		_Log("Checking " & $item[1] & @CRLF)

		If $gestion_affixe_loot = "true" Then
			Dim $item_aff_verif = IterateFilterAffix()
		Else
			$item_aff_verif = ""
		EndIf

		If IsArray($item_aff_verif) And $gestion_affixe_loot = "true" Then
			If IsSafeZone($item[2], $item[3], $item[4], $item_aff_verif) Or CheckQuality($item[0]) = 9 Then
				$itemDestination = CheckItem($item[0], $item[1])
				If $itemDestination == "Stash" Or $itemDestination == "Salvage" Or ($itemDestination == "Inventory" And $takepot = True) Then
					; this loot is interesting
					$foundobject = 1
					If GrabIt($item[1], $item[8]) = False Then
						_Log('ignoring ' & $item[1])
						$IgnoreList = $IgnoreList & $item[8]
						HandleBanList($item[2] & "-" & $item[3] & "-" & $item[4])
						;_Log("Grabtimeout : " & $grabtimeout & " killtimeout: "& $killtimeout)
						If $killtimeout > 2 Or $grabtimeout > 2 Then
							If IsDisconnected() Or IsPlayerDead() Then
								_Log('_checkdisconnect A or player D')
								$GameFailed = 1
							EndIf
						EndIf

					EndIf

					If Trim(StringLower($ItemRefresh)) = "true" Then
						Dim $buff_array = UpdateArrayAttack($test_iterateallobjectslist, $IgnoreList, 1)
						$test_iterateallobjectslist = $buff_array
					EndIf
				Else
					If CheckFromList($monsterList, $item[1]) = False Then
						$IgnoreItemList = $IgnoreItemList & $item[1] & "-"
						;_Log('ignoring ' & $item[8] & " : " & $item[1] & " :::::" &$IgnoreItemList)
					EndIf
				EndIf
			EndIf
		Else
			$itemDestination = CheckItem($item[0], $item[1])
			If $itemDestination == "Stash" Or $itemDestination == "Salvage" Or ($itemDestination == "Inventory" And $takepot = True) Then
				; this loot is interesting
				$foundobject = 1
				If GrabIt($item[1], $item[8]) = False Then
					_Log('ignoring ' & $item[1])
					$IgnoreList = $IgnoreList & $item[8]
					HandleBanList($item[2] & "-" & $item[3] & "-" & $item[4])
					;_Log("Grabtimeout : " & $grabtimeout & " killtimeout: "& $killtimeout)
					If $killtimeout > 2 Or $grabtimeout > 2 Then
						If IsDisconnected() Or IsPlayerDead() Then
							_Log('_checkdisconnect A or player D')
							$GameFailed = 1
						EndIf
					EndIf

				EndIf

				If Trim(StringLower($ItemRefresh)) = "true" Then
					Dim $buff_array = UpdateArrayAttack($test_iterateallobjectslist, $IgnoreList, 1)
					$test_iterateallobjectslist = $buff_array
				EndIf
			Else
				If CheckFromList($monsterList, $item[1]) = False Then
					$IgnoreItemList = $IgnoreItemList & $item[1] & "-"
					;_Log('ignoring ' & $item[8] & " : " & $item[1] & " :::::" &$IgnoreItemList)
				EndIf
			EndIf
		EndIf
	EndIf
EndFunc   ;==>HandleLoot

Func HandleBanList($coords_ban)
	If StringInStr($HandleBanList1, $coords_ban) = False Then
		_Log("banlist 1 -> " & $coords_ban)
		$HandleBanList1 = $HandleBanList1 & "|" & $coords_ban
	ElseIf StringInStr($HandleBanList1, $coords_ban) And StringInStr($HandleBanList2, $coords_ban) = False Then
		_Log("banlist 2 -> " & $coords_ban)
		$HandleBanList2 = $HandleBanList2 & "|" & $coords_ban
	ElseIf StringInStr($HandleBanList2, $coords_ban) Then
		_Log("banlist def -> " & $coords_ban)
		$HandleBanListdef = $HandleBanListdef & "|" & $coords_ban
	EndIf
	_Log("banlist 1 -> " & $HandleBanList1)

	_Log("banlist 2 -> " & $HandleBanList2)

	_Log("banlist def -> " & $HandleBanListdef)

EndFunc   ;==>HandleBanList

;;--------------------------------------------------------------------------------
;;      Attack()
;;--------------------------------------------------------------------------------
Func Attack()
	If RevivePlayerDead() Then
		Return
	EndIf

	If IsPlayerDead() Or ($GameFailed = 1) Then
		$GameFailed = 1
		_Log("Return Cuz : If IsPlayerDead or gamefailed ")
		Return
	EndIf
	Local $IgnoreList = ""
	Local $item[10]
	Dim $test_iterateallobjectslist = IterateFilterAttack($IgnoreList)
	If IsArray($test_iterateallobjectslist) Then
		While IsArray($test_iterateallobjectslist)
			If RevivePlayerDead() Then
				ExitLoop
			EndIf
			If IsPlayerDead() Or ($GameFailed = 1) Then
				$GameFailed = 1
				_Log("Return Cuz : If IsPlayerDead or gamefailed ")
				ExitLoop
			EndIf
			For $i = 0 To 9
				$item[$i] = $test_iterateallobjectslist[0][$i]
			Next

			Select
				Case IsLoot($item)
					HandleLoot($item, $IgnoreList, $test_iterateallobjectslist)
				Case IsMonster($item)
					HandleMonster($item, $IgnoreList, $test_iterateallobjectslist)
				Case IsShrine($item)
					HandleCheckTakeShrine($item)
				Case IsDecorBreakable($item)
					HandleMonster($item, $IgnoreList, $test_iterateallobjectslist)
			EndSelect

			Dim $buff_array = UpdateArrayAttack($test_iterateallobjectslist, $IgnoreList)
			Dim $test_iterateallobjectslist = $buff_array

		WEnd

	EndIf
EndFunc   ;==>Attack

Func DetectElite($Guid)
	Return _MemoryRead(GetACDOffsetByACDGUID($Guid) + 0xB8, $d3, 'int')
EndFunc   ;==>DetectElite

;;--------------------------------------------------------------------------------
;;      KillMob()
;;--------------------------------------------------------------------------------
Func KillMob($name, $offset, $Guid, $test_iterateallobjectslist2)
	$return = True
	$begin = TimerInit()


	Dim $pos = UpdateObjectsPos($offset)


	$Coords = FromD3ToScreenCoords($pos[0], $pos[1], $pos[2])
	MouseMove($Coords[0], $Coords[1], 3)

	$elite = DetectElite($Guid)
	;loop the attack until the mob is dead
	If $elite Then
		$CptElite += 1;on compte les élites
	EndIf

	_Log("Attacking : " & $name & "; Type : " & $elite);
	While IterateActorAttributes($Guid, $Atrib_Hitpoints_Cur) > 0
		$myposs_aff = GetCurrentPos()

		If RevivePlayerDead() Then
			$return = False
			ExitLoop
		EndIf
		Dim $pos = UpdateObjectsPos($offset)

		If $gestion_affixe = "true" Then MaffMove($myposs_aff[0], $myposs_aff[1], $myposs_aff[2], $pos[0], $pos[1])
		For $a = 0 To UBound($test_iterateallobjectslist2) - 1
			$CurrentACD = GetACDOffsetByACDGUID($test_iterateallobjectslist2[$a][0]); ###########
			$CurrentIdAttrib = _memoryread($CurrentACD + 0x120, $d3, "ptr"); ###########
			If GetAttribute($CurrentIdAttrib, $Atrib_Hitpoints_Cur) > 0 Then
				Dim $dist_maj = UpdateObjectsPos($test_iterateallobjectslist2[$a][8])
				$test_iterateallobjectslist2[$a][9] = $dist_maj[3]
			Else
				$test_iterateallobjectslist2[$a][9] = 10000
			EndIf
		Next
		_ArraySort($test_iterateallobjectslist2, 0, 0, 0, 9)
		$dist_verif = GetDistance($test_iterateallobjectslist2[0][2], $test_iterateallobjectslist2[0][3], $test_iterateallobjectslist2[0][4])
		Dim $pos = UpdateObjectsPos($offset)
		If $pos[3] > $dist_verif + 5 Then ExitLoop

		;if getDistance($pos[0], $pos[1], $pos[2])>20 and IterateFilterZone(30,1) then exitloop


		$Coords = FromD3ToScreenCoords($pos[0], $pos[1], $pos[2])
		MouseMove($Coords[0], $Coords[1], 3)
		ManageSpellCasting($pos[3], 1, $elite, $Guid, $offset)
		If TimerDiff($begin) > $a_time Then
			$killtimeout += 1
			; after this time, the mob should be dead, otherwise he is probly unkillable
			$return = False
			ExitLoop
		EndIf
	WEnd
	Return $return
EndFunc   ;==>KillMob


;;--------------------------------------------------------------------------------
;;      GrabIt()
;;--------------------------------------------------------------------------------
Func GrabIt($name, $offset)
	Local $OriginalOffsetValue = _MemoryRead($offset + 0x4, $d3, 'ptr')
	$begin = TimerInit()
	Dim $CoordVerif[3]


	_Log("Grabbing :" & ($name) & @CRLF) ;FOR DEBUGGING

	Dim $pos = UpdateObjectsPos($offset)

	If (StringInStr($name, "gold")) Then
		$Coords = FromD3ToScreenCoords($pos[0], $pos[1], $pos[2])
		$CoordVerif[0] = $pos[0]
		$CoordVerif[1] = $pos[1]
		$CoordVerif[2] = $pos[2]
		MouseClick("middle", $Coords[0], $Coords[1], 1, 5)
	Else
		Interact($pos[0], $pos[1], $pos[2])
	EndIf
	While _MemoryRead($offset + 0x4, $d3, 'ptr') = $OriginalOffsetValue
		If _MemoryRead($offset + 0x4, $d3, 'ptr') = 0xFFFFFFFF Then
			ExitLoop
		EndIf

		If RevivePlayerDead() Then
			$return = False
			ExitLoop
		EndIf
		ManageSpellCasting(0, 2, 0)

		If TimerDiff($begin) > $g_time Then
			$grabtimeout += 1
			; After this time we should already had the item
			Return False
		EndIf

		If $grabskip = 1 Then
			Return False
			ExitLoop
		EndIf

		Dim $pos = UpdateObjectsPos($offset)

		If (StringInStr($name, "gold")) Then


			$Coords = FromD3ToScreenCoords($pos[0], $pos[1], $pos[2])

			;Check if the coord X y z havn't changed.


			If ($CoordVerif[0] <> $pos[0] Or $CoordVerif[1] <> $pos[1] Or $CoordVerif[2] <> $pos[2]) Then
				_Log("Fake GOLD")
				Return False
			Else
				MouseClick("middle", $Coords[0], $Coords[1], 1, 5)
			EndIf
		Else

			Interact($pos[0], $pos[1], $pos[2])


			If DetectUiError($MODE_INVENTORY_FULL) Then
				Unbuff()
				TpRepairAndBack()
				Buffinit()
			EndIf

		EndIf
		Sleep(50)
	WEnd
	Return True
EndFunc   ;==>GrabIt

Func GetILvlFromACD($_ACDid)

	$ActorStructure = DllStructCreate("int;int;char[128];int;byte[36];float;float;float")
	$ACDStructure = DllStructCreate("int;char[128];byte[12];int;byte[32];int;int")
	$itemsAcdOfs = $_ACDid
	$CurrentIdAttrib = _memoryread($itemsAcdOfs + 0x120, $d3, "ptr"); ###########

	DllCall($d3[0], 'int', 'ReadProcessMemory', 'int', $d3[1], 'int', $itemsAcdOfs, 'ptr', DllStructGetPtr($ACDStructure), 'int', DllStructGetSize($ACDStructure), 'int', '')
	$idsnogball = Hex(DllStructGetData($ACDStructure, 6), 8)
	Local $iIndex = _ArraySearch($allSNOitems, $idsnogball, 0, 0, 1, 1)

	If Int($iIndex) < UBound($allSNOitems) Then
		;_Log("iIndex - > " & $iIndex)
		Return $allSNOitems[$iIndex][1]
	Else
		Return 0
	EndIf

EndFunc   ;==>GetILvlFromACD

;;================================================================================
; Function:                     CheckItem
; Description:          This will check a single item and tell if we keep it or not
;                                       This function will be the core of the item filtering
;
; Return:                       Trash
;                                       Stash
;                                       Salvage
;                                       Inventory
;==================================================================================
Func CheckItem($_GUID, $_NAME, $_MODE = 0)
	; _Log("guid: "&$_GUID &" name: "& $_NAME & " qual: "&IterateActorAttributes($_GUID, $Atrib_Item_Quality_Level))
	_Log("checkitem -> " & $_NAME)

	If CheckFromList($Potions, $_NAME) Then
		_Log($_NAME & " ==> It's a pot")
		Return "Inventory"
	ElseIf CheckFromList($grablist, $_NAME) Then
		Return "Stash"
	EndIf


	If Not CheckStartListRegex($Ban_ItemACDCheckList, $_NAME) Then
		$ACD = GetACDOffsetByACDGUID($_GUID)
		$CurrentIdAttrib = _memoryread($ACD + 0x120, $d3, "ptr");
		$quality = GetAttribute($CurrentIdAttrib, $Atrib_Item_Quality_Level)

		If $quality >= $QualityLevel Then ;filter the magic and higher
			_Log($_NAME & " ==> It's the quality level >" & $QualityLevel)
			Return "Stash"
		EndIf


		If CheckFromTable($GrabListTab, $_NAME, $quality) Then
			If CheckILvlFromTable($GrabListTab, $ACD, $_NAME) Then

				If $_MODE = 0 Then
					_Log($_NAME & " ==> It's a rare in our list ")
					Return "Stash"
				Else
					_Log($_NAME & " ==> It's a rare in our list for filterbackpack")
					Return "Stash_filtre"
				EndIf

			EndIf
		EndIf
	EndIf

	_Log($_NAME & " ==> Trash item")
	Return "Trash"
EndFunc   ;==>CheckItem

Func InventoryMove($col = 0, $row = 0)
	$Coords = UiRatio(530 + ($col * 27), 338 + ($row * 27))
	MouseMove($Coords[0], $Coords[1], 2)
EndFunc   ;==>InventoryMove

;;--------------------------------------------------------------------------------
;;      CheckDrinkPotion()
;;--------------------------------------------------------------------------------
Func CheckDrinkPotion()

	$life = GetLifeLeftPercent()
	$diff = TimerDiff($timeforpotion)
	If $life < $LifeForPotion / 100 And $diff > 1500 Then
		Send("q")
		$timeforpotion = TimerInit()
	EndIf

EndFunc   ;==>CheckDrinkPotion

;;--------------------------------------------------------------------------------
;;      CheckFromList()
;;--------------------------------------------------------------------------------
Func CheckFromList($list, $compare, $delimiter = '|')
	Local $arrayList = StringSplit($list, $delimiter)
	For $i = 1 To $arrayList[0]
		If StringInStr($compare, $arrayList[$i]) Then
			Return 1
		EndIf
	Next
	Return 0
EndFunc   ;==>CheckFromList

Func CheckStartListRegex($compare, $_NAME)
	Dim $tab_temp = StringSplit($compare, "|", 2)
	$count = UBound($tab_temp)
	For $i = 0 To $count - 1
		If StringRegExp($_NAME, "(?i)^" & $tab_temp[$i] & "") = 1 Then
			Return True
		EndIf
	Next
	Return False
EndFunc   ;==>CheckStartListRegex

Func CheckEndListRegex($compare, $_NAME)
	Dim $tab_temp = StringSplit($compare, "|", 2)
	$count = UBound($tab_temp)
	For $i = 0 To $count - 1
		If StringRegExp($_NAME, "(?i)" & $tab_temp[$i] & "$") = 1 Then
			Return True
		EndIf
	Next
	Return False
EndFunc   ;==>CheckEndListRegex

Func CheckFromTable($table, $compare, $quality)
	For $i = 0 To UBound($table) - 1
		If StringRegExp($compare, "(?i)^" & $table[$i][0] & "") = 1 And $quality >= $table[$i][2] Then
			;If StringInStr($compare, $table[$i][0]) And $quality >= $table[$i][2] Then
			Return 1
		EndIf
	Next
	Return 0
EndFunc   ;==>CheckFromTable

Func CheckILvlFromTable($table, $ACD, $compare)
	For $i = 0 To UBound($table) - 1
		If StringRegExp($compare, "(?i)^" & $table[$i][0] & "") = 1 Then
			;If StringInStr($compare, $table[$i][0]) Then
			If $table[$i][1] > 0 Then
				$ilvl = GetILvlFromACD($ACD)
				If $ilvl >= $table[$i][1] Then
					Return 1
				EndIf
			Else
				Return 1
			EndIf
		EndIf
	Next
	Return 0
EndFunc   ;==>CheckILvlFromTable

Func CheckFilterFromTable($table, $name, $CurrentIdAttrib)
	For $i = 0 To UBound($table) - 1
		If StringRegExp($name, "(?i)^" & $table[$i][0] & "") = 1 Then
			If Not $table[$i][3] = 0 Then
				$filtre_buff = $table[$i][3]
				$tab_filter = StringSplit($table[$i][4], "|", 2)
				_Log("filtre avant : " & $filtre_buff, 1)
				For $y = 0 To UBound($tab_filter) - 1
					$const_result = FilterToAttribute($CurrentIdAttrib, $tab_filter[$y])
					$filtre_buff = StringReplace($filtre_buff, $tab_filter[$y], $const_result, 0, 2)
					$filtre_buff = StringReplace($filtre_buff, ":", ">=", 0, 2)
				Next
				_Log("filtre apres : " & $filtre_buff, 1)
				If Execute($filtre_buff) Then
					_Log("execute donne true")
					Return True
				Else
					_Log("execute donne false")
					Return False
				EndIf
			EndIf
		EndIf
	Next

EndFunc   ;==>CheckFilterFromTable

Func OpenWp(ByRef $item)
	Local $maxtry = 0
	If IsPlayerDead() = False Then
		_Log($item[1] & " distance : " & $item[9])
		While GetDistance($item[2], $item[3], $item[4]) > 40 And $maxtry <= 15
			$Coords = FromD3ToScreenCoords($item[2], $item[3], $item[4])
			MouseClick("middle", $Coords[0], $Coords[1], 1, 10)
			$maxtry += 1
			_Log('interactbyactor: click x : ' & $Coords[0] & " y : " & $Coords[1])
			Sleep(500)
		WEnd
		;Sleep(500)
		Interact($item[2], $item[3], $item[4])
		Sleep(100)
	EndIf

EndFunc   ;==>OpenWp

;;--------------------------------------------------------------------------------
;;   TakeWP()
;;--------------------------------------------------------------------------------
Func TakeWP($tarChapter, $tarNum, $curChapter, $curNum)
	If $GameFailed = 0 Then
		Local $Waypoint = ""

		
		Local $hTimer = TimerInit()
		While Not OffsetList() And TimerDiff($hTimer) < 30000 ; 30secondes
			Sleep(40)
		WEnd

		If TimerDiff($hTimer) >= 30000 Then
			_Log('Fail to use OffsetList - TakeWP')
			Return False
		EndIf



		;*******************************************************
		Local $index, $offset, $count, $item[10], $maxRange = 80
		StartIterateObjectsList($index, $offset, $count)
		While IterateObjectsList($index, $offset, $count, $item)
			If (StringInStr($item[1], "waypoint_arrival_ribbonGeo") And $item[9] < $maxRange) Or (StringInStr($item[1], "waypoint_neutral_ringGlow") And $item[9] < $maxRange) Or (StringInStr($item[1], "waypoint_neutral_ringGlow") And $item[9] < $maxRange) Then
				If StringInStr($item[1], "waypoint_arrival_ribbonGeo") Then
					$Waypoint = "waypoint_arrival_ribbonGeo"
				ElseIf StringInStr($item[1], "waypoint_neutral_ringGlow") Then
					$Waypoint = "waypoint_neutral_ringGlow"
				Else
					$Waypoint = "Waypoint_Town"
				EndIf
				ExitLoop
			EndIf
		WEnd

		If $Waypoint = "" Then
			$Waypoint = "waypoint"
		EndIf

		;******************************************************

		If $Waypoint = "waypoint" Then ;WAYPOINT PAR DEFAUT ON a PAS TROUVER ITEM
			_Log("enclenchement Old waypoint")
			InteractByActorName($Waypoint)
			Sleep(350)
			Local $wptry = 0
			While IsWaypointSelectionOpened() = False And IsPlayerDead() = False
				If $wptry <= 6 Then
					_Log('Fail to open wp')
					$wptry = $wptry + 1
					InteractByActorName($Waypoint)
				EndIf
				If $wptry > 6 Then
					$GameFailed = 1
					_Log('Failed to open wp after 6 try')
					ExitLoop
				EndIf
			WEnd

		Else ;WAYPOINT DEFINIT, ON A ITEM
			_Log("enclechement new waypoint")
			OpenWp($item)
			Sleep(350)
			Local $wptry = 0
			While IsWaypointSelectionOpened() = False And IsPlayerDead() = False
				If $wptry <= 6 Then
					_Log('Fail to open wp')
					$wptry = $wptry + 1
					OpenWp($item)
				EndIf
				If $wptry > 6 Then
					$GameFailed = 1
					_Log('Failed to open wp after 6 try')
					ExitLoop
				EndIf
			WEnd

		EndIf

		If $tarChapter <> $curChapter Or ($tarChapter = $curChapter And $tarChapter < $curChapter) Then
			For $i = 0 To $tarChapter - 1
				$coord = UiRatio(35, 100 + ($i * 12.5))
				MouseClick("left", $coord[0], $coord[1], 1, 3) ; Close chapters
			Next
			$coord = UiRatio(145, 100 + ($tarChapter * 12.5) + 23 + ($tarNum * 32))
			MouseClick("left", $coord[0], $coord[1], 1, 3) ; Click wp
		EndIf
		If $tarChapter = $curChapter And $tarChapter > $curChapter Then
			For $i = 0 To $tarChapter - 1
				$coord = UiRatio(35, 100 + ($i * 12.5))
				MouseClick("left", $coord[0], $coord[1], 1, 3) ; Close chapters
			Next
			$coord = UiRatio(145, 100 + ($tarChapter * 12.5) + 23 + 12 + ($tarNum * 32))
			MouseClick("left", $coord[0], $coord[1], 1, 3) ; Click wp
		EndIf
		Sleep(1500)

		Local $hTimer = TimerInit()
		While Not OffsetList() And TimerDiff($hTimer) < 30000 ; 30secondes
			Sleep(40)
		WEnd

		If TimerDiff($hTimer) >= 30000 Then
			_Log('Fail to use OffsetList - TakeWP')
			Return False
		EndIf
		$SkippedMove = 0 ;reset ouur skipped move count cuz we should be in brand new area
	EndIf
EndFunc   ;==>TakeWP

;;--------------------------------------------------------------------------------
;;      ResumeGame()
;;--------------------------------------------------------------------------------
Func ResumeGame()
	_Log("Resume Game")
	Sleep(Random(500, 1000, 1))
	If $TryResumeGame > 2 Then
		Local $wait_aftertoomanytry = Random(($TryResumeGame * 2) * 60000, ($TryResumeGame * 2) * 120000, 1)
		_Log("Sleep after too many ResumeGame -> " & $wait_aftertoomanytry)
		Sleep($wait_aftertoomanytry)
	EndIf
	If $TryResumeGame = 0 And $BreakCounter >= ($Breakafterxxgames + Random(-2, 2, 1)) And $TakeABreak = "true" Then;$TryResumeGame = 0 car on veut pas faire une pause en plein jeu
		Local $wait_BreakTimeafterxxgames = (($BreakTime * 1000) + Random(60000, 180000, 1))
		_Log("Break Time after xx games -> Sleep " & (FormatTime($wait_BreakTimeafterxxgames)))
		Sleep($wait_BreakTimeafterxxgames)
		$BreakCounter = 0;on remet le compteur a 0
		$BreakTimeCounter += 1;on compte les pause effectuer
		$tempsPauseGame += $wait_BreakTimeafterxxgames;on récupère le temps de pause game
	EndIf
	If $TryResumeGame = 0 And $PauseRepas = "true" Then; $TryResumeGame = 0 car on veut pas faire une pause en plein jeu
		PauseRepas($Totalruns)
	EndIf
	RandomMouseClick(106, 233)
	$TryResumeGame += 1
	Sleep(4000)
EndFunc   ;==>ResumeGame

Func LoginD3()

	If $TryLoginD3 > 2 Then
		Local $wait_aftertoomanytry = Random(($TryLoginD3 * 2) * 60000, ($TryLoginD3 * 2) * 120000, 1)
		_Log("Sleep after too many LoginD3 -> " & $wait_aftertoomanytry)
		Sleep($wait_aftertoomanytry)
	EndIf

	WinActivate("[CLASS:D3 Main Window Class]")
	_Log("Login")
	Sleep(20)
	Send($d3pass)
	Sleep(2000)
	Send("{ENTER}")
	Sleep(Random(5000, 6000, 1))

	$TryLoginD3 += 1
EndFunc   ;==>LoginD3

;;--------------------------------------------------------------------------------
;;      LeaveGame()
;;--------------------------------------------------------------------------------
Func LeaveGame()
	If IsInGame() Then
		_Log("Leave Game")
		Send("{SPACE}") ; to make sure everything is closed
		Send("{ESCAPE}")
		Sleep(Random(200, 300, 1))
		While IsEscapeMenuOpened() = False
			Send("{ESCAPE}")
			Sleep(Random(200, 300, 1))
		WEnd

		;TCHAT
		If ($PartieSolo = 'false') Then
			Switch Random(1, 2, 1)
				Case 1
					WriteInChat("c'est fini on quitte et on relance")
				Case 2
					WriteInChat("c'est clean on en refait une vite fait")
			EndSwitch
		EndIf
		RandomMouseClick(420, 323)
		Sleep(Random(500, 1000, 1))
		_Log("Leave Game Done")
	EndIf

	If ($PartieSolo = 'false') Then
		;attente du groupe entre 3 et 5 mns
		Sleep(Random(180000, 300000))
	EndIf

EndFunc   ;==>LeaveGame

;;--------------------------------------------------------------------------------
;;      Repair()
;;--------------------------------------------------------------------------------
Func Repair()
	InteractByActorName($RepairVendor)
	Sleep(700)
	Local $vendortry = 0
	While IsVendorOpened() = False
		If $vendortry <= 4 Then
			_Log('Fail to open vendor')
			$vendortry = $vendortry + 1
			InteractByActorName($RepairVendor)
		EndIf
		If $vendortry > 4 Then
			Send("{PRINTSCREEN}")
			Sleep(200)
			_Log('Failed to open Vendor after 4 try')
			WinSetOnTop("[CLASS:D3 Main Window Class]", "", 0)
			MsgBox(0, "Impossible d'ouvrir le vendeur :", "SVP, veuillez reporter ce problème sur le forum. Erreur : v001 ")
			Terminate()
			ExitLoop
		EndIf
	WEnd
	GetRepairTab()

	$coord = UiRatio(290, 130 + ($RepairTab * 70))
	MouseClick("left", $coord[0], $coord[1], 1, 3) ; Repair tab
	Sleep(100)
	$coord = UiRatio(150, 330)
	MouseClick("left", $coord[0], $coord[1], 1, 3) ; Repair Button
	Sleep(100)
	Send("{SPACE}")
EndFunc   ;==>Repair

;;================================================================================
; Function:			GetDistance($_x,$_y,$_z)
; Description:		Check distance between you and a desired position.
; Parameter(s):		$_x,$_y and $_z - the target position
;
; Note(s):			Returns a distance in float
;==================================================================================
Func GetDistance($_x, $_y, $_z)
	$CurrentLoc = GetCurrentPos()
	$xd = $_x - $CurrentLoc[0]
	$yd = $_y - $CurrentLoc[1]
	$zd = $_z - $CurrentLoc[2]
	$Distance = Sqrt($xd * $xd + $yd * $yd + $zd * $zd)
	Return $Distance
EndFunc   ;==>GetDistance

Func CheckGameLength()
	Global $timedifmaxgamelength = TimerDiff($timermaxgamelength)
	If $timedifmaxgamelength > $maxgamelength Then
		_Log('game over time !')
		Global $CheckGameLength = True
	EndIf
EndFunc   ;==>CheckGameLength

Func Terminate()
	_MemoryClose($d3)
	If $checkx64 = 1 Then
		MouseUp("middle")
		MouseUp("left")
		Send("{SHIFTUP}")
		Exit 0

	Else


		WinSetOnTop("[CLASS:D3 Main Window Class]", "", 0)
		If Not FileExists(@ScriptDir & ".\stats") Then
			DirCreate(@ScriptDir & ".\stats")
		EndIf
		$file = FileOpen(@ScriptDir & ".\stats\" & $fichierstat, 1)
		FileWriteLine($file, $DebugMessage)
		FileClose($file)
		WriteStatsInHtml()
		MouseUp("middle")
		MouseUp("left")
		Send("{SHIFTUP}")
		Exit 0
	EndIf
EndFunc   ;==>Terminate

Func WriteStatsInHtml()
	If $Totalruns >= 15 Then

		$sessionstats = "data.addRow([new Date(" & @YEAR & "," & @MON & "," & @MDAY & "," & @HOUR & "," & @MIN & ")," & ($dif_timer_stat / ($Totalruns) / 1000) & "," & $GOLDMOYbyH / 1000 & "," & ($Xp_Moy_Hrs / 100000) & "," & (($Death * 3 + $Res_compt) / $Totalruns) * 100 & "," & $successratio * 1000 & "]);"
		$szFile = "statscontrol.html"
		$szText = FileRead($szFile)
		$szText = StringReplace($szText, "//GoGoAu3End", $sessionstats & @CRLF & "//GoGoAu3End")
		FileDelete($szFile)
		FileWrite($szFile, $szText)
	EndIf
EndFunc   ;==>WriteStatsInHtml

Func TogglePause()
	$Paused = Not $Paused
	If $Paused Then
		WinSetOnTop("[CLASS:D3 Main Window Class]", "", 0)
		While $Paused
			Sleep(100)
			TrayTip("", 'Script is "Paused"', 5)
		WEnd
	EndIf
	CheckWindowD3()
EndFunc   ;==>TogglePause

Func _Log($text, $write = 0)

	$texte_write = @MDAY & "/" & @MON & "/" & @YEAR & " " & @HOUR & ":" & @MIN & ":" & @SEC & " | " & $text

	If $write == 1 Then
		$file = FileOpen(@ScriptDir & "\log\" & $fichierlog, 1)
		If $file = -1 Then
			ConsoleWrite("Log file error, cant be open")
		Else
			FileWrite($file, $texte_write & @CRLF)
		EndIf
		FileClose($file)
	EndIf

	ConsoleWrite(@MDAY & "/" & @MON & "/" & @YEAR & " " & @HOUR & ":" & @MIN & ":" & @SEC & " | " & $text & @CRLF)
EndFunc   ;==>_Log

Func RandSleep($min = 5, $max = 45, $chance = 3)
	$randNum = Round(Random(1, 100))
	If $randNum <= $chance Then
		$sleepTime = Random($min * 1000, $max * 1000)
		_Log("Sleeping " & $sleepTime & "ms")
		For $c = 0 To 10
			Sleep($sleepTime / 10)
		Next
	EndIf
EndFunc   ;==>RandSleep

Func RandomMouseClick($x, $y, $button = "left")
	$coord = UiRatio($x, $y)
	MouseClick($button, Random($coord[0] - 3, $coord[0] + 3), Random($coord[1] - 3, $coord[1] + 3))
EndFunc   ;==>RandomMouseClick


;--------------------------------------------------------------------------------
;;      SetCharacter()
;;--------------------------------------------------------------------------------
Func SetCharacter($nameChar)
	$splitName = StringSplit($nameChar, "_")
	$nameCharacter = $splitName[1]
	;_Log($nameCharacter)
EndFunc   ;==>SetCharacter

;;--------------------------------------------------------------------------------
;;############# Stats by YoPens
;;--------------------------------------------------------------------------------
; modif pour simplifier avec un string replace.
Func FormatNumber($StringToFormat)
	Return StringRegExpReplace($StringToFormat, '(\A\d{1,3}(?=(\d{3})+\z)|\d{3}(?=\d))', '\1 ')
EndFunc   ;==>FormatNumber

Func StatsDisplay()

	Local $index, $offset, $count, $item[4]
	Local $time_Xp_Full_Paragon = 0;ajouter pour la stast paragon 100 dans
	StartIterateLocalActor($index, $offset, $count)
	While IterateLocalActorList($index, $offset, $count, $item)
		If StringInStr($item[1], "GoldCoin-") Then
			$GOLD = IterateActorAttributes($item[0], $Atrib_ItemStackQuantityLo)
			ExitLoop
		EndIf
	WEnd

	If $Totalruns = 1 Then
		$GOLDINI = $GOLD
		$begin_timer_stat = TimerInit()
		$GF = Ceiling(GetAttribute($_MyGuid, $Atrib_Gold_Find) * 100)
		$MF = Ceiling(GetAttribute($_MyGuid, $Atrib_Magic_Find) * 100)
		$PR = GetAttribute($_MyGuid, $Atrib_Gold_PickUp_Radius)
		$MS = (GetAttribute($_MyGuid, $Atrib_Movement_Scalar_Capped_Total) - 1) * 100
		$EBP = Ceiling(GetAttribute($_MyGuid, $Atrib_Experience_Bonus_Percent) * 100);% xp équipement
		$LV = GetAttribute($_MyGuid, $Atrib_Level);level personage
	Else
		$GOLDInthepocket = $GOLD - $GOLDINI
		$GOLDMOY = $GOLDInthepocket / ($Totalruns - 1)
		$dif_timer_stat = TimerDiff($begin_timer_stat);temps total
		$dif_timer_stat_pause = ($tempsPauseGame + $tempsPauserepas);calcule du temps de pause (game + repas)=total pause
		$dif_timer_stat_game = ($dif_timer_stat - $dif_timer_stat_pause);calcule (temps totale - temps total pause)=Temps de jeu
		$GOLDMOYbyH = $GOLDInthepocket * 3600000 / $dif_timer_stat;calcule du gold a l'heure temps total
		$GOLDMOYbyHgame = $GOLDInthepocket * 3600000 / $dif_timer_stat_game;calcule du gold a l'heure temp de jeu

	EndIf

	;stat XP

	;Xp nécessaire pour passer un niveau de paragon

	If $Totalruns = 1 Then
		Global $level[102]
		$level[1] = 7200000
		$level[2] = 8640000
		$level[3] = 10080000
		$level[4] = 11520000
		$level[5] = 12960000
		$level[6] = 14400000
		$level[7] = 15840000
		$level[8] = 17280000
		$level[9] = 18720000
		$level[10] = 20160000
		$level[11] = 21600000
		$level[12] = 23040000
		$level[13] = 24480000
		$level[14] = 25920000
		$level[15] = 27360000
		$level[16] = 28800000
		$level[17] = 30240000
		$level[18] = 31680000
		$level[19] = 33120000
		$level[20] = 34560000
		$level[21] = 36000000
		$level[22] = 37440000
		$level[23] = 38880000
		$level[24] = 40320000
		$level[25] = 41760000
		$level[26] = 43200000
		$level[27] = 44640000
		$level[28] = 46080000
		$level[29] = 47520000
		$level[30] = 48960000
		$level[31] = 50400000
		$level[32] = 51840000
		$level[33] = 53280000
		$level[34] = 54720000
		$level[35] = 56160000
		$level[36] = 57600000
		$level[37] = 59040000
		$level[38] = 60480000
		$level[39] = 61920000
		$level[40] = 63360000
		$level[41] = 64800000
		$level[42] = 66240000
		$level[43] = 67680000
		$level[44] = 69120000
		$level[45] = 70560000
		$level[46] = 72000000
		$level[47] = 73440000
		$level[48] = 74880000
		$level[49] = 76320000
		$level[50] = 77760000
		$level[51] = 79200000
		$level[52] = 80640000
		$level[53] = 82080000
		$level[54] = 83520000
		$level[55] = 84960000
		$level[56] = 86400000
		$level[57] = 87840000
		$level[58] = 89280000
		$level[59] = 90720000
		$level[60] = 92160000
		$level[61] = 95040000
		$level[62] = 97920000
		$level[63] = 100800000
		$level[64] = 103680000
		$level[65] = 106560000
		$level[66] = 109440000
		$level[67] = 112320000
		$level[68] = 115200000
		$level[69] = 118080000
		$level[70] = 120960000
		$level[71] = 126000000
		$level[72] = 131040000
		$level[73] = 136080000
		$level[74] = 141120000
		$level[75] = 146160000
		$level[76] = 151200000
		$level[77] = 156240000
		$level[78] = 161280000
		$level[79] = 166320000
		$level[80] = 171360000
		$level[81] = 177840000
		$level[82] = 184320000
		$level[83] = 190800000
		$level[84] = 197280000
		$level[85] = 203760000
		$level[86] = 210240000
		$level[87] = 216720000
		$level[88] = 223200000
		$level[89] = 229680000
		$level[90] = 236160000
		$level[91] = 244800000
		$level[92] = 253440000
		$level[93] = 262080000
		$level[94] = 270720000
		$level[95] = 279360000
		$level[96] = 288000000
		$level[97] = 296640000
		$level[98] = 305280000
		$level[99] = 313920000
		$level[100] = 322560000
		$level[101] = 0
	EndIf

	If $Totalruns = 1 Then

		$NiveauParagon = GetAttribute($_MyGuid, $Atrib_Alt_Level)
		$ExperienceNextLevel = GetAttribute($_MyGuid, $Atrib_Alt_Experience_Next)
		$Expencours = $level[$NiveauParagon + 1] - $ExperienceNextLevel
		$Xp_Run = 0
		$Xp_Total = 0
		$Xp_Moy_Run = 0
		$Xp_Moy_Hrs = 0
		$time_Xp = 0
		$time_Xp = FormatTime($time_Xp)

	Else
		;calcul de l'xp du run
		If $NiveauParagon = GetAttribute($_MyGuid, $Atrib_Alt_Level) Then; verification de level up (égalité => pas de level up

			$Xp_Run = ($level[GetAttribute($_MyGuid, $Atrib_Alt_Level) + 1] - GetAttribute($_MyGuid, $Atrib_Alt_Experience_Next)) - $Expencours;experience run n - experience run n-1

		EndIf

		$Expencours = $level[GetAttribute($_MyGuid, $Atrib_Alt_Level) + 1] - GetAttribute($_MyGuid, $Atrib_Alt_Experience_Next)

		If $NiveauParagon <> GetAttribute($_MyGuid, $Atrib_Alt_Level) Then

			$Xp_Run = $ExperienceNextLevel + $Expencours

		EndIf


		$Xp_Total = $Xp_Total + $Xp_Run
		$Xp_Moy_Run = $Xp_Total / ($Totalruns - 1)
		$Xp_Moy_Hrs = $Xp_Total * 3600000 / $dif_timer_stat;on calcul l'xp/heure en temps total
		$Xp_Moy_Hrsgame = $Xp_Total * 3600000 / $dif_timer_stat_game;on calcul l'xp/heure en temps de jen
		$Xp_Moy_HrsPerte = ($Xp_Moy_Hrsgame - $Xp_Moy_Hrs);on calcule la perte du au pause
		$NiveauParagon = GetAttribute($_MyGuid, $Atrib_Alt_Level)
		$ExperienceNextLevel = GetAttribute($_MyGuid, $Atrib_Alt_Experience_Next)

		;calcul temps avant prochain niveau
		$Xp_Moy_Sec = $Xp_Total * 1000 / $dif_timer_stat
		$time_Xp = Int($ExperienceNextLevel / $Xp_Moy_Sec) * 1000
		$time_Xp = FormatTime($time_Xp)

		;<<<<<<<<<<<<<<<<<<<<<<<<< début ajouter pour paragon dans 100 >>>>>>>>>>>>>>>>>>>>>>>>>>>>
		;; calcul de l'experience total puis temps nécessaire pour atteindre le paragon 100
		;; et 99 exclu c'est le dernier level
		If $NiveauParagon < 99 Then
			;; xp restant à faire pour le level paragon en cours
			$ExperienceFullParagon = $ExperienceNextLevel
			;; on ajoute les n+1 levels paragons restants
			$current_paragon_level = $NiveauParagon + 1
			While $current_paragon_level <> 101
				$ExperienceFullParagon += $level[$current_paragon_level]
				$current_paragon_level += 1
			WEnd
			; calcul temps avant paragon 100
			$time_Xp_Full_Paragon = Int($ExperienceFullParagon / $Xp_Moy_Sec) * 1000
			$time_Xp_Full_Paragon = FormatTime($time_Xp_Full_Paragon)
		Else
			;; cas du dernier level 99 ou alors paragon 100 deja atteind
			If $NiveauParagon = 99 Then
				;; on utilise le calcul existant
				$time_Xp_Full_Paragon = $time_Xp
			Else
				$time_Xp_Full_Paragon = "ALREADY 100 !!!"
			EndIf
		EndIf
		;<<<<<<<<<<<<<<<<<<<<<<<<< fin ajouter pour paragon dans 100 >>>>>>>>>>>>>>>>>>>>>>>>>>>>
	EndIf
	;########

	$timer_stat_total = FormatTime($dif_timer_stat);temps Total

	If $Totalruns = 1 Then
		$timer_stat_run_moyen = 0
		;Lv_stat=lv
		;Xp_next_stat=Xp_next
		;Xprun=0
		;Xptotal=0
		;Xpmoyen=0
	Else
		;;;$dif_timer_stat_moyen = $dif_timer_stat / ($Totalruns - 1)
		$dif_timer_stat_moyen = $dif_timer_stat_game / ($Totalruns - 1);on recalcule le temps moyen d'une run par raport au temps jeu
		$timer_stat_run_moyen = FormatTime($dif_timer_stat_moyen)
	EndIf

	GetAct()
	GetMonsterPow()
	$DebugMessage = "                                 INFO RUNS ACT " & $Act & @CRLF
	$DebugMessage = $DebugMessage & "PM " & $MP & @CRLF
	$DebugMessage = $DebugMessage & "Runs : " & $Totalruns & @CRLF
	$DebugMessage = $DebugMessage & "Morts : " & $Death & @CRLF
	$DebugMessage = $DebugMessage & "Resurrections : " & $Res_compt & @CRLF
	$DebugMessage = $DebugMessage & "Déconnexions  : " & $disconnectcount & @CRLF
	$DebugMessage = $DebugMessage & "Sanctuaires Pris : " & $CheckTakeShrineTaken & @CRLF
	$DebugMessage = $DebugMessage & "Élites Rencontrés : " & $CptElite & @CRLF
	$DebugMessage = $DebugMessage & "Succès Runs : " & Round($successratio * 100) & "%   ( " & ($Totalruns - $success) & " Avortés )" & @CRLF
	$DebugMessage = $DebugMessage & "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" & @CRLF
	$DebugMessage = $DebugMessage & "                                   INFO COFFRE" & @CRLF
	$DebugMessage = $DebugMessage & "Nombre Objets Recylés : " & $ItemToRecycle & @CRLF
	$DebugMessage = $DebugMessage & "Nombre de Legs au Coffre : " & $nbLegs & @CRLF
	$DebugMessage = $DebugMessage & "Nombre de Rare ID au Coffre : " & $nbRares & @CRLF
	$DebugMessage = $DebugMessage & "Nombre de Rare Unid au Coffre : " & $nbRaresUnid & @CRLF
	$DebugMessage = $DebugMessage & "Objets Stockés Dans le Coffre : " & $ItemToStash & @CRLF
	$DebugMessage = $DebugMessage & "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" & @CRLF
	$DebugMessage = $DebugMessage & "                                     INFO GOLD" & @CRLF
	$DebugMessage = $DebugMessage & "Gold au Coffre : " & FormatNumber(Ceiling($GOLD)) & @CRLF
	$DebugMessage = $DebugMessage & "Gold Total Obtenu  : " & FormatNumber(Ceiling($GOLDInthepocket)) & @CRLF
	$DebugMessage = $DebugMessage & "Gold Moyen/Run : " & FormatNumber(Ceiling($GOLDMOY)) & @CRLF
	$DebugMessage = $DebugMessage & "Gold Moyen/Heure : " & FormatNumber(Ceiling($GOLDMOYbyH)) & @CRLF
	;$DebugMessage = $DebugMessage & "Gold Moyen/Heure Jeu : " & formatNumber(Ceiling($GOLDMOYbyHgame)) & @CRLF ;====> gold de temps de jeu
	$DebugMessage = $DebugMessage & "Perte Moyenne/Heure : " & FormatNumber(Ceiling($GOLDMOYbyH - $GOLDMOYbyHgame)) & "   (" & Round(($GOLDMOYbyHgame - $GOLDMOYbyH) / $GOLDMOYbyHgame * 100) & "%)" & @CRLF
	$DebugMessage = $DebugMessage & "Nombre d'objet Vendu :  " & $ItemToSell & "  /  " & FormatNumber(Ceiling($GoldBySale)) & "   (" & Round($GoldBySale / $GOLDInthepocket * 100) & "%)" & @CRLF
	$DebugMessage = $DebugMessage & "Gold Obtenu par Collecte  :    " & FormatNumber(Ceiling($GOLDInthepocket - $GoldBySale - $GoldByRepaire)) & "   (" & Round(($GOLDInthepocket - $GoldBySale - $GoldByRepaire) / $GOLDInthepocket * 100) & "%)" & @CRLF
	$DebugMessage = $DebugMessage & "Nombre de Réparation : " & $RepairORsell & " / " & FormatNumber(Ceiling($GoldByRepaire)) & "   (" & Round($GoldByRepaire / $GOLDInthepocket * 100) & "%)" & @CRLF
	$DebugMessage = $DebugMessage & "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" & @CRLF
	$DebugMessage = $DebugMessage & "                                     INFO TEMPS " & @CRLF
	;$DebugMessage = $DebugMessage & "Débuté à :  " & @HOUR & ":" & @MIN & @CRLF
	$DebugMessage = $DebugMessage & "Durée Moyenne/Run : " & $timer_stat_run_moyen & @CRLF
	$DebugMessage = $DebugMessage & "Temps Total De Bot:   " & $timer_stat_total & @CRLF
	$DebugMessage = $DebugMessage & "Temps Total En Jeu :   " & FormatTime($dif_timer_stat_game) & " (" & Round($dif_timer_stat_game / $dif_timer_stat * 100) & "%)" & @CRLF
	$DebugMessage = $DebugMessage & "Pauses Effectuées : " & ($BreakTimeCounter + $PauseRepasCounter) & "  /  " & FormatTime($dif_timer_stat_pause) & " (" & Round($dif_timer_stat_pause / $dif_timer_stat * 100) & "%)" & @CRLF
	;stats XP
	$DebugMessage = $DebugMessage & "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" & @CRLF
	$DebugMessage = $DebugMessage & "                                        INFO XP" & @CRLF
	$DebugMessage = $DebugMessage & "Bonus d'XP : " & $EBP & " %" & @CRLF

	If ($Xp_Total < 1000000) Then ;afficher en "K"
		$DebugMessage = $DebugMessage & "XP Obtenu : " & Int($Xp_Total / 1000) & " K" & @CRLF
	EndIf
	If ($Xp_Total > 999999) Then ;afficher en "M"
		$DebugMessage = $DebugMessage & "XP Obtenu : " & Int($Xp_Total / 1000) / 1000 & " M" & @CRLF
	EndIf

	If ($Xp_Moy_Run < 1000000) Then ;afficher en "K"
		$DebugMessage = $DebugMessage & "XP Moyen/Run : " & Int($Xp_Moy_Run / 1000) & " K" & @CRLF
	EndIf
	If ($Xp_Moy_Run > 999999) Then ;afficher en "M"
		$DebugMessage = $DebugMessage & "XP Moyen/Run : " & Int($Xp_Moy_Run / 1000) / 1000 & " M" & @CRLF
	EndIf

	If ($Xp_Moy_Hrs < 1000000) Then ;afficher en "K"
		$DebugMessage = $DebugMessage & "XP Moyen/Heure : " & Int($Xp_Moy_Hrs / 1000) & " K" & @CRLF
	EndIf
	If ($Xp_Moy_Hrs > 999999) Then ;afficher en "M"
		$DebugMessage = $DebugMessage & "XP Moyen/Heure : " & Int($Xp_Moy_Hrs / 1000) / 1000 & " M" & @CRLF
	EndIf
	#cs   If ($Xp_Moy_Hrsgame < 1000000) Then ;afficher en "K" ===> xp/h Temps de jeu
		$DebugMessage = $DebugMessage & "XP Moyen/Heure Jeu: " & Int($Xp_Moy_Hrsgame / 1000) & " K" & @CRLF
		EndIf
		If ($Xp_Moy_Hrsgame > 999999) Then ;afficher en "M" ===> xp/h Temps de jeu
		$DebugMessage = $DebugMessage & "XP Moyen/Heure Jeu: " & Int($Xp_Moy_Hrsgame / 1000) / 1000 & " M" & @CRLF
	#ce   EndIf
	If ($Xp_Moy_HrsPerte < 1000000) Then ;afficher en "K"
		$DebugMessage = $DebugMessage & "Perte Moyenne/Heure : -" & Int($Xp_Moy_HrsPerte / 1000) & " K (" & Round($Xp_Moy_HrsPerte / $Xp_Moy_Hrsgame * 100) & "%)" & @CRLF
	EndIf
	If ($Xp_Moy_HrsPerte > 999999) Then ;afficher en "M"
		$DebugMessage = $DebugMessage & "Perte Moyenne/Heure : -" & Int($Xp_Moy_HrsPerte / 1000) / 1000 & " M (" & Round($Xp_Moy_HrsPerte / $Xp_Moy_Hrsgame * 100) & "%)" & @CRLF
	EndIf
	;$DebugMessage = $DebugMessage & "temps avant prochain niveau : " $ExperienceNextLevel/ & " M" & @CRLF
	$DebugMessage = $DebugMessage & "Temps Avant Prochain LV : " & $time_Xp & @CRLF
	$DebugMessage = $DebugMessage & "Temps Avant Parangon 100 : " & $time_Xp_Full_Paragon & @CRLF
	$DebugMessage = $DebugMessage & "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" & @CRLF
	;$DebugMessage = $DebugMessage & "XP Moyen par heure : " & $Xp_Moy_Hrs & @CRLF
	;$DebugMessage = $DebugMessage & "XP avant prochain niveau : " & int($ExperienceNextLevel/1000)/1000 &" M" & @CRLF
	;$DebugMessage = $DebugMessage & "niveau paragon actuel : " & $NiveauParagon & @CRLF

	;$DebugMessage = $DebugMessage & "#################################"& @CRLF

	;$DebugMessage = $DebugMessage & "test 1 : " & $level[$NiveauParagon+1] & @CRLF
	;$DebugMessage = $DebugMessage & "exp en cours : " & int($Expencours/1000)/1000 &" M" &@CRLF
	;$DebugMessage = $DebugMessage & "Xp_Run : " & int($Xp_Run/1000)/1000 &" M" &@CRLF
	;$DebugMessage = $DebugMessage & "#################################"& @CRLF
	;#########


	$DebugMessage = $DebugMessage & "                                    INFO PERSO " & @CRLF
	$DebugMessage = $DebugMessage & $nameCharacter & "  " & $LV & " [ " & $NiveauParagon & " ] " & @CRLF
	$DebugMessage = $DebugMessage & "PickUp Radius  : " & $PR & @CRLF
	$DebugMessage = $DebugMessage & "Movement Speed : " & Round($MS) & " %" & @CRLF
	$DebugMessage = $DebugMessage & "Gold Find Total      : " & ($GF + ($NiveauParagon * 3) + ($MP * 25)) & " %" & @CRLF
	$DebugMessage = $DebugMessage & "      Équipement : " & $GF & " %" & @CRLF
	$DebugMessage = $DebugMessage & "Magic Find Total     : " & ($MF + ($NiveauParagon * 3) + ($MP * 25)) & " %" & @CRLF
	$DebugMessage = $DebugMessage & "      Équipement : " & $MF & " %" & @CRLF
	$DebugMessage = $DebugMessage & "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" & @CRLF
	Switch $Choix_Act_Run
		Case -1
			$file = FileOpen($fileLog, 0)
			$line = FileReadLine($file, 1)
			$DebugMessage = $DebugMessage & $line & @CRLF
			$line = FileReadLine($file, $numLigneFichier)
			$DebugMessage = $DebugMessage & $line & @CRLF
			FileClose($file)
		Case 0
			$DebugMessage = $DebugMessage & "Mode normal" & @CRLF
		Case 1
			$DebugMessage = $DebugMessage & "Act 1 en automatique" & @CRLF
		Case 2
			$DebugMessage = $DebugMessage & "Act 2 en automatique" & @CRLF
		Case 3
			$DebugMessage = $DebugMessage & "Act 3 en automatique" & @CRLF
	EndSwitch



	$MESSAGE = $DebugMessage
	ToolTip($MESSAGE, $DebugX, $DebugY)

	$Totalruns = $Totalruns + 1 ;compte le nombre de run

EndFunc   ;==>StatsDisplay

;;--------------------------------------------------------------------------------
; Function:             FormatTime()
; Description:          Format time by length
;
; Note(s): faster than YoPens : 100% if < 1mn, 150% if < 1h, 30% if more
;;--------------------------------------------------------------------------------
Func FormatTime($MS)
	Switch $MS
		Case 0 To 59999 ; less than 1 mn
			Return Round(($MS / 1000), 2) & " s"
		Case 60000 To 359999 ; 1 mn to 1 hour
			Return Int($MS / 60000) & " mn " & Round(($MS / 1000) - Int(Int($MS / 60000) * 60)) & " s"
		Case Else ; more than 1 hour
			Return Int($MS / 3600000) & "h " & Int((Int($MS / 60000) - Int(Int($MS / 3600000) * 3600) / 60)) & "mn " & Round(($MS / 1000) - Int($MS / 3600000) * 3600 - Int(Int($MS / 60000) - Int(Int($MS / 3600000) * 3600) / 60) * 60) & "s"
	EndSwitch
	Return $MS
EndFunc   ;==>FormatTime

;;--------------------------------------------------------------------------------
; Function:                     EmergencyStopCheck()
; Description:          Check for dangerous behavior and stop bot if needed to prevent problems
;
; Note(s):
;;--------------------------------------------------------------------------------
Func EmergencyStopCheck()

	If $DieTooFastCount > 6 Then
		WinSetOnTop("[CLASS:D3 Main Window Class]", "", 0)
		MsgBox(4096, "Arret d'urgence", "Nombre de mort : " & $Death)
		Terminate()
	EndIf

	If $NeedRepairCount > 4 Then
		WinSetOnTop("[CLASS:D3 Main Window Class]", "", 0)
		MsgBox(4096, "Arret d'urgence", "Nombre de tentatives de repair a la suite : " & $NeedRepairCount)
		Terminate()
	EndIf

EndFunc   ;==>EmergencyStopCheck

;;--------------------------------------------------------------------------------
; Function:                     CheckEnoughPotions()
; Description:    Read amount of pot in inv. Compare with Potionstock and set takepot to true of false.
;
;
;;--------------------------------------------------------------------------------
Func CheckEnoughPotions()
	Local $potinstock = Number(FastCheckUiValue('Root.NormalLayer.game_dialog_backgroundScreenPC.game_potion.text', 1, 875))
	If $potinstock > $PotionStock Then
		_Log("I have more than " & $PotionStock & " potions. I will not take more until next check " & "(" & $potinstock & ")")
		$takepot = False
	Else
		_Log("I have less than " & $PotionStock & " potions. I will grab them until next check " & "pot:" & "(" & $potinstock & ")")
		$takepot = True
	EndIf
EndFunc   ;==>CheckEnoughPotions

;;--------------------------------------------------------------------------------
; Function:                     CheckTakeShrine()
; Description:    Take Bonus CheckTakeShrine
;;--------------------------------------------------------------------------------
Func CheckTakeShrine($name, $offset, $Guid)

	Local $begin = TimerInit()

	While IterateActorAttributes($Guid, $Atrib_gizmo_state) <> 1 And IsPlayerDead() = False

		If GetDistance(_MemoryRead($offset + 0xB0, $d3, 'float'), _MemoryRead($offset + 0xB4, $d3, 'float'), _MemoryRead($offset + 0xB8, $d3, 'float')) >= 8 Then
			If TimerDiff($begin) > 4000 Then
				_Log('CheckTakeShrine is banned because time out')
				Return False
				ExitLoop
			Else

				$Coords = FromD3ToScreenCoords(_MemoryRead($offset + 0xB0, $d3, 'float'), _MemoryRead($offset + 0xB4, $d3, 'float'), _MemoryRead($offset + 0xB8, $d3, 'float'))
				MouseMove($Coords[0], $Coords[1], 3)

			EndIf

		EndIf

		If TimerDiff($begin) > 6000 Then
			_Log('Fake CheckTakeShrine')
			Return False
		EndIf

		Interact(_MemoryRead($offset + 0xB0, $d3, 'float'), _MemoryRead($offset + 0xB4, $d3, 'float'), _MemoryRead($offset + 0xB8, $d3, 'float'))

	WEnd

	$CheckTakeShrineTaken += 1;on compte les CheckTakeShrine qu'on prend

EndFunc   ;==>CheckTakeShrine

;;--------------------------------------------------------------------------------
; Function:                     DieTooFast()
; Description:    Cette fonction est appelée toute les 20 min.
;
; Note(s): Permet de detecter un nombre de mort a la suite trop important
;;--------------------------------------------------------------------------------
Func DieTooFast()
	$DieTooFastCount = 0
EndFunc   ;==>DieTooFast

;;--------------------------------------------------------------------------------
; Functions:                     Attrib STUFF
; Description:    Read Atrib without dll
;;--------------------------------------------------------------------------------

Func GetFAG($idAttrib)
	$c = _memoryread($ofs_objectmanager, $d3, "ptr")
	$c1 = _memoryread($c + 0x894, $d3, "ptr")
	$c2 = _memoryread($c1 + 0x70, $d3, "ptr")

	$id = BitAND($idAttrib, 0xFFFF)

	$bitshift = _memoryread($c2 + 0x18C, $d3, "int")
	$group1 = _memoryread(_memoryread($c2 + 0x148, $d3, "ptr"), $d3, "int")
	$group2 = 4 * BitShift($id, $bitshift)
	$group3 = BitShift(1, -$bitshift) - 1
	$group4 = 0x180 * BitAND($id, $group3)
	Return $group2 + $group4 + $group1
EndFunc   ;==>GetFAG

Func GetAttributeOfs($idAttrib, $attrib)
	$FAG = GetFAG($idAttrib)
	$temp1 = _memoryread(_memoryread($FAG + 0x10, $d3, "ptr") + 8, $d3, "int")
	$temp2 = _memoryread(_memoryread($FAG + 0x10, $d3, "ptr") + 0x418, $d3, "int")
	$temp3 = BitXOR($attrib, BitShift($attrib, 16))
	$temp4 = 4 * BitAND($temp2, $temp3)
	$attribEntry = _memoryread($temp1 + $temp4, $d3, "int")

	If $attribEntry <> 0 Then
		While _memoryread($attribEntry + 4, $d3, "int") <> $attrib
			$attribEntry = _memoryread($attribEntry, $d3, "int")
			If $attribEntry == 0 Then
				Return -1
			EndIf
		WEnd
		Return $attribEntry + 8
	EndIf
	Return -1
EndFunc   ;==>GetAttributeOfs

Func GetAttributeInt($idAttrib, $attrib)
	Return _memoryread(GetAttributeOfs($idAttrib, BitOR($attrib, 0xFFFFF000)), $d3, "int")
EndFunc   ;==>GetAttributeInt

Func GetAttributeFloat($idAttrib, $attrib)
	Return _memoryread(GetAttributeOfs($idAttrib, BitOR($attrib, 0xFFFFF000)), $d3, "float")
EndFunc   ;==>GetAttributeFloat


Func IsPowerReady($idAttrib, $idPower)
	Return _memoryread(GetAttributeOfs($idAttrib, BitOR($Atrib_Power_Cooldown[0], BitShift($idPower, -12))), $d3, "int") <= 0
EndFunc   ;==>IsPowerReady

Func IsBuffActive($idAttrib, $idPower)
	Return _memoryread(GetAttributeOfs($idAttrib, BitOR($Atrib_Buff_Active[0], BitShift($idPower, -12))), $d3, "int") == 1
EndFunc   ;==>IsBuffActive

Func CastSpell($i)

	Dim $buff_table[11]
	Switch $i

		Case 0
			$buff_table = $Skill1
		Case 1
			$buff_table = $Skill2
		Case 2
			$buff_table = $Skill3
		Case 3
			$buff_table = $Skill4
		Case 4
			$buff_table = $Skill5
		Case 5
			$buff_table = $Skill6
	EndSwitch

	If $buff_table[1] = False Then
		Switch $buff_table[6]
			Case "right"
				MouseClick("right")
			Case "left"
				MouseClick("left")
			Case Else
				Send($buff_table[6])
		EndSwitch
		Sleep(10)

	ElseIf $buff_table[1] And IsPowerReady($_MyGuid, $buff_table[9]) Then
		Switch $buff_table[6]
			Case "right"
				MouseClick("right")
			Case "left"
				MouseClick("left")
			Case Else

				Send($buff_table[6])

		EndSwitch
;~ 		Sleep(10)

	EndIf

EndFunc   ;==>CastSpell

Func GetResource($idAttrib, $resource)
	If $resource <> "" Then
		Switch $resource
			Case "spirit"
				$source = 0x3000
				$MaximumSource = $MaximumSpirit
			Case "fury"
				$source = 0x2000
				$MaximumSource = $MaximumFury
			Case "arcane"
				$source = 0x1000
				$MaximumSource = $MaximumArcane
			Case "mana"
				$source = 0
				$MaximumSource = $MaximumMana
			Case "hatred"
				$source = 0x5000
				$MaximumSource = $MaximumHatred
			Case "discipline"
				$MaximumSource = $MaximumDiscipline
				$source = 0x6000
		EndSwitch
		Return _memoryread(GetAttributeOfs($idAttrib, BitOR($Atrib_Resource_Cur[0], $source)), $d3, "float") / $MaximumSource
	Else
		Return 1
	EndIf
EndFunc   ;==>GetResource

Func ManageSpellCasting($Distance, $action_spell, $elite, $Guid = 0, $offset = 0)

	; $action_spell = 0 -> movetopos
	; $action_spell = 1 -> attack
	; $action_spell = 2 -> grab

	CheckDrinkPotion()

	For $i = 0 To 5

		Dim $buff_table[11]

		Switch $i

			Case 0
				$buff_table = $Skill1
			Case 1
				$buff_table = $Skill2
			Case 2
				$buff_table = $Skill3
			Case 3
				$buff_table = $Skill4
			Case 4
				$buff_table = $Skill5
			Case 5
				$buff_table = $Skill6
		EndSwitch



		Switch $buff_table[5]
			Case "spirit"
;~ 				$source = 0x3000
				$MaximumSource = $MaximumSpirit
			Case "fury"
;~ 				$source = 0x2000
				$MaximumSource = $MaximumFury
			Case "arcane"
;~ 				$source = 0x1000
				$MaximumSource = $MaximumArcane
			Case "mana"
;~ 				$source = 0
				$MaximumSource = $MaximumMana
			Case "hatred"
;~ 				$source = 0x5000
				$MaximumSource = $MaximumHatred
			Case "discipline"
				$MaximumSource = $MaximumDiscipline
;~ 				$source = 0x6000
			Case Else
				$MaximumSource = 15000
;~ 				$source = 5000
		EndSwitch

		$source = GetResource($_MyGuid, $buff_table[5])

		If $buff_table[0] And ($source > $buff_table[4] / $MaximumSource Or $buff_table[5] = "") And (TimerDiff($buff_table[10]) > $buff_table[2] Or $buff_table[2] = "") Then ;skill Activé

			Switch $action_spell

				Case 0
					Switch $buff_table[3]
						Case 0
							If GetLifeLeftPercent() <= $buff_table[7] / 100 Then
								CastSpell($i)
								$buff_table[10] = TimerInit()
							EndIf

						Case 7
							If Not IsBuffActive($_MyGuid, $buff_table[9]) Then
;~ 					$timer_buff = TimerInit()
								If $nameCharacter = "DemonHunter" Then
									If IsBuffActive($_MyGuid, $DemonHunter_Chakram) = False Then

										Send("1")

									EndIf
								EndIf
								CastSpell($i)

								$buff_table[10] = TimerInit()
							EndIf


						Case 9
							If GetLifeLeftPercent() <= $buff_table[7] / 100 Or ($Distance <= $buff_table[8] Or $buff_table[8] = "") Then
								CastSpell($i)
								$buff_table[10] = TimerInit()
							EndIf

						Case 10
							If ($Distance <= $buff_table[8] Or $buff_table[8] = "") Or $action_spell <> 1 Then
								CastSpell($i)
								$buff_table[10] = TimerInit()
							EndIf

						Case 11
							If IsBuffActive($_MyGuid, $buff_table[9]) = False Or GetLifeLeftPercent() <= $buff_table[7] / 100 Then
								CastSpell($i)
								$buff_table[10] = TimerInit()
							EndIf

						Case 12
							If IsBuffActive($_MyGuid, $buff_table[9]) = False Or GetLifeLeftPercent() <= $buff_table[7] / 100 Then
								CastSpell($i)
								$buff_table[10] = TimerInit()
							EndIf


						Case 16
							If GetLifeLeftPercent() <= $buff_table[7] / 100 Or $elite > 0 Then
								CastSpell($i)
								$buff_table[10] = TimerInit()
							EndIf

						Case 22
							CastSpell($i)
							$buff_table[10] = TimerInit()


					EndSwitch

				Case 1


					Switch $buff_table[3]
						Case 0
							If GetLifeLeftPercent() <= $buff_table[7] / 100 Then
								CastSpell($i)
								$buff_table[10] = TimerInit()
							EndIf

						Case 1
							If $Distance <= $buff_table[8] Or $buff_table[8] = "" Then
								CastSpell($i)
								$buff_table[10] = TimerInit()
							EndIf


						Case 2
							CastSpell($i)

						Case 3
							If $elite > 0 Then
								CastSpell($i)
								$buff_table[10] = TimerInit()

							EndIf

						Case 4
							If Not IsBuffActive($_MyGuid, $buff_table[9]) And $action_spell = 1 Then

								CastSpell($i)
								$buff_table[10] = TimerInit()
							EndIf


						Case 5
;~ 			    local $IgnoreList=""
							;Not IsBuffActive($_MyGuid, $buff_table[9]) And
							If $buff_table[8] = "" Then
								$dist = 20
							Else
								$dist = $buff_table[8]
							EndIf

							If $action_spell = 1 And IterateFilterZone($dist) Then
								_Log("mauvais click droit")
								CastSpell($i)
								$buff_table[10] = TimerInit()
							EndIf


						Case 6
;~ 			    local $IgnoreList=""
							If IsBuffActive($_MyGuid, $buff_table[9]) = False Then
								If $buff_table[8] = "" Then
									$dist = 20
								Else
									$dist = $buff_table[8]
								EndIf
								If IterateFilterZone($dist) Then
									CastSpell($i)
									$buff_table[10] = TimerInit()
								EndIf
							EndIf


						Case 8
							If GetLifeLeftPercent() <= $buff_table[7] / 100 And ($Distance <= $buff_table[8] Or $buff_table[8] = "") Then
								CastSpell($i)
								$buff_table[10] = TimerInit()
							EndIf
						Case 11
							If IsBuffActive($_MyGuid, $buff_table[9]) = False Or GetLifeLeftPercent() <= $buff_table[7] / 100 Then
								CastSpell($i)
								$buff_table[10] = TimerInit()
							EndIf

						Case 13
							If IsBuffActive($_MyGuid, $buff_table[9]) = False And GetLifeLeftPercent() <= $buff_table[7] / 100 Then
								CastSpell($i)
								$buff_table[10] = TimerInit()
							EndIf

						Case 14
							If IsBuffActive($_MyGuid, $buff_table[9]) = False Or ($Distance <= $buff_table[8] Or $buff_table[8] = "") Then
								CastSpell($i)
								$buff_table[10] = TimerInit()
							EndIf

						Case 15
							If IsBuffActive($_MyGuid, $buff_table[9]) = False And ($Distance <= $buff_table[8] Or $buff_table[8] = "") Then
								CastSpell($i)
								$buff_table[10] = TimerInit()
							EndIf


						Case 17
							If GetLifeLeftPercent() <= $buff_table[7] / 100 And $elite > 0 Then
								CastSpell($i)
								$buff_table[10] = TimerInit()
							EndIf

						Case 18
							If ($Distance <= $buff_table[8] Or $buff_table[8] = "") Or $elite > 0 Then
								CastSpell($i)
								$buff_table[10] = TimerInit()
							EndIf

						Case 19
							If ($Distance <= $buff_table[8] Or $buff_table[8] = "") And $elite > 0 Then
								CastSpell($i)
								$buff_table[10] = TimerInit()
							EndIf

						Case 20
							If IsBuffActive($_MyGuid, $buff_table[9]) = False And $elite > 0 Then
								CastSpell($i)
								$buff_table[10] = TimerInit()
							EndIf

						Case 21
							If IsBuffActive($_MyGuid, $buff_table[9]) = False Or $elite > 0 Then
								CastSpell($i)
								$buff_table[10] = TimerInit()
							EndIf

						Case 22
							CastSpell($i)
							$buff_table[10] = TimerInit()

					EndSwitch

				Case 2
					Switch $buff_table[3]
						Case 0
							If GetLifeLeftPercent() <= $buff_table[7] / 100 Then
								CastSpell($i)
								$buff_table[10] = TimerInit()
							EndIf
						Case 22
							CastSpell($i)
							$buff_table[10] = TimerInit()

						Case 7
							If Not IsBuffActive($_MyGuid, $buff_table[9]) Then
								$timer_buff = TimerInit()
								If IsBuffActive($_MyGuid, $DemonHunter_Chakram) = False Then

									If $nameCharacter = "DemonHunter" Then Send("1")

								EndIf
								CastSpell($i)

;~ 					Send("{" & $buff_table[6] & " down}")
;~ 					While Not IsBuffActive($_MyGuid, $buff_table[9])
;~ 						If TimerDiff($timer_buff) > 350 Then ExitLoop
;~ 						Sleep(50)
;~ 					WEnd
;~ 					Send("{" & $buff_table[6] & " up}")
								$buff_table[10] = TimerInit()
							EndIf

					EndSwitch
			EndSwitch


		EndIf

		If $i = 0 Then
			$Skill1 = $buff_table
		ElseIf $i = 1 Then
			$Skill2 = $buff_table
		ElseIf $i = 2 Then
			$Skill3 = $buff_table
		ElseIf $i = 3 Then
			$Skill4 = $buff_table
		ElseIf $i = 4 Then
			$Skill5 = $buff_table
		ElseIf $i = 5 Then
			$Skill6 = $buff_table
		EndIf

	Next

EndFunc   ;==>ManageSpellCasting

Func ManageSpellInit()

	For $i = 0 To 5

		Dim $buff_table[11]
		Dim $buff_conf_table[6]

		If $i = 0 Then
			$buff_conf_table = $Skill_conf1
			$buff_table = $Skill1
		ElseIf $i = 1 Then
			$buff_conf_table = $Skill_conf2
			$buff_table = $Skill2
		ElseIf $i = 2 Then
			$buff_conf_table = $Skill_conf3
			$buff_table = $Skill3
		ElseIf $i = 3 Then
			$buff_conf_table = $Skill_conf4
			$buff_table = $Skill4
		ElseIf $i = 4 Then
			$buff_conf_table = $Skill_conf5
			$buff_table = $Skill5
		ElseIf $i = 5 Then
			$buff_conf_table = $Skill_conf6
			$buff_table = $Skill6
		EndIf


		If Not $buff_conf_table[0] Or $buff_conf_table[0] = "false" Then
			$buff_table[0] = False
		Else
			$buff_table[0] = True
		EndIf

		If $buff_table[0] Then ;Si skill actived

			If Not trim($buff_conf_table[1]) = "" Then ;Delay
				$buff_table[2] = $buff_conf_table[1]
			EndIf

			If Not trim($buff_conf_table[2]) = "" Then ;Type
				$buff_table[3] = $buff_conf_table[2]
			EndIf

			If Not trim($buff_conf_table[3]) = "" Then ;EnergyNeeds
				$buff_table[4] = $buff_conf_table[3]
			EndIf

			If Not trim($buff_conf_table[4]) = "" Then ;Trigger Life
				$buff_table[7] = $buff_conf_table[4]
			EndIf

			If Not trim($buff_conf_table[5]) = "" Then ;Trigger Distance
				$buff_table[8] = $buff_conf_table[5]
			EndIf

		EndIf

		Select

			Case $buff_table[3] = "life"
				$Type = 0

			Case $buff_table[3] = "attack"
				$Type = 1


			Case $buff_table[3] = "physical"
				$Type = 2

			Case $buff_table[3] = "elite"
				$Type = 3



			Case $buff_table[3] = "buff"
				$Type = 4


			Case $buff_table[3] = "zone"
				$Type = 5


			Case StringInStr($buff_table[3], "zone") And StringInStr($buff_table[3], "&") And StringInStr($buff_table[3], "buff")
				$Type = 6

			Case $buff_table[3] = "move"
				$Type = 7

			Case StringInStr($buff_table[3], "life") And StringInStr($buff_table[3], "&") And StringInStr($buff_table[3], "attack")
				$Type = 8

			Case StringInStr($buff_table[3], "life") And StringInStr($buff_table[3], "|") And StringInStr($buff_table[3], "attack")
				$Type = 9

			Case StringInStr($buff_table[3], "move") And StringInStr($buff_table[3], "|") And StringInStr($buff_table[3], "attack")
				$Type = 10

			Case StringInStr($buff_table[3], "life") And StringInStr($buff_table[3], "|") And StringInStr($buff_table[3], "buff")
				$Type = 11

			Case StringInStr($buff_table[3], "life") And StringInStr($buff_table[3], "|") And StringInStr($buff_table[3], "move")
				$Type = 12

			Case StringInStr($buff_table[3], "life") And StringInStr($buff_table[3], "&") And StringInStr($buff_table[3], "buff")
				$Type = 13

			Case StringInStr($buff_table[3], "attack") And StringInStr($buff_table[3], "|") And StringInStr($buff_table[3], "buff")
				$Type = 14

			Case StringInStr($buff_table[3], "attack") And StringInStr($buff_table[3], "&") And StringInStr($buff_table[3], "buff")
				$Type = 15

			Case StringInStr($buff_table[3], "life") And StringInStr($buff_table[3], "|") And StringInStr($buff_table[3], "elite")
				$Type = 16

			Case StringInStr($buff_table[3], "life") And StringInStr($buff_table[3], "&") And StringInStr($buff_table[3], "elite")
				$Type = 17

			Case StringInStr($buff_table[3], "attack") And StringInStr($buff_table[3], "|") And StringInStr($buff_table[3], "elite")
				$Type = 18

			Case StringInStr($buff_table[3], "attack") And StringInStr($buff_table[3], "&") And StringInStr($buff_table[3], "elite")
				$Type = 19

			Case StringInStr($buff_table[3], "elite") And StringInStr($buff_table[3], "&") And StringInStr($buff_table[3], "buff")
				$Type = 20

			Case StringInStr($buff_table[3], "elite") And StringInStr($buff_table[3], "|") And StringInStr($buff_table[3], "buff")
				$Type = 21

			Case $buff_table[3] = "buff_permanent"
				$Type = 22

			Case $buff_table[3] = "canalisation"
				$Type = 23

		EndSelect

		$buff_table[3] = $Type

		If $i = 0 Then
			$Skill1 = $buff_table
		ElseIf $i = 1 Then
			$Skill2 = $buff_table
		ElseIf $i = 2 Then
			$Skill3 = $buff_table
		ElseIf $i = 3 Then
			$Skill4 = $buff_table
		ElseIf $i = 4 Then
			$Skill5 = $buff_table
		ElseIf $i = 5 Then
			$Skill6 = $buff_table
		EndIf
		_Log($buff_table[3])
	Next

EndFunc   ;==>ManageSpellInit

;;================================================================================
; Function:                     GetPlayerOffset
; Note(s):
;==================================================================================
Func GetPlayerOffset()
	$ptr1 = _memoryread($ofs_objectmanager, $d3, "ptr")
	$ptr2 = _memoryread($ptr1 + 0x96c, $d3, "ptr")
	$index = _memoryread($ptr2 + 0x0, $d3, "int")

	$ptr1bis = _memoryread($ofs_objectmanager, $d3, "ptr")
	$ptr2bis = _memoryread($ptr1 + 0x874, $d3, "ptr")
	$id = _memoryread($ptr2bis + 0x60 + $index * 0x82C8, $d3, "int")

	Return GetActorFromId($id)
EndFunc   ;==>GetPlayerOffset


;;================================================================================
; Function:                     GetActorFromId
; Note(s):
;==================================================================================
Func GetActorFromId($id)
	$ptr1 = _memoryread($ofs_objectmanager, $d3, "ptr")
	$ptr2 = _memoryread($ptr1 + 0x900, $d3, "int")
	$sid = BitAND($id, 0xFFFF)

	$bitshift = _memoryread($ptr2 + 0x18C, $d3, "int")
	$group1 = 4 * BitShift($sid, $bitshift)
	$group2 = BitShift(1, -$bitshift) - 1
	$group3 = _memoryread(_memoryread($ptr2 + 0x148, $d3, "int"), $d3, "int")
	$group4 = 0x42C * BitAND($sid, $group2)
	Return $group3 + $group1 + $group4
EndFunc   ;==>GetActorFromId

Func GoToTown()

	_Log("start loop IsOnLoginScreen() = False And IsInTown() = False And IsPlayerDead() = False")

	Local $nbTriesTownPortal = 0
	While (IsInTown() = False And IsInMenu() = False)
		$nbTriesTownPortal += 1

		If $nbTriesTownPortal < 3 Then
			If Not UseTownPortal(10) Then
				$nbTriesTownPortal = 3
			EndIf
		Else
			LeaveGame()
			$nbTriesTownPortal = 0
			Sleep(10000)
			While IsInMenu() = False
				Sleep(10)
			WEnd
			ExitLoop
		EndIf

		If IsDisconnected() Then
			_Log("Disconnected dc1")
			$disconnectcount += 1
			Sleep(1000)
			RandomMouseClick(398, 349)
			RandomMouseClick(398, 349)
			Sleep(1000)
			While Not (IsOnLoginScreen() Or IsInMenu())
				Sleep(Random(80000, 15000))
			WEnd
			ExitLoop
		EndIf
	WEnd

	RandSleep()
EndFunc   ;==>GoToTown

Func TpRepairAndBack()

	$PortBack = False

	While Not IsInTown()
		If Not UseTownPortal2() Then
			$GameFailed = 1
			Return False
		EndIf

	WEnd

	$PortBack = True


	StashAndRepair()

	If $PortBack Then
		SafePortBack()

		Local $hTimer = TimerInit()
		While Not OffsetList() And TimerDiff($hTimer) < 30000 ; 30secondes
			Sleep(40)
		WEnd

		If TimerDiff($hTimer) >= 30000 Then
			_Log('Fail to use OffsetList - TpRepairAndBack')
		EndIf
	EndIf

	$games = 0

EndFunc   ;==>TpRepairAndBack

Func StashAndRepair()

	_Log("Func StashAndRepair")
	$RepairORsell += 1
	$item_to_stash = 0

	If trim(StringLower($Unidentified)) = "true" Or (trim(StringLower($Unidentified) = "false") And trim(StringLower($Identified)) = "false") Then ; swicht unidentifier
		_Log("Unidentified")

		While IsInventoryOpened() = False
			Send("i")
			Sleep(Random(200, 300))
		WEnd

		Local $hTimer = TimerInit()
		While Not OffsetList() And TimerDiff($hTimer) < 30000 ; 30secondes
			Sleep(40)
		WEnd

		If TimerDiff($hTimer) >= 30000 Then
			_Log('Fail to use OffsetList - StashAndRepair')
			Return False
		EndIf

		Sleep(Random(500, 1000))

		_Log('Filter Backpack2')
		$items = FilterBackpack2()
		$ToStash = _ArrayFindAll($items, "Stash", 0, 0, 0, 1, 2)

		If $ToStash <> -1 Then
			Send("{SPACE}")
			Sleep(500)
			InteractByActorName($actorStash)
			Sleep(700)
			Local $stashtry = 0

			While IsStashOpened() = False
				If $stashtry <= 4 Then
					_Log('Fail to open Stash')
					$stashtry += 1
					InteractByActorName($actorStash)
					Sleep(Random(100, 200))

				Else
					Send("{PRINTSCREEN}")
					Sleep(200)
					_Log('Failed to open Stash after 4 try')
					WinSetOnTop("Diablo III", "", 0)
					MsgBox(0, "Impossible d'ouvrir le stash :", "SVP, veuillez reporter ce problème sur le forum. Erreur : s001 ")
					Terminate()

				EndIf
			WEnd
			$tabfull = 0
			CheckWindowD3Size()

			For $i = 0 To UBound($ToStash) - 1
				_Log($items[$ToStash[$i]][0] & " stash : " & $items[$ToStash[$i]][1])

				Sleep(Random(100, 200))
				InventoryMove($items[$ToStash[$i]][0], $items[$ToStash[$i]][1])
				Sleep(Random(100, 500))

				MouseClick('Right')
				Sleep(Random(50, 200))
				If DetectUiError($MODE_STASH_FULL) Then
					_Log('Tab is full : Switching tab')
					CheckWindowD3Size()
					$i = $i - 1
					If $tabfull = 0 Then
						MouseClick('left', 286, 194, 5)
						$tabfull = 1
					ElseIf $tabfull = 1 Then
						MouseClick('left', 282, 266, 5)
						$tabfull = 2
					ElseIf $tabfull = 2 Then
						_Log('Stash is full : Botting stopped')
						Terminate()
					EndIf

					Sleep(5000)

				Else
					$ItemToStash = $ItemToStash + 1
				EndIf
			Next

			Sleep(Random(50, 100))
			Send("{SPACE}")
			Sleep(Random(100, 150))

			;****************************************************************
			If Not VerifAttributeGlobalStuff() Then
				_Log("CHANGEMENT DE STUFF ON TOURNE EN ROND (Stash and Repair - Stash)!!!!!")
				AntiIdle()
			EndIf
			;****************************************************************

		EndIf

	EndIf ; fin swicht Unidentier

	If trim(StringLower($Identified)) = "true" Then ;swicht identifier

		_Log("Identified")

		While IsInventoryOpened() = False
			Send("i")
			Sleep(Random(200, 300))
		WEnd

		Local $hTimer = TimerInit()
		While Not OffsetList() And TimerDiff($hTimer) < 30000 ; 30secondes
			Sleep(40)
		WEnd

		If TimerDiff($hTimer) >= 30000 Then
			_Log('Fail to use OffsetList - StashAndRepairs')
			Return False
		EndIf

		Sleep(Random(500, 1000))

		_Log('Filter Backpack')
		$items = FilterBackpack()
		$ToStash = _ArrayFindAll($items, "Stash", 0, 0, 0, 1, 2)

		If $ToStash <> -1 Then
			Send("{SPACE}")
			Sleep(500)
			InteractByActorName($actorStash)
			Sleep(700)
			Local $stashtry = 0

			While IsStashOpened() = False
				If $stashtry <= 4 Then
					_Log('Fail to open Stash')
					$stashtry += 1
					InteractByActorName($actorStash)
					Sleep(Random(100, 200))

				Else
					Send("{PRINTSCREEN}")
					Sleep(200)
					_Log('Failed to open Stash after 4 try')
					WinSetOnTop("Diablo III", "", 0)
					MsgBox(0, "Impossible d'ouvrir le stash :", "SVP, veuillez reporter ce problème sur le forum. Erreur : s001 ")
					Terminate()

				EndIf
			WEnd
			$tabfull = 0
			CheckWindowD3Size()

			For $i = 0 To UBound($ToStash) - 1
				_Log($items[$ToStash[$i]][0] & " stash : " & $items[$ToStash[$i]][1])

				Sleep(Random(100, 200))
				InventoryMove($items[$ToStash[$i]][0], $items[$ToStash[$i]][1])
				Sleep(Random(100, 500))

				MouseClick('Right')
				Sleep(Random(50, 200))
				If DetectUiError($MODE_STASH_FULL) Then
					_Log('Tab is full : Switching tab')
					CheckWindowD3Size()
					$i = $i - 1
					If $tabfull = 0 Then
						MouseClick('left', 286, 194, 5)
						$tabfull = 1
					ElseIf $tabfull = 1 Then
						MouseClick('left', 282, 266, 5)
						$tabfull = 2
					ElseIf $tabfull = 2 Then
						_Log('Stash is full : Botting stopped')
						Terminate()
					EndIf

					Sleep(5000)

				Else
					$ItemToStash = $ItemToStash + 1
				EndIf
			Next

			Sleep(Random(50, 100))
			Send("{SPACE}")
			Sleep(Random(100, 150))

			;****************************************************************
			If Not VerifAttributeGlobalStuff() Then
				_Log("CHANGEMENT DE STUFF ON TOURNE EN ROND (Stash and Repair - Stash)!!!!!")
				AntiIdle()
			EndIf
			;****************************************************************

		EndIf ; fin swicht Indentifier

	EndIf

	Sleep(Random(100, 200))
	Send("{SPACE}")
	Sleep(Random(100, 200))
	Sleep(Random(500, 1000))
	If (trim(StringLower($Unidentified)) = "true" And trim(StringLower($Identified)) = "false") Then
		UseBookOfCain()
		Sleep(Random(100, 200))
		Send("{SPACE}")
		Sleep(Random(100, 200))
	EndIf

	; <<<<<<<<<<<<<<<<<<<<<<<<<        Test pour le recyclage ITEM  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

	$ToRecycle = _ArrayFindAll($items, "Recycle", 0, 0, 0, 1, 2)

	If $ToRecycle <> -1 Then
		Send("{SPACE}")
		Sleep(500)
		InteractByActorName('Blacksmith_RepairShortcut')
		Sleep(700)
		Local $stashtry = 0

		$tabfull = 0
		CheckWindowD3Size()
		MouseMove(150, 150, 2) ; clic sur dez
		MouseClick('Left')

		For $i = 0 To UBound($ToRecycle) - 1

			_Log($items[$ToRecycle[$i]][0] & " stash : " & $items[$ToRecycle[$i]][1])
			Sleep(Random(100, 200))
			InventoryMove($items[$ToRecycle[$i]][0], $items[$ToRecycle[$i]][1]);dez l'objet
			Sleep(Random(100, 500))

			MouseClick('Left')
			Sleep(Random(40, 250))
			$ItemToRecycle += 1 ;on compste les objets recyclés
			If $items[$ToRecycle[$i]][3] > 8 Then ; si leg ou plus, clique sur OK
				MouseMove(300, 210, 2)
				Sleep(Random(100, 500))
				MouseClick('Left')
			EndIf

		Next

		Sleep(Random(50, 100))
		Send("{SPACE}")
		Sleep(Random(100, 150))

		;****************************************************************
		If Not VerifAttributeGlobalStuff() Then
			_Log("CHANGEMENT DE STUFF ON TOURNE EN ROND (Stash and Repair - Stash)!!!!!")
			AntiIdle()
		EndIf
		;****************************************************************

	EndIf

	; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<          Fin de test recyclage ITEM          >>>>>>>>>>>>>>>>>>>>>>

	;on mesure l'or avant la réparation
	Local $GoldBeforeRepaire = GetGold()

	Repair()
	Sleep(Random(100, 200))
	Send("{SPACE}")
	Sleep(Random(100, 200))

	;on mesure l'or après
	Local $GoldAfterRepaire = GetGold()
	$GoldByRepaire += $GoldAfterRepaire - $GoldBeforeRepaire;on compte le cout de la réparation

	;Trash
	$ToTrash = _ArrayFindAll($items, "Trash", 0, 0, 0, 1, 2)
	If $ToTrash <> -1 Then
		Sleep(Random(100, 200))
		Send("{SPACE}")
		Sleep(500)

		;on mesure l'or avant la vente d'objets
		Local $GoldBeforeSell = GetGold()
		InteractByActorName($RepairVendor)
		Sleep(600)
		Local $vendortry = 0
		While Not IsVendorOpened()
			If $vendortry < 6 Then
				_Log('Fail to open vendor')
				$vendortry += 1
				InteractByActorName($RepairVendor)
			Else
				Send("{PRINTSCREEN}")
				Sleep(200)
				_Log('Failed to open Vendor after 5 try')
				WinSetOnTop("Diablo III", "", 0)
				MsgBox(0, "Impossible d'ouvrir le vendeur :", "SVP, veuillez reporter ce problème sur le forum. Erreur : v002 ")
				Terminate()
				ExitLoop
			EndIf
		WEnd
		CheckWindowD3Size()
		For $i = 0 To UBound($ToTrash) - 1
			InventoryMove($items[$ToTrash[$i]][0], $items[$ToTrash[$i]][1])
			Sleep(Random(100, 350))
			$ItemToSell += 1
			MouseClick('Right')
			Sleep(Random(100, 200))
		Next
		Sleep(Random(100, 200))
		Send("{SPACE}")
		Sleep(Random(100, 200))
		; on mesure l'or après
		Local $GoldAfterSell = GetGold()
		$GoldBySale += $GoldAfterSell - $GoldBeforeSell;on compte l'or par vente

		;****************************************************************
		If Not VerifAttributeGlobalStuff() Then
			_Log("CHANGEMENT DE STUFF ON TOURNE EN ROND (Stash and Repair - vendeur)!!!!!")
			AntiIdle()
		EndIf
		;****************************************************************

	EndIf
EndFunc   ;==>StashAndRepair

;;--------------------------------------------------------------------------------
;;	Gets levels from Gamebalance file, returns a list with snoid and lvl
;;--------------------------------------------------------------------------------
Func GetLevelsAdvanced($offset)
	If $offset <> 0 Then
		$ofs = $offset + 0x218;
		$read = _MemoryRead($ofs, $d3, 'int')
		While $read = 0
			$ofs += 0x4
			$read = _MemoryRead($ofs, $d3, 'int')
		WEnd
		$size = _MemoryRead($ofs + 0x4, $d3, 'int')
		$size -= 0x5F8
		$ofs = $offset + _MemoryRead($ofs, $d3, 'int')
		$nr = $size / 0x5F8
		Local $snoItems[$nr + 1][4]
		$j = 0
		For $i = 0 To $size Step 0x5F8
			$ofs_address = $ofs + $i
			$snoItems[$j][0] = _MemoryRead($ofs_address, $d3, 'ptr')
			$snoItems[$j][3] = _MemoryRead($ofs_address + 0x4, $d3, 'char[256]')
			$snoItems[$j][2] = Abs(_MemoryRead($ofs_address + 0x108, $d3, 'int')) ;item_type_hash
			$snoItems[$j][1] = _MemoryRead($ofs_address + 0x114, $d3, 'int') ;lvl
			$j += 1
		Next
	EndIf

	Return $snoItems

EndFunc   ;==>GetLevelsAdvanced

; #FUNCTION# =====================================================================
; Name...........: __ArrayConcatenate
; Description ...: Concatenate two 1D or 2D arrays
; Syntax.........: __ArrayConcatenate(ByRef $avArrayTarget, Const ByRef $avArraySource)
; Parameters ....: $avArrayTarget - The array to concatenate onto
;				  $avArraySource - The array to concatenate from - Must be 1D or 2D to match $avArrayTarget,
;								   and if 2D, then Ubound($avArraySource, 2) <= Ubound($avArrayTarget, 2).
; Return values .: Success - Index of last added item
;				  Failure - -1, sets @error to 1 and @extended per failure (see code below)
; Author ........: Ultima
; Modified.......: PsaltyDS - 1D/2D version, changed return value and @error/@extended to be consistent with __ArrayAdd()
; Remarks .......:
; Related .......: __ArrayAdd, _ArrayPush
; Link ..........;
; Example .......; Yes
; ===============================================================================
Func __ArrayConcatenate(ByRef $avArrayTarget, Const ByRef $avArraySource)
	If Not IsArray($avArrayTarget) Then Return SetError(1, 1, -1); $avArrayTarget is not an array
	If Not IsArray($avArraySource) Then Return SetError(1, 2, -1); $avArraySource is not an array

	Local $iUBoundTarget0 = UBound($avArrayTarget, 0), $iUBoundSource0 = UBound($avArraySource, 0)
	If $iUBoundTarget0 <> $iUBoundSource0 Then Return SetError(1, 3, -1); 1D/2D dimensionality did not match
	If $iUBoundTarget0 > 2 Then Return SetError(1, 4, -1); At least one array was 3D or more

	Local $iUBoundTarget1 = UBound($avArrayTarget, 1), $iUBoundSource1 = UBound($avArraySource, 1)

	Local $iNewSize = $iUBoundTarget1 + $iUBoundSource1
	If $iUBoundTarget0 = 1 Then
		; 1D arrays
		ReDim $avArrayTarget[$iNewSize]
		For $i = 0 To $iUBoundSource1 - 1
			$avArrayTarget[$iUBoundTarget1 + $i] = $avArraySource[$i]
		Next
	Else
		; 2D arrays
		Local $iUBoundTarget2 = UBound($avArrayTarget, 2), $iUBoundSource2 = UBound($avArraySource, 2)
		If $iUBoundSource2 > $iUBoundTarget2 Then Return SetError(1, 5, -1); 2D boundry of source too large for target
		ReDim $avArrayTarget[$iNewSize][$iUBoundTarget2]
		For $r = 0 To $iUBoundSource1 - 1
			For $c = 0 To $iUBoundSource2 - 1
				$avArrayTarget[$iUBoundTarget1 + $r][$c] = $avArraySource[$r][$c]
			Next
		Next
	EndIf

	Return $iNewSize - 1
EndFunc   ;==>__ArrayConcatenate

;;--------------------------------------------------------------------------------
;;  LoadingSNOExtended
;;--------------------------------------------------------------------------------
Func LoadingSNOExtended()
	_Log("LoadingSNO")
	$list = IndexSNO($gameBalance)



	$armorOffs = 0
	$weaponOffs = 0
	$otherOffs = 0
	For $j = 0 To UBound($list) - 1
		;19750 = armor, 19754 = weapon, 1953 = other
		;170627 = leg armor, 19752 = leg weapon, 1189 = leg other
		If ($list[$j][1] = 19750) Then
			$armorOffs = $list[$j][0]
		EndIf
		If ($list[$j][1] = 19754) Then
			$weaponOffs = $list[$j][0]
		EndIf
		If ($list[$j][1] = 19753) Then
			$otherOffs = $list[$j][0]
		EndIf

		If ($list[$j][1] = 170627) Then
			$legarmorOffs = $list[$j][0]
		EndIf
		If ($list[$j][1] = 19752) Then
			$legweaponOffs = $list[$j][0]
		EndIf
		If ($list[$j][1] = 1189) Then
			$legotherOffs = $list[$j][0]
		EndIf

	Next
	Global $armorItems = GetLevelsAdvanced($armorOffs)
	Global $weaponItems = GetLevelsAdvanced($weaponOffs)
	Global $otherItems = GetLevelsAdvanced($otherOffs)

	Global $legarmorItems = GetLevelsAdvanced($legarmorOffs)
	Global $legweaponItems = GetLevelsAdvanced($legweaponOffs)
	Global $legotherItems = GetLevelsAdvanced($legotherOffs)


	Global $allSNOitems = $armorItems
	__ArrayConcatenate($allSNOitems, $weaponItems)
	__ArrayConcatenate($allSNOitems, $otherItems)
	__ArrayConcatenate($allSNOitems, $legarmorItems)
	__ArrayConcatenate($allSNOitems, $legweaponOffs)
	__ArrayConcatenate($allSNOitems, $legotherOffs)
	_Log("GB SNO loaded")
	Return "true"
EndFunc   ;==>LoadingSNOExtended


Func InitGrabListFile()
	Dim $txttoarray[1]
	;local $load_file = ""
	Local $compt_line = 0

	Local $file = FileOpen("grablist/" & $grabListFile, 0)
	If $file = -1 Then
		MsgBox(0, "Error", "Unable to open file : " & $grabListFile)
		Exit
	EndIf

	While 1 ;Boucle de traitement de lecture du fichier txt
		$line = FileReadLine($file)
		If @error = -1 Then ExitLoop

		If $line <> "" Then
			$line = StringLower($line)
			ReDim $txttoarray[$compt_line + 1]
			$txttoarray[$compt_line] = $line
			$compt_line += 1
		EndIf
	WEnd

	FileClose($file)

	Global $tab_grablist[1][2]
	Global $grablist = ""
	Local $compt = 0

	For $i = 0 To UBound($txttoarray) - 1
		If StringInStr($txttoarray[$i], "=", 0) Then
			$var_temp = StringSplit($txttoarray[$i], "=", 2)

			$var_temp[0] = trim($var_temp[0])

			ReDim $tab_grablist[$compt + 1][2]

			$tab_grablist[$compt][0] = $var_temp[0]
			$tab_grablist[$compt][1] = $var_temp[1]

			Assign($var_temp[0], $var_temp[1], 2)
			$compt += 1
		Else

			If $grablist = "" Then
				$grablist = $txttoarray[$i]
			Else
				$grablist = $grablist & "|" & $txttoarray[$i]
			EndIf

		EndIf
	Next

EndFunc   ;==>InitGrabListFile

Func InitGrabListTab()

	Dim $tab_temp = StringSplit($grablist, "|", 2)

	Local $rules_ilvl = '(?i)\[ilvl:([0-9]{1,2})\]'
	Local $rules_quality = '(?i)\[q:([0-9]{1,2})\]'
	Local $rules_filtre = '(?i)\(([[:ascii:]+]+)\)' ;enleve les "(" de premier niveau

	Local $i = 0, $detect = 0
	Global $GrabListTab[UBound($tab_temp)][5]
	For $y = 0 To UBound($tab_temp) - 1
		$tab_buff = StringLower(trim($tab_temp[$y]))

		If StringRegExp($tab_buff, $rules_ilvl) = 1 Then ;patern declaration ilvl
			$tab_RegExp = StringRegExp($tab_buff, $rules_ilvl, 2)
			$tab_buff = StringReplace($tab_buff, $tab_RegExp[0], "", 0, 2)

			$curr_ilvl = $tab_RegExp[1]
		Else
			$curr_ilvl = 0
		EndIf


		If StringRegExp($tab_buff, $rules_quality) = 1 Then ;patern declaration quality
			$tab_RegExp = StringRegExp($tab_buff, $rules_quality, 2)
			$tab_buff = StringReplace($tab_buff, $tab_RegExp[0], "", 0, 2)
			$curr_quality = $tab_RegExp[1]
		Else
			$curr_quality = 0
		EndIf


		If StringRegExp($tab_buff, $rules_filtre) = 1 Then ;patern declaration filtre
			$tab_RegExp = StringRegExp($tab_buff, $rules_filtre, 2)
			$tab_buff = StringReplace($tab_buff, $tab_RegExp[0], "", 0, 2)
			$tab_RegExp[1] = StringReplace($tab_RegExp[1], "and", " and ", 0, 2)
			$tab_RegExp[1] = StringReplace($tab_RegExp[1], "or", " or ", 0, 2)

			For $x = 0 To UBound($tab_grablist) - 1
				If StringInStr($tab_RegExp[1], $tab_grablist[$x][0], 0) Then
					$tab_RegExp[1] = StringReplace($tab_RegExp[1], $tab_grablist[$x][0], $tab_grablist[$x][1], 0, 2)
				EndIf
			Next

			$curr_filtre = $tab_RegExp[1]
			$curr_filtre_str = GrabListFilterToStr($tab_RegExp[1])
		Else
			$curr_filtre = 0
			$curr_filtre_str = ""
		EndIf

		For $x = 0 To UBound($tab_grablist) - 1
			If StringInStr($tab_buff, $tab_grablist[$x][0], 0) Then
				$tab = StringSplit($tab_grablist[$x][1], "|", 2)
				For $Z = 0 To UBound($tab) - 1

					If $Z > 0 Then
						ReDim $GrabListTab[UBound($GrabListTab) + 1][5]
					EndIf

					$GrabListTab[$i][0] = $tab[$Z]
					$GrabListTab[$i][1] = $curr_ilvl
					$GrabListTab[$i][2] = $curr_quality
					$GrabListTab[$i][3] = $curr_filtre
					$GrabListTab[$i][4] = $curr_filtre_str

					$i += 1
				Next
				$detect = 1
			EndIf
		Next

		If $detect = 0 Then
			$GrabListTab[$i][0] = $tab_buff
			$GrabListTab[$i][1] = $curr_ilvl
			$GrabListTab[$i][2] = $curr_quality
			$GrabListTab[$i][3] = $curr_filtre
			$GrabListTab[$i][4] = $curr_filtre_str
			$i += 1
		EndIf

		$detect = 0
	Next
EndFunc   ;==>InitGrabListTab

Func GrabListFilterToStr($str)
	Local $result = ""
	$str = StringReplace($str, "and", " ", 0, 2)
	$str = StringReplace($str, "or", " ", 0, 2)

	While StringRegExp($str, '(?i)([a-z]+)') = 1
		$list = StringRegExp($str, '(?i)([a-z]+)', 2)
		If $result = "" Then
			$result = $list[1]
		Else
			$result = $result & "|" & $list[1]
		EndIf
		$str = StringReplace($str, $list[1], " ", 0, 2)
		;msgbox(1, "", $str)
	WEnd

	Return $result
EndFunc   ;==>GrabListFilterToStr

Func SafePortStart()
	$Curentarea = GetLevelAreaId()
	;fix offset list
	While $Curentarea = -1
		Local $hTimer = TimerInit()
		While Not OffsetList() And TimerDiff($hTimer) < 30000 ; 30secondes
			Sleep(40)
		WEnd

		If TimerDiff($hTimer) >= 30000 Then
			_Log('Fail to use OffsetList - SafePortStart')
			Return False
		EndIf

		$Curentarea = GetLevelAreaId()

	WEnd
	_Log('cur area :' & $Curentarea)

	$tptry = 0
	$tpcheck = 0

	While $tpcheck = 0 And $tptry <= 1
		_Log("try n°" & $tptry + 1 & " hearthPortal")
		InteractByActorName('hearthPortal')
		$Newarea = GetLevelAreaId()

		Local $areatry = 0

		While $Newarea = $Curentarea And $areatry <= 10
			$Newarea = GetLevelAreaId()
			Sleep(500)
			$areatry = $areatry + 1
		WEnd

		If $Newarea <> $Curentarea Then
			$tpcheck = 1
		Else
			$tptry += 1
		EndIf

	WEnd

	If $Newarea <> $Curentarea Then
		_Log('succesfully teleported back : ' & $Curentarea & ":" & $Newarea)
		Local $hTimer = TimerInit()
		While Not OffsetList() And TimerDiff($hTimer) < 30000 ; 30secondes
			Sleep(40)
		WEnd

		If TimerDiff($hTimer) >= 30000 Then
			_Log('Fail to use OffsetList - SafePortStart')
		EndIf

	Else
		$GameFailed = 1
	EndIf

EndFunc   ;==>SafePortStart

Func SafePortBack()
	$Curentarea = GetLevelAreaId()
	_Log('cur area :' & $Curentarea)
	;Go to center according to act
	Switch $Act
		Case 1 ; act 1
			MoveToPos(2922.02783203125, 2791.189453125, 24.0453262329102, 0, 25)
			MoveToPos(2945.61547851563, 2800.7109375, 24.0453319549561, 0, 25)
			MoveToPos(2973.68774414063, 2800.90869140625, 24.0453262329102, 0, 25)

		Case 2 ; act 2
			;mtp a definir


		Case 3 ; act 3
			MoveToPos(427.152893066406, 345.048858642578, 0.10000141710043, 0, 25)
			MoveToPos(400.490386962891, 380.362884521484, 0.332595944404602, 0, 25)
			MoveToPos(390.630401611328, 399.380554199219, 0.55376011133194, 0, 25)

		Case 4 ; act 4
			MoveToPos(427.152893066406, 345.048858642578, 0.10000141710043, 0, 25)
			MoveToPos(400.490386962891, 380.362884521484, 0.332595944404602, 0, 25)
			MoveToPos(390.630401611328, 399.380554199219, 0.55376011133194, 0, 25)

	EndSwitch

	InteractByActorName('hearthPortal')
	$Newarea = GetLevelAreaId()

	Local $areatry = 0
	While $Newarea = $Curentarea And $areatry <= 10
		$Newarea = GetLevelAreaId()
		Sleep(500)
		$areatry = $areatry + 1
	WEnd

	If $Newarea <> $Curentarea Then
		_Log('succesfully teleported back : ' & $Curentarea & ":" & $Newarea)
		Local $hTimer = TimerInit()
		While Not OffsetList() And TimerDiff($hTimer) < 30000 ; 30secondes
			Sleep(40)
		WEnd

		If TimerDiff($hTimer) >= 30000 Then
			_Log('Fail to use OffsetList - SafePortBack')
		EndIf

	Else
		_Log('We failed to teleport back')
	EndIf
EndFunc   ;==>SafePortBack

Func FastCheckUiItemVisibleSize($valuetocheckfor, $visibility, $bucket)
	Global $itemsize[4]
	$ptr1 = _memoryread($ofs_objectmanager, $d3, "ptr")
	$ptr2 = _memoryread($ptr1 + 2420, $d3, "ptr")
	$ptr3 = _memoryread($ptr2 + 0, $d3, "ptr")
	$ofs_uielements = _memoryread($ptr3 + 8, $d3, "ptr")
	$uielementpointer = _memoryread($ofs_uielements + 4 * $bucket, $d3, "ptr")
	While $uielementpointer <> 0
		$npnt = _memoryread($uielementpointer + 528, $d3, "ptr")
		$name = BinaryToString(_memoryread($npnt + 56, $d3, "byte[256]"), 4)
		If StringInStr($name, $valuetocheckfor) Then
			If _memoryread($npnt + 40, $d3, "int") = $visibility Then


				$x = _memoryread($npnt + 0x508, $d3, "float") ;left
				$y = _memoryread($npnt + 0x50C, $d3, "float") ;top
				$r = _memoryread($npnt + 0x510, $d3, "float") ;right
				$B = _memoryread($npnt + 0x514, $d3, "float") ;bot
				_Log(" x :" & $x & " y :" & $y & " R :" & $r & " B:" & $B)


				Dim $itemsize[4] = [$x, $y, $r, $B]



				Return $itemsize
			Else
				_Log("The UI element we are looking for is invisible")
				Return False
			EndIf
		EndIf
		$uielementpointer = _memoryread($uielementpointer, $d3, "ptr")
	WEnd
	Return False
EndFunc   ;==>FastCheckUiItemVisibleSize

Func CheckBackpackSize()
	$sizelookfor = "Root.NormalLayer.inventory_dialog_mainPage.inventory_button_backpack"

	$count_FastCheckUiItemVisibleSize = 0
	$sizecheck = 0
	While $count_FastCheckUiItemVisibleSize <= 100 And $sizecheck = 0
		FastCheckUiItemVisibleSize($sizelookfor, 1, 1180)
		$count_FastCheckUiItemVisibleSize += 1
		If $itemsize[0] <> 0 Then
			$sizecheck = 1
		EndIf
	WEnd

	If $itemsize[0] = 1035 And $itemsize[1] = 652 And $itemsize[2] = 1575 And $itemsize[3] = 972 Then
		_Log("UI Size check OK : " & $itemsize[0] & ":" & $itemsize[1] & ":" & $itemsize[2] & ":" & $itemsize[3])
		Return True
	Else

		If $itemsize[0] = False Then
			_Log("UI Size check failed for unknow reason : " & $itemsize[0] & ":" & $itemsize[1] & ":" & $itemsize[2] & ":" & $itemsize[3])
		Else
			_Log("UI Size check failed cuz windows is wrong size : " & $itemsize[0] & ":" & $itemsize[1] & ":" & $itemsize[2] & ":" & $itemsize[3])
		EndIf
		AntiIdle()
	EndIf

EndFunc   ;==>CheckBackpackSize

Func AutoModeInitSpells()
	If StringLower(Trim($nameCharacter)) = "monk" Then
		Dim $tab_skill_temp = $Monk_skill_Table
		If $Gest_affixe_ByClass = "true" Then
			$gestion_affixe_loot = "false"
			$gestion_affixe = "false"
			_Log("Monk detected, Gest Affix disabled")
		EndIf
	ElseIf StringLower(Trim($nameCharacter)) = "barbarian" Then
		Dim $tab_skill_temp = $Barbarian_Skill_Table
		If $Gest_affixe_ByClass = "true" Then
			$gestion_affixe_loot = "false"
			$gestion_affixe = "false"
			_Log("Barbarian detected, Gest Affix disabled")
		EndIf
	ElseIf StringLower(Trim($nameCharacter)) = "witchdoctor" Then
		Dim $tab_skill_temp = $WitchDoctor_Skill_Table
		If $Gest_affixe_ByClass = "true" Then
			$gestion_affixe_loot = "true"
			$gestion_affixe = "true"
			_Log("WitchDoctor detected, Gest Affix Enabled")
		EndIf
	ElseIf StringLower(Trim($nameCharacter)) = "demonhunter" Then
		Dim $tab_skill_temp = $DemonHunter_skill_Table
		If $Gest_affixe_ByClass = "true" Then
			$gestion_affixe_loot = "true"
			$gestion_affixe = "true"
			_Log("DemonHunter detected, Gest Affix Enabled")
		EndIf
	Else
		Dim $tab_skill_temp = $Wizard_skill_Table
		If $Gest_affixe_ByClass = "true" Then
			$gestion_affixe_loot = "true"
			$gestion_affixe = "true"
			_Log("Wizard detected, Gest Affix Enabled")
		EndIf
	EndIf


	For $i = -1 To 4
		For $y = 0 To UBound($tab_skill_temp) - 1

			If GetActivePlayerSkill($i) = $tab_skill_temp[$y][0] Then
				If $i = -1 Then
					$Skill1 = AssociateSkills($y, "left", $tab_skill_temp)
				ElseIf $i = 0 Then
					$Skill2 = AssociateSkills($y, "right", $tab_skill_temp)
				ElseIf $i = 1 Then
					$Skill3 = AssociateSkills($y, $Key1, $tab_skill_temp)
				ElseIf $i = 2 Then
					$Skill4 = AssociateSkills($y, $Key2, $tab_skill_temp)
				ElseIf $i = 3 Then
					$Skill5 = AssociateSkills($y, $Key3, $tab_skill_temp)
				ElseIf $i = 4 Then
					$Skill6 = AssociateSkills($y, $Key4, $tab_skill_temp)
				EndIf
				ExitLoop
			EndIf

		Next
	Next
EndFunc   ;==>AutoModeInitSpells

Func AssociateSkills($y, $key, $tab_skill_temp)
	Dim $tab[11]
	$tab[0] = True
	$tab[1] = $tab_skill_temp[$y][1]
	$tab[2] = $tab_skill_temp[$y][2]
	$tab[3] = $tab_skill_temp[$y][3]
	$tab[4] = $tab_skill_temp[$y][4]
	$tab[5] = $tab_skill_temp[$y][5]
	$tab[6] = $key
	$tab[7] = $tab_skill_temp[$y][6]
	$tab[8] = $tab_skill_temp[$y][7]
	$tab[9] = $tab_skill_temp[$y][0]
	$tab[10] = ""
	Return $tab
EndFunc   ;==>AssociateSkills

Func DetectUiError($mode = 0)

	;$mode=0 -> Detection inventory full
	;$mode=1 -> Detection Stash full
	;$mode=2 -> Detection Deny Boss tp
	;$mode=3 -> Detection No item IDentify

	$bucket_inventory_full = 1185
	$valuetocheckfor = "Root.TopLayer.error_notify.error_text"
	$Visibility = 1

	$ptr1 = _memoryread($ofs_objectmanager, $d3, "ptr")
	$ptr2 = _memoryread($ptr1 + 2420, $d3, "ptr")
	$ptr3 = _memoryread($ptr2 + 0, $d3, "ptr")
	$ofs_uielements = _memoryread($ptr3 + 8, $d3, "ptr")
	$uielementpointer = _memoryread($ofs_uielements + 4 * $bucket_inventory_full, $d3, "ptr")

	While $uielementpointer <> 0
		$npnt = _memoryread($uielementpointer + 528, $d3, "ptr")
		$name = BinaryToString(_memoryread($npnt + 56, $d3, "byte[256]"), 4)
		$uitextptr = _memoryread($npnt + 0xAE0, $d3, "ptr")

		If StringInStr($name, $valuetocheckfor) Then
			If _memoryread($npnt + 40, $d3, "int") = $Visibility Then

				;_Log("Ui Error Visible")

				If $mode = 0 Then ;Detect inventory full
					$uitext_InventaireFull = _memoryread($uitextptr, $d3, "byte[" & $Byte_full_inventory[1] & "]")
					If $Byte_full_inventory[0] = $uitext_InventaireFull Then
						_Log("Detection Inventaire Full !")
						Return True
					EndIf
				ElseIf $mode = 1 Then ;Detect Stash full
					$uitext_StashFull = _memoryread($uitextptr, $d3, "byte[" & $Byte_Full_Stash[1] & "]")
					If $Byte_Full_Stash[0] = $uitext_StashFull Then
						_Log("Detection Stash Full !")
						Return True
					EndIf
				ElseIf $mode = 2 Then ;Detect Deny Tp
					$uitext_BossTpDeny = _memoryread($uitextptr, $d3, "byte[" & $Byte_Boss_TpDeny[1] & "]")
					If $Byte_Boss_TpDeny[0] = $uitext_BossTpDeny Then
						_Log("Detection Deny Tp, Boss room !")
						Return True
					EndIf
				ElseIf $mode = 3 Then ;Detect No Item identify
					$uitext_NoItemIdentify = _memoryread($uitextptr, $d3, "byte[" & $Byte_NoItem_Identify[1] & "]")
					If $Byte_NoItem_Identify[0] = $uitext_NoItemIdentify Then
						_Log("Detection No Item IDentify !")
						Return True
					EndIf
				ElseIf $mode > 3 Then ;Test Mode

					$uitext_InventaireFull = _memoryread($uitextptr, $d3, "byte[" & $Byte_full_inventory[1] & "]")
					$uitext_StashFull = _memoryread($uitextptr, $d3, "byte[" & $Byte_Full_Stash[1] & "]")
					$uitext_BossTpDeny = _memoryread($uitextptr, $d3, "byte[" & $Byte_Boss_TpDeny[1] & "]")
					$uitext_NoItemIdentify = _memoryread($uitextptr, $d3, "byte[" & $Byte_NoItem_Identify[1] & "]")

					If $Byte_full_inventory[0] = $uitext_InventaireFull Then
						_Log("Detection Inventaire Full !")
						Return True
					ElseIf $Byte_Full_Stash[0] = $uitext_StashFull Then
						_Log("Detection Stash Full !")
						Return True
					ElseIf $Byte_Boss_TpDeny[0] = $uitext_BossTpDeny Then
						_Log("Detection Deny Tp, Boss room !")
						Return True
					ElseIf $Byte_NoItem_Identify[0] = $uitext_NoItemIdentify Then
						_Log("Detection No Item IDentify !")
						Return True
					EndIf

				EndIf

			Else
				_Log("No detection")
				Return False
			EndIf

		EndIf

		$uielementpointer = _memoryread($uielementpointer, $d3, "ptr")
	WEnd
	Return False
EndFunc   ;==>DetectUiError


Func DetectStrInventoryFull()

	Global $Byte_Full_Inventory[2]
	Global $Byte_Full_Stash[2]
	Global $Byte_Boss_TpDeny[2]
	Global $Byte_NoItem_Identify[2]

	Dim $list = IndexSNO($ofs_StringListDef, 0)
	;_arraydisplay($list)

	For $y = 1 To UBound($list) - 1

		If $list[$y][1] = 0xCB21 Then
			$count = _MemoryRead($list[$y][0] + 0x1c, $d3, "int")
			$count = $count / 0x50

			$offset = $list[$y][0] + 0x28

			For $i = 0 To $count - 1


				$structtest = DllStructCreate("ptr;byte[8];int;ptr;byte[8];int;ptr;byte[8];int;ptr;byte[8];int;byte[16]")
				;$structtest = DllStructCreate("ptr;byte[4];ptr;int;byte[8];ptr;int;byte[8]ptr;int;byte[8];ptr;int;byte[16]")
				DllCall($d3[0], 'int', 'ReadProcessMemory', 'int', $d3[1], 'int', $offset, 'ptr', DllStructGetPtr($structtest), 'int', DllStructGetSize($structtest), 'int', '')

				$str1 = DllStructGetData($structtest, 1)
				$size1 = DllStructGetData($structtest, 3)

				$str2 = DllStructGetData($structtest, 4)
				$size2 = DllStructGetData($structtest, 6)


				$str_to_check = BinaryToString( _MemoryRead($str1, $d3, "char[" & $size1 & "]"), 4)

				If StringInStr($str_to_check, "Pickup_NoSuitableSlot") Then
					_Log("1) Pickup_NoSuitableSlot found")
					$Byte_Full_Inventory[0] = _MemoryRead($str2, $d3, "byte[" & $size2 & "]")
					$Byte_Full_Inventory[1] = $size2
				ElseIf StringInStr($str_to_check, "IAR_NotEnoughRoom") Then
					_Log("2) IAR_NotEnoughRoom found")
					$Byte_Full_Stash[0] = _MemoryRead($str2, $d3, "byte[" & $size2 & "]")
					$Byte_Full_Stash[1] = $size2
				ElseIf StringInStr($str_to_check, "PowerUnusableDuringBossEncounter") Then
					_Log("3) PowerUnusableDuringBossEncounter found")
					$Byte_boss_TpDeny[0] = _MemoryRead($str2, $d3, "byte[" & $size2 & "]")
					$Byte_boss_TpDeny[1] = $size2
				ElseIf StringInStr($str_to_check, "IdentifyAllNoItems") Then
					_Log("4) IdentifyAllNoItems found")
					$Byte_NoItem_Identify[0] = _MemoryRead($str2, $d3, "byte[" & $size2 & "]")
					$Byte_NoItem_Identify[1] = $size2
				EndIf


				$offset += 0x50
				$structtest = ""
			Next
		EndIf
	Next

EndFunc   ;==>DetectStrInventoryFull

Func GetLocalPlayer()
	Global $ObjManStorage = 0x7CC ;0x794
	$v0 = _MemoryRead(_MemoryRead($ofs_objectmanager, $d3, 'int') + 0x984, $d3, 'int') ;0x94C/934
	$v1 = _MemoryRead(_MemoryRead($ofs_objectmanager, $d3, 'int') + $ObjManStorage + 0xA8, $d3, 'int')

	If $v0 <> 0 And _MemoryRead($v0, $d3, 'int') <> -1 And $v1 <> 0 Then
		Return 0x8008 * _MemoryRead($v0, $d3, 'int') + $v1 + 0x58
	Else
		Return 0
	EndIf
EndFunc   ;==>GetLocalPlayer

Func GetActivePlayerSkill($index)
	$Local_player = GetLocalPlayer()
	If $Local_player <> 0 Then
		Return _MemoryRead($Local_player + 4 * (3 * $index + 0x30), $d3, 'int')
	Else
		Return 0
	EndIf
EndFunc   ;==>GetActivePlayerSkill

Func UseTownPortal($mode = 0)

	;TCHAT
	If ($PartieSolo = 'false') Then
		Switch Random(1, 3, 1)
			Case 1
				WriteInChat("sell")
			Case 2
				WriteInChat("je vends/repare")
			Case 3
				WriteInChat("je retourne en ville")
		EndSwitch
	EndIf

	$compt = 0

	While Not IsInTown()

		_Log("tour de boucle IsInTown")

		$compt += 1
		$compt_while = 0
		$timer = 0
		$try = 0

		If $mode <> 0 And $compt > $mode Then
			_Log("Too Much TP try !!!")
			ExitLoop
		EndIf

		_Log("enclenche attack")
		$grabskip = 1
		Attack()
		$grabskip = 0

		Sleep(100)

		$CurrentLoc = GetCurrentPos()
		MoveToPos($CurrentLoc[0] + 5, $CurrentLoc[1] + 5, $CurrentLoc[2], 0, 6)


		If IsPlayerDead() = False Then

			Sleep(250)
			Send("t")
			Sleep(250)

			If $Choix_Act_Run < 100 And DetectUiError($MODE_BOSS_TP_DENIED) And Not IsInTown() Then
				_Log('Detection Asmo room')
				Return False
			EndIf

			$Current_area = GetLevelAreaId()

			_Log("enclenchement fastCheckui de la barre de loading")

			While FastCheckUiItemVisible("Root.NormalLayer.game_dialog_backgroundScreen.loopinganimmeter.progressBar", 1, 996)
				If $compt_while = 0 Then
					_Log("enclenchement du timer")
					$timer = TimerInit()
				EndIf

				Sleep(100)
				$compt_while += 1
			WEnd

			_Log("compare time to tp -> " & TimerDiff($timer) & "> 3700")
			If TimerDiff($timer) > 3700 Then
				While Not IsInTown() And $try < 6
					_Log("on a peut etre reussi a tp, on reste inerte pendant 6sec voir si on arrive en ville, tentative -> " & $try)
					$try += 1
					Sleep(1000)
				WEnd
			EndIf

			Sleep(500)


			If $Current_area <> GetLevelAreaId() Then
				_Log("Changement d'arreat, on quite la boucle")
				ExitLoop
			EndIf

		Else
			_Log("Vous etes morts lors d'une tentative de teleporte !!!")
			Return False
		EndIf

		Sleep(100)
		$PortBack = True
	WEnd
	
	Local $hTimer = TimerInit()
	While Not OffsetList() And TimerDiff($hTimer) < 30000 ; 30secondes
		Sleep(40)
	WEnd

	If TimerDiff($hTimer) >= 30000 Then
		_Log('Fail to use OffsetList - TakeWP')
		Return False
	EndIf

	_Log("on a renvoyer true, quite bien la fonction")

	Return True
EndFunc   ;==>UseTownPortal

Func UseTownPortal2()
	Do ;execute au moins 1 fois de tp avant de faire le test du until
		If IsPlayerDead() = False Then
			_Log("enclenche attack")
			$grabskip = 1
			Attack()
			$grabskip = 0
			Sleep(250)
			_Log("on enclenche TP")
			Send("t")
			Sleep(250)
			While (FastCheckUiItemVisible("Root.NormalLayer.game_dialog_backgroundScreen.loopinganimmeter.progressBar", 1, 996)) ; on attend que la barre du tp disparaise pour tester si on est en ville
			WEnd
		Else
			_Log("Vous etes morts lors d'une tentative de teleporte !!!")
			Return False
		EndIf
	Until IsInTown() ;Tant qu'on est pas en ville
	Return True
EndFunc   ;==>UseTownPortal2

Func GetMaxResource($idAttrib, $classe)

	Switch $classe
		Case "monk"
			$source = 0x3000
			$MaximumSpirit = _memoryread(GetAttributeOfs($idAttrib, BitOR($Atrib_Resource_Max_Total[0], $source)), $d3, "float")
			_Log("Ressource Maximum : " & $MaximumSpirit)
		Case "barbarian"
			$source = 0x2000
			$MaximumFury = _memoryread(GetAttributeOfs($idAttrib, BitOR($Atrib_Resource_Max_Total[0], $source)), $d3, "float")
			_Log("Ressource Maximum : " & $MaximumFury)
		Case "wizard"
			$source = 0x1000
			$MaximumArcane = _memoryread(GetAttributeOfs($idAttrib, BitOR($Atrib_Resource_Max_Total[0], $source)), $d3, "float")
			_Log("Ressource Maximum : " & $MaximumArcane)
		Case "witchdoctor"
			$source = 0
			$MaximumMana = _memoryread(GetAttributeOfs($idAttrib, BitOR($Atrib_Resource_Max_Total[0], $source)), $d3, "float")
			_Log("Ressource Maximum : " & $MaximumMana)
		Case "demonhunter"
			$source = 0x5000
			$MaximumHatred = _memoryread(GetAttributeOfs($idAttrib, BitOR($Atrib_Resource_Max_Total[0], $source)), $d3, "float")
			$source = 0x6000
			$MaximumDiscipline = _memoryread(GetAttributeOfs($idAttrib, BitOR($Atrib_Resource_Max_Total[0], $source)), $d3, "float")
			_Log("Ressource Maximum : " & $MaximumHatred)
			_Log("Ressource Maximum : " & $MaximumDiscipline)

	EndSwitch

EndFunc   ;==>GetMaxResource

Func ResetTimerIgnore()
	If TimerDiff($timer_ignore_reset) > 120000 Then

		ReDim $ignore_affix[1][2]
		$timer_ignore_reset = TimerInit()
	EndIf
EndFunc   ;==>ResetTimerIgnore

Func CheckIgnoreAffixe($_x_verif, $_y_verif)
	For $a = 0 To UBound($ignore_affix) - 1
		If $_x_verif = $ignore_affix[$a][0] And $_y_verif = $ignore_affix[$a][1] Then
			Return False
			$a = UBound($ignore_affix) - 1
		Else
			Return True
		EndIf
	Next

EndFunc   ;==>CheckIgnoreAffixe

Func IsSafeZone($x_perso, $y_perso, $z_test, $item_safe)
	$condition_affixe = 0
	For $aa = 0 To UBound($item_safe) - 1

		$distance_centre_affixe = Sqrt(($item_safe[$aa][2] - $x_perso) ^ 2 + ($item_safe[$aa][3] - $y_perso) ^ 2)
		If $distance_centre_affixe < $item_safe[$aa][10] Then
			$condition_affixe = $condition_affixe + 1
;~ 					$aa=ubound($item_safe)-1
		EndIf

	Next

	If $condition_affixe = 0 Then

		Return True
	Else
		Return False
	EndIf

EndFunc   ;==>IsSafeZone

Func FindSafeZone($x_perso, $y_perso, $item_verif, $z_test, $x_mob, $y_mob)
	Dim $safe_array[1][3]
	$bb = -1
	If $x_mob - $x_perso > 0 Then
		$ord = 1
	Else
		$ord = -1
	EndIf

	If $y_mob - $y_perso > 0 Then
		$abs = 1
	Else
		$abs = -1
	EndIf

	For $B = 0 To UBound($tab_aff2) - 1
		$x_test = $x_perso + $ord * $tab_aff2[$B][0]
		$y_test = $y_perso + $abs * $tab_aff2[$B][1]
		If IsSafeZone($x_test, $y_test, $z_test, $item_verif) And CheckIgnoreAffixe($x_test, $y_test) Then
			ReDim $safe_array[$bb + 2][3]
			$bb = $bb + 1
			$distance_safe = GetDistance($x_test, $y_test, 0)
			$safe_array[$bb][1] = $x_test
			$safe_array[$bb][2] = $y_test
			$safe_array[$bb][0] = $distance_safe
;~ 			$safe_array[$bb+1][1]=$x_test
;~ 			$safe_array[$bb+1][2]=$y_test
;~ 			$safe_array[$bb+1][0]=$distance_safe
;~ 		   $b= ubound($tab_aff2)-1
		EndIf

		$x_test = $x_perso - $ord * $tab_aff2[$B][0]
		$y_test = $y_perso - $abs * $tab_aff2[$B][1]
		If IsSafeZone($x_test, $y_test, $z_test, $item_verif) And CheckIgnoreAffixe($x_test, $y_test) Then
			ReDim $safe_array[$bb + 2][3]
			$bb = $bb + 1
			$distance_safe = GetDistance($x_test, $y_test, 0)
			$safe_array[$bb][1] = $x_test
			$safe_array[$bb][2] = $y_test
			$safe_array[$bb][0] = $distance_safe
;~ 			$safe_array[$bb+1][1]=$x_test
;~ 			$safe_array[$bb+1][2]=$y_test
;~ 			$safe_array[$bb+1][0]=$distance_safe
;~ 		   $b= ubound($tab_aff2)-1
		EndIf

		$x_test = $x_perso + $ord * $tab_aff2[$B][0]
		$y_test = $y_perso - $abs * $tab_aff2[$B][1]
		If IsSafeZone($x_test, $y_test, $z_test, $item_verif) And CheckIgnoreAffixe($x_test, $y_test) Then
			ReDim $safe_array[$bb + 2][3]
			$bb = $bb + 1
			$distance_safe = GetDistance($x_test, $y_test, 0)
			$safe_array[$bb][1] = $x_test
			$safe_array[$bb][2] = $y_test
			$safe_array[$bb][0] = $distance_safe
;~ 			$safe_array[$bb+1][1]=$x_test
;~ 			$safe_array[$bb+1][2]=$y_test
;~ 			$safe_array[$bb+1][0]=$distance_safe
;~ 		   $b= ubound($tab_aff2)-1
		EndIf

		$x_test = $x_perso - $ord * $tab_aff2[$B][0]
		$y_test = $y_perso + $abs * $tab_aff2[$B][1]
		If IsSafeZone($x_test, $y_test, $z_test, $item_verif) And CheckIgnoreAffixe($x_test, $y_test) Then
			ReDim $safe_array[$bb + 2][3]
			$bb = $bb + 1
			$distance_safe = GetDistance($x_test, $y_test, 0)
			$safe_array[$bb][1] = $x_test
			$safe_array[$bb][2] = $y_test
			$safe_array[$bb][0] = $distance_safe
		EndIf
	Next
	If $safe_array[0][0] <> 0 Then
		_ArraySort($safe_array)
		Dim $move_aff[2]
		$move_aff[0] = $safe_array[0][1]
		$move_aff[1] = $safe_array[0][2]

	Else
		$move_aff[0] = $x_test
		$move_aff[1] = $y_test

	EndIf
	Return $move_aff

EndFunc   ;==>FindSafeZone

Func MaffMove($_x_aff, $_y_aff, $_z_aff, $x_mob, $y_mob)
	ResetTimerIgnore()
	If TimerDiff($maff_timer) > 500 Then
		Dim $item_maff_move = IterateFilterAffix()
		If IsArray($item_maff_move) Then
			$a = 0
			While $a <= UBound($item_maff_move) - 1
				CheckDrinkPotion()
				MouseUp('left')
;~ 			   $dist_aff=sqrt(($_x_aff-$item_maff_move[$a][2])*($_x_aff-$item_maff_move[$a][2]) + ($_y_aff-$item_maff_move[$a][3])*($_y_aff-$item_maff_move[$a][3]) + ($_z_aff-$item_maff_move[$a][4])*($_z_aff-$item_maff_move[$a][4]))
				If $item_maff_move[$a][9] < $item_maff_move[$a][10] And IsPlayerDead() = False Then
					Dim $move_coords[2]
					$move_coords = FindSafeZone($_x_aff, $_y_aff, $item_maff_move, $_z_aff, $x_mob, $y_mob)
					$Coords_affixe = FromD3ToScreenCoords($move_coords[0], $move_coords[1], $_z_aff)
					MouseMove($Coords_affixe[0], $Coords_affixe[1], 3)
					ManageSpellCasting(0, 0, 0)
					MouseClick("middle")
					$ignore_timer = TimerInit()
					While _MemoryRead($ClickToMoveToggle, $d3, "float") <> 0
;~ 					 ManageSpellCasting(0, 2, 0)
						If TimerDiff($ignore_timer) > 10000 Then ExitLoop
						Sleep(10)

					WEnd
					If TimerDiff($ignore_timer) < 30 Then
						$nbr_ignore = UBound($ignore_affix)
						ReDim $ignore_affix[$nbr_ignore + 1][2]
						$ignore_affix[$nbr_ignore][0] = $move_coords[0]
						$ignore_affix[$nbr_ignore][1] = $move_coords[1]
					EndIf

					$maff_timer = TimerInit()
					ExitLoop

				EndIf
				$a += 1
			WEnd
		EndIf

	EndIf
EndFunc   ;==>MaffMove

Func IterateFilterAffix()
	Local $index, $offset, $count, $item[10]
	StartIterateObjectsList($index, $offset, $count)
	Dim $item_affix_2D[1][11]
	Local $i = 0
	$pv_affix = GetLifeLeftPercent()
	$compt = 0
;~ 		 $ii=0
	While IterateObjectsList($index, $offset, $count, $item)
		$compt += 1
		If IsAffix($item, $pv_affix) Then
			ReDim $item_affix_2D[$i + 1][11]
			For $x = 0 To 9
				$item_affix_2D[$i][$x] = $item[$x]
			Next

			If (StringInStr($item[1], "woodWraith_explosion") Or StringInStr($item[1], "WoodWraith_sporeCloud_emitter")) Then $item_affix_2D[$i][10] = $range_ice
			If StringInStr($item[1], "sandwasp_projectile") Then $item_affix_2D[$i][10] = $range_arcane
			If StringInStr($item[1], "molten_trail") Then $item_affix_2D[$i][10] = $range_lave
			If StringInStr($item[1], "Desecrator") Then $item_affix_2D[$i][10] = $range_profa
			If (StringInStr($item[1], "bomb_buildup") Or StringInStr($item[1], "Icecluster") Or StringInStr($item[1], "Molten_deathExplosion") Or StringInStr($item[1], "Molten_deathStart")) Then $item_affix_2D[$i][10] = $range_ice
			If (StringInStr($item[1], "demonmine_C") Or StringInStr($item[1], "Crater_DemonClawBomb")) Then $item_affix_2D[$i][10] = $range_mine
			If StringInStr($item[1], "creepMobArm") Then $item_affix_2D[$i][10] = $range_arm
			If (StringInStr($item[1], "spore") Or StringInStr($item[1], "Plagued_endCloud") Or StringInStr($item[1], "Poison")) Then $item_affix_2D[$i][10] = $range_peste
			If StringInStr($item[1], "ArcaneEnchanted_petsweep") Then $item_affix_2D[$i][10] = $range_arcane

;~ 			   if $item_affix_2D[$i][10]-$item_affix_2D[$i][9]>0 then $ii=$ii+1

			$i += 1
		EndIf
	WEnd
;~  or $ii=0
	If $i = 0 Then
		Return False
	Else

		_ArraySort($item_affix_2D, 0, 0, 0, 9)

		Return $item_affix_2D
	EndIf
EndFunc   ;==>IterateFilterAffix

Func IsAffix($item, $pv = 0)
	If $item[9] < 50 Then
		If ((StringInStr($item[1], "bomb_buildup") And $pv <= $Life_explo / 100) Or _
				(StringInStr($item[1], "demonmine_C") And $pv <= $Life_mine / 100) Or _
				(StringInStr($item[1], "creepMobArm") And $pv <= $Life_arm / 100) Or _
				(StringInStr($item[1], "woodWraith_explosion") And $pv <= $Life_spore / 100) Or _
				(StringInStr($item[1], "WoodWraith_sporeCloud_emitter") And $pv <= $Life_spore / 100) Or _
				(StringInStr($item[1], "sandwasp_projectile") And $pv <= $Life_proj / 100) Or _
				(StringInStr($item[1], "Crater_DemonClawBomb") And $pv <= $Life_mine / 100) Or _
				(StringInStr($item[1], "Molten_deathExplosion") And $pv <= $Life_explo / 100) Or _
				(StringInStr($item[1], "Molten_deathStart") And $pv <= $Life_explo / 100) Or _
				(StringInStr($item[1], "icecluster") And $pv <= $Life_ice / 100) Or _
				(StringInStr($item[1], "spore") And $pv <= $Life_spore / 100) Or _
				(StringInStr($item[1], "ArcaneEnchanted_petsweep") And $pv <= $Life_arcane / 100) Or _
				(StringInStr($item[1], "desecrator") And $pv <= $Life_profa / 100) Or _
				(StringInStr($item[1], "Plagued_endCloud") And $pv <= $Life_peste / 100) Or _
				(StringInStr($item[1], "poison") And $pv <= $Life_poison / 100) Or _
				(StringInStr($item[1], "molten_trail") And $pv <= $Life_lave / 100)) _
				And CheckFromList($BanAffixList, $item[1]) = 0 Then
			Return True
		Else
			Return False
		EndIf
	EndIf

EndFunc   ;==>IsAffix

Func UseBookOfCain()

	;TCHAT
	If ($PartieSolo = 'false') Then
		Switch Random(1, 2, 1)
			Case 1
				WriteInChat("je vends")
			Case 2
				WriteInChat("bof rien à garder comme d'hab")
		EndSwitch
	EndIf
	If IsInventoryOpened() = True Then
		Send("i")
		Sleep(150)
	EndIf

	Switch $Act
		Case 1
			InteractByActorName("Waypoint_Town");ajouter pour ne pas blocqué au coffre
			MoveToPos(2955.8681640625, 2803.51489257813, 24.0453319549561, 0, 20)
		Case 2
			;do nothing act 2
		Case 3 To 4
			MoveToPos(395.930847167969, 390.577362060547, 0.408410131931305, 0, 20)
	EndSwitch

	InteractByActorName("All_Book_Of_Cain")
	While Not FastCheckUiItemVisible("Root.NormalLayer.game_dialog_backgroundScreen.loopinganimmeter", 1, 1512) And Not DetectUiError($MODE_NO_IDENTIFIED_ITEM)
		;_Log("Ui : " & FastCheckUiItemVisible("Root.NormalLayer.game_dialog_backgroundScreen.loopinganimmeter", 1, 1512) & " Error : " &  FastCheckUiItemVisible("Root.TopLayer.error_notify.error_text", 1, 1185))
		_Log("tour boucle")
		If Not FastCheckUiItemVisible("Root.NormalLayer.game_dialog_backgroundScreen.loopinganimmeter", 1, 1512) Then
			InteractByActorName("All_Book_Of_Cain")
		EndIf
	WEnd
	While FastCheckUiItemVisible("Root.NormalLayer.game_dialog_backgroundScreen.loopinganimmeter", 1, 1512)
		Sleep(50)
	WEnd
EndFunc   ;==>UseBookOfCain

Func MoveToPointZero();function qui a pour bu de le placer au point voulu dans chaque act

	If IsInventoryOpened() = True Then
		Send("i")
		Sleep(150)
	EndIf

	Switch $Act
		Case 1
			MoveToPos(2955.8681640625, 2803.51489257813, 24.0453319549561, 0, 20)
		Case 2
			;do nothing act 2
		Case 3 To 4
			;do nothing act 3 and 4
	EndSwitch

	Sleep(50)
EndFunc   ;==>MoveToPointZero

Func GetGold()
	IterateLocalActor()
	$foundobject = 0
	For $i = 0 To UBound($__ACTOR, 1) - 1
		If StringInStr($__ACTOR[$i][2], "GoldCoin-") Then
			Return IterateActorAttributes($__ACTOR[$i][1], $Atrib_ItemStackQuantityLo)
			ExitLoop
		EndIf
	Next
	Return 0
EndFunc   ;==>GetGold

;TCHAT
Func WriteInChat($str)
	_Log("--------------------> TCHAT : " & $str & @CRLF)
	Send("{ENTER}") ;validation de la fenetre de tchat sur le groupe
	Send('' & $str & '');Ecriture du message
	Send("{ENTER}") ;Envoie du message et sort de la fenetre du tchat
EndFunc   ;==>WriteInChat

#include-once
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
	$vftableSubA = _MemoryRead($vftableSubA + 0x928, $d3, 'ptr')
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
			_Log("Mesure FindActor Trouv�" & TimerDiff($hTimer) & @CRLF)
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
				If ($PartieSolo = 'false') Then WriteMe($WRITE_ME_HAVE_LEGENDARY) ; TChat
				$nbLegs += 1 ; on definit les legendaire et on compte les legs id au coffre
			ElseIf ($quality = 6) Then
				$nbRares += 0 ; on definit les rares
			EndIf

			$itemDestination = CheckItem($__ACDACTOR[$i][0], $__ACDACTOR[$i][1], 1) ;on recupere ici ce que l'on doit faire de l'objet (stash/inventaire/trash)

			$return[$i][0] = $__ACDACTOR[$i][3] ;definit la collone de l'item
			$return[$i][1] = $__ACDACTOR[$i][4] ;definit la ligne de l'item
			$return[$i][3] = $quality

			;;;       If $itemDestination = "Stash_Filtre" And trim(StringLower($Unidentified)) = "false" Then ;Si c'est un item � filtrer et que l'on a definit Unidentified sur false (il faudra juste changer le nom de la variable Unidentifier)
			If $itemDestination = "Stash_Filtre" Then ;Si c'est un item � filtrer
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
				If $return[$i][2] = "Trash" And $return[$i][3] > 2 And $return[$i][3] < $QualityRecycle Then ; si trash + qualit� >2, soit les bleus et jaunes, mettre 5 pour ne recycler que les jaunes.
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
				If ($PartieSolo = 'false') Then WriteMe($WRITE_ME_HAVE_LEGENDARY) ; TChat
				$nbLegs += 1 ; on definit les legendaire et on compte les legs unid au coffre
			ElseIf ($quality = 6) Then
				$nbRaresUnid += 0 ; on definit les rares
			EndIf

			$itemDestination = CheckItem($__ACDACTOR[$i][0], $__ACDACTOR[$i][1], 1) ;on recupere ici ce que l'on doit faire de l'objet (stash/inventaire/trash)

			$return[$i][0] = $__ACDACTOR[$i][3] ;definit la collone de l'item
			$return[$i][1] = $__ACDACTOR[$i][4] ;definit la ligne de l'item
			$return[$i][3] = $quality

			If $Unidentified = "false" And $Identified = "false" Then ;ajouter pour ne rien filtrer
				If $itemDestination = "Stash_Filtre" Then ;on traite la qualit�
					If ($quality < 9) Then;si la qualit� est plus petite que 9 on jette
						$return[$i][2] = "Trash"
						_Log('invalide', 1)
						_Log(' - ', 1)
					EndIf

				Else
					$return[$i][2] = $itemDestination ;row
				EndIf

			EndIf


			If $Unidentified = "true" Then
				If $itemDestination = "Stash_Filtre" Then ;Si c'est un item � filtrer
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
				If $return[$i][2] = "Trash" And $return[$i][3] > 2 And $return[$i][3] < $QualityRecycle Then ; si trash + qualit� >2, soit les bleus et jaunes, mettre 5 pour ne recycler que les jaunes.
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

                Local $splitName = StringSplit($_NAME, "_")
                $nameCharacter = $splitName[1]


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

Func IsPlayerMoving()
	Return _MemoryRead($ClickToMoveToggle, $d3, 'float')
EndFunc

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

Func DetectElite($Guid)
	Return _MemoryRead(GetACDOffsetByACDGUID($Guid) + 0xB8, $d3, 'int')
EndFunc   ;==>DetectElite

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
			; After this time we should already have the item
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

; TODO : check o� le mettre
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

; TODO : check o� le mettre
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

; TODO : check o� le mettre
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

; TODO : voir a quoi �a sert et o�
Func ResetTimerIgnore()
	If TimerDiff($timer_ignore_reset) > 120000 Then

		ReDim $ignore_affix[1][2]
		$timer_ignore_reset = TimerInit()
	EndIf
EndFunc   ;==>ResetTimerIgnore

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


;--------------------------------------------------------------------
;	NE PAS TIDY CE FICHIER ! (CTRL + T)
;--------------------------------------------------------------------
#include-once

; const
Global Const $PI = 3.141593

; check ui error
Global Const $MODE_INVENTORY_FULL 		= 0
Global Const $MODE_STASH_FULL	  		= 1
Global Const $MODE_BOSS_TP_DENIED 		= 2
Global Const $MODE_NO_IDENTIFIED_ITEM 	= 3

; ?
Global $ClickToMoveToggle
Global $GameFailed
Global $CheckGameLength
Global $ResActivated
Global $Step
Global $a_range
Global $d3

Global $BanmonsterList
Global $File_Sequence
Global $ResLife
Global $Res_compt
Global $takeShrines
Global $nb_die_t
Global $rdn_die_t

Global $Byte_NoItem_Identify
Global $Xp_Moy_Hrs
Global $_ActorAtrib_Count
Global $_MyGuid
Global $ofs_LocalActor_StrucSize
Global $ofs_objectmanager

Global $Byte_Boss_TpDeny[2]
Global $Byte_Full_Inventory[2]
Global $Byte_Full_Stash[2]
Global $GrabListTab
Global $_ActorAtrib_4
Global $_MyACDWorld
Global $_MyCharType
Global $_MyGuid
Global $_Myoffset
Global $_defcount
Global $_deflink
Global $_defptr
Global $_ofs_FileMonster_LevelHell
Global $_ofs_FileMonster_LevelInferno
Global $_ofs_FileMonster_LevelNightmare
Global $_ofs_FileMonster_LevelNormal
Global $_ofs_FileMonster_MonsterRace
Global $_ofs_FileMonster_MonsterType
Global $allSNOitems
Global $grablist
Global $ofs_ActorAtrib_StrucSize
Global $ofs_ActorDef
Global $ofs_LocalActor_atribGUID
Global $ofs_MonsterDef


; Variable global pour Automatisation des séquences
Global $Act1_Hero_Axe_Z
Global $Act2_Hero_Axe_Z
Global $Act3_Hero_Axe_Z
Global $Act_Encour
Global $ChainageActeEnCour[3]
Global $ChainageActe[6][3]      = [[1, 2, 3],[1, 3, 2],[2, 1, 3],[2, 3, 1],[3, 1, 2],[3, 2, 1]]
Global $Choix_Act_Run
Global $ColonneEnCour
Global $NbreRunChangSeqAlea
Global $NombreDeRun
Global $NombreMaxiAct1
Global $NombreMaxiAct2
Global $NombreMaxiAct3
Global $NombreMiniAct1
Global $NombreMiniAct2
Global $NombreMiniAct3
Global $NombreRun_Encour
Global $Nombre_de_Run
Global $SequenceFileAct1
Global $SequenceFileAct2
Global $SequenceFileAct3
Global $SequenceFileAct333
Global $SequenceFileAct362
Global $SequenceFileAct373
Global $SequenceFileAct3PtSauve
Global $Sequence_Aleatoire
Global $fileLog
Global $numLigneFichier
; Fin Variable global pour Automatisation des séquences

;Gestion des Skills suivant les Héros, de la difficulté et de la puissance des monstres
Global $Heros
Global $PuisMonstre
Global $TypeDeGrabList
Global $TypedeBot
Global $difficulte
;Gestion des Skills suivant les Héros

;Variable d'initialisation de la pause repas
Global $collationOK             = 0
Global $dejeunerOK              = 0
Global $dinerOK                 = 0
Global $gouterOK                = 0
Global $petitDejeunerOK         = 0
Global $tempsPause

;global ajouter
Global $BreakCounter            = 0
Global $BreakTimeCounter        = 0;global pour compter les pauses
Global $CptElite                = 0
Global $GOLDMOYbyHgame          = 0
Global $GoldByRepaire           = 0;global pour récupèré l'or
Global $GoldBySale              = 0
Global $ItemToRecycle           = 0
Global $PauseRepasCounter       = 0
Global $CheckTakeShrineTaken             = 0;global pour compter elite,item recyclé et CheckTakeShrine
Global $Xp_Moy_HrsPerte         = 0;globale pour xp et gold /heure temps de jeu
Global $Xp_Moy_Hrsgame          = 0
Global $dif_timer_stat_game     = 0;global de temps de pause et temps de jeu
Global $dif_timer_stat_pause    = 0
Global $nbLegs                  = 0;global pour compter les items
Global $nbRares                 = 0
Global $nbRaresUnid             = 0
Global $tempsPauseGame          = 0
Global $tempsPauserepas         = 0;global pour récupèré temps de pause
;fin global ajouter

; global sur la fenetre d3
Global $posd3
Global $DebugX
Global $DebugY

Global $Ban_ItemACDCheckList    = "a1_|a3_|a2_|a4_|Lore_Book_Flippy|Topaz_|Emeraude_|Rubis_|Amethyste_|healthPotion_Mythic|GoldCoins|GoldSmall|GoldMedium|GoldLarge"
Global $Ban_endstrItemList      = "_projectile"
Global $Ban_startstrItemList    = "barbarian_|Demonhunter_|Monk_|WitchDoctor_|WD_|Enchantress_|Scoundrel_|Templar_|Wizard_|monsterAffix_|Demonic_|Generic_|fallenShaman_fireBall_impact|demonFlyer_B_clickable_corpse_01|grenadier_proj_trail"
Global $Count_ACD               = 0
Global $Current_Hero_Z          = 0
Global $Death                   = 0
Global $DeathCountToggle        = True
Global $DebugMessage
Global $DieTooFastCount           = 0
Global $EBP                     = 0
Global $GF                      = 0
Global $GOLD                    = 0
Global $GOLDINI                 = 0
Global $GOLDInthepocket         = 0
Global $GOLDMOY                 = 0
Global $GOLDMOYbyH              = 0
Global $GameDifficulty          = 0
Global $GameFailed              = 0
Global $CheckGameLength            = False
Global $GetACD
Global $Hero_Axe_Z              = 10
Global $IgnoreItemList          = ""
Global $ItemToSell              = 0
Global $ItemToStash             = 0
Global $LV                      = 0
Global $MF                      = 0
Global $MP
Global $MS                      = 0
Global $NeedRepairCount         = 0
Global $PR                      = 0
Global $Paused
Global $RepairORsell            = 0
Global $RepairTab               = 0
Global $SkippedMove             = 0
Global $Step                    = $PI / 6
Global $Totalruns               = 1
Global $TryLoginD3             = 0
Global $TryResumeGame          = 0
Global $act                     = 0
Global $area                    = 0
Global $begin_timer_stat        = 0
Global $dif_timer_stat          = 0
Global $dif_timer_stat_formater = 0
Global $dif_timer_stat_moyen    = 0
Global $disconnectcount         = 0
Global $elite                   = 0
Global $fichierlog              = "log-" & @YEAR & "_" & @MDAY & "_" & @MON & "_" & @HOUR & "h" & @MIN & ".txt"
Global $fichierstat             = "stat_" & @YEAR & "_" & @MON & "_" & @MDAY & "-" & @HOUR & "h" & @MIN & ".txt"
Global $gamecounter             = 0
Global $games                   = 1
Global $grabskip                = 0
Global $grabtimeout             = 0
Global $HandleBanList1         = ""
Global $HandleBanList2         = ""
Global $HandleBanListdef       = ""
Global $hotkeycheck             = 0
Global $killtimeout             = 0
Global $maxhp
Global $mousedownleft           = 0
Global $nameCharacter
Global $spell_gestini_verif     = 0
Global $success                 = 0
Global $successratio            = 1
Global $timeForSpell1           = 0
Global $timeForSpell2           = 0
Global $timeForSpell3           = 0
Global $timeForSpell4           = 0
Global $timedifmaxgamelength    = 0
Global $timeforRightclick       = 0
Global $timeforclick            = 0
Global $timeforpotion           = 0
Global $timeforskill            = 0
Global $timer_stat_run_moyen    = 0
Global $timer_stat_total        = 0
Global $timermaxgamelength      = 0

;var xp
Global $Expencours              = 0
Global $ExperienceNextLevel     = 0
Global $NiveauParagon           = 0
Global $Xp_Total                = 0

; GUID / UI items
Global $uiPlayerDead	= "NormalLayer.deathmenu_dialog"

; Actor
Global $actorStash = "Player_Shared_Stash"

; decor
Global $decorlist = ""
Global $bandecorlist = ""


;Setup the settings file if it don't exist, overwise, setup de globals
;------------------------------------------------------------------------
#AutoIt3Wrapper_UseX64=n
#include-once

Global $Skill1[11]
Global $Skill2[11]
Global $Skill3[11]
Global $Skill4[11]
Global $Skill5[11]
Global $Skill6[11]


Global $Skill_conf1[6]
Global $Skill_conf2[6]
Global $Skill_conf3[6]
Global $Skill_conf4[6]
Global $Skill_conf5[6]
Global $Skill_conf6[6]


Global $MonsterTri = "True"
Global $MonsterRefresh = "True"
Global $ItemRefresh = "True"

;Valeur par défaut False
Global $MonsterPriority = "True"
Global $Unidentified = "false"
Global $Identified = "true"

Global $BreakTime = 360
Global $Breakafterxxgames = Round(Random(4, 8))
Global $TakeABreak = "false"
Global $PauseRepas = "false"
Global $PartieSolo = "true"

Global $profilFile = "settings.ini"
Global $a_range = Round(Random(55, 60))
Global $g_range = Round(Random(100, 120))
Global $a_time = 9000
Global $g_time = 7500
Global $SpecialmonsterList = "Goblin|brickhouse_|woodwraith_"
Global $monsterList = "Beast_B|Goatman_M|Goatman_R|WitherMoth|Beast_A|Scavenger|zombie|Corpulent|Skeleton|QuillDemon|FleshPitFlyer|Succubus|Scorpion|azmodanBodyguard|succubus|ThousandPounder|Fallen|GoatMutant|demonFlyer_B|creepMob|Triune_|TriuneVesselActivated_|TriuneVessel|Triune_Summonable_|ConductorProxyMaster|sandWasp|TriuneCultist|SandShark|Lacuni"
Global $BanmonsterList = "Skeleton_Archer_A_Unique_Ring_|Skeleton_A_Unique_Ring_|WD_ZombieDog|WD_wallOfZombies|DH_Companion"
Global $grabListFile = ""
Global $Potions = "healthPotion_Mythic"
Global $repairafterxxgames = Round(Random(4, 8))
Global $maxgamelength = 560000
Global $d3pass = ""
Global $PreBuff1 = ""
Global $ToucheBuff1 = ""
Global $delaiBuff1 = ""
Global $PreBuff2 = ""
Global $ToucheBuff2 = ""
Global $delaiBuff2 = ""
Global $PreBuff3 = ""
Global $ToucheBuff3 = ""
Global $delaiBuff3 = ""
Global $PreBuff4 = ""
Global $ToucheBuff4 = ""
Global $delaiBuff4 = ""
Global $QualityLevel = 9
Global $LifeForPotion = 50
Global $takepot = True
Global $PotionStock = 100
Global $TakeCheckTakeShrines = "false"

Global $MaximumHatred = 125
Global $MaximumDiscipline = 25
Global $MaximumSpirit = 100
Global $MaximumFury = 100
Global $MaximumArcane = 100
Global $MaximumMana = 100

;Global $Act = "3"
Global $Devmode = "true"

Global $UsePath = "false"
Global $ResActivated = "false"
Global $ResLife = "0"
Global $Res_compt = 0
Global $nb_die_t = 0
Global $rdn_die_t = 0

Global $ftpserver = ""
Global $ftpusername = ""
Global $ftppass = ""
Global $ftpfilename = ""

Global $File_Sequence = "sequence\sequence.txt"

Global $Key1 = "&"
Global $Key2 = "é"
Global $Key3 = '"'
Global $Key4 = "'"

Global $InventoryCheck = "False"



Global $tab_aff[60][2] = [ _
		[-5, -5],[-5, 5],[5, -5],[5, 5], _
		[-10, -10],[-10, 10],[10, -10],[10, 10], _
		[-15, -10],[-15, 10],[15, -10],[15, 10], _
		[-10, -20],[-10, 20],[10, -20],[10, 20], _
		[-20, -10],[-20, 10],[20, -10],[20, 10], _
		[-10, -15],[-10, 15],[10, -15],[10, 15], _
		[-15, -15],[-15, 15],[15, -15],[15, 15], _
		[-20, -20],[-20, 20],[20, -20],[20, 20], _
		[-25, -25],[-25, 25],[25, -25],[25, 25], _
		[-30, -30],[-30, 30],[30, -30],[30, 30], _
		[-40, -40],[-40, 40],[40, -40],[40, 40], _
		[-50, -50],[-50, 50],[50, -50],[50, 50], _
		[-60, -60],[-60, 60],[60, -60],[60, 60], _
		[-70, -70],[-70, 70],[70, -70],[70, 70], _
		[-80, -80],[-80, 80],[80, -80],[80, 80] _
		]
Global $tab_aff2[15][2] = [ _
		[5, 5],[10, 10],[15, 10],[10, 20], _
		[20, 10],[10, 15],[15, 15],[20, 20], _
		[25, 25],[30, 30],[40, 40],[50, 50], _
		[60, 60],[70, 70],[80, 80] _
		]
Global $gestion_affixe = "false"
Global $gestion_affixe_loot = "false"
Global $range_arcane = 25
Global $range_peste = 18
Global $range_profa = 13
Global $range_lave = 13
Global $range_arm = 15
Global $range_mine = 13
Global $range_explosion = 18
Global $range_ice = 20
Global $life_arcane = 100
Global $life_peste = 100
Global $life_profa = 100
Global $life_ice = 100
Global $life_poison = 100
Global $life_explo = 100
Global $life_lave = 100
Global $life_proj = 100
Global $life_mine = 100
Global $life_arm = 100
Global $life_spore = 100
Global $maff_timer = TimerInit()
Global $timer_ignore_reset = TimerInit()
Global $energy_mini = 0
Global $BanAffixList = ""
Global $ignore_affix[1][2]

Global $Gest_affixe_ByClass = "false"
Global $key_cana = ""
Global $cana_statut = ""

; Recyclage
Global $Recycle = "false"
Global $QualityRecycle = 9


Func writeConfigs($profilFile = "settings.ini", $creation = 0)
	IniWrite($profilFile, "Account info", "pass", 0)
	IniWrite($profilFile, "Account info", "ftpserver", $ftpserver)
	IniWrite($profilFile, "Account info", "ftpusername", $ftpusername)
	IniWrite($profilFile, "Account info", "ftppass", $ftppass)
	IniWrite($profilFile, "Account info", "ftpfilename", $ftpfilename)

	IniWrite($profilFile, "Run info", "SequenceFile", $File_Sequence)
	IniWrite($profilFile, "Run info", "UsePath", $UsePath)
	IniWrite($profilFile, "Run info", "ResActivated", $ResActivated)
	IniWrite($profilFile, "Run info", "Reslife", $ResLife)
	IniWrite($profilFile, "Run info", "monsterList", $monsterList)
	IniWrite($profilFile, "Run info", "specialmonsterList", $SpecialmonsterList)
	IniWrite($profilFile, "Run info", "MonsterTri", $MonsterTri)
	IniWrite($profilFile, "Run info", "MonsterRefresh", $MonsterRefresh)
	IniWrite($profilFile, "Run info", "ItemRefresh", $ItemRefresh)
	IniWrite($profilFile, "Run info", "MonsterPriority", $MonsterPriority)
	IniWrite($profilFile, "Run info", "grabListFile", $grabListFile)
	IniWrite($profilFile, "Run info", "QualiteItem", $QualityLevel)
	IniWrite($profilFile, "Run info", "attackRange", $a_range)
	IniWrite($profilFile, "Run info", "grabRange", $g_range)
	IniWrite($profilFile, "Run info", "attacktimeout", $a_time)
	IniWrite($profilFile, "Run info", "grabtimeout", $g_time)
	IniWrite($profilFile, "Run info", "repairafterxxgames", $repairafterxxgames)
	IniWrite($profilFile, "Run info", "maxgamelength", $maxgamelength)
	IniWrite($profilFile, "Run info", "BreakTime", $BreakTime)
	IniWrite($profilFile, "Run info", "Breakafterxxgames", $Breakafterxxgames)
	IniWrite($profilFile, "Run info", "TakeABreak", $TakeABreak)
	IniWrite($profilFile, "Run info", "Potions", $Potions)
	IniWrite($profilFile, "Run info", "PreBuff1", $PreBuff1)
	IniWrite($profilFile, "Run info", "ToucheBuff1", $ToucheBuff1)
	IniWrite($profilFile, "Run info", "delaiBuff1", $delaiBuff1)
	IniWrite($profilFile, "Run info", "PreBuff2", $PreBuff2)
	IniWrite($profilFile, "Run info", "ToucheBuff2", $ToucheBuff2)
	IniWrite($profilFile, "Run info", "delaiBuff2", $delaiBuff2)
	IniWrite($profilFile, "Run info", "PreBuff3", $PreBuff3)
	IniWrite($profilFile, "Run info", "ToucheBuff3", $ToucheBuff3)
	IniWrite($profilFile, "Run info", "delaiBuff3", $delaiBuff3)
	IniWrite($profilFile, "Run info", "PreBuff4", $PreBuff4)
	IniWrite($profilFile, "Run info", "ToucheBuff4", $ToucheBuff4)
	IniWrite($profilFile, "Run info", "delaiBuff4", $delaiBuff4)
	IniWrite($profilFile, "Run info", "LifeForPotion", $LifeForPotion)
	IniWrite($profilFile, "Run info", "PotionStock", $PotionStock)
	IniWrite($profilFile, "Run info", "TakeCheckTakeShrines", $TakeCheckTakeShrines)
	IniWrite($profilFile, "Run info", "Unidentified", $Unidentified)
	IniWrite($profilFile, "Run info", "Identified", $Identified)

	IniWrite($profilFile, "Run info", "SpellOnLeft", $Skill_conf1[0])
	IniWrite($profilFile, "Run info", "SpellDelayLeft", $Skill_conf1[1])
	IniWrite($profilFile, "Run info", "SpellTypeLeft", $Skill_conf1[2])
	IniWrite($profilFile, "Run info", "SpellEnergyNeedsLeft", $Skill_conf1[3])
	IniWrite($profilFile, "Run info", "SpellLifeLeft", $Skill_conf1[4])
	IniWrite($profilFile, "Run info", "SpellDistanceLeft", $Skill_conf1[5])

	IniWrite($profilFile, "Run info", "SpellOnRight", $Skill_conf2[0])
	IniWrite($profilFile, "Run info", "SpellDelayRight", $Skill_conf2[1])
	IniWrite($profilFile, "Run info", "SpellTypeRight", $Skill_conf2[2])
	IniWrite($profilFile, "Run info", "SpellEnergyNeedsRight", $Skill_conf2[3])
	IniWrite($profilFile, "Run info", "SpellLifeRight", $Skill_conf2[4])
	IniWrite($profilFile, "Run info", "SpellDistanceRight", $Skill_conf2[5])

	IniWrite($profilFile, "Run info", "SpellOn1", $Skill_conf3[0])
	IniWrite($profilFile, "Run info", "SpellDelay1", $Skill_conf3[1])
	IniWrite($profilFile, "Run info", "SpellType1", $Skill_conf3[2])
	IniWrite($profilFile, "Run info", "SpellEnergyNeeds1", $Skill_conf3[3])
	IniWrite($profilFile, "Run info", "SpellLife1", $Skill_conf3[4])
	IniWrite($profilFile, "Run info", "SpellDistance1", $Skill_conf3[5])

	IniWrite($profilFile, "Run info", "SpellOn4", $Skill_conf4[0])
	IniWrite($profilFile, "Run info", "SpellDelay4", $Skill_conf4[1])
	IniWrite($profilFile, "Run info", "SpellType4", $Skill_conf4[2])
	IniWrite($profilFile, "Run info", "SpellEnergyNeeds4", $Skill_conf4[3])
	IniWrite($profilFile, "Run info", "SpellLife4", $Skill_conf4[4])
	IniWrite($profilFile, "Run info", "SpellDistance4", $Skill_conf4[5])

	IniWrite($profilFile, "Run info", "SpellOn5", $Skill_conf5[0])
	IniWrite($profilFile, "Run info", "SpellDelay5", $Skill_conf5[1])
	IniWrite($profilFile, "Run info", "SpellType5", $Skill_conf5[2])
	IniWrite($profilFile, "Run info", "SpellEnergyNeeds5", $Skill_conf5[3])
	IniWrite($profilFile, "Run info", "SpellLife5", $Skill_conf5[4])
	IniWrite($profilFile, "Run info", "SpellDistance5", $Skill_conf5[5])

	IniWrite($profilFile, "Run info", "SpellOn6", $Skill_conf6[0])
	IniWrite($profilFile, "Run info", "SpellDelay6", $Skill_conf6[1])
	IniWrite($profilFile, "Run info", "SpellType6", $Skill_conf6[2])
	IniWrite($profilFile, "Run info", "SpellEnergyNeeds6", $Skill_conf6[3])
	IniWrite($profilFile, "Run info", "SpellLife6", $Skill_conf6[4])
	IniWrite($profilFile, "Run info", "SpellDistance6", $Skill_conf6[5])

	IniWrite($profilFile, "Run info", "Key1", $Key1)
	IniWrite($profilFile, "Run info", "Key1", $Key2)
	IniWrite($profilFile, "Run info", "Key1", $Key3)
	IniWrite($profilFile, "Run info", "Key1", $Key4)

	IniWrite($profilFile, "Run info", "InventoryCheck", $InventoryCheck)

	IniWrite($profilFile, "Run info", "gestion_affixe", $gestion_affixe)
	IniWrite($profilFile, "Run info", "gestion_affixe_loot", $gestion_affixe_loot)
	IniWrite($profilFile, "Run info", "BanAffixList", $BanAffixList)
	IniWrite($profilFile, "Run info", "Life_Arcane", $life_arcane)
	IniWrite($profilFile, "Run info", "Life_Peste", $life_peste)
	IniWrite($profilFile, "Run info", "Life_Profa", $life_profa)
	IniWrite($profilFile, "Run info", "Life_Mine", $life_mine)
	IniWrite($profilFile, "Run info", "Life_Spore", $life_spore)
	IniWrite($profilFile, "Run info", "Life_Arm", $life_arm)
	IniWrite($profilFile, "Run info", "Life_Lave", $life_lave)
	IniWrite($profilFile, "Run info", "Life_Proj", $life_proj)
	IniWrite($profilFile, "Run info", "Life_Ice", $life_ice)
	IniWrite($profilFile, "Run info", "Life_Poison", $life_poison)
	IniWrite($profilFile, "Run info", "Life_Explo", $life_explo)

	IniWrite($profilFile, "Run info", "Gest_affixe_ByClass", $Gest_affixe_ByClass)

	; dev mod
	IniWrite($profilFile, "Run info", "Devmode", $Devmode)

	; Recyclage
	IniWrite($profilFile, "Run info", "Recycle", $Recycle)
	IniWrite($profilFile, "Run info", "QualityRecycle", $QualityRecycle)

EndFunc   ;==>writeConfigs

Func LoadConfigs($profilFile = "settings.ini", $creation = 0)

	;; Account info
	;$d3pass = IniRead($profilFile, "Account info", "pass", 0)
	$d3pass = IniRead($profilFile, "Account info", "pass", $d3pass)
	$ftpserver = IniRead($profilFile, "Account info", "ftpserver", $ftpserver)
	$ftpusername = IniRead($profilFile, "Account info", "ftpusername", $ftpusername)
	$ftppass = IniRead($profilFile, "Account info", "ftppass", $ftppass)
	$ftpfilename = IniRead($profilFile, "Account info", "ftpfilename", $ftpfilename)

	;; Run info


	;; Ajout config run
	$Choix_Act_Run = IniRead($profilFile, "Run info", "Choix_Act_Run", $Choix_Act_Run)

	Switch $Choix_Act_Run
		Case 0
			$Hero_Axe_Z = IniRead($profilFile, "Run info", "Hero_Axe_Z", $Hero_Axe_Z)
			$File_Sequence = IniRead($profilFile, "Run info", "SequenceFile", $File_Sequence)

		Case 1
			$Act1_Hero_Axe_Z = IniRead($profilFile, "Run info", "Act1_Hero_Axe_Z", $Act1_Hero_Axe_Z)
			$SequenceFileAct1 = IniRead($profilFile, "Run info", "SequenceFileAct1", $SequenceFileAct1)

		Case 2
			$Act2_Hero_Axe_Z = IniRead($profilFile, "Run info", "Act2_Hero_Axe_Z", $Act2_Hero_Axe_Z)
			$SequenceFileAct2 = IniRead($profilFile, "Run info", "SequenceFileAct2", $SequenceFileAct2)

		Case 3
			$Act3_Hero_Axe_Z = IniRead($profilFile, "Run info", "Act3_Hero_Axe_Z", $Act3_Hero_Axe_Z)
			$SequenceFileAct3 = IniRead($profilFile, "Run info", "SequenceFileAct3", $SequenceFileAct3)
			$SequenceFileAct3PtSauve = IniRead($profilFile, "Run info", "SequenceFileAct3PtSauve", $SequenceFileAct3PtSauve)

		Case 333 ; Act 3 quête 3 sous quête 3 --> tuez Ghom
			$Act3_Hero_Axe_Z = IniRead($profilFile, "Run info", "Act3_Hero_Axe_Z", $Act3_Hero_Axe_Z)
			$SequenceFileAct333 = IniRead($profilFile, "Run info", "SequenceFileAct333", $SequenceFileAct333)

		Case 362 ; Act 3 quête 6 sous quête 2 --> Tuez le briseur de siège
			$Act3_Hero_Axe_Z = IniRead($profilFile, "Run info", "Act3_Hero_Axe_Z", $Act3_Hero_Axe_Z)
			$SequenceFileAct362 = IniRead($profilFile, "Run info", "SequenceFileAct362", $SequenceFileAct362)

		Case 373 ; Act 3 quête 7 sous quête 3 --> Terrasez Asmodam
			$Act3_Hero_Axe_Z = IniRead($profilFile, "Run info", "Act3_Hero_Axe_Z", $Act3_Hero_Axe_Z)
			$SequenceFileAct373 = IniRead($profilFile, "Run info", "SequenceFileAct373", $SequenceFileAct373)

		Case -1
			$SequenceFileAct1 = IniRead($profilFile, "Run info", "SequenceFileAct1", $SequenceFileAct1)
			$SequenceFileAct2 = IniRead($profilFile, "Run info", "SequenceFileAct2", $SequenceFileAct2)
			$SequenceFileAct3 = IniRead($profilFile, "Run info", "SequenceFileAct3", $SequenceFileAct3)
			$SequenceFileAct3PtSauve = IniRead($profilFile, "Run info", "SequenceFileAct3PtSauve", $SequenceFileAct3PtSauve)
			$Act1_Hero_Axe_Z = IniRead($profilFile, "Run info", "Act1_Hero_Axe_Z", $Act1_Hero_Axe_Z)
			$Act2_Hero_Axe_Z = IniRead($profilFile, "Run info", "Act2_Hero_Axe_Z", $Act2_Hero_Axe_Z)
			$Act3_Hero_Axe_Z = IniRead($profilFile, "Run info", "Act3_Hero_Axe_Z", $Act3_Hero_Axe_Z)
			$Sequence_Aleatoire = IniRead($profilFile, "Run info", "Sequence_Aleatoire", $Sequence_Aleatoire)
			$NbreRunChangSeqAlea = IniRead($profilFile, "Run info", "NbreRunChangSeqAlea", $NbreRunChangSeqAlea)
			$Nombre_de_Run = IniRead($profilFile, "Run info", "Nombre_de_Run", $Nombre_de_Run)
			$NombreMiniAct1 = IniRead($profilFile, "Run info", "NombreMiniAct1", $NombreMiniAct1)
			$NombreMiniAct2 = IniRead($profilFile, "Run info", "NombreMiniAct2", $NombreMiniAct2)
			$NombreMiniAct3 = IniRead($profilFile, "Run info", "NombreMiniAct3", $NombreMiniAct3)
			$NombreMaxiAct1 = IniRead($profilFile, "Run info", "NombreMaxiAct1", $NombreMaxiAct1)
			$NombreMaxiAct2 = IniRead($profilFile, "Run info", "NombreMaxiAct2", $NombreMaxiAct2)
			$NombreMaxiAct3 = IniRead($profilFile, "Run info", "NombreMaxiAct3", $NombreMaxiAct3)
	EndSwitch
	;; Fin d'ajout config run


	$monsterList = IniRead($profilFile, "Run info", "monsterList", $monsterList)
	$SpecialmonsterList = IniRead($profilFile, "Run info", "SpecialmonsterList", $SpecialmonsterList)

	;Selection de la difficulte et du pm des monstres
	$difficulte = IniRead($profilFile, "Run info", "difficulte", $difficulte)
	$PuisMonstre = IniRead($profilFile, "Run info", "PuisMonstre", $PuisMonstre)

	;Selection du type de graliste pour le mode arma
	$TypeDeGrabList = IniRead($profilFile, "Run info", "TypeDeGrabList", $TypeDeGrabList)

	;Selection de la GrabListe suivant la difficulté
	Switch $difficulte
		Case 1
			$grabListFile = IniRead($profilFile, "Run info", "grablistNormal", $grabListFile)

		Case 2
			$grabListFile = IniRead($profilFile, "Run info", "grablistCauchemar", $grabListFile)

		Case 3
			$grabListFile = IniRead($profilFile, "Run info", "grablistEnfer", $grabListFile)

		Case 4
			Switch $TypeDeGrabList
				Case 1
					$grabListFile = IniRead($profilFile, "Run info", "grabListArma", $grabListFile)
				Case 2
					$grabListFile = IniRead($profilFile, "Run info", "grabListArmaXP", $grabListFile)
				Case 3
					$grabListFile = IniRead($profilFile, "Run info", "grabListArmaUnid", $grabListFile)
				Case 4
					$grabListFile = IniRead($profilFile, "Run info", "grabListArmaRecycle", $grabListFile)
			EndSwitch
	EndSwitch

	$QualityLevel = IniRead($profilFile, "Run info", "QualiteItem", $QualityLevel)

	$Unidentified = IniRead($profilFile, "Run info", "Unidentified", $Unidentified)
	$Identified = IniRead($profilFile, "Run info", "Identified", $Identified)

	;Fonction recyclage des items
	$Recycle = IniRead($profilFile, "Run info", "Recycle", $Recycle)
	$QualityRecycle = IniRead($profilFile, "Run info", "QualityRecycle", $QualityRecycle)
	;fin de la Fonction recyclage des items

	$BreakTime = IniRead($profilFile, "Run info", "BreakTime", $BreakTime)
	$Breakafterxxgames = IniRead($profilFile, "Run info", "Breakafterxxgames", $Breakafterxxgames)
	$TakeABreak = IniRead($profilFile, "Run info", "TakeABreak", $TakeABreak)
	$PauseRepas = IniRead($profilFile, "Run info", "PauseRepas", $PauseRepas)

	;Fonction Iniatialisation du Skill suivant le Héros
	$Heros = IniRead($profilFile, "Run info", "Heros", $Heros)

	Switch $Heros
		Case 1
			InitSkillHeros("settingsHero1.ini")
		Case 2
			InitSkillHeros("settingsHero2.ini")
		Case 3
			InitSkillHeros("settingsHero3.ini")
		Case 4
			InitSkillHeros("settingsHero4.ini")
		Case 5
			InitSkillHeros("settingsHero5.ini")
		Case 6
			InitSkillHeros("settingsHero6.ini")
		Case 7
			InitSkillHeros("settingsHero7.ini")
		Case 8
			InitSkillHeros("settingsHero8.ini")
		Case 9
			InitSkillHeros("settingsHero9.ini")
		Case 10
			InitSkillHeros("settingsHero10.ini")
	EndSwitch

	$TypedeBot = IniRead($profilFile, "Run info", "TypeDeBot", $TypedeBot)
	$PartieSolo = IniRead($profilFile, "Run info", "PartieSolo", $PartieSolo)

	; dev mod
	$Devmode = IniRead($profilFile, "Run info", "Devmode", $Devmode)


EndFunc   ;==>LoadConfigs

Func InitSkillHeros($skillHeros)

	$Potions = IniRead($skillHeros, "Run info", "Potions", $Potions)

	; pre-buff
	$Key1 = IniRead($skillHeros, "Run info", "Key1", $Key1)
	$Key2 = IniRead($skillHeros, "Run info", "Key2", $Key2)
	$Key3 = IniRead($skillHeros, "Run info", "Key3", $Key3)
	$Key4 = IniRead($skillHeros, "Run info", "Key4", $Key4)

	$PreBuff1 = IniRead($skillHeros, "Run info", "PreBuff1", $PreBuff1)
	$ToucheBuff1 = IniRead($skillHeros, "Run info", "ToucheBuff1", $ToucheBuff1)
	$delaiBuff1 = IniRead($skillHeros, "Run info", "delaiBuff1", $delaiBuff1)

	$PreBuff2 = IniRead($skillHeros, "Run info", "PreBuff2", $PreBuff2)
	$ToucheBuff2 = IniRead($skillHeros, "Run info", "ToucheBuff2", $ToucheBuff2)
	$delaiBuff2 = IniRead($skillHeros, "Run info", "delaiBuff2", $delaiBuff2)

	$PreBuff3 = IniRead($skillHeros, "Run info", "PreBuff3", $PreBuff3)
	$ToucheBuff3 = IniRead($skillHeros, "Run info", "ToucheBuff3", $ToucheBuff3)
	$delaiBuff3 = IniRead($skillHeros, "Run info", "delaiBuff3", $delaiBuff3)

	$PreBuff4 = IniRead($skillHeros, "Run info", "PreBuff4", $PreBuff4)
	$ToucheBuff4 = IniRead($skillHeros, "Run info", "ToucheBuff4", $ToucheBuff4)
	$delaiBuff4 = IniRead($skillHeros, "Run info", "delaiBuff4", $delaiBuff4)


	;; Spells
	$Skill_conf1[0] = IniRead($skillHeros, "Run info", "SpellOnLeft", $Skill_conf1[0])
	$Skill_conf1[1] = IniRead($skillHeros, "Run info", "SpellDelayLeft", $Skill_conf1[1])
	$Skill_conf1[2] = IniRead($skillHeros, "Run info", "SpellTypeLeft", $Skill_conf1[2])
	$Skill_conf1[3] = IniRead($skillHeros, "Run info", "SpellEnergyNeedsLeft", $Skill_conf1[3])
	$Skill_conf1[4] = IniRead($skillHeros, "Run info", "SpellLifeLeft", $Skill_conf1[4])
	$Skill_conf1[5] = IniRead($skillHeros, "Run info", "SpellDistanceLeft", $Skill_conf1[5])


	$Skill_conf2[0] = IniRead($skillHeros, "Run info", "SpellOnRight", $Skill_conf2[0])
	$Skill_conf2[1] = IniRead($skillHeros, "Run info", "SpellDelayRight", $Skill_conf2[1])
	$Skill_conf2[2] = IniRead($skillHeros, "Run info", "SpellTypeRight", $Skill_conf2[2])
	$Skill_conf2[3] = IniRead($skillHeros, "Run info", "SpellEnergyNeedsRight", $Skill_conf2[3])
	$Skill_conf2[4] = IniRead($skillHeros, "Run info", "SpellLifeRight", $Skill_conf2[4])
	$Skill_conf2[5] = IniRead($skillHeros, "Run info", "SpellDistanceRight", $Skill_conf2[5])


	$Skill_conf3[0] = IniRead($skillHeros, "Run info", "SpellOn1", $Skill_conf3[0])
	$Skill_conf3[1] = IniRead($skillHeros, "Run info", "SpellDelay1", $Skill_conf3[1])
	$Skill_conf3[2] = IniRead($skillHeros, "Run info", "SpellType1", $Skill_conf3[2])
	$Skill_conf3[3] = IniRead($skillHeros, "Run info", "SpellEnergyNeeds1", $Skill_conf3[3])
	$Skill_conf3[4] = IniRead($skillHeros, "Run info", "SpellLife1", $Skill_conf3[4])
	$Skill_conf3[5] = IniRead($skillHeros, "Run info", "SpellDistance1", $Skill_conf3[5])


	$Skill_conf4[0] = IniRead($skillHeros, "Run info", "SpellOn2", $Skill_conf4[0])
	$Skill_conf4[1] = IniRead($skillHeros, "Run info", "SpellDelay2", $Skill_conf4[1])
	$Skill_conf4[2] = IniRead($skillHeros, "Run info", "SpellType2", $Skill_conf4[2])
	$Skill_conf4[3] = IniRead($skillHeros, "Run info", "SpellEnergyNeeds2", $Skill_conf4[3])
	$Skill_conf4[4] = IniRead($skillHeros, "Run info", "SpellLife2", $Skill_conf4[4])
	$Skill_conf4[5] = IniRead($skillHeros, "Run info", "SpellDistance2", $Skill_conf4[5])


	$Skill_conf5[0] = IniRead($skillHeros, "Run info", "SpellOn3", $Skill_conf5[0])
	$Skill_conf5[1] = IniRead($skillHeros, "Run info", "SpellDelay3", $Skill_conf5[1])
	$Skill_conf5[2] = IniRead($skillHeros, "Run info", "SpellType3", $Skill_conf5[2])
	$Skill_conf5[3] = IniRead($skillHeros, "Run info", "SpellEnergyNeeds3", $Skill_conf5[3])
	$Skill_conf5[4] = IniRead($skillHeros, "Run info", "SpellLife3", $Skill_conf5[4])
	$Skill_conf5[5] = IniRead($skillHeros, "Run info", "SpellDistance3", $Skill_conf5[5])


	$Skill_conf6[0] = IniRead($skillHeros, "Run info", "SpellOn4", $Skill_conf6[0])
	$Skill_conf6[1] = IniRead($skillHeros, "Run info", "SpellDelay4", $Skill_conf6[1])
	$Skill_conf6[2] = IniRead($skillHeros, "Run info", "SpellType4", $Skill_conf6[2])
	$Skill_conf6[3] = IniRead($skillHeros, "Run info", "SpellEnergyNeeds4", $Skill_conf6[3])
	$Skill_conf6[4] = IniRead($skillHeros, "Run info", "SpellLife4", $Skill_conf6[4])
	$Skill_conf6[5] = IniRead($skillHeros, "Run info", "SpellDistance4", $Skill_conf6[5])


	; Routines
	$LifeForPotion = IniRead($skillHeros, "Run info", "LifeForPotion", $LifeForPotion)
	$PotionStock = IniRead($skillHeros, "Run info", "PotionStock", $PotionStock)

	$TakeCheckTakeShrines = IniRead($skillHeros, "Run info", "TakeCheckTakeShrines", $TakeCheckTakeShrines)

	$repairafterxxgames = IniRead($skillHeros, "Run info", "repairafterxxgames", $repairafterxxgames)

	$maxgamelength = IniRead($skillHeros, "Run info", "maxgamelength", $maxgamelength)
	$a_range = IniRead($skillHeros, "Run info", "attackRange", $a_range)
	$g_range = IniRead($skillHeros, "Run info", "grabRange", $g_range)

	$MonsterTri = IniRead($skillHeros, "Run info", "MonsterTri", $MonsterTri)
	$MonsterRefresh = IniRead($skillHeros, "Run info", "MonsterRefresh", $MonsterRefresh)
	$ItemRefresh = IniRead($skillHeros, "Run info", "ItemRefresh", $ItemRefresh)
	$MonsterPriority = IniRead($skillHeros, "Run info", "MonsterPriority", $MonsterPriority)
	$InventoryCheck = IniRead($skillHeros, "Run info", "InventoryCheck", $InventoryCheck)

	$a_time = IniRead($skillHeros, "Run info", "attacktimeout", $a_time)
	$g_time = IniRead($skillHeros, "Run info", "grabtimeout", $g_time)


	$gestion_affixe = IniRead($skillHeros, "Run info", "gestion_affixe", $gestion_affixe)
	$gestion_affixe_loot = IniRead($skillHeros, "Run info", "gestion_affixe_loot", $gestion_affixe_loot)
	$BanAffixList = IniRead($skillHeros, "Run info", "BanAffixList", $BanAffixList)
	$Gest_affixe_ByClass = IniRead($skillHeros, "Run info", "Gest_affixe_ByClass", $Gest_affixe_ByClass)

	$life_arcane = IniRead($skillHeros, "Run info", "Life_Arcane", $life_arcane)
	$life_peste = IniRead($skillHeros, "Run info", "Life_Peste", $life_peste)
	$life_profa = IniRead($skillHeros, "Run info", "Life_Profa", $life_profa)
	$life_proj = IniRead($skillHeros, "Run info", "Life_Proj", $life_proj)
	$life_ice = IniRead($skillHeros, "Run info", "Life_Ice", $life_ice)
	$life_poison = IniRead($skillHeros, "Run info", "Life_Poison", $life_poison)
	$life_explo = IniRead($skillHeros, "Run info", "Life_Explo", $life_explo)
	$life_lave = IniRead($skillHeros, "Run info", "Life_Lave", $life_lave)
	$life_mine = IniRead($skillHeros, "Run info", "Life_Mine", $life_mine)
	$life_arm = IniRead($skillHeros, "Run info", "Life_Arm", $life_arm)
	$life_spore = IniRead($skillHeros, "Run info", "Life_Spore", $life_spore)

	$UsePath = StringLower(IniRead($skillHeros, "Run info", "UsePath", $UsePath))
	$ResActivated = StringLower(IniRead($skillHeros, "Run info", "ResActivated", $ResActivated))
	$ResLife = IniRead($skillHeros, "Run info", "ResLife", $ResLife)

EndFunc   ;==>InitSkillHeros

; ------------------------------------
If Not FileExists($profilFile) Then
	writeConfigs()
EndIf

LoadConfigs()
InitGrabListFile()
InitGrabListTab()
; ------------------------------------















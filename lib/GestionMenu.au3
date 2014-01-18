#cs ----------------------------------------------------------------------------

Extension permettant de gerer le menu

#ce ----------------------------------------------------------------------------

;--------------------------------------------------------------
; Choix de l'acte
;-------------------------------------------------------------

Func _choixgame($choixgame,$auto)

	local $xChoixGame,$yChoixGame,$posChoixGame
	;Automatisation des sequences sur enchainement de run
	if $auto Then
		Switch $choixgame
			case 1
				$Hero_Axe_Z =$Act1_Hero_Axe_Z
				$File_Sequence=$SequenceFileAct1
			case 2
				$Hero_Axe_Z =$Act2_Hero_Axe_Z
				$File_Sequence=$SequenceFileAct2
			case 3
				$Hero_Axe_Z =$Act3_Hero_Axe_Z
				$File_Sequence=$SequenceFileAct3PtSauve
			case 333
				$Hero_Axe_Z =$Act3_Hero_Axe_Z
				$File_Sequence=$SequenceFileAct333
			case 362
				$Hero_Axe_Z =$Act3_Hero_Axe_Z
				$File_Sequence=$SequenceFileAct362
			case 373
				$Hero_Axe_Z =$Act3_Hero_Axe_Z
				$File_Sequence=$SequenceFileAct373
		EndSwitch
	EndIf
	; fin Automatisation des sequences sur enchainement de run

;Selection du Heros
if($Totalruns=1)and($TypedeBot=1) Then
		_choixHereos()
EndIf

sleep(Random(2500,3000,1));pause pour laiser temps quiter la game

if $TypedeBot<>2 Then
	;Selection -> CHANGER DE QUETE
	sleep(Random(300,400,1))
	_randomclick(106, 270)
	Sleep(Random(300,400,1))

	;Selection de la difficulte et de la puissance des monstres
	if($Totalruns=1)and($TypedeBot=1) Then
			_choixDifPm()
	EndIf

	;Selection de la quête

	;Initialisation de la quete 1.2 preparation de l'arborescense des quêtes comparaison au choix des portails en reduisant l'arbo
	$xChoixGame=Random(100,200)
	;$yChoixGame=170
	$yChoixGame=Random(169,171)

	;Selection d'une quête au hasard
	MouseMove($xChoixGame,$yChoixGame+80, Random(12,14,1))
	MouseClick("left")
	sleep(Random(600,800,1))

	;vitesse de test ok =15
	MouseMove($xChoixGame,$yChoixGame, Random(12,14,1))

	;valeur de test ok 27 ... mini pour balayer toutes les quêtes 26
	for $i=1 to Random(27,28,1) step 1
		MouseWheel("up")
		;Valeur de test ok 100
		sleep(Random(100,150,1))
	Next

	;valeur de test ok 1000
	MouseClick("left")
	sleep(Random(600,800,1))
	MouseClick("left")
	sleep(Random(600,800,1))

	Switch $choixgame
		case 1
		;selection de la quête 10.1 act 1
			for $i=1 to 9 step 1
				MouseWheel("down")
				sleep(Random(100,150,1))
			Next

			$posChoixGame=mousegetpos()
			$xChoixGame=$posChoixGame[0]
			$yChoixGame=$posChoixGame[1]+6

			MouseMove($xChoixGame,$yChoixGame, 15)
			MouseClick("left")
			sleep(Random(600,800,1))
			MouseMove($xChoixGame,$yChoixGame+30, 15)
			MouseClick("left")
			sleep(Random(600,800,1))

		case 2
		;selection de la quête 8.3
			for $i=1 to 18 step 1
				MouseWheel("down")
				sleep(Random(100,150,1))
			Next

			$posChoixGame=mousegetpos()
			$xChoixGame=$posChoixGame[0]
			$yChoixGame=$posChoixGame[1]+5

			MouseMove($xChoixGame,$yChoixGame, 15)
			MouseClick("left")
			sleep(Random(600,800,1))
			MouseMove($xChoixGame,$yChoixGame+70, 15)
			MouseClick("left")
			sleep(Random(600,800,1))

		case 3
		;selection de la quête 7.3
			for $i=1 to 27 step 1
				MouseWheel("down")
				sleep(Random(100,150,1))
			Next

			$posChoixGame=mousegetpos()
			$xChoixGame=$posChoixGame[0]
			$yChoixGame=$posChoixGame[1]+95

			MouseMove($xChoixGame,$yChoixGame, 15)
			MouseClick("left")
			sleep(Random(600,800,1))
			MouseMove($xChoixGame,$yChoixGame+70, 15)
			MouseClick("left")
			sleep(Random(600,800,1))

		case 333 ; Act 3 quête 3 sous quête 3 --> tuez Ghom
			for $i=1 to 22 step 1
				MouseWheel("down")
				sleep(150)
			Next
			$posChoixGame=mousegetpos()
			$xChoixGame=$posChoixGame[0]
			$yChoixGame=$posChoixGame[1]+64
			MouseMove($xChoixGame,$yChoixGame, 15)
			MouseClick("left")
			sleep(Random(600,800,1))
			MouseMove($xChoixGame,$yChoixGame+66, 15)
			MouseClick("left")
			sleep(Random(600,800,1))

		case 362 ; Act 3 quête 6 sous quête 2 --> Tuez le briseur de siège
			for $i=1 to 27 step 1
				MouseWheel("down")
				sleep(150)
			Next
			$posChoixGame=mousegetpos()
			$xChoixGame=$posChoixGame[0]
			$yChoixGame=$posChoixGame[1]+73
			MouseMove($xChoixGame,$yChoixGame, 15)
			MouseClick("left")
			sleep(Random(600,800,1))
			MouseMove($xChoixGame,$yChoixGame+44, 15)
			MouseClick("left")
			sleep(Random(600,800,1))

		case 373 ; Act 3 quête 7 sous quête 3 --> Terrasez Asmodam
			for $i=1 to 27 step 1
				MouseWheel("down")
				sleep(Random(100,150,1))
			Next

			$posChoixGame=mousegetpos()
			$xChoixGame=$posChoixGame[0]
			$yChoixGame=$posChoixGame[1]+95

			MouseMove($xChoixGame,$yChoixGame, 15)
			MouseClick("left")
			sleep(Random(600,800,1))
			MouseMove($xChoixGame,$yChoixGame+70, 15)
			MouseClick("left")
			sleep(Random(600,800,1))
	EndSwitch

	;Bp choisir la quete
	Sleep(Random(300,400,1))
	_randomclick(500, 475)
	; Bp validation de la quête
	Sleep(Random(300,400,1))
	_randomclick(350, 350)
	EndIf
EndFunc

;Selection de la quete en automatique
func _gestionDesQuete()
		if ($Choix_Act_Run=1) and ($Totalruns=1)  then
			_choixgame(1,True)
		EndIf
		if ($Choix_Act_Run=2) and ($Totalruns=1) then
			_choixgame(2,True)
		EndIf
		if ($Choix_Act_Run=3) then
			if($Totalruns=1) Then
				_choixgame(3,True)
			EndIf
			if($Totalruns=2) Then
				$Hero_Axe_Z =$Act3_Hero_Axe_Z
				$File_Sequence=$SequenceFileAct3
			EndIf
		EndIf
		if ($Choix_Act_Run=333) then
			_choixgame(333,True)
		EndIf
		if ($Choix_Act_Run=362) then
			_choixgame(362,True)
		EndIf
		if ($Choix_Act_Run=373) then
			_choixgame(373,True)
		EndIf

;Selection de la quete en automatique et enchainement des actes
		if $Choix_Act_Run=-1 then
;Initialisation de la séquence
			if($Totalruns=1) Or ($Totalruns=$NbreRunChangSeqAlea) Then
				$act=0
				$NombreRun_Encour=0
;Chainage aléatoire ou non des actes
				if $Sequence_Aleatoire="True" Then
					;$ChainageActe[6][3]=[[1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]]
					Local $ligne=Random(0,5,1)
					for $colonne =0 to 2 step 1
						$ChainageActeEnCour[$colonne]=$ChainageActe[$ligne][$colonne]
					Next
				Else
					$ChainageActeEnCour[0]=1
					$ChainageActeEnCour[1]=2
					$ChainageActeEnCour[2]=3
				EndIf
				$ColonneEnCour=0
				$Act_Encour=$ChainageActeEnCour[$ColonneEnCour]
				_choixgame($Act_Encour,True)

;Création d un fichier de log pour le mode automatique
				if($Totalruns=1) Then
					Local $TIME = @MDAY & @MON &@YEAR&"_"&@HOUR&@MIN&@SEC
					$fileLog=".\stats\StatsRunAuto"&$TIME&".txt"
					FileWrite($fileLog,"Run automatique du "&@MDAY&"/"&@MON&"/"&@YEAR& " à " & @hour&":"&@MIN & ":" & @SEC & @CRLF)
					$numLigneFichier=2
					_FileWriteToLine($fileLog,$numLigneFichier, "Chainage : Act " & $ChainageActeEnCour[0] & ", " & $ChainageActeEnCour[1] & " et " & $ChainageActeEnCour[2], 1)
					$numLigneFichier=$numLigneFichier+1
				Else
					$numLigneFichier=$numLigneFichier+1
					Local $TIME = @MDAY &"/"& @MON&"/"&@YEAR&" "&@HOUR&":"&@MIN&":"&@SEC
					_FileWriteToLine($fileLog,$numLigneFichier,$TIME, 1)
					$numLigneFichier=$numLigneFichier+1
					_FileWriteToLine($fileLog,$numLigneFichier, "Changement de Chainage : Act " & $ChainageActeEnCour[0] & ", " & $ChainageActeEnCour[1] & " et " & $ChainageActeEnCour[2], 1)
					$numLigneFichier=$numLigneFichier+1
					_FileWriteToLine($fileLog,$numLigneFichier, "Act " & $Act_Encour & ": " & $NombreRun_Encour & "/" & $NombreDeRun, 1)
  					$NbreRunChangSeqAlea=$NbreRunChangSeqAlea+$Totalruns
				EndIf

				if ($Nombre_de_Run=0) Then
					Switch $Act_Encour
						case 1
							$NombreDeRun=Random($NombreMiniAct1,$NombreMaxiAct1,1)
						case 2
							$NombreDeRun=Random($NombreMiniAct2,$NombreMaxiAct2,1)
						case 3
							$NombreDeRun=Random($NombreMiniAct3,$NombreMaxiAct3,1)
						EndSwitch
				Else
					$NombreDeRun=$Nombre_de_Run
				EndIf
			EndIf

;Changement d acte lorsque l'on a atteint le mombre de run max
			if($NombreRun_Encour>=$NombreDeRun) Then
				$act=0
				if $ColonneEnCour < 2 Then
					$ColonneEnCour=$ColonneEnCour+1
				Else
					$ColonneEnCour=0
				EndIf
				$Act_Encour=$ChainageActeEnCour[$ColonneEnCour]
				_choixgame($Act_Encour,True)
				$NombreRun_Encour=1
				if ($Nombre_de_Run=0) Then
					Switch $Act_Encour
						case 1
							$NombreDeRun=Random($NombreMiniAct1,$NombreMaxiAct1,1)
						case 2
							$NombreDeRun=Random($NombreMiniAct2,$NombreMaxiAct2,1)
						case 3
							$NombreDeRun=Random($NombreMiniAct3,$NombreMaxiAct3,1)
					EndSwitch
				EndIf
				$numLigneFichier=$numLigneFichier+1
				Local $TIME = @MDAY &"/"& @MON&"/"&@YEAR&" "&@HOUR&":"&@MIN&":"&@SEC
				_FileWriteToLine($fileLog,$numLigneFichier,$TIME, 1)
				$numLigneFichier=$numLigneFichier+1
				_FileWriteToLine($fileLog,$numLigneFichier, "Act " & $Act_Encour & ": " & $NombreRun_Encour & "/" & $NombreDeRun, 1)
			Else
				if($Act_Encour=3) and ($NombreRun_Encour=1)  Then
					$Hero_Axe_Z =$Act3_Hero_Axe_Z
					$File_Sequence=$SequenceFileAct3
				EndIf
				$NombreRun_Encour=$NombreRun_Encour+1
				_FileWriteToLine($fileLog,$numLigneFichier, "Act " & $Act_Encour & ": " & $NombreRun_Encour & "/" & $NombreDeRun, 1)
			EndIf
		EndIf
EndFunc

Func _choixHereos()

; bonton Changer de heros
MouseMove(random(350,430),Random(515,520), Random(12,14,1))
MouseClick("left")
sleep(Random(600,800,1))

;positionnement dans la liste des heros
MouseMove(random(105,120),Random(140,240), Random(12,14,1))
sleep(Random(600,800,1))

;Choix du heros
for $i=1 to Random(6,7,1) step 1
MouseWheel("up")
;Valeur de test ok 100
sleep(Random(100,150,1))
Next

$XherosPmin=150
$XherosPmax=155
$YHeros1min=120
$YHeros1max=130
Local $offsetHerosYmin=49
Local $offsetHerosYmax=51

Switch $Heros
	Case 1
		MouseMove(Random($XherosPmin,$XherosPmax,1),Random($YHeros1min,$YHeros1max,1), Random(12,14,1))
	Case 2
		$YHeros1min=$YHeros1min+$offsetHerosYmin
		$YHeros1max=$YHeros1max+$offsetHerosYmax
		MouseMove(Random($XherosPmin,$XherosPmax,1),Random($YHeros1min,$YHeros1max,1), Random(12,14,1))
	Case 3
		$YHeros1min=$YHeros1min+($offsetHerosYmin*2)
		$YHeros1max=$YHeros1max+($offsetHerosYmax*2)
		MouseMove(Random($XherosPmin,$XherosPmax,1),Random($YHeros1min,$YHeros1max,1), Random(12,14,1))
	Case 4
		$YHeros1min=$YHeros1min+($offsetHerosYmin*3)
		$YHeros1max=$YHeros1max+($offsetHerosYmax*3)
		MouseMove(Random($XherosPmin,$XherosPmax,1),Random($YHeros1min,$YHeros1max,1), Random(12,14,1))
	Case 5
		$YHeros1min=$YHeros1min+($offsetHerosYmin*4)
		$YHeros1max=$YHeros1max+($offsetHerosYmax*4)
		MouseMove(Random($XherosPmin,$XherosPmax,1),Random($YHeros1min,$YHeros1max,1), Random(12,14,1))
	Case 6
		$YHeros1min=$YHeros1min+($offsetHerosYmin*5)
		$YHeros1max=$YHeros1max+($offsetHerosYmax*5)
		MouseMove(Random($XherosPmin,$XherosPmax,1),Random($YHeros1min,$YHeros1max,1), Random(12,14,1))
	Case 7
		$YHeros1min=$YHeros1min+($offsetHerosYmin*6)
		$YHeros1max=$YHeros1max+($offsetHerosYmax*6)
		MouseMove(Random($XherosPmin,$XherosPmax,1),Random($YHeros1min,$YHeros1max,1), Random(12,14,1))
	Case 8
		for $i=1 to 5 step 1
			MouseWheel("down")
			;Valeur de test ok 100
			sleep(Random(100,150,1))
		Next
		$YHeros1min=$YHeros1min+($offsetHerosYmin*4)
		$YHeros1max=$YHeros1max+($offsetHerosYmax*4)
		MouseMove(Random($XherosPmin,$XherosPmax,1),Random($YHeros1min,$YHeros1max,1), Random(12,14,1))
	Case 9
		for $i=1 to 5 step 1
			MouseWheel("down")
			;Valeur de test ok 100
			sleep(Random(100,150,1))
		Next
 		$YHeros1min=$YHeros1min+($offsetHerosYmin*5)
		$YHeros1max=$YHeros1max+($offsetHerosYmax*5)
		MouseMove(Random($XherosPmin,$XherosPmax,1),Random($YHeros1min,$YHeros1max,1), Random(12,14,1))
	Case 10
		for $i=1 to 5 step 1
			MouseWheel("down")
			;Valeur de test ok 100
			sleep(Random(100,150,1))
		Next
		$YHeros1min=$YHeros1min+($offsetHerosYmin*6)
		$YHeros1max=$YHeros1max+($offsetHerosYmax*6)
		MouseMove(Random($XherosPmin,$XherosPmax,1),Random($YHeros1min,$YHeros1max,1), Random(12,14,1))
	EndSwitch
	sleep(Random(600,800,1))

	;selection du Heros
	MouseClick("left")
	sleep(Random(600,800,1))

	;Deplacement sur le bp choisir
	MouseMove(Random(330,450,1),Random(512,515,1), Random(12,14,1))
	sleep(Random(600,800,1))
	;Clic sur le bouton choisir temps mini de chargement du hero 4000ms
	MouseClick("left")
	sleep(Random(6000,8000,1))
EndFunc

func _choixDifPm()

;Selection de la fleche du menu déroulant de la difficulté

MouseMove(random(183,186),Random(474,476), Random(12,14,1))
MouseClick("left")
sleep(Random(600,800,1))

Switch $difficulte
	case 1 ;Normal
		MouseMove(Random(90,110,1),Random(495,500,1), Random(12,14,1))
	case 2 ;Cauchemar
		MouseMove(Random(90,110,1),Random(516,519,1), Random(12,14,1))
	case 3 ;Enfer
		MouseMove(Random(90,110,1),Random(535,538,1), Random(12,14,1))
	case 4 ;Arma
		MouseMove(Random(90,110,1),Random(551,555,1), Random(12,14,1))
EndSwitch
sleep(Random(600,800,1))
MouseClick("left")
sleep(Random(600,800,1))


;Selection de la fleche du menu déroulant de la Puissance des monstres
MouseMove(Random(309,311,1),Random(473,475,1), Random(12,14,1))
sleep(Random(600,800,1))
MouseClick("left")
sleep(Random(600,800,1))

; Initialisation de la liste déroulante de la PM
MouseMove(Random(220,280,1),Random(497,499,1), Random(12,14,1))
for $i=1 to Random(4,6,1) step 1
	MouseWheel("up")
	;Valeur de test ok 100
	sleep(Random(100,150,1))
Next

#cs
Selection de la puissance des monstres
Selection de la puissance des monstres comprise entre 5 et 9
Selection de la puissance des monstres = 10
#ce

if ($PuisMonstre>4)and($PuisMonstre<10) Then
	for $i=1 to 3 step 1
		MouseWheel("down")
		;Valeur de test ok 100
		sleep(Random(100,150,1))
	Next
EndIf

if ($PuisMonstre=10) Then
	for $i=1 to 4 step 1
		MouseWheel("down")
		;Valeur de test ok 100
		sleep(Random(100,150,1))
	Next
EndIf

Switch $PuisMonstre
	case 0
		MouseMove(Random(230,240,1),Random(497,499,1), Random(12,14,1))
	case 1
		MouseMove(Random(220,280,1),Random(518,520,1), Random(12,14,1))
	case 2
		MouseMove(Random(220,280,1),Random(536,538,1), Random(12,14,1))
	case 3
		MouseMove(Random(220,280,1),Random(556,558,1), Random(12,14,1))
	case 4
		MouseMove(Random(220,280,1),Random(573,574,1), Random(12,14,1))
	case 5
		MouseMove(Random(220,280,1),Random(497,499,1), Random(12,14,1))
	case 6
		MouseMove(Random(220,280,1),Random(518,520,1), Random(12,14,1))
	case 7
		MouseMove(Random(220,280,1),Random(538,539,1), Random(12,14,1))
	case 8
		MouseMove(Random(220,280,1),Random(556,558,1), Random(12,14,1))
	case 9
		MouseMove(Random(220,280,1),Random(573,574,1), Random(12,14,1))
	case 10
		MouseMove(Random(220,280,1),Random(573,574,1), Random(12,14,1))
EndSwitch
sleep(Random(600,800,1))
MouseClick("left")
sleep(Random(600,800,1))
EndFunc

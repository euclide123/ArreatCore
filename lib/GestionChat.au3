#cs ----------------------------------------------------------------------------
	Extension permettant de géré l'intervention du bot via le chat
#ce ----------------------------------------------------------------------------

Func SetConfigPartieSolo();reconfiguration du settings.ini
   	_Log("Partie en équipe, configuration du settings.ini")
	$TakeABreak = "false"
	$PauseRepas = "false"
	$ResLife = 100
EndFunc   ;==>SetConfigPartieSolo

Func WriteInChat($str)
	_Log("--------------------> TCHAT : " & $str & @CRLF)
	Send("{ENTER}") ;validation de la fenetre de tchat sur le groupe
	Send('' & $str & '');Ecriture du message
	Send("{ENTER}") ;Envoie du message et sort de la fenetre du tchat
EndFunc   ;==>WriteInChat
 
Func WriteMe($situation)
    ;Temps d'attent en milliseconde pour pouvoir suivre le bot
	Local $Tp = 5000
	Local $NewRun = 2000
	Local $TaweWp = 5000
	Local $StartNewGame = 15000
	Local $BreakMenu = 120000
   
	Switch $situation
		Case 1;dans le menu pour recommencer une run
			Switch Random(1, 3, 1)
				Case 1 
					WriteInChat("J'attends un peu et je recommence")
				Case 2 
					WriteInChat("GO GO GO paragon 1000 nous attend ;)")
				Case 3
					WriteInChat("Tu es prêt, je relance")
			EndSwitch 
			Sleep($StartNewGame)
			
		Case 2;en jeu, début de la run
			Switch Random(1, 5, 1) 
				Case 1 
					WriteInChat("En avant l'aventure") 
				Case 2 
					WriteInChat("La chasse au montres est ouverte") 
				Case 3
					WriteInChat("Alors on y va")
				Case 4 
					WriteInChat("Bonjour c'est partie pour un run")
				Case 5 
					WriteInChat("Je vous souhaite la bienvenue")	 
			EndSwitch
			Sleep($NewRun)
			
		Case 3;on met un légendaire au coffre
			Switch Random(1, 3, 1) 
				Case 1 
					WriteInChat("Et encore un souffre dans le coffre") 
				Case 2 
					WriteInChat("YES! j'ai trouvé un légendaire")
				Case 3
					WriteInChat("Pas moyen d'avoir de bon Leg")	
            EndSwitch 
			
		Case 4;la run est terminer le bot quite	
			Switch Random(1, 3, 1) 
				Case 1 
					WriteInChat("C'est fini on quite") 
				Case 2 
					WriteInChat("C'est clean on en refait une vite fait")
				Case 3 
					WriteInChat("Je quite")	 
			EndSwitch

		Case 5;inventaire plein ou besoin de réparation
			Switch Random(1, 3, 1) 
				Case 1 
					WriteInChat("Je suis plein.Je TP et je revien") 
				Case 2 
					WriteInChat("Ça ne sera pas long. Je dois aller me vider mon inventaire")
				Case 3 
					WriteInChat("Hey, je dois aller réparer")	 
			EndSwitch
			
	    Case 6;revien de vider l'inventaire ou de réparer
			Switch Random(1, 3, 1) 
				Case 1 
					WriteInChat("J'arrive") 
				Case 2 
					WriteInChat("J'ai terminer")
				Case 3 
					WriteInChat("Ça commence à couter cher de réparation")	 
			EndSwitch

		Case 7;on tp en ville pour changer zone	
			Switch Random(1, 3, 1) 
				Case 1 
					WriteInChat("Je TP en ville") 
				Case 2 
					WriteInChat("TP") 
				Case 3 
					WriteInChat("Je retourne en ville") 
			EndSwitch
			Sleep($TP)

	    Case 8;on vend, répare, recycle
		    Switch Random(1, 3, 1) 
	            Case 1 
			        WriteInChat("je vends") 
	            Case 2 
                    WriteInChat("Bof rien à garder comme d'hab")
				Case 3
                    WriteInChat("Bon j'identifie tout ca pour voir")	
            EndSwitch 

		Case 9;on est mort
			Switch Random(1, 3, 1) 
				Case 1 
					WriteInChat("Je me suis fait avoir comme un bleu") 
				Case 2 
					WriteInChat("Ils font mal") 
				Case 3 
					WriteInChat("ça pique fort")  
 			EndSwitch

		Case 10;change de zone par WP
			Switch Random(1, 6, 1) 
				Case 1 
					WriteInChat("TP sur moi je change de zone") 
				Case 2 
					WriteInChat("TP sur mon drapeau")
				Case 3
					WriteInChat("Cette map est clean.On change de zone") 
				Case 4 
					WriteInChat("On passe a la prochaine zone")
				Case 5 
					WriteInChat("Next zone") 
				Case 6 
					WriteInChat("Pas mal clean. On passe a la prochaine zone")	
			EndSwitch 
			Sleep($TaweWp)
			
		Case 11;dans le menu et on fait une pause
			Switch Random(1, 3, 1) 
				Case 1 
					WriteInChat("Je vais attendre") 
				Case 2 
					WriteInChat("Je vais attendre dans le menu") 
				Case 3 
					WriteInChat("C'est long xD")  
 			EndSwitch
			Sleep($BreakMenu)
			
	EndSwitch
EndFunc   ;==>WriteMe	
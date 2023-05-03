
(* TODO: Hier einen Kommentar eingeben *)
FUNCTION_BLOCK Silo	
	
	(* Initialisierung *)
	IF iB_Init THEN
		
		(* Bestimmung der Mindestmenge im Silo *)
		xA_Mindestfuellmenge := VolumenImSilo(iA_H_Min, iA_H1, iA_R0, iA_R1) * iA_Dichte;
		
		iB_Init := FALSE;
		iB_Reset := TRUE;
	END_IF;
	
	(* Berechnungen bei Aenderung der Fuellhoehe *)
	IF (iA_h <> xA_h_zuletzt) THEN
		
		(* Ermittle Hoehendifferenz *)
		xA_dh := xA_h_zuletzt - iA_h;
		
		(* Bestimmung der Kreisflaeche anhand der Fuellhoehe *)
		IF iA_h < iA_H1 THEN
			xA_A := (iA_dR * iA_h) / iA_H1 + iA_R0;
		ELSE
			xA_A := iA_R1;
		END_IF;
    
		xA_A := xA_A ** 2;
		xA_A := xA_A * 3.141;
		
		(* Ermittle Volumenunterschied *)
		xA_dV := xA_A * xA_dh;
		
		(* Summiere abgegebene Menge auf *)
		qA_AbgegebeneMenge := qA_AbgegebeneMenge + xA_dV;
		
		(* Speichere aktuelle Fuellhoehe *)
		xA_h_zuletzt := iA_h;
		
	ELSE
		
		(* Keine Volumenaenderung ohne Hoehenaenderung *)
		xA_dV := 0;
		
	END_IF;
	
		
	(* Bestimmung der Menge im Silo *)
	qA_MengeImSilo := VolumenImSilo(iA_h, iA_H1, iA_R0, iA_R1) * iA_Dichte;
	
	(* Pruefe ob Sollwert erreicht *)
	IF qA_AbgegebeneMenge >= iA_SwMenge THEN
		qB_SwErreicht := TRUE;
	ELSE
		qB_SwErreicht := FALSE;
	END_IF;
	
	(* Pruefe ob Silo ausreichend voll *)
	IF qA_MengeImSilo - iA_SwMenge - xA_Mindestfuellmenge > 0 THEN
		qB_Freigabe := TRUE;
	ELSE
		qB_Freigabe := FALSE;
	END_IF;


	(* Zuruecksetzen *)
	IF iB_Reset THEN
		qA_AbgegebeneMenge := 0;
		iB_Reset := FALSE;
	END_IF;
	
END_FUNCTION_BLOCK

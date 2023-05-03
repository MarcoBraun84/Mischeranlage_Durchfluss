
(* TODO: Hier einen Kommentar eingeben *)
FUNCTION_BLOCK PiRegler
	
	IF iB_Freigabe THEN
 
		(* Bestimme Regeldifferenz *)
		xA_u := iA_SW - iA_IW;
  
		(* Berechne Proportionalanteil *)
		xA_yP1 := xA_u * iA_Kp;
		xA_yP2 := (xA_yP1 - xA_yP2) * iA_dt / iA_Tp + xA_yP2;
  
		(* Pruefe ob Aussteuerungsgrenze ueberschritten wird *)
		(* Falls ja, setze AntiWindUp(AWU)-Flag *)
		xB_AWU :=  (xA_yP1 < 0) AND (qA_y < iA_yMin);
		xB_AWU := ((xA_yP1 > 0) AND (qA_y > iA_yMax)) OR xB_AWU;
  
		(* Falls AWU-Flag inaktiv, berechne I-Anteil *)
		IF NOT xB_AWU THEN
			xA_yI := xA_yI + xA_yP1 / iA_Tn * iA_dt;
		END_IF;
  
		(* Addiere P- und I-Anteil --> Reglerausgangswert *)
		qA_y := xA_yP2 + xA_yI;
		
		IF qA_y > iA_yMax THEN
			qA_y := iA_yMax;
		END_IF;
		
		IF qA_y < iA_yMin THEN
			qA_y := iA_yMin;
		END_IF;
		
		
  	ELSE
 
		(* Falls keine Reglerfreigabe, setze alles zurueck *)
		xA_yP1 := 0;
		xA_yP2 := 0;
		xA_yI  := 0;
		qA_y   := 0;
  
	END_IF;
	
END_FUNCTION_BLOCK

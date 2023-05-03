
(* Berechnung des Volumens im Silo in Abhängigkeit von h *)
FUNCTION VolumenImSilo
	iA_dR := iA_R1 - iA_R0;
	
	IF iA_h >= iA_H1 THEN
		xA_V1 := (iA_dR ** 2) / 3 + iA_dR * iA_R0 + (iA_R0 ** 2);
		xA_V1 := xA_V1 * 3.141 * iA_H1;
		
		xA_V2 := 3.141 * (iA_R1 ** 2) * (iA_h - iA_H1);
	ELSE
		xA_V1 := (iA_dR ** 2) / 3 / (iA_H1 ** 2) * iA_h;
		xA_V1 := (xA_V1 + iA_dR * iA_R0 / iA_H1) * iA_h;
		xA_V1 := (xA_V1 + (iA_R0 ** 2)) * iA_h * 3.141;
		
		xA_V2 := 0;
	END_IF;
	VolumenImSilo := xA_V1 + xA_V2;
END_FUNCTION


PROGRAM _INIT
    
    (* Nullen der Zeitvariablen *)
	xA_T_Schieber := 0;
	xA_T_S1 := 0;
    
	(* Silofuellstaende zu Beginn*)
	xA_h1 := 25;
	xA_h2 := 32;
	
	xA_A1 := 0;
	
END_PROGRAM

PROGRAM _CYCLIC
    
    (* Potentiometer *)
	
	IF xA_R1 > 250 THEN
		xA_R1 := 250;
	ELSIF xA_R1 < 10 THEN
		xA_R1 := 10;
	END_IF;
	
	IF xA_R2 > 250 THEN
		xA_R2 := 250;
	ELSIF xA_R2 < 10 THEN
		xA_R2 := 10;
	END_IF;
	
	tmpA_R1 := (xA_R1 - 10) / 240 * 32767 * 0.8;
	iA_R1 := REAL_TO_INT(tmpA_R1);
	tmpA_R2 := (xA_R2 - 10) / 240 * 32767 * 0.8;
	iA_R2 := REAL_TO_INT(tmpA_R2);
	
	
    (* Silo 1 *)
    
	IF qB_Q1_1 THEN
		xA_dV1 := 10 * cA_T_Zykl;
		xA_dV1 := xA_dV1 / 1000;
	ELSE
		xA_dV1 := 0;    
	END_IF;
    
	IF xA_h1 < cA_H1 THEN
		xA_A1 := (cA_dR * xA_h1) / cA_H1 + cA_R0;
	ELSE
		xA_A1 := cA_R1;
	END_IF;
    
	xA_A1 := xA_A1 ** 2;
	xA_A1 := xA_A1 * 3.141;
	xA_dh1 := xA_dV1 / xA_A1;
	xA_h1 := xA_h1 - xA_dh1;
    
	IF xA_h1 < 0 THEN
		xA_h1 := 0;
	END_IF;
    
	xA_s1 := 40 - xA_h1;
	iA_L1 := REAL_TO_INT((xA_s1 - 1) / 99 * 32767);


	(* Silo 2 *)
    
	IF qB_Q2_1 THEN
		xA_dV2 := 10 * cA_T_Zykl;
		xA_dV2 := xA_dV2 / 1000;
	ELSE
		xA_dV2 := 0;    
	END_IF;
    
	IF xA_h2 < cA_H1 THEN
		xA_A2 := (cA_dR * xA_h2) / cA_H1 + cA_R0;
	ELSE
		xA_A2 := cA_R1;
	END_IF;
    
	xA_A2 := xA_A2 ** 2;
	xA_A2 := xA_A2 * 3.141;
	xA_dh2 := xA_dV2 / xA_A2;
	xA_h2 := xA_h2 - xA_dh2;
    
	IF xA_h2 < 0 THEN
		xA_h2 := 0;
	END_IF;

	xA_s2 := 40 - xA_h2;
	iA_L2 := REAL_TO_INT((xA_s2 - 1) / 99 * 32767);


	(* Steuerung der Anlage *)
    
	(* Mischer befuellen *)
	IF qB_Q1_1 AND (xA_h1 > 0) THEN
		xA_Mischer := xA_Mischer + 1;
	END_IF;
    
	IF qB_Q2_1 AND (xA_h2 > 0) THEN
		xA_Mischer := xA_Mischer + 1;
	END_IF;
    
	IF xA_Mischer < 0 THEN
		xA_Mischer := 0;
	END_IF;
    
	(* Mischer entleeren *)
	IF xA_T_Schieber > 0 THEN
		xA_Mischer := xA_Mischer - 0.001 * xA_T_Schieber;
	END_IF;
    
	(* Paralleles Auf- und Zufahren unterbinden *)
	z_Auffahren := qB_Q4_1 AND NOT z_Zufahren  AND NOT iB_S6;
	z_Zufahren  := qB_Q4_2 AND NOT z_Auffahren AND NOT iB_S5;
    
	(* Laufzeit Schieber auffahren *)
	IF z_Auffahren THEN
		xA_T_Schieber := xA_T_Schieber + cA_T_Zykl;
	END_IF
    
	(* Laufzeit Schieber zufahren *)
	IF z_Zufahren THEN
		xA_T_Schieber := xA_T_Schieber - cA_T_Zykl;
	END_IF
    
	(* Erreichen der Schieberendlagen *)
	iB_S6 := (xA_T_Schieber >= cA_T_Schieber);
	iB_S5 := (xA_T_Schieber <= 0);
	
	(* Zeug faellt auf's Band solang Schieber offen und Mischer nicht leer *)
	iB_B4 := (xA_Mischer > 0) AND (xA_T_Schieber > cA_T_Schieber / 5);
	
	(* Taster zuruecksetzen *)
	IF iB_S1 THEN
		xA_T_S1 := xA_T_S1 + cA_T_Zykl;
	ELSE
		xA_T_S1 := 0;
	END_IF;
	
	iB_S1 := iB_S1 AND NOT (xA_T_S1 >= cA_T_S1);
    
	IF iB_S2 THEN
		xA_T_S2 := xA_T_S2 + cA_T_Zykl;
	ELSE
		xA_T_S2 := 0;
	END_IF;
	
	iB_S2 := iB_S2 AND NOT (xA_T_S2 >= cA_T_S2);
	
	(* Leitungsdruck *)
	IF xB_DruckSteigt THEN
		xA_Druck := xA_Druck + xA_SteigenderDruck * cA_T_Zykl / 1000;
		xB_DruckSteigt := (xA_Druck < xA_MaxDruck);
	ELSE
		xA_Druck := xA_Druck - xA_FallenderDruck * cA_T_Zykl / 1000;
		xB_DruckSteigt := (xA_Druck < xA_MinDruck);
	END_IF;
	
	(*Durchfluss*)
	(* alt
	IF qA_Y3 > xA_Y3_Sim + xA_HystY3 THEN
		xA_Y3_Sim := xA_Y3_Sim + xA_dY3;
	ELSIF qA_Y3 < xA_Y3_Sim - xA_HystY3 THEN
		xA_Y3_Sim := xA_Y3_Sim - xA_dY3;
	END_IF;
	*)
	
	(* Darstellung der Strecke als PT1 *)
	xA_Y3_Sim := REAL_TO_INT((qA_Y3 - xA_Y3_Sim) / 20 + xA_Y3_Sim);
	
	IF xA_Y3_Sim < 0 THEN
		xA_Y3_Sim := 0;
	END_IF;
	
	IF xA_Y3_Sim > 32000 THEN
		xA_Y3_Sim := 32000;
	END_IF;
	
	xA_Fluss := xA_Y3_Sim * xA_Druck * 0.47 / 32767;
	iA_F3 := REAL_TO_INT(xA_Fluss / 10 * 32767);
    
END_PROGRAM

PROGRAM _EXIT
    (* Insert code here *)
     
END_PROGRAM


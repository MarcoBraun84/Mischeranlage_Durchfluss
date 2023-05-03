(*Zugriff auf Simulation über Webbrowser (Chrome oder EDGE) http://localhost:81/*)
PROGRAM _INIT
	
	(* Silos initialisieren *)
	typSilo_Silo1.iA_Dichte := 1;
	typSilo_Silo1.iA_dR		:= cA_dR;
	typSilo_Silo1.iA_H1		:= cA_H1;
	typSilo_Silo1.iA_H_Min	:= cA_H_Min;
	typSilo_Silo1.iA_R0		:= cA_R0;
	typSilo_Silo1.iA_R1		:= cA_R1;
	typSilo_Silo1.iB_Init	:= TRUE;

	typSilo_Silo2.iA_Dichte := 1;
	typSilo_Silo2.iA_dR		:= cA_dR;
	typSilo_Silo2.iA_H1		:= cA_H1;
	typSilo_Silo2.iA_H_Min	:= cA_H_Min;
	typSilo_Silo2.iA_R0		:= cA_R0;
	typSilo_Silo2.iA_R1		:= cA_R1;
	typSilo_Silo2.iB_Init	:= TRUE;
	
	(* Standard Mengensollwerte *)
	xA_SwMenge1 := 150;
	xA_SwMenge2 := 100;

	(* Durchflussregelung initialisieren *)
	typPiRegler_Durchflussregler.iA_SW := 3276;
	typPiRegler_Durchflussregler.iA_Kp := 6;
	typPiRegler_Durchflussregler.iA_Tp := 0.1;
	typPiRegler_Durchflussregler.iA_Tn := 0.5;
	typPiRegler_Durchflussregler.iA_dt := 0.1;
	typPiRegler_Durchflussregler.iA_yMax := 32700;
	typPiRegler_Durchflussregler.iA_yMin := 0;

END_PROGRAM

PROGRAM _CYCLIC
	
	(* Analogwerte skalieren *)
	xA_h1 := 40 - iA_L1 * cA_k_h1 - 1;
	xA_h2 := 40 - iA_L2 * cA_k_h2 - 1;
	xA_SwMenge1 := 240 * 1.25 * iA_R1 / 32767 + 10; 
	xA_SwMenge2 := 240 * 1.25 * iA_R2 / 32767 + 10; 
	
	(* Werte an Silos uebergeben und berechnen *)
	typSilo_Silo1.iA_h := xA_h1;
	typSilo_Silo2.iA_h := xA_h2;
	typSilo_Silo1.iA_SwMenge := xA_SwMenge1;
	typSilo_Silo2.iA_SwMenge := xA_SwMenge2;
	typSilo_Silo1();
	typSilo_Silo2();
	
	(* Pruefe Starttransition *)
	xB_T0 := iB_S1 AND z_0;
	xB_T0 := xB_T0 AND typSilo_Silo1.qB_Freigabe;
	xB_T0 := xB_T0 AND typSilo_Silo2.qB_Freigabe;
	
	xB_FehlerFuellstand1 := (iB_S1 OR xB_FehlerFuellstand1) AND NOT typSilo_Silo1.qB_Freigabe;
	xB_FehlerFuellstand2 := (iB_S1 OR xB_FehlerFuellstand2) AND NOT typSilo_Silo2.qB_Freigabe;
	
	(* Zustandskette *)
	z_6 := NOT iB_S5 AND (z_6 OR (z_4 AND NOT iB_B4)); (* Schieber zufahren *)
	z_5 := NOT xB_T5 AND (z_5 OR (z_4 AND NOT iB_B4)); (* Bandnachlaufzeit *)
	z_4 := NOT z_5   AND (z_4 OR (z_3 AND     iB_S6)); (* Abtransport *)
	z_3 := NOT z_4   AND (z_3 OR (z_2 AND     xB_T2)); (* Schieber auf und Abtransport *)
	z_2 := NOT z_3   AND (z_2 OR (z_1 AND     xB_T1)); (* Mischen *)
	z_1 := NOT z_2   AND (z_1 OR (z_0 AND     xB_T0)); (* Befuellen und Mischen *)
	z_0 := NOT (z_1 OR z_2 OR z_3 OR z_4 OR z_5 OR z_6);
	
	(* Befuellung *)
	xB_Befuelle1 := z_1 AND NOT (typSilo_Silo1.qA_AbgegebeneMenge >= xA_SwMenge1);
	xB_Befuelle2 := z_1 AND NOT (typSilo_Silo2.qA_AbgegebeneMenge >= xA_SwMenge2);
	xB_T1 := z_1 AND NOT (xB_Befuelle1 OR xB_Befuelle2);
	
	(* Zeitsteuerung *)	
	IF z_2 THEN
		xA_T2 := xA_T2 + cA_T_Zykl;
	ELSE
		xA_T2 := 0;
	END_IF;

	IF z_5 THEN
		xA_T5 := xA_T5 + cA_T_Zykl;
	ELSE
		xA_T5 := 0;
	END_IF;

	(* xB_T1 := (xA_T1 >= cA_T1); *)
	xB_T2 := (xA_T2 >= cA_T2);
	xB_T5 := (xA_T5 >= cA_T5);
	
	
	(* Steuerung der Motor-Ausgaenge *)
	qB_Q1_1 := xB_Befuelle1;
	qB_Q2_1 := xB_Befuelle2;
	qB_Q3_1 := z_1 OR z_2;
	qB_Q4_1 := z_3;
	qB_Q4_2 := z_6;
	qB_Q5_1 := z_3 OR z_4 OR z_5;
	
	iA_L1 := iA_L1;
	iA_L2 := iA_L2;
	
	(* Mengenzaehler zuruecksetzen *)
	IF z_0 THEN
		typSilo_Silo1.iB_Reset := TRUE;
		typSilo_Silo2.iB_Reset := TRUE;
	END_IF
	
	(* P1 blinkt bei zu geringem Füllstand *)
	qB_P1 := (xB_FehlerFuellstand1 OR xB_FehlerFuellstand2) AND xB_T_Takt;
	
	xB_T_Takt := ((xA_T_Takt >= cA_T_Takt) OR xB_T_Takt) AND (xA_T_Takt > 0);
	
	IF xB_T_Takt THEN
		xA_T_Takt := xA_T_Takt - cA_T_Zykl;
	ELSE
		xA_T_Takt := xA_T_Takt + cA_T_Zykl;
	END_IF;
	
	(* Automatikbetrieb *)
	xB_S2_sF := iB_S2 AND NOT tmpB_S2; (* steigende Flanke an S2 *)
	xB_Auto := (NOT xB_S2_sF AND xB_Auto) OR (xB_S2_sF AND NOT xB_Auto);
	tmpB_S2 := iB_S2;
	qB_P2 := xB_Auto;
	iB_S1 := (z_0 AND xB_Auto) OR iB_S1;
	
	(* Durchflusstregelung *)
	typPiRegler_Durchflussregler.iB_Freigabe := z_2;
	typPiRegler_Durchflussregler.iA_IW := iA_F3;
	typPiRegler_Durchflussregler();
	qA_Y3 := REAL_TO_INT(typPiRegler_Durchflussregler.qA_y);
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM


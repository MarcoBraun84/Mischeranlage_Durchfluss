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
	(* Insert code here *)

	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM


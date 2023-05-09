(* Zustaende *)<br />
VAR<br />
&emsp; z_0 : BOOL := FALSE; (* Leerlauf *)<br />
&emsp; z_1 : BOOL := FALSE; (* Befuellen und Mischen *)<br />
&emsp; z_2 : BOOL := FALSE; (* Mischen *)<br />
&emsp; z_3 : BOOL := FALSE; (* Schieber auffahren und Abtransport *)<br />
&emsp; z_4 : BOOL := FALSE; (* Abtransport *)<br />
&emsp; z_5 : BOOL := FALSE; (* Bandnachlaufzeit *)<br />
&emsp; z_6 : BOOL := FALSE; (* Schieber zufahren *) (* Schalt- und Transitionsvariablen *)<br />
(*Variablen *)<br />
&emsp; xB_T0 : BOOL := FALSE; (* Transition von z_0 nach z_1 *)<br />
&emsp; xB_T1 : BOOL := FALSE; (* Transition von z_1 nach z_2 *)<br />
&emsp; xB_Befuelle1 : BOOL := FALSE; (* Befuellung aus Silo 1 *)<br />
&emsp; xB_Befuelle2 : BOOL := FALSE; (* Befuellung aus Silo 2 *)<br />
&emsp; &emsp xB_FehlerFuellstand1 : BOOL := FALSE; (* Fehlermeldung Visu wg Fuellstand 1 *)<br />
&emsp; xB_FehlerFuellstand2 : BOOL := FALSE; (* Fehlermeldung Visu wg Fuellstand 1 *)<br />
&emsp; xB_S2_sF : BOOL := FALSE; (* steigende Flanke an S2 *)<br />
&emsp; xB_Auto : BOOL := FALSE; (* Automatikbetrieb aktiv *) (* Zeitvariablen *)<br />
&emsp; xA_T1 : INT := 0; (* Zeitmessung im z_1 *)<br />
&emsp; xA_T2 : INT := 0; (* Zeitmessung im z_2 *)<br />
&emsp; xA_T5 : INT := 0; (* Zeitmessung im z_5 *)<br />
&emsp; xA_T_Takt : INT := 0; (* Zeitmessung Taktgeber *)<br />
&emsp; xB_T2 : BOOL := FALSE; (* Weiterschaltzeitpunkt erreicht *)<br />
&emsp; xB_T5 : BOOL := FALSE; (* Weiterschaltzeitpunkt erreicht *)<br />
&emsp; xB_T_Takt : BOOL := FALSE; (* Schaltausgang Taktgeber *) (* Silos *)<br />
&emsp; typSilo_Silo1 : Silo; (* Funktionsbaustein Silo 1 *)<br />
&emsp; typSilo_Silo2 : Silo; (* Funktionsbaustein Silo 2 *)<br />
&emsp; xA_h1 : REAL := 0; (* Errechnete Fuellhoehe Silo 1 *)<br />
&emsp; xA_h2 : REAL := 0; (* Errechnete Fuellhoehe Silo 2 *)<br />
&emsp; xA_SwMenge1 : REAL := 0; (* Sollwert der abzuwiegenden Menge aus Silo 1 *)<br />
&emsp; xA_SwMenge2 : REAL := 0; (* Sollwert der abzuwiegenden Menge aus Silo 2 *) (* "temporaere" Variablen *)<br />
&emsp; tmpB_S2 : BOOL := FALSE; (* Letzter Zustand von Taster S2 *) (* Durchflussregelung *)<br />
&emsp; typPiRegler_Durchflussregler : PiRegler;<br />
END_VAR<br />
(* Zeitkonstanten *)<br />
VAR CONSTANT<br />
&emsp; cA_T1 : INT := 10000; (* Befuellzeit *)<br />
&emsp; cA_T2 : INT := 20000; (* Mischernachlaufzeit *)<br />
&emsp; cA_T5 : INT := 5000; (* Bandnachlaufzeit *)<br />
&emsp; cA_T_Takt : INT := 500; (* Taktzeit / 2 *)<br />
&emsp; cA_T_Zykl : INT := 100; (* Umrechnungskonstanten Analogwerte *)<br />
&emsp; cA_k_h1 : REAL := 99 / 32767;<br />
&emsp; cA_k_h2 : REAL := 99 / 32767;<br />
END_VAR<br />
<br />
Die Visualisierung kann erreicht werden über http://localhost:81<br />


{REDUND_ERROR} FUNCTION_BLOCK Silo (*TODO: Hier einen Kommentar eingeben*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		iA_h : REAL;
		iA_SwMenge : REAL;
		iB_Init : BOOL;
		iB_Reset : BOOL;
		iA_H1 : REAL;
		iA_R0 : REAL;
		iA_R1 : REAL;
		iA_Dichte : REAL;
		qB_SwErreicht : BOOL;
		iA_dR : REAL;
		iA_H_Min : REAL;
	END_VAR
	VAR_OUTPUT
		qB_Freigabe : BOOL;
		qA_MengeImSilo : REAL;
		qA_AbgegebeneMenge : REAL;
	END_VAR
	VAR
		xA_A : REAL;
		xA_h_zuletzt : REAL;
		xA_dh : REAL;
		xA_Mindestfuellmenge : REAL;
		xA_dV : REAL;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} {REDUND_UNREPLICABLE} FUNCTION_BLOCK PiRegler (*TODO: Hier einen Kommentar eingeben*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		iB_Freigabe: BOOL;
		iA_SW:       REAL;
		iA_IW:       REAL;
		iA_Kp:       REAL;
		iA_Tp:       REAL;
		iA_Tn:       REAL;
		iA_dt:       REAL;
		iA_yMin:     REAL;
		iA_yMax:     REAL;
	END_VAR

	VAR
		xB_AWU: BOOL;
		xA_u:   REAL;
		xA_yP1: REAL;
		xA_yP2: REAL;
		xA_yI:  REAL;
	END_VAR

	VAR_OUTPUT
		qA_y: REAL;
	END_VAR
	
END_FUNCTION_BLOCK

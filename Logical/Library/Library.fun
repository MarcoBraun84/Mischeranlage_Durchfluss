
{REDUND_ERROR} FUNCTION VolumenImSilo : REAL (*Berechnung des Volumens im Silo in Abhängigkeit von h*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		iA_h : REAL; (*Fuellhoehe*)
		iA_H1 : REAL; (*Hoehe Konus*)
		iA_R0 : REAL; (*Radius Konus*)
		iA_R1 : REAL; (*Radius Zylinder*)
	END_VAR
	VAR
		iA_dR : REAL; (*delta radius R1 - R0 vom Konus*)
		xA_V1 : REAL; (*Volumen 1 im Konus*)
		xA_V2 : REAL; (*Volumen 2 im Zylinder*)
	END_VAR
END_FUNCTION

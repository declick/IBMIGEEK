PGM
             DCLF       FILE(QUEMIN/BONBON) OPNID(P)
             DCLF       FILE(QUEMIN/ECRBONBON) OPNID(E)
 LOOP:       RCVF       OPNID(P)
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END))
             CHGVAR     VAR(&E_NOM) VALUE(&P_NOM)
             CHGVAR     VAR(&E_MARQUE) VALUE(&P_MARQUE)
             CHGVAR     VAR(&E_COULEUR) VALUE(&P_COULEUR)
             CHGVAR     VAR(&E_PRIX) VALUE(&P_PRIX)
             CHGVAR     VAR(&E_NUMBER) VALUE(&P_NUMBER)
             SNDRCVF    RCDFMT(FMTBONBON) OPNID(E)
             IF         COND(&E_IN03) THEN(GOTO CMDLBL(END))
             GOTO       CMDLBL(LOOP)
 END:        ENDPGM

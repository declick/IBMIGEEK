             PGM
             DCLF       FILE(QUEMIN/TEST)
LOOP:        SNDRCVF    RCDFMT(FMT1)
             IF         COND(&IN03) THEN(GOTO CMDLBL(END))
             GOTO       CMDLBL(LOOP)
END:         ENDPGM

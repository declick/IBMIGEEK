             PGM        PARM(&PARAM)
             DCLF       FILE(QADSPOBJ) /* Template IBM */
             DCL        VAR(&PARAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NB) TYPE(*DEC) LEN(10 0) VALUE(0)
             DSPOBJD    OBJ(&PARAM/*ALL) OBJTYPE(*ALL) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/LISTEOBJ)
             OVRDBF     FILE(QADSPOBJ) TOFILE(QTEMP/LISTEOBJ) +
                          MBR(LISTEOBJ)
 LOOP:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END))
             CHGVAR     VAR(&NB) VALUE(&NB + 1)
             GOTO       CMDLBL(LOOP)
 END:        DLTOVR     FILE(QADSPOBJ)
             SNDPGMMSG  MSG('Nombre d objets dans ' *CAT &PARAM +
                          *TCAT ': ' *CAT %CHAR(&NB))
             ENDPGM

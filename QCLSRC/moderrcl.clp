/*   CODER DANS MAIN AVANT RETURN    */
             PGM        PARM(&PARM)
/*********************************************************************/
/* PARAMETER                                                         */
/*********************************************************************/
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(10)
/*********************************************************************/
/* ERROR HANDLING VARIABLES                                          */
/*********************************************************************/
             DCL        VAR(&ERRORSW) TYPE(*LGL)
             DCL        VAR(&MSGID)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGDTA)  TYPE(*CHAR) LEN(512)
             DCL        VAR(&MSGF)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFLIB) TYPE(*CHAR) LEN(10)
/*********************************************************************/
/* MONITOR FOR ALL ESCAPE MESSAGES (MONMSG GLOBAL)                   */
/*********************************************************************/
/* MONMSG GLOBAL : TOUTE ERREUR CPF DU PGM SAUTE VERS STDERR1      */
             MONMSG     MSGID(CPF0000) EXEC(GOTO STDERR1)
/*********************************************************************/
/* MAIN PROGRAM FUNCTIONS  -> TON CODE ICI                           */
/*********************************************************************/
             RETURN  /* NORMAL END OF PROGRAM */
/*********** ERROR HANDLING ******************************************/
 STDERR1:    IF         &ERRORSW SNDPGMMSG MSGID(CPF9999) +
                          MSGF(QCPFMSG) MSGTYPE(*ESCAPE) /* FUNC CHK */
/* ERRORSW DEJA A 1 = ERREUR DANS LA GESTION D ERREUR -> CPF9999   */
/* DMPCLPGM = CLICHE DES VARIABLES DANS LE SPOOL QPPGMDMP          */
             CHGVAR     &ERRORSW '1' /* SET TO FAIL IF ERROR OCCURS */
             DMPCLPGM
             MONMSG     MSGID(CPF0000)
 STDERR2:    RCVMSG     MSGTYPE(*DIAG) MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          MSGF(&MSGF) MSGFLIB(&MSGFLIB)
/* BOUCLE : RENVOIE CHAQUE MESSAGE *DIAG A L APPELANT              */
             IF         (&MSGID *EQ '       ') GOTO STDERR3
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSGDTA) MSGTYPE(*DIAG)
             GOTO       STDERR2 /* LOOP BACK FOR ADDL DIAGNOSTICS */
 STDERR3:    RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          MSGF(&MSGF) MSGFLIB(&MSGFLIB)
/* RENVOIE L ERREUR PRINCIPALE (EX CPF2105) EN *ESCAPE A L APPELANT*/
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSGDTA) MSGTYPE(*ESCAPE)
             ENDPGM

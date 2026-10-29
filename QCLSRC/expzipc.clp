             PGM        PARM(&DIR &LIB &STAMP &NB &RC &MSG)
/*********************************************************************/
/* EXPZIPC : zippe <DIR>/<LIB> dans <DIR>/<LIB>_<STAMP>.zip          */
/*           RC '0' = OK, '1' = erreur (texte dans MSG)              */
/*********************************************************************/
             DCL        VAR(&DIR)   TYPE(*CHAR) LEN(50)
             DCL        VAR(&LIB)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&STAMP) TYPE(*CHAR) LEN(15)
             DCL        VAR(&NB)    TYPE(*DEC)  LEN(5 0)
             DCL        VAR(&RC)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSG)   TYPE(*CHAR) LEN(70)
             DCL        VAR(&SRC)   TYPE(*CHAR) LEN(70)
             DCL        VAR(&ZIP)   TYPE(*CHAR) LEN(100)
/* Error handling variables (modele MODERRCL)                        */
             DCL        VAR(&ERRORSW) TYPE(*LGL)
             DCL        VAR(&MSGID)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGDTA)  TYPE(*CHAR) LEN(512)
             DCL        VAR(&MSGF)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFLIB) TYPE(*CHAR) LEN(10)
             MONMSG     MSGID(CPF0000 CPFA000) EXEC(GOTO STDERR1)
/*********************************************************************/
/* MAIN PROGRAM FUNCTIONS                                            */
/*********************************************************************/
             CHGVAR     VAR(&RC) VALUE('0')
             CHGVAR     VAR(&SRC) VALUE(&DIR *TCAT '/' *TCAT &LIB)
             CHGVAR     VAR(&ZIP) VALUE(&SRC *TCAT '_' *TCAT &STAMP +
                *TCAT '.zip')
/* Compression du repertoir <DIR>/<LIB> et des sous repertoires      */
             CPYTOARCF  FROMFILE(&SRC) TOARCF(&ZIP) SUBTREE(*ALL)
             MONMSG     MSGID(CPF0000 CPFA000) EXEC(DO)
             CHGVAR     VAR(&RC) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('Erreur creation archive' +
                          *BCAT &ZIP)
             RETURN
             ENDDO
             CHGVAR     VAR(&MSG) VALUE(%CHAR(&NB) *BCAT 'membres +
                          exportes dans' *BCAT &ZIP)
             RETURN
/* Error handeling (erreur IMPREVUE)                                 */
STDERR1:    CHGVAR     VAR(&RC) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('Erreur systeme dans EXPZIPC')
             IF         &ERRORSW SNDPGMMSG MSGID(CPF9999) +
                          MSGF(QCPFMSG) MSGTYPE(*ESCAPE)
             CHGVAR     &ERRORSW '1'
             DMPCLPGM
             MONMSG     MSGID(CPF0000)
 STDERR2:    RCVMSG     MSGTYPE(*DIAG) MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          MSGF(&MSGF) MSGFLIB(&MSGFLIB)
             IF         (&MSGID *EQ '       ') GOTO STDERR3
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSGDTA) MSGTYPE(*DIAG)
             GOTO       STDERR2
 STDERR3:    RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          MSGF(&MSGF) MSGFLIB(&MSGFLIB)
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSGDTA) MSGTYPE(*ESCAPE)
             ENDPGM

             PGM        PARM(&DIR &LIB &FIC &MBR &ATR &RC &MSG)
/*********************************************************************/
/* EXPMBRC : copie un membre vers <DIR>/<LIB>/<FIC>/<mbr>.<atr>      */
/*           RC '0' = OK, '1' = erreur (texte dans MSG)              */
/*********************************************************************/
             DCL        VAR(&DIR)     TYPE(*CHAR) LEN(50)
             DCL        VAR(&LIB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&FIC)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBR)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&ATR)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&RC)      TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSG)     TYPE(*CHAR) LEN(70)
             DCL        VAR(&DIRLIB)  TYPE(*CHAR) LEN(70)
             DCL        VAR(&DIRFIC)  TYPE(*CHAR) LEN(90)
             DCL        VAR(&NOM)     TYPE(*CHAR) LEN(25)
             DCL        VAR(&STMF)    TYPE(*CHAR) LEN(120)
             DCL        VAR(&MBRPATH) TYPE(*CHAR) LEN(80)
/* Error handling variables (modele MODERRCL)                        */
             DCL        VAR(&ERRORSW) TYPE(*LGL)
             DCL        VAR(&MSGID)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGDTA)  TYPE(*CHAR) LEN(512)
             DCL        VAR(&MSGF)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFLIB) TYPE(*CHAR) LEN(10)
/* MONMSG global : toute erreur imprevue part en STDERR1             */
             MONMSG     MSGID(CPF0000 CPFA000) EXEC(GOTO STDERR1)
/*********************************************************************/
/* MAIN PROGRAM FONCTION                                             */
/*********************************************************************/
             CHGVAR     VAR(&RC) VALUE('0')
/* Sous-repertoires <BIB> puis <FICHIER> (un par un)                 */
             CHGVAR     VAR(&DIRLIB) VALUE(&DIR *TCAT '/' *TCAT &LIB)
             CHGVAR     VAR(&DIRFIC) VALUE(&DIRLIB *TCAT '/' *TCAT +
                          &FIC)
             MKDIR      DIR(&DIRLIB)
             MONMSG     MSGID(CPFA0A0)
             MKDIR      DIR(&DIRFIC)
             MONMSG     MSGID(CPFA0A0)
/* Nom du fichier ifs en minuscules : membre.attribut                */
             CHGVAR     VAR(&NOM) VALUE(%LOWER(&MBR) *TCAT '.' *TCAT +
                          %LOWER(&ATR))
             CHGVAR     VAR(&STMF) VALUE(&DIRFIC *TCAT '/' *TCAT &NOM)
             CHGVAR     VAR(&MBRPATH) VALUE('/QSYS.LIB/' *TCAT &LIB +
                          *TCAT '.LIB/' *TCAT &FIC *TCAT '.FILE/' +
                          *TCAT &MBR *TCAT '.MBR')
/* Copie en UTF-8 : Erreur prevue -> RC/MSG pour le RPG              */
            CPYTOSTMF  FROMMBR(&MBRPATH) TOSTMF(&STMF) +
                          STMFOPT(*REPLACE) STMFCCSID(1208)
             MONMSG     MSGID(CPF0000 CPFA000) EXEC(DO)
             CHGVAR     VAR(&RC) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('Erreur export du membre' +
                          *BCAT &MBR)
             RETURN
             ENDDO
             CHGVAR     VAR(&MSG) VALUE(&MBR *TCAT ' -> ' *CAT &STMF)
             RETURN
/*********** Error handling (erreur IMPREVUE) ************************/
 STDERR1:    CHGVAR     VAR(&RC) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('Erreur systeme dans EXPMBRC')
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

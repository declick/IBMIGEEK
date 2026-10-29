/*================================================================= */
/*|  SAVBIBPGM : PROGRAMME DE LA COMMANDE SAVBIB                  | */
/*|  SAVLIB DANS UN SAVF (QTEMP) PUIS COPIE DANS L IFS            | */
/*================================================================= */

             PGM        PARM(&BIB &DOSSIER)

/*--- PARAMETRES RECUS DE LA COMMANDE (MEME ORDRE QUE LES PARM) --- */

             DCL        VAR(&BIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DOSSIER) TYPE(*CHAR) LEN(20)

/*--- VARIABLES DE TRAVAIL --- */

             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&DATEISO) TYPE(*CHAR) LEN(8)
             DCL        VAR(&CHEMIN) TYPE(*CHAR) LEN(100)

/*--- *CURLIB : ON PREND LA BIBLIOTHEQUE EN COURS DU TRAVAIL --- */

             IF         COND(&BIB *EQ '*CURLIB') THEN(DO)
             RTVJOBA    CURLIB(&BIB)
             ENDDO

/*--- *USER : DOSSIER /HOME/UTILISATEUR --- */

             IF         COND(&DOSSIER *EQ ' ') THEN(DO)
             RTVJOBA    USER(&USER)
             CHGVAR     VAR(&DOSSIER) VALUE('/HOME/' *CAT &USER)
             ENDDO

/*--- LA BIBLIOTHEQUE EXISTE-T-ELLE ? --- */

             CHKOBJ     OBJ(QSYS/&BIB) OBJTYPE(*LIB)
             MONMSG     MSGID(CPF9800) EXEC(DO)
             SNDPGMMSG  MSG('BIBLIOTHEQUE' *BCAT &BIB *BCAT +
                          'INTROUVABLE OU NON AUTORISEE')
             RETURN
             ENDDO

/*--- DATE DU JOUR AU FORMAT AAAAMMJJ --- */

             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&DATE)
             CVTDAT     DATE(&DATE) TOVAR(&DATEISO) FROMFMT(*SYSVAL) +
                          TOFMT(*YYMD) TOSEP(*NONE)

/*--- CHEMIN IFS : DOSSIER/BIB_AAAAMMJJ.SAVF --- */

             CHGVAR     VAR(&CHEMIN) VALUE(&DOSSIER *TCAT '/' *CAT +
                          &BIB *TCAT '_' *CAT &DATEISO *CAT '.SAVF')

/*--- SAVF TEMPORAIRE DANS QTEMP (VIDE S IL EXISTE DEJA) --- */

             CRTSAVF    FILE(QTEMP/SAVBIB)
             MONMSG     MSGID(CPF7302) EXEC(CLRSAVF FILE(QTEMP/SAVBIB))

/*--- SAUVEGARDE DE LA BIBLIOTHEQUE DANS LE SAVF --- */

             SAVLIB     LIB(&BIB) DEV(*SAVF) SAVF(QTEMP/SAVBIB)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDPGMMSG  MSG('SAUVEGARDE DE' *BCAT &BIB *BCAT +
                          'IMPOSSIBLE (DROITS OU OBJETS UTILISES)')
             DLTF       FILE(QTEMP/SAVBIB)
             RETURN
             ENDDO

/*--- CREE LE DOSSIER IFS S IL N EXISTE PAS ENCORE --- */

             MKDIR      DIR(&DOSSIER)
             MONMSG     MSGID(CPFA000)

/*--- COPIE DU SAVF VERS L IFS --- */

             CPYTOSTMF  FROMMBR('/QSYS.LIB/QTEMP.LIB/SAVBIB.FILE') +
                          TOSTMF(&CHEMIN) STMFOPT(*REPLACE)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDPGMMSG  MSG('COPIE IFS IMPOSSIBLE DANS' *BCAT &DOSSIER)
             DLTF       FILE(QTEMP/SAVBIB)
             RETURN
             ENDDO

/*--- MENAGE PUIS MESSAGE DE FIN --- */

             DLTF       FILE(QTEMP/SAVBIB)
             SNDPGMMSG  MSG('SAUVEGARDE OK :' *BCAT &CHEMIN)

             ENDPGM

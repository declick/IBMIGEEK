/*================================================================= */
/*| AFFOBJ : AFFICHE LES OBJETS D UNE BIBLIOTHEQUE UN PAR UN      | */
/*| ENTREE = OBJET SUIVANT      F = EXIT                          | */
/*|                                                              | */
/*| TAILLE EN ROUGE SI PLUS DE 100K OCTECTS (INDICATEUR 60)       | */
/*================================================================= */

             PGM        PARM(&BIB &NBR &RETOUR)

/*--- DECLARATIONS : PARAMETRE, LISTE(O), ECRAN(E) --- */

             DCL        VAR(&BIB) TYPE(*CHAR) LEN(10)
             DCLF       FILE(QSYS/QADSPOBJ) OPNID(O)
             DCLF       FILE(QUEMIN/ECROBJ) OPNID(E)
             DCL        VAR(&NBR) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&RETOUR) TYPE(*CHAR) LEN(1)

/*--- PREPARATION DE LA LISTE DE OBJETS --- */

             CHGVAR     VAR(&RETOUR) VALUE('0')
             CALLSUBR   SUBR(PREPARE)

/*--- BOUCLE : UN OBJET PAR ECRAN --- */

             DOWHILE    COND('1')
             RCVF       DEV(*FILE) OPNID(O)
             MONMSG     MSGID(CPF0864) EXEC(LEAVE)
             CALLSUBR   SUBR(COPIE)
             SNDRCVF    RCDFMT(FMTOBJ) OPNID(E)

/*--- F3 : ON QUITTE TOUT(CODE3) --- */

             IF         COND(&E_IN03) THEN(DO)
             CHGVAR     VAR(&RETOUR) VALUE('3')
             LEAVE
             ENDDO

/*--- F12 : RETOUR A LA SAISIE(CODE2) --- */
             IF         COND(&E_IN12) THEN(DO)
             CHGVAR     VAR(&RETOUR) VALUE('2')
             LEAVE
             ENDDO
             ENDDO

/*--- MENAGE ET FIN --- */

             DLTOVR     FILE(QADSPOBJ)
             RETURN

/*--- SOUS ROUTINE : LISTE + TOTAL = REDIRECTION --- */

             SUBR       SUBR(PREPARE)
             CHGVAR     VAR(&E_BIB) VALUE(&BIB)
             DSPOBJD    OBJ(&BIB/*ALL) OBJTYPE(*ALL) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/LISTOBJ)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             CHGVAR     VAR(&RETOUR) VALUE('1')
             CHGVAR     VAR(&NBR) VALUE(0)
             RETURN
             ENDDO
             RTVMBRD    FILE(QTEMP/LISTOBJ) NBRCURRCD(&NBR)
             CHGVAR     VAR(&E_TOTAL) VALUE(%CHAR(&NBR))
             CHGVAR     VAR(&E_NUM) VALUE(0)
             OVRDBF     FILE(QADSPOBJ) TOFILE(QTEMP/LISTOBJ)
             ENDSUBR

/*--- SOUS ROUTINE : COPIE FICHIER(O) VERS ECRAN(E) + COULEUR --- */

             SUBR       SUBR(COPIE)
             CHGVAR     VAR(&E_NUM) VALUE(&E_NUM + 1)
             CHGVAR     VAR(&E_NOM) VALUE(&O_ODOBNM)
             CHGVAR     VAR(&E_TYPE) VALUE(&O_ODOBTP)
             CHGVAR     VAR(&E_TAILLE) VALUE(%CHAR(&O_ODOBSZ))
             CHGVAR     VAR(&E_IN60) VALUE('0')
             IF         COND(&O_ODOBSZ *GT 100000) THEN(CHGVAR +
                          VAR(&E_IN60) VALUE('1'))
             ENDSUBR
             ENDPGM

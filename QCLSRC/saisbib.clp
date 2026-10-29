/*================================================================= */
/*|      PRGA(SAISBIB) CALL PGRB(AFFOBJ) ET PASSE LES PARAM       | */
/*|                                                               | */
/*|      PARAM : &BIB -> ALLER  /  &RETOUR -> RETOUR              | */
/*|                                                               | */
/*|      F3 = EXIT                                                | */
/*================================================================= */

PGM

/*--- DECLARATIONS : ECRAN DE SAISIE(S) --- */

             DCLF       FILE(QUEMIN/ECRSAIS) OPNID(S)

/*--- PARAMETRES ECHANGES AVEC AFFOBJ --- */

             DCL        VAR(&BIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&RETOUR) TYPE(*CHAR) LEN(1)

/*--- BOUCLE DE SAISIE : ON TOURNE JUSQU A F3 --- */

             DOWHILE    COND('1')
             SNDRCVF    RCDFMT(FMTSAIS) OPNID(S)
             IF         COND(&S_IN03) THEN(LEAVE)

/*---- NOUVELLE SAISIE : ON EFFACE L ANCIEN MESSAGE --- */

             CHGVAR     VAR(&S_MESS) VALUE(' ')

/*--- BIBLIOTHEQUE VIDE : MESAGE ET RETOUR A LA SAISIE --- */

             IF         COND(&S_SBIB *EQ ' ') THEN(DO)
             CHGVAR     VAR(&S_MESS) VALUE('veuillez saisir une +
                          bibliotheque')
             ITERATE    /* Reviens au debut de la boucle */
             ENDDO

/*--- APPEL DE AFFOBJ PUIS LE MESSAGE SELON LE CODE RETOUR --- */

             CALLSUBR   SUBR(APPEL)
             IF         COND(&RETOUR *EQ '3') THEN(LEAVE)
             CALLSUBR   SUBR(MESSAGE)
             ENDDO

/*--- FIN DU PROGRAMME PRINCIPAL --- */

             RETURN

/*--- SOUS ROUTINE : APPEL DE AFFOBJ AVEC LES PARAM --- */

             SUBR       SUBR(APPEL)
             CHGVAR     VAR(&BIB) VALUE(&S_SBIB)
             CHGVAR     VAR(&NBR) VALUE(0)
             CHGVAR     VAR(&RETOUR) VALUE(' ')
             CALL       PGM(QUEMIN/AFFOBJ) PARM(&BIB &NBR &RETOUR)
             ENDSUBR

/*--- SOUS ROUTINE : MESSAGE SELON LE CODE DE AFFOBJ --- */
/*--- 0 = LISTE DE VUE ENTIER / 1 = ERREUR / 3 = SORTIE PAR F3 --- */

             SUBR       SUBR(MESSAGE)

                        /* CODE 0 : LISTE VUE EN ENTIER */
             IF         COND(&RETOUR *EQ '0') THEN(CHGVAR +
                          VAR(&S_MESS) VALUE(%CHAR(&NBR) *BCAT +
                          'objets consultes dans' *BCAT &BIB))

                        /* CODE 1 : BIB VIDE OU INTROUVABLE */
             IF         COND(&RETOUR *EQ '1') THEN(CHGVAR +
                          VAR(&S_MESS) VALUE('BIBLIOTHEQUE' *BCAT +
                          &BIB *BCAT 'VIDE OU INTROUVABLE'))

                         /* CODE 2 : RETOUR PAR F12 */
             IF          COND(&RETOUR *EQ '2') THEN(CHGVAR +
                           VAR(&S_MESS) VALUE('CONSULTATION DE' +
                           *BCAT &BIB *BCAT 'TERMINEE (F12)'))

                        /* CODE 3 : SORTIR PAR F3 */
             IF         COND(&RETOUR *EQ '3') THEN(CHGVAR +
                          VAR(&S_MESS) VALUE('CONSULTATION DE' +
                          *BCAT &BIB *BCAT 'INTERROMPUE (F3)'))

             ENDSUBR

/* --- C EST LA FIN POUET POUET --- */

ENDPGM

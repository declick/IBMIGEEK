/*================================================================= */
/*|  AFFMARQUE : AFFICHE LES BONBONS D UNE MARQUE SAISIE          | */
/*|  F3 = QUITTER (AVEC CONFIRMATION) F12 = RETOUR SAISIE         | */
/*================================================================= */

PGM

/*--- DECLARATION : BONBON (P), L ECRAN (E), CASE TROUVE --- */

             DCLF       FILE(QUEMIN/BONBON) OPNID(P)
             DCLF       FILE(QUEMIN/ECRBONBON) OPNID(E)
             DCL        VAR(&TROUVE) TYPE(*LGL) VALUE('0')

/*--- CONTROLE D ACCES / QUI LANCE OU AUTORISER  --- */

             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AUTOR) TYPE(*CHAR) LEN(10)

/*--- RECHERCHE PAR MORCEAU DE MARQUE (QCLSCAN) --- */

             DCL        VAR(&LEN) TYPE(*CHAR) LEN(21)
             DCL        VAR(&L) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&STRLEN) TYPE(*DEC) LEN(3 0) VALUE(20)
             DCL        VAR(&STRPOS) TYPE(*DEC) LEN(3 0) VALUE(1)
             DCL        VAR(&RESULT) TYPE(*DEC) LEN(3 0)

/*--- APPEL DU CONTROLE D ACCES ---*/

             CALLSUBR   SUBR(CONTROLE)

/*--- SAISIE DE LA MARQUE --- */

DEBUT:       SNDRCVF    RCDFMT(FMTMARQUE) OPNID(E)
             IF         COND(&E_IN03) THEN(GOTO CMDLBL(QUITM))

/*--- NOUVELLE RECHERCHE : MESSAGE ETEINT, RIEN TROUVE --- */

             CHGVAR     VAR(&E_IN50) VALUE('0')
             CHGVAR     VAR(&TROUVE) VALUE('0')

/*--- MARQUE VIDE : MESSAGE ET RETOUR SAISIE --- */

             IF         COND(&E_SMARQUE *EQ ' ') THEN(DO)
             CHGVAR     VAR(&E_IN50) VALUE('1')
             GOTO       CMDLBL(DEBUT)
             ENDDO

/*--- SAISIE EN MAJUSCULES + LONGUEUR REELLE --- */

             CHGVAR     VAR(&E_SMARQUE) VALUE(%UPPER(&E_SMARQUE))
             CHGVAR     VAR(&LEN) VALUE(&E_SMARQUE *TCAT '.')
             CHGVAR     VAR(&L) VALUE(%SCAN('.' &LEN))
             CHGVAR     VAR(&L) VALUE(&L - 1)

/*--- LECTURE DE BONBON, UN BONBON A LA FOIS --- */

 LOOP:       RCVF       OPNID(P)
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(RETOUR))

/*--- LA MARQUE CONTIENT ELLE LE MORCEAU SAISIE ? --- */

             CALL       PGM(QCLSCAN) PARM(&P_MARQUE &STRLEN &STRPOS +
                           &E_SMARQUE &L '1' '0' ' ' &RESULT)
             IF         COND(&RESULT *LE 0) THEN(GOTO CMDLBL(LOOP))

/*--- MARQUE TROUVEE : ON L AFFICHE --- */

             CHGVAR     VAR(&TROUVE) VALUE('1')
             CALLSUBR   SUBR(COPIE)

/*--- AFFICHAGE DU BONBON --- */

 AFFB:       SNDRCVF    RCDFMT(FMTBONBON) OPNID(E)
             IF         COND(&E_IN03) THEN(GOTO CMDLBL(QUITB))
             IF         COND(&E_IN12) THEN(GOTO CMDLBL(RETOUR))
             GOTO       CMDLBL(LOOP)

/* ---RETOUR A LA SAISIE, FERME BONBON POUR RELIRE AU DEBUT --- */

RETOUR:                 CLOSE OPNID(P)
             IF         COND(*NOT &TROUVE) THEN(CHGVAR VAR(&E_IN50) +
                          VALUE('1'))
             GOTO       CMDLBL(DEBUT)

/*--- CONFIRMATION DE SORTIE DEPUIS LA SAISIE --- */

 QUITM:      SNDRCVF    RCDFMT(FMTWIN) OPNID(E)
             IF         COND(&E_IN03) THEN(GOTO CMDLBL(END))
             GOTO       CMDLBL(DEBUT)

/*--- CONFIRMATION DE SORTIE DEPUIS BONBON --- */

 QUITB:      SNDRCVF    RCDFMT(FMTWIN) OPNID(E)
             IF         COND(&E_IN03) THEN(GOTO CMDLBL(END))
             GOTO       CMDLBL(AFFB)

/*--- SOUS ROUTINE DE CONTROLE --- */

             SUBR       SUBR(CONTROLE)
             RTVJOBA    USER(&USER)
             RTVDTAARA  DTAARA(QUEMIN/ACCESBON *ALL) RTNVAR(&AUTOR)
             IF         COND(&USER *NE &AUTOR) THEN(DO)
             SNDPGMMSG  MSG('Utilisateur non autoriser : ' *CAT &USER)
             RETURN
             ENDDO
             ENDSUBR

/*--- SOUS ROUTINE DE COPIE FICHIER(P) VERS ECRAN (E) --- */

             SUBR       SUBR(COPIE)
             CHGVAR     VAR(&E_NOM) VALUE(&P_NOM)
             CHGVAR     VAR(&E_MARQUE) VALUE(&P_MARQUE)
             CHGVAR     VAR(&E_COULEUR) VALUE(&P_COULEUR)
             CHGVAR     VAR(&E_PRIX) VALUE(&P_PRIX)
             CHGVAR     VAR(&E_NUMBER) VALUE(&P_NUMBER)
             ENDSUBR

/*--- C EST LA FIN POUET POUET --- */

 END:        ENDPGM

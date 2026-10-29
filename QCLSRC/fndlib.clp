             PGM

/* --- DECLARATIONS : LISTE DES BIBS (O), ECRAN (E) --- */

             DCLF       FILE(QSYS/QADSPOBJ) OPNID(O)
             DCLF       FILE(QUEMIN/ECRFND) OPNID(E)

/* --- VARIABLES POUR QCLSCAN (LONGUEURS EN *DEC 3 0) --- */

             DCL        VAR(&LEN) TYPE(*CHAR) LEN(21)
             DCL        VAR(&L) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&STRLEN) TYPE(*DEC) LEN(3 0) VALUE(50)
             DCL        VAR(&STRPOS) TYPE(*DEC) LEN(3 0) VALUE(1)
             DCL        VAR(&RESULT) TYPE(*DEC) LEN(3 0)

/* --- COMPTEUR ET CODE DE SORTIE --- */

             DCL        VAR(&NUM) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&QUITTE) TYPE(*LGL) VALUE('0')

/* --- BOUCLE DE SAISIE : ON TOURNE JUSQU A F3 --- */

             DOWHILE    COND('1')
             SNDRCVF    RCDFMT(FMTSAI) OPNID(E)
             IF         COND(&E_IN03) THEN(LEAVE)
             CHGVAR     VAR(&E_MESS) VALUE(' ')

/* --- MOT VIDE : MESSAGE ET RETOUR A LA SAISIE --- */

             IF         COND(&E_STXT *EQ ' ') THEN(DO)
             CHGVAR     VAR(&E_MESS) VALUE('VEUILLEZ SAISIR UN MOT')
             ITERATE
             ENDDO

 /* --- PREPARATION, RECHERCHE, MENAGE --- */

             CALLSUBR   SUBR(PREPARE)
             CALLSUBR   SUBR(CHERCHE)
             CLOSE      OPNID(O)
             DLTOVR     FILE(QADSPOBJ)

/* --- F3 DANS LES RESULTATS : ON QUITTE TOUT --- */

             IF         COND(&QUITTE) THEN(LEAVE)

/* --- COMPTE RENDU DE LA RECHERCHE --- */

             IF         COND(&NUM *EQ 0) THEN(CHGVAR VAR(&E_MESS) +
                          VALUE('AUCUNE BIBLIOTHEQUE AVEC' *BCAT +
                          &E_STXT))
             ELSE       CMD(CHGVAR VAR(&E_MESS) VALUE(%CHAR(&NUM) +
                          *BCAT 'BIBLIOTHEQUE(S) VUE(S) AVEC' *BCAT +
                          &E_STXT))
             ENDDO

             RETURN

/* --- SOUS ROUTINE : MOT EN MAJ, LONGUEUR, LISTE DES BIBS --- */

             SUBR       SUBR(PREPARE)
             CHGVAR     VAR(&NUM) VALUE(0)
             CHGVAR     VAR(&E_STXT) VALUE(%UPPER(&E_STXT))
             CHGVAR     VAR(&LEN) VALUE(&E_STXT *TCAT '.')
             CHGVAR     VAR(&L) VALUE(%SCAN('.' &LEN))
             CHGVAR     VAR(&L) VALUE(&L - 1)
             DSPOBJD    OBJ(QSYS/*ALL) OBJTYPE(*LIB) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/LISTLIB)
             OVRDBF     FILE(QADSPOBJ) TOFILE(QTEMP/LISTLIB)
             ENDSUBR

/* --- SOUS ROUTINE : LECTURE ET AFFICHAGE DES BIBS TROUVEES --- */

             SUBR       SUBR(CHERCHE)
             DOWHILE    COND('1')
             RCVF       OPNID(O)
             MONMSG     MSGID(CPF0864) EXEC(LEAVE)

/* --- LE TEXTE CONTIENT-IL LE MOT ? SINON BIB SUIVANTE --- */

             CALL       PGM(QCLSCAN) PARM(&O_ODOBTX &STRLEN &STRPOS +
                          &E_STXT &L '1' '0' ' ' &RESULT)
             IF         COND(&RESULT *LE 0) THEN(ITERATE)

/* --- TROUVEE : ON L AFFICHE --- */

             CHGVAR     VAR(&NUM) VALUE(&NUM + 1)
             CHGVAR     VAR(&E_RBIB) VALUE(&O_ODOBNM)
             CHGVAR     VAR(&E_RTXT) VALUE(&O_ODOBTX)
             CHGVAR     VAR(&E_RNUM) VALUE(%CHAR(&NUM))
             SNDRCVF    RCDFMT(FMTRES) OPNID(E)

/* --- F3 : TOUT QUITTER   F12 : RETOUR A LA SAISIE --- */

             IF         COND(&E_IN03) THEN(DO)
             CHGVAR     VAR(&QUITTE) VALUE('1')
             LEAVE
             ENDDO
             IF         COND(&E_IN12) THEN(LEAVE)
             ENDDO
             ENDSUBR

             ENDPGM

             PGM        PARM(&LIB)
/*********************************************************************/
/* LSTSRCC : CONTROLE LA BIBLIOTHEQUE, CREE LA LISTE DES MEMBRES     */
/*           DANS QTEMP (DSPFD *MBRLIST) ET APPELLE LSTSRCR          */
/*********************************************************************/
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
/* LA BIBLIOTHEQUE EXISTE ? SINON MESSAGE D'ERREUR ET ARRET          */
             CHKOBJ     OBJ(QSYS/&LIB) OBJTYPE(*LIB)
             MONMSG     MSGID(CPF9800) EXEC(DO)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) +
                          MSGDTA('BIBLIOTHEQUE' *BCAT &LIB *BCAT +
                          'INEXISTANTE') MSGTYPE(*ESCAPE)
             ENDDO
/* CREE LA LISTE DES MEMBRES DANS QTEMP/LSTMBR                       */
             DSPFD      FILE(&LIB/*ALL) TYPE(*MBRLIST) +
                          OUTPUT(*OUTFILE) FILEATR(*PF) +
                          OUTFILE(QTEMP/LSTMBR) OUTMBR(LSTMBR *REPLACE)
/* CONTROLE : LA LISTE A BIEN ETE CREEE ?                            */
             CHKOBJ     OBJ(QTEMP/LSTMBR) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9800) EXEC(SNDPGMMSG MSGID(CPF9898) +
                          MSGF(QCPFMSG) MSGDTA('LISTE NON CREEE') +
                          MSGTYPE(*ESCAPE))
/* Le RPG est compile sur le modele QSYS/QAFDMBRL : on le redirige   */
/* vers la liste de QTEMP                                            */
              OVRDBF     FILE(QAFDMBRL) TOFILE(QTEMP/LSTMBR) MBR(LSTMBR)
              CALL       PGM(LSTSRCR) PARM(&LIB)
              DLTOVR     FILE(QAFDMBRL)
              ENDPGM

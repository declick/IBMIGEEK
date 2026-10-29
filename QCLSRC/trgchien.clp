/*===========================================================*/
/* PROGRAMME : TRGCHIEN                                      */
/* OBJET     : TRIGGER SUR MES_CHIENS - MESSAGE A CHAQUE     */
/*             AJOUT / MODIF / SUPPRESSION                   */
/* AUTEUR    : QUEMIN07                                      */
/*===========================================================*/
             PGM        PARM(&BUFFER &LONGUEUR)

             DCL        VAR(&BUFFER)   TYPE(*CHAR) LEN(100)
             DCL        VAR(&LONGUEUR) TYPE(*CHAR) LEN(4)

/* VARIABLES DE TRAVAIL                                      */
            DCL        VAR(&FICHIER)  TYPE(*CHAR) LEN(10)
DCL        VAR(&EVENT)    TYPE(*CHAR) LEN(1)
DCL        VAR(&LIBEVT)   TYPE(*CHAR) LEN(12)
DCL        VAR(&USER)     TYPE(*CHAR) LEN(10)
/* LECTURE DU TAMPON : NOM DU FICHIER ET EVENEMENT           */
             CHGVAR     VAR(&FICHIER) VALUE(%SST(&BUFFER 1 10))
             CHGVAR     VAR(&EVENT)   VALUE(%SST(&BUFFER 31 1))

/* TRADUCTION DU CODE EVENEMENT EN LIBELLE                   */
             IF         COND(&EVENT = '1') THEN(CHGVAR VAR(&LIBEVT) +
                          VALUE('AJOUT'))
             IF         COND(&EVENT = '2') THEN(CHGVAR VAR(&LIBEVT) +
                          VALUE('SUPPRESSION'))
             IF         COND(&EVENT = '3') THEN(CHGVAR VAR(&LIBEVT) +
                          VALUE('MODIF'))



/* QUI A FAIT L'OPERATION                                    */
             RTVJOBA    USER(&USER)

/* MESSAGE A QUEMIN07                                        */
             SNDMSG     MSG('TRIGGER :' *BCAT &LIBEVT *BCAT 'DANS' +
                          *BCAT &FICHIER *BCAT 'PAR' *BCAT &USER) +
                          TOUSR(QUEMIN07)
             MONMSG     MSGID(CPF0000)

             ENDPGM



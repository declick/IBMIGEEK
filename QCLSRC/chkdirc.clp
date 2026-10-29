             PGM        PARM(&DIR &RC)
/* CHKDIRC : RC = '0' SI LE REPERTOIRE EXISTE, '1' SINON             */
             DCL        VAR(&DIR) TYPE(*CHAR) LEN(50)
             DCL        VAR(&RC)  TYPE(*CHAR) LEN(1)
             CHGVAR     VAR(&RC) VALUE('0')
/* SOLUTION : SE PLACER DANS LE REPERTOIRE. S'IL N'EXISTE PAS, LA    */
/* COMMANDE ECHOUE. ON NE CREE NI NE MODIFIE AUCUN FICHIER.          */
             CHGCURDIR  DIR(&DIR)
             MONMSG     MSGID(CPFA000) EXEC(CHGVAR VAR(&RC) VALUE('1'))
             ENDPGM

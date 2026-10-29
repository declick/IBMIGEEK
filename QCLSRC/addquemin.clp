             PGM

/* ajout de la bib CL QUEMIN */
             ADDLIBLE   LIB(QUEMIN)
             MONMSG     MSGID(CPF2103)

/* MESSAGE DACCEUIL */
             SNDUSRMSG  MSG('BONJOUR QUENTIN ! PENSE A EMARGER ! ET +
                          PASSE UNE BONNE JOURNEE, COURAGE ;)') +
                          MSGTYPE(*INQ)

             ENDPGM

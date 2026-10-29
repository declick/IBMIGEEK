/*================================================================= */
/*|  SAVBIB : SAUVEGARDE D UNE BIBLIOTHEQUE DANS L IFS            | */
/*|  PROGRAMME DE TRAITEMENT : QUEMIN/SAVBIBPGM                   | */
/*================================================================= */

CMD        PROMPT('SAUVEGARDE BIB DANS L''IFS')

/*--- PARAMETRE 1 : LA BIBLIOTHEQUE (OBLIGATOIRE) --- */

             PARM       KWD(LIB) TYPE(*NAME) LEN(10) MIN(1) +
                          SPCVAL((*CURLIB)) +
                          CHOICE('NOM, *CURLIB') +
                          PROMPT('BIBLIOTHEQUE A SAUVEGARDER')

/*--- PARAMETRE 2 : LE DOSSIER IFS (PAR DEFAUT /HOME/QUEMIN07) --- */

             PARM       KWD(FOLDER) TYPE(*CHAR) LEN(20) +
                        DFT(*USER) SPCVAL((*USER ' ') (*TMP '/TMP')) +
                          CASE(*MIXED) +
                          CHOICE('CHEMIN, *USER, *TMP') +
                          PROMPT('DOSSIER (*USER DEFAULT, *TMP)')


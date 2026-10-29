             CMD        PROMPT('EXPORT BONBON EN CSV IFS')

             PARM       KWD(FICHIER) TYPE(*CHAR) LEN(50) +
                          DFT('BONBON.CSV') CASE(*MIXED) +
                          PROMPT('NOM DU FICHIER CSV')

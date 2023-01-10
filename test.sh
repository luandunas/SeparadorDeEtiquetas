#!/bin/bash -e

function readFile() {
    if [ -s sas06.1532654235 ]; then
        # The file is not-empty.
        clear
        etiqueta=$(sed '/\^PQ1,0,1,Y.XZ/q' sas06.1532654235)
        echo $etiqueta
        sed -i '0,/\^PQ1,0,1,Y.XZ/d' sas06.1532654235
        readFile
    else
        # ARQUIVO VAZIO (ETIQUETAS ACABARAM).
        echo "EMPTY"
    fi

}
readFile
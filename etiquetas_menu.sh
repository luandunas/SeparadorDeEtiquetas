columns="$(tput cols)"
printf "%*s\n" $(($columns / 2)) "$text"

clear
GREEN='\033[1;32m'
CYAN='\033[1;36m'
RED='\033[1;31m'
NC='\033[0m' # No Color

CYANBG='\e[48;5;027m'
RESETBG='\e[0m'

selectedFile=""
lastFileName=""

function showDevCredits() {
    tput cup 4 10
    printf "${CYAN} DESENVOLVIDO POR LUAN (CPD 321)${NC}\n"
    tput cup 5 10
    printf "${CYAN} [@] @luandunas (Todas redes sociais)${NC}"
    tput cup 6 10
    printf "\n\n\n\n"

    sleep 3
    exit 1
}

function waitUserInput() {
    while [ true ]; do
        read -rsn1 k
        if [[ $k = s || $k = S ]]; then
            # printf "${CYAN}IMPRESSÃO ETIQUETAS X ENVIADA${NC}\n"
            echo $k | tr 'a-z' 'A-Z'
            tput cup $productsPrinted 4
            read enterKey
            if [[ -z $enterKey ]]; then
				lp -d lpt12 $selectedFile
                rm $selectedFile
                clear
                printFiles
            fi
        elif [[ $k = q || $k = Q ]]; then
            clear
            showDevCredits
        else
            echo $k | tr 'a-z' 'A-Z'
            tput cup $productsPrinted 4
        fi
    done
}

function printFiles() {

    varTotalFilesInDir=$(ls -l imp/)
    if [[ $varTotalFilesInDir == "total 0" ]]; then
        showDevCredits
        exit 1
    fi

    productsPrinted=0
    printf "||   ${GREEN}IMPRESSOR DE ETIQUETA${CYAN} (DEV. LUAN - CPD 321)${NC}   ||\n"
    echo "||=================================================="
    # printf "|| ${CYAN}[X] ARQUIVO1\n${NC}"
    for filename in imp/*; do
        productsPrinted=$((productsPrinted + 1))
        if [[ "$productsPrinted" == 1 ]]; then
        filenameUpperCase=`echo ${filename/"imp/"/} | tr 'a-z' 'A-Z'`
            printf "|| [X] ${CYANBG}${filenameUpperCase/"imp/"/}\n${RESETBG}"
            selectedFile=$filename
        else
            echo "|| [ ] ${filename/"imp/"/}" | tr 'a-z' 'A-Z'
        fi
    done
    echo "||=================================================||"
    printf "|| [ ] | [S] ${GREEN}IMPRIMIR ${CYAN}SELECIONADO ${GREEN}| [Q] ${RED}PARA SAIR${NC}  ||\n"
    echo "||=================================================||"
    productsPrinted=$((productsPrinted + 3))
    tput cup $productsPrinted 4
    waitUserInput
}

printFiles
stty -echo

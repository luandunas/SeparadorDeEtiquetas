clear

#FUNCTIONS
function status() {
    echo -e "$2STATUS:\e[0m $1"
}

# text="    ___       ___       ___   "
# col=$((($(tput cols)-${#text}) / 2))
# tput cup 2 $col
echo -e "+-------------------------------+\e[1;49;34m
\e[0m|\e[1;49;34m    ___       ___       ___    \e[0m|
\e[0m|\e[1;49;34m   /\  \     /\  \     /\  \   \e[0m|
\e[0m|\e[1;49;34m  /::\  \   /::\  \   /::\  \  \e[0m|
\e[0m|\e[1;49;34m /:/\:\__\ /::\:\__\ /:/\:\__\ \e[0m|
\e[0m|\e[1;49;34m \:\ \/__/ \/\::/  / \:\/:/  / \e[0m|
\e[0m|\e[1;49;34m  \:\__\      \/__/   \::/  /  \e[0m|
\e[0m|\e[1;49;34m   \/__/               \/__/   \e[0m| 
\e[0m|\e[0m                               |"

echo -e "| \e[1;97;44mCPD 321 - CARAPICUIBA GOPIUVA\e[0m |"
echo -e "| \e[1;97;44mDesenvolvido por: Luan Santos\e[0m |"
echo "+-------------------------------+"
status "Buscando arquivos..." "\e[1;44;97m"
cd ../../../../fs1/save/bk

if [ -f "smg11.f321.2331518606.csv" ]; then
    fileCreationDate=$(date -r smg11.f321.2331518606.csv "+%d-%m-%Y")

    if [ $(date "+%d-%m-%Y") = "$fileCreationDate" ]; then
        status "Arquivos encontrado!" "\e[1;44;97m"
        status "Copiando Arquivos..." "\e[1;44;97m"
        cp sas06.1532654235 smg11.f321.2331518606.csv ../../../Users/Dunas/Downloads/etiquetas
        status "Arquivos copiado com sucesso!" "\e[1;44;97m"
        cd ../../../Users/Dunas/Downloads/etiquetas
    else
        echo -e "\e[1;97;41mFALHA: ESTE SCRIPT DEVE SER EXECUTADO APÓS A DD04!\e[0m"
        exit
    fi
fi

status "Checando quantidade de Etiquetas..." "\e[1;44;97m"
etqQuant=$(grep "LS0" sas06.1532654235 | wc -l)
status "Quantidade de etiquetas \e[1;44;42m${etqQuant}\e[0m" "\e[1;44;97m"
# echo ""
status "Separando \e[1;44;42m${etqQuant}\e[0m etiquetas...\e[1;41;97mEste processo pode levar alguns minutos\e[0m" "\e[1;44;97m"
status "ETIQUETAS SEPARADAS: \e[1;44;45m0\e[0m" "\e[1;44;97m"

#------------------------------------------------------------------#

text=$(<sas06.1532654235)

#Define multi-character delimiter
delimiter="^PQ1,0,1,Y^XZ"
#Concatenate the delimiter with the main string
string=$text$delimiter

#Split the text based on the delimiter
myarray=()
declare -A separetedTags
todasEtiquetas=0

#Creating a loop FOR EACH tag on file "text=$(<sas06.2223332547)"

function gerar_etiquetas() {
    while [[ $string ]]; do
        # printf "\n\n"
        myarray+=("${string%%"$delimiter"*}")
        # echo "${string%%"$delimiter"*}"
        if [ "$string" != "^PQ1,0,1,Y^XZ" ]; then
            todasEtiquetas=$((todasEtiquetas + 1))
        fi
        # echo "${string%%"$delimiter"*}" | grep -P '(?<=\^FT\d\d\d,\d\d\^A0R,68,\d\d\^FH\\\^FD)(.*?)(?=\^FS)' -o
        etiqueta=$(echo "${string%%"$delimiter"*}" | grep -P '(?<=\^FDMA,\:p\:)\d+(?=\:d\:)' -o)

        etiquetaSetor=$(grep "\b$etiqueta\b\;[0-9][0-9][0-9]\;" smg11.f321.2331518606.csv)
        # echo $etiquetaSetor
        IFS=';' read -r -a array <<<$etiquetaSetor
        etiquetaCategoria=${array[26]}
        # echo $etiquetaCategoria
        if [[ " ${!separetedTags[*]} " =~ $etiquetaCategoria ]]; then
            separetedTags["$etiquetaCategoria"]+="${string%%"$delimiter"*}^PQ1,0,1,Y^XZ"
        else
            separetedTags["$etiquetaCategoria"]="${string%%"$delimiter"*}^PQ1,0,1,Y^XZ"
        fi
        string=${string#*"$delimiter"}
        tput cup 19 0
        status "ETIQUETAS SEPARADAS: \e[1;44;45m${todasEtiquetas}\e[0m" "\e[1;44;97m"
    done

    #When done all process to group tags.
    #Use the the below to see all keys in object and create files to printer

    #   echo "=================CRIANDO ARQUIVOS DE IMPRESSAO==============="
    for k in "${!separetedTags[@]}"; do
        fileName=${k//\//-}
        fileName=$(echo ${fileName//\ /} | tr '[:upper:]' '[:lower:]')
        fileContent=${separetedTags[$k]}
        # echo ${#separetedTags[$k]}
        # echo $fileName
        tput cup 20 0
        echo "                                                                                                "
        tput cup 20 0
        status "Criando arquivo: \e[0m${fileName}" "\e[1;44;97m"
        echo "$fileContent" >./imp/$fileName
        #remove first EMPTY line from file
        tail -n +2 "./imp/$fileName" >"./imp/$fileName.tmp" && mv "./imp/$fileName.tmp" "./imp/$fileName"
    done
    status "\e[1;97;42mArquivos criado com sucesso!" "\e[1;44;97m"
    status "Para começar a imprimir, execute o shell \e[1;97;42metiquetas_menu.sh\e[0m" "\e[1;44;97m"
    #   echo "${string%%"$delimiter"*}"
}

gerar_etiquetas

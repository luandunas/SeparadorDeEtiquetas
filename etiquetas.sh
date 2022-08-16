#!/bin/bash
#Define the string to split

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
    printf "\n\n"
    myarray+=("${string%%"$delimiter"*}")
    # echo "${string%%"$delimiter"*}"
    todasEtiquetas=$((todasEtiquetas + 1))
    # echo "${string%%"$delimiter"*}" | grep -P '(?<=\^FT\d\d\d,\d\d\^A0R,68,\d\d\^FH\\\^FD)(.*?)(?=\^FS)' -o
    etiqueta=$(echo "${string%%"$delimiter"*}" | grep -P '(?<=\^FDMA,\:p\:)\d+(?=\:d\:)' -o)

    etiquetaSetor=$(grep "\b$etiqueta\b\;[0-9][0-9][0-9]\;" smg11.f321.2331518606.csv)
    # echo $etiquetaSetor
    IFS=';' read -r -a array <<<$etiquetaSetor
    etiquetaCategoria=${array[26]}
    echo $etiquetaCategoria
    if [[ " ${!separetedTags[*]} " =~ $etiquetaCategoria ]]; then
      separetedTags["$etiquetaCategoria"]+="${string%%"$delimiter"*}^PQ1,0,1,Y^XZ"
    else
      separetedTags["$etiquetaCategoria"]="${string%%"$delimiter"*}^PQ1,0,1,Y^XZ"
    fi

    echo "ETIQUETAS CONTADAS: ${todasEtiquetas}"
    string=${string#*"$delimiter"}
  done

  #When done all process to group tags.
  #Use the the below to see all keys in object and create files to printer

  echo "=================CRIANDO ARQUIVOS DE IMPRESSAO==============="
  for k in "${!separetedTags[@]}"; do
    fileName=${k//\//-}
    fileName=$(echo ${fileName//\ /} | tr '[:upper:]' '[:lower:]')
    fileContent=${separetedTags[$k]}
    echo ${#separetedTags[$k]}
    echo $fileName
    echo "$fileContent" >./imp/$fileName
    #remove first EMPTY line from file
    tail -n +2 "./imp/$fileName" >"./imp/$fileName.tmp" && mv "./imp/$fileName.tmp" "./imp/$fileName"
  done
  echo "${string%%"$delimiter"*}"
}

gerar_etiquetas

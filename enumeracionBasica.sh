#!/bin/bash

#Requerimientos


#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

#USABILIDAD Y AYUDA
usage="$(basename "$0") [-h] [Nombre Objetivo] [ip Objetivo] -- Programa para realizar el comienzo de una enumeración básica.

where:
    -h                  Muestra esta ayuda
    Nombre Objetivo     Escribe el nombre del objetivo
    ip Objetivo         IP del objetivo"

while getopts ':h:' option; do
    case "$option" in
        h)  echo "$usage"
            exit 0
            ;;
        :)  echo "$usage"
            exit 0
            ;;
        \?) printf "\n"
            printf "${yellowColour}[!] ${redColour}Opción no permitida: -%s\n${endColour}" "$OPTARG" >&2
            printf "\n"
            echo "$usage" >&2
            exit 1
            ;;
    esac
done
shift $((OPTIND - 1))

#Parar la app
trap ctrl-c INT

function ctrl-c(){
    echo -e "\n${yellowColour}[!] ${redColour}Saliendo...\n${endColour}"
    exit 0
}

#ARGUMENTOS
objName="$1"
ipObjetive="$2"

if [ -z ${objName}  ]; then
    printf "\n"
    echo -e "${yellowColour}[!] ${redColour}Escriba el nombre y la ip de su objetivo\n${endColour}"
    echo "$usage"
    exit 1
elif [ -n ${ipObjetive} ]; then
    if [[ ${ipObjetive} == *"."*"."*"."* ]]; then
        printf "\n"
        echo -e "${yellowColour}Objetivo: ${grayColour}${objName}${endColour}"
        echo -e "${yellowColour}ip: ${grayColour}${ipObjetive}\n${endColour}"
    else
        printf "\n"
        echo -e "${yellowColour}[!] ${redColour}Escriba el nombre del objetivo o revise la dirección ip\n${endColour}"
        echo "$usage"
        exit 1
    fi
fi

#FUNCIONES
function folders(){
    if [[ -d ${objName} ]]; then
        read -n 1 -p "[!] El directorio ya existe, ¿desea sobreescribirlo? (y/n): " pregunta
        sleep 0.5
        if [ "$pregunta" = "y" ]; then
            echo -e "Escribiendo el archivo allPorts dentro del directorio '${objName}/nmap/allPorts'"
            normalScan | awk 'NF{print $NF}' | tr "puertos." " "
            printf "\n"
        elif [ "$pregunta" = "n" ]; then
            printf "\n"
            echo -e "\n${yellowColour}[!] ${redColour}Saliendo...\n${endColour}"
            exit 0
        else
            printf "\n"
            echo -e "${yellowColour}[!] ${redColour}No entiendo tu respuesta.${endColour}"
            echo -e "\n${yellowColour}[!] ${redColour}Saliendo...\n${endColour}"
            exit 0
        fi
    else
        TODO!!!!!!!!!!!!
        mkdir ${objName} && mkdir ${objName}/{nmap,exploits,content}
    fi
}

echo $extractPorts

function normalScan(){
    echo -e "${turquoiseColour}Comenzando el escaneo de puertos.\n${endColour}"
    nmap -p- --open -T5 ${ipObjetive} -n > "${objName}/nmap/allPorts"
}

function fastScan(){
    echo -e "${turquoiseColour}Buscando servicios por el método rápido en los puertos: ${purpleColour}${extractPorts}.\n${endColour}"
    echo -e "${yellowColour}[!]${blueColour}Mostrando status cada 10s... ${endColour}"
    nmap -n -Pn -p- --open --min-rate 5000 ${ipObjetive} -oN "${objName}/nmap/allPorts"
}

function pruebaScan(){
    echo -e "Comenzamos realizando una prueba para evaluar la velocidad del escaneo durante 20 segundos."
    nmap -p- --open -T5 ${ipObjetive} -n --stats-every 5s &
    proceso=$(ps | grep nmap | cut -d ' ' -f 2)
    sleep 20
    kill -9 $proceso
    echo -e "
        ${yellowColour}1) ${grayColour}Realizar un escaneo como el que acaba de ver.${endColour}
        ${yellowColour}2) ${grayColour}Realizar un escaneo más rápido.${endColour}"
    read -p "¿Que opción desea elegir? " OPCION
    case $OPCION in
        1)
            echo -e "Comenzando el programa con un escaneo normal..."
            normalScan
        ;;
        2)
            echo -e "Comenzando el programa con un escaneo rápido..."
            fastScan
        ;;
        *)
            echo -e "${yellowColour}[!] ${redColour}No conozco esta opción.${endColour}"
            echo -e "\n${yellowColour}[!] ${redColour}Saliendo...\n${endColour}"
        ;;
    esac
}

function portScan(){
    echo -e "${turquoiseColour}Buscando servicios en los puertos: ${purpleColour}${extractPorts}.\n${endColour}"
    echo -e "${yellowColour}[!]${blueColour}Mostrando status cada 10s... ${endColour}"
    nmap -sC -sV -p${extractPorts} ${ipObjetive} --stats-every 10s -oN "${objName}/nmap/portsVersion"
}

function enumeration(){
    #Variables
    puertos=$(cat ${objName}/nmap/allPorts | grep -oP '\d{1,5}/' | xargs | tr '/' ',' | sed -e 's/.$//' | tr -d '[:space:]' | sort -u | uniq -u | tr ',' ' ')
    lista=($puertos)
    ftp=$(cat ${objName}/nmap/portsVersion | grep -i anonymous)
    for i in ${lista[*]}
    do
        if [[ ${i} == 80 ]]; then
            python3 /opt/dirsearch/dirsearch -u http://${ipObjetive}/ -e php,txt,html -t200 -x 403 --simple-report="${objName}/nmap/directorios"
        elif  [[ ${i} == 443 ]]; then
            python3 /opt/dirsearch/dirsearch -u https://${ipObjetive}/ -e php,txt,html -t200 -x 403 --simple-report="${objName}/nmap/directorios"
        elif [[ ${i} == 21 ]]; then
            echo ${ftp}
            if [[ $? == 1 ]]; then
                printf "\n"
                echo -e "${yellowColour}[!]${grayColour}El objetivo es vulnerable a acceso anónimo por FTP${endColour}"
            else
                printf "\n"
                echo -e "${yellowColour}[x]${redColour}El objetivo NO es vulnerable a acceso anónimo por FTP${endColour}"
            fi
        else
            printf "\n"
            echo -e "${yellowColour}[x]${redColour}El puerto ${i} no está en esta lista${endColour}"
        fi
    done
}


#MAIN PROGRAM
#Creamos las carpetas
folders
#Realizamos una prueba de ecaneo para ver la velocidad
pruebaScan
#Extraemos los puertos obtenidos
extractPorts=$(cat ${objName}/nmap/allPorts | grep -oP '\d{1,5}/' | xargs | tr '/' ',' | sed -e 's/.$//' | tr -d '[:space:]' | sort -u | uniq -u)
#Escaneamos los puertos
portScan
#Realizamos una enumeración básica de cada puerto común obtenido
enumeration
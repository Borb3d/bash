#!/bin/bash

## Colours ##
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"


## CANCEL APP ##
trap ctrl-c INT

function ctrl-c(){
    /usr/bin/printf "\n${yellowColour}Fixing dependencies, please wait for exit...\n${greenColour}"
    sleep 2
    sudo /usr/bin/dpkg --configure -a
    sudo /usr/bin/apt-get install -f -y
    /usr/bin/echo -e "\n${yellowColour}[!] ${redColour}Exiting...\n${endColour}"
    exit 0
}

function configureExt(){
    /usr/bin/printf "\n${yellowColour}[!]${grayColour}Installing extension $1..."
    gnome-extensions install $2 -f 2>>$HOME/error.log
    /usr/bin/sleep 1 && /usr/bin/clear
}

function extensions(){ #Function for config my desktop
    #Installing Extension to modify lateral bar
    configureExt "Dash To Dock" "dash-to-dockmicxgx.gmail.com.v69.shell-extension.zip"
    #Installing Places Status Indicator
    configureExt "Place Status" "places-menugnome-shell-extensions.gcampax.github.com.v48.shell-extension.zip"
    #Installing User Themes (To put any custom theme)
    configureExt "User Themes" "user-themegnome-shell-extensions.gcampax.github.com.v42.shell-extension.zip"
    #Installing Workspace Indicator (To see the current desktop space)
    configureExt "Workspace Indicator" "workspace-indicatorgnome-shell-extensions.gcampax.github.com.v45.shell-extension.zip"
    #Adding the extensions
    /usr/bin/printf "\n\n${redColour}Press 'alt+F2' and after put 'r' and accept.\nThe desktop gonna restart now...${blueColour}\n"
    read -rsn1 -p "Press any key to continue";/usr/bin/echo
}

#MAIN
/usr/bin/printf "\n${grayColour}Remember put necessary files on the folder where this script stay for correctly configuration...\n${yellowColour}"
read -rsn1 -p "Press any key to continue";/usr/bin/echo
#Install Extensions
extensions
#Configurate Extensions
/usr/bin/printf "${grayColour}I put all you need to configure desktop in correct folders\n${yellowColour}[!]Now you have to configure all on Tweak Tool"
#Open Tweak Tools to configurate
/usr/bin/printf "\n${redColour}Opening...\n${blueColour}"
sleep 2
/usr/bin/gnome-tweaks >/dev/null 2>>$HOME/error.log

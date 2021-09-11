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

## REQUIREMENTS ##
# Tested on Kali Linux 2021.2

## VARIABLES ##
zone=$(pwd)
backgroundImage="wild.png"
terminalImage="pirata1.jpg"

#Programs
bloodHound="https://github.com/BloodHoundAD/BloodHound/releases/download/4.0.3/BloodHound-linux-x64.zip"
burpSuite="https://portswigger.net/burp/releases/download?product=community&version=2021.6.2&type=Linux"
sonicVisualizer="https://code.soundsoftware.ac.uk/attachments/download/2787/SonicVisualiser-4.3-x86_64.AppImage"
pspy="https://github.com/DominicBreuker/pspy/releases/download/v1.2.0/pspy32"
impacket="https://github.com/SecureAuthCorp/impacket/releases/download/impacket_0_9_23/impacket-0.9.23.tar.gz"

#ZSH
lsd="https://github.com/Peltoche/lsd/releases/download/0.19.0/lsd-musl_0.19.0_amd64.deb"
bat="https://github.com/sharkdp/bat/releases/download/v0.17.1/bat_0.17.1_amd64.deb"

## USAGE AND HELP ##
usage="\n ${redColour}$(basename "$0") ${grayColour}[-h] -- Configure your work Operating System (Tested on Kali Linux 2021.2).

where:
    ${yellowColour}-h                  Show this help\n
    ${purpleColour}You don't need put any more arguments${endColour}\n"

while getopts ':h:' option; do
    case "$option" in
        h)  /usr/bin/printf "$usage"
            exit 0
            ;;
        :)  /usr/bin/printf "$usage"
            exit 0
            ;;
        \?) /usr/bin/printf "\n"
            /usr/bin/printf "${yellowColour}[!] ${redColour}ERROR: -%s\n${endColour}" "$OPTARG" >&2
            /usr/bin/printf "\n"
            /usr/bin/echo "$usage" >&2
            exit 1
            ;;
    esac
done
shift $((OPTIND - 1))

## CANCEL APP ##
trap ctrl-c INT

function ctrl-c(){
    /usr/bin/echo -e "\n${yellowColour}[!] ${redColour}Exiting...\n${endColour}"
    exit 0
}

## FUNCTIONS ##

function requirements(){
    /usr/bin/clear
    #Install Go
    aptInstall "Go" "golang"
    #Install xclip
    aptInstall "xClip" "xclip"
    #Install Locate
    aptInstall "Locate" "locate"
    #Install libraries
    aptInstall "libgtk-3-dev" "libgtk-3-dev"
    aptInstall "libpolkit-gobject-1-dev" "libpolkit-gobject-1-dev"
    aptInstall "libssl-dev" "libssl-dev"
    aptInstall "yasm" "yasm"
    aptInstall "libpcap-dev" "libpcap-dev"
    aptInstall "libbz2-dev" "libbz2-dev"
    aptInstall "dconf" "dconf-cli"
    #Install pip3
    aptInstall "pip3" "python3-pip"
    #Setting python3 as default
    sudo /usr/bin/update-alternatives --install /usr/bin/python python /usr/bin/python3 1
    #Install python3.8 venv
    aptInstall "python3.9-venv" "python3.9-venv"
}

function dpkgInstall(){ #Structure to download and configure programs
    /usr/bin/printf "\n${grayColour}Downloading and configuring $1...\n${yellowColour}"
    /usr/bin/wget $2 -O $3 -q --show-progress
    sudo /usr/bin/dpkg -i $PWD/$3 && /usr/bin/printf "${grayColour}[*]${blueColour}$1 ${greenColour}OK\n" >> $HOME/output.txt || /usr/bin/printf "${redColour}[x] $1 is NOT Installed\n" >> $HOME/output.txt
    sudo /usr/bin/apt-get install -f -y >/dev/null 2>>$HOME/error.log
    /usr/bin/sleep 1 && /usr/bin/clear
}

function aptInstall(){
    /usr/bin/printf "\n${grayColour}Downloading and configuring $1...\n${blueColour}"
    sudo /usr/bin/apt-get install $2 -y >/dev/null 2>>$HOME/error.log && /usr/bin/printf "${grayColour}[*]${blueColour}$1 ${greenColour}OK\n" >> $HOME/output.txt || /usr/bin/printf "${redColour}[x] $1 is NOT Installed\n" >> $HOME/output.txt
    sudo /usr/bin/apt-get install -f -y >/dev/null 2>>$HOME/error.log
    /usr/bin/sleep 1 && /usr/bin/clear
}

function install(){ #Programs to install
    #Installing Tilix
    aptInstall "Tilix" "tilix"
    /usr/bin/dconf load /com/gexperts/Tilix/ < $HOME/tmp/tilix.dconf ##** Solo peronal!!!!! **##
    sudo /usr/bin/cp $HOME/tmp/tilix.dconf /home/${name_new_user}/tmp/tilix.dconf 2>/dev/null
    #Installing Remmina
    aptInstall "Remmina" "remmina"
    #Installing Parcellite
    aptInstall "Parcellite" "parcellite"
    #Installing Keepass
    aptInstall "KeePass" "keepassxc"
}

function desktop(){
    /usr/bin/printf "${grayColour}Putting my images on your user images folder...\n${yellowColour}"
    /usr/bin/cp $HOME/tmp/${backgroundImage} $HOME/Pictures/${backgroundImage} 2>>$HOME/error.log || /usr/bin/cp $HOME/tmp/${backgroundImage} $HOME/Imágenes/${backgroundImage} 2>>$HOME/error.log
    /usr/bin/cp $HOME/tmp/${terminalImage} $HOME/Pictures/${terminalImage} 2>>$HOME/error.log || /usr/bin/cp $HOME/tmp/${terminalImage} $HOME/Imágenes/${terminalImage} 2>>$HOME/error.log
    /usr/bin/printf "${yellowColour}[!]${grayColour}You can change the tilix background on (Tilix configuration => Appareance => Background image)...\n${blueColour}"
    read -rsn1 -p "Press any key to continue";/usr/bin/echo
    #Copying ip script on PATH
    /usr/bin/printf "${grayColour}Copying ip.sh script on PATH...${yellowColour}(remember you have to put a generic monitor with this script on a desktop panel)\n${blueColour}"
    sudo /usr/bin/cp $HOME/tmp/ip.sh /usr/bin/ip.sh
    sudo /usr/bin/chmod +x /usr/bin/ip.sh
    read -rsn1 -p "Press any key to continue";/usr/bin/echo
}

function hackingTools(){
    #Creating hacking folder
    /usr/bin/printf "${grayColour}Creating this folders...(/opt/tools/fuzzing,bruteForce,activeDirectory,stego,utils/windows)\n${blueColour}"
    sudo /usr/bin/chown $USER:$USER -R /opt/
    /bin/mkdir -p /opt/{fuzzing,bruteForce,activeDirectory,stego,utils/windows}
    /usr/bin/sleep 1 && /usr/bin/clear
    #Installing StegHide (Steganography tool)
    aptInstall "StegHide" "steghide"
    #Installing BloodHound
    /usr/bin/printf "\n${grayColour}Downloading and configuring neo4j for BloodHound...\n${yellowColour}"
    echo "deb http://httpredir.debian.org/debian stretch-backports main" | sudo /usr/bin/tee -a /etc/apt/sources.list.d/stretch-backports.list
    sudo /usr/bin/apt-get update
    /usr/bin/wget -O - https://debian.neo4j.com/neotechnology.gpg.key | sudo apt-key add -
    echo 'deb https://debian.neo4j.com stable 4.0' > /tmp/neo4j.list && sudo /usr/bin/cp /tmp/neo4j.list /etc/apt/sources.list.d/neo4j.list
    sudo /usr/bin/apt-get update
    aptInstall "http-transport" "apt-transport-https"
    aptInstall "neo4j" "neo4j"
    sudo /usr/bin/systemctl stop neo4j
    sudo /usr/bin/systemctl disable neo4j
    /usr/bin/sleep 1 && /usr/bin/clear
    /usr/bin/printf "\n${grayColour}Downloading and configuring BloodHound...\n${yellowColour}"
    /usr/bin/wget ${bloodHound} -O /opt/activeDirectory/BloodHound.zip -q --show-progress
    /usr/bin/unzip /opt/activeDirectory/BloodHound.zip >/dev/null 2>>$HOME/error.log && /usr/bin/printf "${grayColour}[*]${blueColour} BloodHound ${greenColour}OK\n" >> $HOME/output.txt || /usr/bin/printf "${redColour}[x] BloodHound is NOT Installed\n" >> $HOME/output.txt
    /usr/bin/mv BloodHound-linux-x64 /opt/activeDirectory/bloodHound
    /usr/bin/rm /opt/activeDirectory/BloodHound.zip
    sudo /usr/bin/ln -s /opt/activeDirectory/bloodHound/BloodHound /usr/bin/bloodHound
    /usr/bin/sleep 1 && /usr/bin/clear
    #Creating Virtual ENV for Python2
    /usr/bin/printf "\n${grayColour}Downloading and configuring Virtual ENV for Python2...\n${yellowColour}"
    aptInstall "Virtualenv Requirements" "python3-virtualenv"
    /usr/bin/virtualenv -p /usr/bin/python2 /opt/venv >/dev/null 2>>$HOME/error.log && /usr/bin/printf "${grayColour}[*]${blueColour} Virtual ENV ${greenColour}OK\n" >> $HOME/output.txt || /usr/bin/printf "${redColour}[x] Virtual ENV is NOT Installed\n" >> $HOME/output.txt
    /usr/bin/sleep 1 && /usr/bin/clear
    #Installing Sonic Visualizer (On Stego folder)
    /usr/bin/printf "\n${grayColour}Downloading and configuring Sonic Visualizer...\n${yellowColour}"
    /usr/bin/wget ${sonicVisualizer} --no-check-certificate -O /opt/stego/SonicVisualizer.AppImage -q --show-progress
    /usr/bin/chmod +x /opt/stego/SonicVisualizer.AppImage >/dev/null 2>>$HOME/error.log && /usr/bin/printf "${grayColour}[*]${blueColour} Sonic Visualizer ${greenColour}OK\n" >> $HOME/output.txt || /usr/bin/printf "${redColour}[x] Sonic Visualizer is NOT Installed\n" >> $HOME/output.txt
    sudo /usr/bin/ln -s /opt/stego/SonicVisualizer.AppImage /usr/bin/sonicVisualizer
    /usr/bin/sleep 1 && /usr/bin/clear
    #Downloading linpeas for Linux
    /usr/bin/printf "\n${grayColour}Downloading linpeas for Linux...\n${yellowColour}"
    /usr/bin/wget https://raw.githubusercontent.com/carlospolop/PEASS-ng/master/linPEAS/linpeas.sh -O /opt/utils/linpeas -q --show-progress
    /usr/bin/chmod +x /opt/utils/linpeas
    /opt/utils/linpeas -h >/dev/null 2>>$HOME/error.log && /usr/bin/printf "${grayColour}[*]${blueColour} LinPeas ${greenColour}OK\n" >> $HOME/output.txt || /usr/bin/printf "${redColour}[x] LinPeas is NOT Downloaded\n" >> $HOME/output.txt
    /usr/bin/sleep 1 && /usr/bin/clear
    #Downloading pspy (Tool for check Crontab)
    /usr/bin/printf "\n${grayColour}Downloading pspy...\n${yellowColour}"
    /usr/bin/wget ${pspy} -O /opt/utils/pspy -q --show-progress
    /usr/bin/chmod +x /opt/utils/pspy
    /opt/utils/pspy -h >/dev/null 2>>$HOME/error.log && /usr/bin/printf "${grayColour}[*]${blueColour} pspy ${greenColour}OK\n" >> $HOME/output.txt || /usr/bin/printf "${redColour}[x] pspy is NOT Downloaded\n" >> $HOME/output.txt
    /usr/bin/sleep 1 && /usr/bin/clear
    #Unzipping rockyou to /opt/utils
    /usr/bin/printf "\n${grayColour}Unzipping rockyou to /opt/utils...\n${yellowColour}"
    /usr/bin/gunzip -c /usr/share/wordlists/rockyou.txt.gz > /opt/utils/rockyou.txt >/dev/null 2>>$HOME/error.log && /usr/bin/printf "${grayColour}[*]${blueColour} rockyou.txt ${greenColour}OK\n" >> $HOME/output.txt || /usr/bin/printf "${redColour}[x] rockyou.txt is NOT Unzipped\n" >> $HOME/output.txt
    /usr/bin/sleep 1 && /usr/bin/clear
    #Downloading Invoke-Kerberoast
    /usr/bin/printf "\n${grayColour}Downloading Invoke-Kerberoast...\n${yellowColour}"
    /usr/bin/wget https://raw.githubusercontent.com/EmpireProject/Empire/master/data/module_source/credentials/Invoke-Kerberoast.ps1 -O /opt/utils/windows/Invoke-Kerberoast.ps1
    /usr/bin/sleep 1 && /usr/bin/clear
    #Downloading PowerUp.ps1
    /usr/bin/printf "\n${grayColour}Downloading PowerUp...\n${yellowColour}"
    /usr/bin/wget https://raw.githubusercontent.com/PowerShellEmpire/PowerTools/master/PowerUp/PowerUp.ps1 -O /opt/utils/windows/PowerUp.ps1
    /usr/bin/sleep 1 && /usr/bin/clear
    #Downloading winPEAS
    /usr/bin/printf "\n${grayColour}Downloading WinPEAS...\n${yellowColour}"
    /usr/bin/wget https://github.com/carlospolop/PEASS-ng/blob/master/winPEAS/winPEASexe/binaries/x64/Release/winPEASx64.exe -O /opt/utils/winPEAS64.exe
    /usr/bin/sleep 1 && /usr/bin/clear
    #Installing kerbrute
    /usr/bin/printf "\n${grayColour}Downloading and configuring Kerbrute...\n${yellowColour}"
    /usr/bin/git clone https://github.com/TarlogicSecurity/kerbrute.git /opt/activeDirectory/kerbrute
    /usr/bin/pip3 install -r /opt/activeDirectory/kerbrute/requirements.txt
    /usr/bin/python3 /opt/activeDirectory/kerbrute/kerbrute.py -h >/dev/null 2>>$HOME/error.log && /usr/bin/printf "${grayColour}[*]${blueColour} Kerbrute ${greenColour}OK\n" >> $HOME/output.txt || /usr/bin/printf "${redColour}[x] Kerbrute is NOT Installed\n" >> $HOME/output.txt
    /usr/bin/sleep 1 && /usr/bin/clear
    #Installing Furious
    /usr/bin/printf "\n${grayColour}Downloading and configuring Furious...\n${yellowColour}"
    /usr/bin/go get -u github.com/liamg/furious >/dev/null 2>>$HOME/error.log && /usr/bin/printf "${grayColour}[*]${blueColour} Furious ${greenColour}OK\n" >> $HOME/output.txt || /usr/bin/printf "${redColour}[x] Furious is NOT Downloaded\n" >> $HOME/output.txt
    sudo /usr/bin/ln -s ${HOME}/go/bin/furious /usr/bin/furious
    /usr/bin/sleep 1 && /usr/bin/clear
}

function configureTerminal(){
    #Unziping folders and puting all in correct folders
    /bin/mkdir $HOME/.fonts
    /usr/bin/mv  $HOME/tmp/Hack $HOME/.fonts/
    /usr/bin/printf "\n${grayColour}Now we gonna configurate our zsh\n"
    /usr/bin/sleep 1
    #Configuring zsh SHELL
    /usr/bin/printf "\n${yellowColour}[!]${grayColour}Before start, when i open Tilix, you have to put the 'Hack Nerd Font' font on your terminal to configure the zsh correctly\n${blueColour}"
    read -rsn1 -p "Press any key to continue";/usr/bin/echo
    #Copying my zshrc on ur HOME directory
    /usr/bin/printf "\n${grayColour}Copying zshrc on ${USER}, and ROOT...\n${yellowColour}"
    sudo /usr/bin/rm /root/.zshrc || /usr/bin/printf "${redColour}[x] zshrc on ROOT is NOT deleted\n" >> $HOME/output.txt
    /usr/bin/cp $HOME/tmp/zshrc $HOME/.zshrc && /usr/bin/printf "${grayColour}[*]${blueColour}zshrc on ${USER} and ${name_new_user} ${greenColour}OK\n" >> $HOME/output.txt || \
        /usr/bin/printf "${redColour}[x] zshrc on ${USER} and ${name_new_user} is NOT Installed\n" >> $HOME/output.txt
    sudo /usr/bin/ln -s $HOME/.zshrc /root/.zshrc && /usr/bin/printf "${grayColour}[*]${blueColour}zshrc on ROOT ${greenColour}OK\n" \
                                        >> $HOME/output.txt || /usr/bin/printf "${redColour}[x] zshrc on ROOT is NOT Installed\n" >> $HOME/output.txt
    /usr/bin/sleep 1 && /usr/bin/clear
    #Install lsd (Plugin to see better the folders)
    dpkgInstall "LSD" ${lsd} "lsd.deb"
    #Install bat (Plugin to see "cat" better)
    dpkgInstall "BAT" ${bat} "bat.deb"
    /usr/bin/printf "${yellowColour}[!]${grayColour}Opening Tilix...\n${blueColour}"
    /usr/bin/tilix
    read -rsn1 -p "Press any key to continue";/usr/bin/echo
    /usr/bin/sleep 1 && /usr/bin/clear
}

## MAIN ##
#Manage script execution with  privileges
if [ $(id -u) != "0" ]; then
    /usr/bin/clear
    /usr/bin/printf "\t\t${purpleColour}WELCOME to my configurate script for Linux\n\n\t${redColour}Done for ﮊBorb3dﮊ\n\n${blueColour}"
    read -rsn1 -p "Press any key to continue";/usr/bin/echo
    /usr/bin/sleep 2 && /usr/bin/clear
    #Create temporary folder and go in
    if [[ -d "$HOME/tmp" ]]; then
            /usr/bin/mv $HOME/tmp $HOME/tmp2
            /usr/bin/mkdir $HOME/tmp && cd $HOME/tmp #Creating tmp folder and moving in
            /usr/bin/unzip ${zone}/tools.zip -d $HOME/tmp >/dev/null 2>>$HOME/error.log #Unzipping necessary tools
    else
            /usr/bin/mkdir $HOME/tmp && cd $HOME/tmp #Creating tmp folder and moving in
            /usr/bin/unzip ${zone}/tools.zip -d $HOME/tmp >/dev/null 2>>$HOME/error.log #Unzipping necessary tools
    fi
    #Updating system
    /usr/bin/printf "${yellowColour}[!]${purpleColour}Updating system. Please Wait...\n"
    sudo /usr/bin/apt-get update >/dev/null 2>>$HOME/error.log
    sleep 2
    /usr/bin/printf "${yellowColour}[!]${purpleColour}Upgrading system. Please Wait...\n"
    sudo /usr/bin/apt-get upgrade -y >/dev/null 2>>$HOME/error.log
    #Installing requirements for next tools
    requirements
    #Installing basic programs to work
    install
    #Installing themes, icons, fonts...for your cool desktop
    desktop
    #Installing hacking tools
    hackingTools
    #Installing and configuring zsh
    configureTerminal
    #Updating all System and installing dependencies
    /usr/bin/printf "${yellowColour}[!]${purpleColour}Updating system. Please Wait...\n"
    sudo /usr/bin/apt-get update >/dev/null 2>>$HOME/error.log
    /usr/bin/printf "${yellowColour}[!]${purpleColour}Fixing dependencies...\n"
    sudo /usr/bin/apt-get install -f -y >/dev/null 2>>$HOME/error.log
    /usr/bin/printf "${yellowColour}[!]${purpleColour}Upgrading system. Please Wait...\n"
    sudo /usr/bin/apt-get upgrade -y >/dev/null 2>>$HOME/error.log
    #Return to home directory
    cd $HOME
    #Show result of script
    /usr/bin/printf "${grayColour}Showing results of script...\n${yellowColour}[!]${grayColour}If some installation go wrong please, install manually\n\n"
    /usr/bin/cat output.txt
    #Cleaning temporal files ** The "Output.txt" don't be deleted for you interesting **
    /usr/bin/printf "${grayColour}\nCleaning temporary files...\n"
    sudo /usr/bin/rm -r tmp && /usr/bin/printf "${greenColour}DONE\n" || /usr/bin/printf "${redColour}[x]Sorry can't delete all temporary files..."
    #Thanks to use my script
    /usr/bin/printf "${redColour}\nNow i gonna restart the system\n"
    /usr/bin/printf "${redColour}\nThank you for use my script...\n\nﮊBorb3dﮊ\n\n"
    /usr/bin/printf "${grayColour}\nRemember to configurate the Desktop...\n"
    sleep 3
    read -rsn1 -p "Press any key to continue";/usr/bin/echo
    sudo /sbin/reboot
else
    /usr/bin/printf "\n${redColour}This tool can't be executed with root privileges\n\n"
fi

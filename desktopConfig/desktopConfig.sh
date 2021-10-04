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
# Tested on Ubuntu 20.10 & Linux Mint 20.1 & 20.2

## VARIABLES ##
zone=$(pwd)
backgroundImage="wild.png"
terminalImage="pirata1.jpg"

#Programs
chrome="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
vbox="https://download.virtualbox.org/virtualbox/6.1.26/virtualbox-6.1_6.1.26-145957~Ubuntu~eoan_amd64.deb"
vscode="https://az764295.vo.msecnd.net/stable/7f6ab5485bbc008386c4386d08766667e155244e/code_1.60.2-1632313585_amd64.deb"
dbeaver="https://download.dbeaver.com/community/21.2.1/dbeaver-ce_21.2.1_amd64.deb"
bloodHound="https://github.com/BloodHoundAD/BloodHound/releases/download/4.0.3/BloodHound-linux-x64.zip"
burpSuite="https://portswigger.net/burp/releases/download?product=community&version=2021.8.4&type=Linux"
sonicVisualizer="https://code.soundsoftware.ac.uk/attachments/download/2787/SonicVisualiser-4.3-x86_64.AppImage"
pspy="https://github.com/DominicBreuker/pspy/releases/download/v1.2.0/pspy32"
impacket="https://github.com/SecureAuthCorp/impacket/releases/download/impacket_0_9_23/impacket-0.9.23.tar.gz"

#ZSH
lsd="https://github.com/Peltoche/lsd/releases/download/0.19.0/lsd-musl_0.19.0_amd64.deb"
bat="https://github.com/sharkdp/bat/releases/download/v0.17.1/bat_0.17.1_amd64.deb"

## PERSONAL VARIABLES ##
#anydesk="https://download.anydesk.com/linux/anydesk_6.0.1-1_amd64.deb"
#vnc="https://www.realvnc.com/download/file/viewer.files/VNC-Viewer-6.20.529-Linux-x64.deb"

## USAGE AND HELP ##
usage="\n ${redColour}$(basename "$0") ${grayColour}[-h] -- Configure your work desktop (Tested on Ubuntu 20.10 & Linux Mint 20.1 && 20.2).

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
    #Installing GCC (C compilator)
    aptInstall "GCC" "gcc"
    #Installing G++ (C++ compilator)
    aptInstall "G++" "g++"
    #Installing 7z (Archived file tool)
    aptInstall "7z" "p7zip-full"
    #Install Git
    aptInstall "Git" "git"
    #Install Curl
    aptInstall "Curl" "curl"
    #Install Go
    aptInstall "Go" "golang"
    #Install ZSH
    aptInstall "zsh" "zsh"
    #Install xclip
    aptInstall "xClip" "xclip"
    #Install vim
    aptInstall "VIM" "vim"
    #Install Locate
    aptInstall "Locate" "locate"
    #Install Make
    aptInstall "Make" "make"
    #Install libraries
    aptInstall "libgtk-3-dev" "libgtk-3-dev"
    aptInstall "libpolkit-gobject-1-dev" "libpolkit-gobject-1-dev"
    aptInstall "Build-Essential" "build-essential"
    aptInstall "libssl-dev" "libssl-dev"
    aptInstall "zlib1g-dev" "zlib1g-dev"
    aptInstall "yasm" "yasm"
    aptInstall "pkg-config" "pkg-config"
    aptInstall "libgmp-dev" "libgmp-dev"
    aptInstall "libffi-dev" "libffi-dev"
    aptInstall "python-dev" "python-dev"
    aptInstall "libpcap-dev" "libpcap-dev"
    aptInstall "libbz2-dev" "libbz2-dev"
    #If u have Nvidia GPU install this
    aptInstall "nvidia-opencl-dev" "nvidia-opencl-dev"
    #Install pip3
    aptInstall "pip3" "python3-pip"
    #Setting python3 as default
    sudo /usr/bin/update-alternatives --install /usr/bin/python python /usr/bin/python3 1
    #Install python3.8 venv
    aptInstall "python3.8-venv" "python3.8-venv"
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

function sublt3(){
    /usr/bin/wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg 2>>$HOME/error.log | sudo /usr/bin/apt-key add - 2>>$HOME/error.log && \
        sudo /usr/bin/apt-get install -y apt-transport-https 2>>$HOME/error.log && sudo /usr/bin/echo "deb https://download.sublimetext.com/ apt/stable/" | \
        sudo /usr/bin/tee /etc/apt/sources.list.d/sublime-text.list 2>>$HOME/error.log &&  sudo /usr/bin/apt-get update >/dev/null 2>>$HOME/error.log && \
        sudo /usr/bin/apt-get install sublime-text -y >/dev/null 2>>$HOME/error.log && /usr/bin/printf "${grayColour}[*]${blueColour}Sublime Text 3 ${greenColour}OK\n" \
        >> $HOME/output.txt || /usr/bin/printf "${redColour}[x] Sublime Text 3 is NOT Installed\n" >> $HOME/output.txt
    /usr/bin/sleep 1 && /usr/bin/clear
}

function install(){ #Programs to install
    #Installing Google Chrome
    dpkgInstall "Google Chrome" ${chrome} "chrome.deb"
    #Installing VirtualBox
    dpkgInstall "Virtual Box" ${vbox} "vbox.deb"
    /usr/bin/printf "${grayColour}It's possible Virtual Box installation fail, but no problem, the script gonna check dependencies after\n${yellowColour}"
    #Installing vsCode
    dpkgInstall "Visual Studio Code" ${vscode} "vscode.deb"
    #Installing Tilix
    aptInstall "Tilix" "tilix"
    /usr/bin/dconf load /com/gexperts/Tilix/ < $HOME/tmp/tilix.dconf ## This line change Tilix config, prob better get commented for you ##
    sudo /usr/bin/cp $HOME/tmp/tilix.dconf /home/${name_new_user}/tmp/tilix.dconf 2>/dev/null
    #Installing Remmina
    aptInstall "Remmina" "remmina"
    #Installing Dbeaver
    dpkgInstall "Dbeaver" ${dbeaver} "dbeaver.deb"
    #Installing Parcellite
    aptInstall "Parcellite" "parcellite"
    #Installing Keepass
    aptInstall "KeePass" "keepassxc"
    #Installing cool Screen Locker
    aptInstall "Screen Locker" "i3lock-fancy"
}

function desktop(){
    #Unziping folders and puting all in correct folders
    /bin/mkdir $HOME/{".themes",".icons",".fonts"}
    /usr/bin/unzip $HOME/tmp/theme.zip -d $HOME/.themes
    /usr/bin/unzip $HOME/tmp/icons.zip -d $HOME/.icons
    /usr/bin/unzip $HOME/tmp/gnomeTheme.zip -d $HOME/.themes
    /usr/bin/unzip $HOME/tmp/Hack.zip -d $HOME/.fonts
    /usr/bin/printf "${grayColour}I put all you need to configure desktop in correct folders\n${yellowColour}"
    #Moving my images to your user images folder, you must to configurate after
    /usr/bin/printf "${grayColour}Putting my images on your user images folder...\n${yellowColour}"
    /usr/bin/cp $HOME/tmp/${backgroundImage} $HOME/Pictures/${backgroundImage} 2>>$HOME/error.log || /usr/bin/cp $HOME/tmp/${backgroundImage} $HOME/Imágenes/${backgroundImage} 2>>$HOME/error.log
    /usr/bin/cp $HOME/tmp/${terminalImage} $HOME/Pictures/${terminalImage} 2>>$HOME/error.log || /usr/bin/cp $HOME/tmp/${terminalImage} $HOME/Imágenes/${terminalImage} 2>>$HOME/error.log
    /usr/bin/printf "${yellowColour}[!]${grayColour}You can change the tilix background on (Tilix configuration => Appareance => Background image)...\n${blueColour}"
    read -rsn1 -p "Press any key to continue";/usr/bin/echo
}

function newUser(){
    sudo /bin/mkdir /home/$1
    sudo /usr/sbin/useradd -d /home/$1 -s /bin/bash $1
    sudo /usr/bin/passwd $1
    sudo /usr/bin/chown -R $1:$1 /home/$1
    sudo /usr/sbin/usermod -aG sudo $1
}

function hackingTools(){
    #Creating hacking folder
    /usr/bin/printf "${grayColour}Creating this folders...(/opt/tools/fuzzing,bruteForce,activeDirectory,stego,utils/windows)\n${blueColour}"
    sudo /usr/bin/chown $USER:$USER -R /opt/
    /bin/mkdir -p /opt/{fuzzing,bruteForce,activeDirectory,stego,utils/windows}
    #Installing NMAP
    /usr/bin/sleep 1 && /usr/bin/clear
    aptInstall "Nmap" "nmap"
    #Installing ffuf (Fuzzing tool in GO)
    /usr/bin/printf "\n${grayColour}Downloading and configuring ffuf...\n${yellowColour}"
    sudo /usr/bin/git -C /opt/fuzzing/ clone https://github.com/ffuf/ffuf ; cd /opt/fuzzing/ffuf ; sudo /usr/bin/go get ; \
                    sudo /usr/bin/go build; cd .. && /usr/bin/printf "${grayColour}[*]${blueColour}ffuf ${greenColour}OK\n" >> $HOME/output.txt || \
                    /usr/bin/printf "${redColour}[x] ffuf is NOT Installed\n" >> $HOME/output.txt
    sudo /usr/bin/ln -s /opt/fuzzing/ffuf/ffuf /usr/bin/ffuf
    sudo /usr/bin/chmod +x /usr/bin/ffuf
    /usr/bin/sleep 1 && /usr/bin/clear
    #Installing searchsploit (Exploit database)
    /usr/bin/printf "\n${grayColour}Downloading and configuring Searchsploit...\n${yellowColour}"
    /usr/bin/git clone https://github.com/offensive-security/exploitdb.git /opt/exploit-database
    sudo /usr/bin/ln -sf /opt/exploit-database/searchsploit /usr/bin/searchsploit
    /usr/bin/sleep 1 && /usr/bin/clear
    #Installing hydra (Brute-Force tool)
    aptInstall "Hydra" "hydra"
    #Installing John The Ripper (Brute-Force tool)
    /usr/bin/printf "\n${grayColour}Downloading and configuring John The Ripper...\n${yellowColour}"
    /usr/bin/git clone https://github.com/openwall/john.git /opt/bruteForce/john
    cd /opt/bruteForce/john/src
    sudo ./configure && sudo /usr/bin/make -s clean && sudo /usr/bin/make -sj4
    sudo /usr/bin/ln -s /opt/bruteForce/john/run/john /usr/bin/john
    /usr/bin/john >/dev/null 2>>$HOME/error.log && /usr/bin/printf "${grayColour}[*]${blueColour} John The Ripper ${greenColour}OK\n" >> $HOME/output.txt || /usr/bin/printf "${redColour}[x] John The Ripper is NOT Installed\n" >> $HOME/output.txt
    cd $HOME/tmp/
    /usr/bin/sleep 1 && /usr/bin/clear
    #Installing HashCat (Brute-Force tool)
    aptInstall "HashCat" "hashcat"
    #Installing BinWalk ("Steganography and more" Tool)
    aptInstall "BinWalk" "binwalk"
    #Installing StegHide (Steganography tool)
    aptInstall "StegHide" "steghide"
    #Installing HashID (For identify hashes)
    aptInstall "HashID" "hashid"
    #Installing hash-Identifier (For identify hashes like hashid)
    sudo /usr/bin/wget https://raw.githubusercontent.com/blackploit/hash-identifier/master/hash-id.py -O /opt/utils/hash-id.py -q --show-progress
    #Installing Metasploit-Framework
    /usr/bin/printf "\n${grayColour}Downloading and configuring Metasploit-Framework...\n${yellowColour}"
    /usr/bin/curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && \
        sudo /usr/bin/chmod 755 msfinstall && /usr/bin/printf "\n${grayColour}Be patience, this gonna take a time...\n${yellowColour}" && \
        sudo ./msfinstall 2>>$HOME/error.log && /usr/bin/printf "${grayColour}[*]${blueColour}Metasploit-Framework ${greenColour}OK\n" >> $HOME/output.txt || \
        /usr/bin/printf "${redColour}[x] Metasploit-Framework is NOT Installed\n" >> $HOME/output.txt
    sudo /usr/bin/apt-get install -f -y >/dev/null 2>>$HOME/error.log
    mainHome=$HOME
    /usr/bin/sleep 1 && /usr/bin/clear
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
    #Installing Responder
    /usr/bin/printf "\n${grayColour}Downloading and configuring Responder...\n${yellowColour}"
    /usr/bin/git clone https://github.com/lgandx/Responder.git /opt/activeDirectory/Responder
    sudo /usr/bin/ln -s /opt/activeDirectory/Responder/Responder.py /usr/bin/responder
    /usr/bin/responder -h >/dev/null 2>>$HOME/error.log && /usr/bin/printf "${grayColour}[*]${blueColour} Responder ${greenColour}OK\n" >> $HOME/output.txt || /usr/bin/printf "${redColour}[x] Responder is NOT Installed\n" >> $HOME/output.txt
    /usr/bin/sleep 1 && /usr/bin/clear
    #Installing Burp Suite
    /usr/bin/printf "\n${grayColour}Downloading and configuring Burp Suite Community...\n${yellowColour}"
    /usr/bin/wget ${burpSuite} -O /tmp/burp.sh -q --show-progress && /usr/bin/printf "${grayColour}[*]${blueColour} BurpSuite ${greenColour}OK\n" >> $HOME/output.txt || /usr/bin/printf "${redColour}[x] BurpSuite is NOT Installed\n" >> $HOME/output.txt
    /usr/bin/bash /tmp/burp.sh 
    /usr/bin/rm /tmp/burp.sh
    /usr/bin/sleep 1 && /usr/bin/clear
    #Installing Impacket
    /usr/bin/printf "\n${grayColour}Downloading and configuring Impacket...\n${yellowColour}"
    /usr/bin/wget $impacket -O /tmp/impacket.tar.gz -q --show-progress
    /usr/bin/tar xf /tmp/impacket.tar.gz -C /tmp/
    /usr/bin/python3 -m pip install /tmp/$(echo $impacket | cut -d "/" -f 9 | sed 's/.tar.gz//g') >/dev/null 2>>$HOME/error.log && /usr/bin/printf "${grayColour}[*]${blueColour} Impacket ${greenColour}OK\n" >> $HOME/output.txt || /usr/bin/printf "${redColour}[x] Impacket is NOT Installed\n" >> $HOME/output.txt
    /usr/bin/sleep 1 && /usr/bin/clear
    #Installing CrackMapExec
    /usr/bin/printf "\n${grayColour}Configurin CrackMapExec ('cme' to use)...\n${yellowColour}"
    /usr/bin/python3 -m pip install crackmapexec >/dev/null 2>>$HOME/error.log && /usr/bin/printf "${grayColour}[*]${blueColour} CrackMapExec ${greenColour}OK\n" >> $HOME/output.txt || /usr/bin/printf "${redColour}[x] CrackMapExec is NOT Installed\n" >> $HOME/output.txt
    sudo /usr/bin/ln -s $HOME/.local/lib/python3.8/site-packages/cme/crackmapexec.py /usr/bin/cme
    #Installing enum4linux
    /usr/bin/printf "\n${grayColour}Downloading and configuring enum4linux...\n${yellowColour}"
    /usr/bin/git clone https://github.com/CiscoCXSecurity/enum4linux.git /opt/enum4linux
    sudo /usr/bin/ln -s /opt/enum4linux/enum4linux.pl /usr/bin/enum4linux
    /usr/bin/enum4linux -h >/dev/null 2>>$HOME/error.log && /usr/bin/printf "${grayColour}[*]${blueColour} Enum4Linux ${greenColour}OK\n" >> $HOME/output.txt || /usr/bin/printf "${redColour}[x] Enum4Linux is NOT Installed\n" >> $HOME/output.txt
    /usr/bin/sleep 1 && /usr/bin/clear
    #Creating Virtual ENV for Python2
    /usr/bin/printf "\n${grayColour}Downloading and configuring Virtual ENV for Python2...\n${yellowColour}"
    aptInstall "Virtualenv Requirements" "python3-virtualenv"
    /usr/bin/virtualenv -p /usr/bin/python2 /opt/venv >/dev/null 2>>$HOME/error.log && /usr/bin/printf "${grayColour}[*]${blueColour} Virtual ENV ${greenColour}OK\n" >> $HOME/output.txt || /usr/bin/printf "${redColour}[x] Virtual ENV is NOT Installed\n" >> $HOME/output.txt
    /usr/bin/sleep 1 && /usr/bin/clear
    #Installing smbmap
    aptInstall "smbmap" "smbmap"
    #Installing Sonic Visualizer (On Stego folder)
    /usr/bin/printf "\n${grayColour}Downloading and configuring Sonic Visualizer...\n${yellowColour}"
    /usr/bin/wget ${sonicVisualizer} --no-check-certificate -O /opt/stego/SonicVisualizer.AppImage -q --show-progress
    sudo /usr/bin/ln -s /opt/stego/SonicVisualizer.AppImage /usr/bin/sonicVisualizer
    /usr/bin/chmod +x /opt/stego/SonicVisualizer.AppImage >/dev/null 2>>$HOME/error.log && /usr/bin/printf "${grayColour}[*]${blueColour} Sonic Visualizer ${greenColour}OK\n" >> $HOME/output.txt || /usr/bin/printf "${redColour}[x] Sonic Visualizer is NOT Installed\n" >> $HOME/output.txt
    /usr/bin/sleep 1 && /usr/bin/clear
    #Clonnig SecList repository
    /usr/bin/printf "\n${grayColour}Downloading SecLists repository...\n${yellowColour}"
    /usr/bin/git clone https://github.com/danielmiessler/SecLists.git /opt/utils/secLists
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
    /usr/bin/tar -xf /opt/utils/secLists/Passwords/Leaked-Databases/rockyou.txt.tar.gz -C /opt/utils/ >/dev/null 2>>$HOME/error.log && /usr/bin/printf "${grayColour}[*]${blueColour} rockyou.txt ${greenColour}OK\n" >> $HOME/output.txt || /usr/bin/printf "${redColour}[x] rockyou.txt is NOT Unzipped\n" >> $HOME/output.txt
    /usr/bin/sleep 1 && /usr/bin/clear
    #Download Socat
    /usr/bin/printf "\n${grayColour}Downloading Socat for Linux...\n${yellowColour}"
    /usr/bin/wget https://github.com/3ndG4me/socat/releases/download/v1.7.3.3/socatx64.bin -O /opt/utils/socat -q --show-progress
    /usr/bin/chmod +x /opt/utils/socat
    /opt/utils/socat -h >/dev/null 2>>$HOME/error.log && /usr/bin/printf "${grayColour}[*]${blueColour} Socat ${greenColour}OK\n" >> $HOME/output.txt || /usr/bin/printf "${redColour}[x] Socat is NOT Downloaded\n" >> $HOME/output.txt
    /usr/bin/sleep 1 && /usr/bin/clear
    #Clonning kali-windows-binaries repository
    /usr/bin/printf "\n${grayColour}Downloading kali-windows-binaries repository...\n${yellowColour}"
    /usr/bin/git clone https://github.com/interference-security/kali-windows-binaries.git /opt/utils/windows/windows-binaries
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

function body(){
    /usr/bin/sleep 1 && /usr/bin/clear
    /usr/bin/printf "\n"
    read -p "¿Are you sure about install Hacking Tools?: (y/n) " sure
    if [ "$sure" = "y" ] || [ "$sure" = "Y" ]; then
        /usr/bin/printf "\n"
        read -p "Do you want create a new user for the hacking tools?: (y/n) " user
        if [ "$user" = "y" ] || [ "$user" = "Y" ]; then
            /usr/bin/printf "\n"
            read -p "¿What's the name of the new user?: " name_new_user
            #Creating new user for hacking tools
            newUser $name_new_user
            #Now i gonna install the hacking tools
            mainHome="/home/${name_new_user}"
            hackingTools
            configureNewUser
            /usr/bin/printf "\n${grayColour}You must to configurate the extensions on this new user aswell...\nYou have a script on the same repo with only the shell extensions config.${yellowColour}"
        elif [ "$user" = "n" ] || [ "$user" = "N" ]; then 
            cd $HOME
            mainHome="/home/$USER"
            hackingTools
        else
            /usr/bin/printf "Don't understand your response..."
            body
        fi
    elif [ "$sure" = "n" ] || [ "$sure" = "N" ]; then
        /usr/bin/sleep 1
        :
    else
        /usr/bin/printf "Don't understand your response..."
        body
    fi
}

function configureNewUser(){
    #Moving my images to your user images folder, you must to configurate after
    /usr/bin/printf "${grayColour}Putting my images on your user images folder...\n${yellowColour}"
    sudo /usr/bin/cp $HOME/tmp/${backgroundImage} /home/${name_new_user}/Pictures/${backgroundImage} 2>>$HOME/error.log || /usr/bin/cp $HOME/tmp/${backgroundImage} /home/${name_new_user}/Imágenes/${backgroundImage} 2>>$HOME/error.log
    sudo /usr/bin/cp $HOME/tmp/${terminalImage} /home/${name_new_user}/Pictures/${terminalImage} 2>>$HOME/error.log || /usr/bin/cp $HOME/tmp/${terminalImage} /home/${name_new_user}/Imágenes/${terminalImage} 2>>$HOME/error.log
    /usr/bin/printf "${yellowColour}[!]${grayColour}You can change the tilix background on (Tilix configuration => Appareance => Background image)...\n${blueColour}"
    read -rsn1 -p "Press any key to continue";/usr/bin/echo
    #Unziping folders and puting all in correct folders
    sudo /bin/mkdir /home/${name_new_user}/{".themes",".icons",".fonts","tmp"}
    sudo /usr/bin/unzip $HOME/tmp/theme.zip -d /home/${name_new_user}/.themes
    sudo /usr/bin/unzip $HOME/tmp/icons.zip -d /home/${name_new_user}/.icons
    sudo /usr/bin/unzip $HOME/tmp/gnomeTheme.zip -d /home/${name_new_user}/.themes
    sudo /usr/bin/unzip $HOME/tmp/Hack.zip -d /home/${name_new_user}/.fonts
    /usr/bin/printf "${grayColour}I put all you need to configure desktop in correct folders\n${yellowColour}[!]Now you have to configure all on Tweak Tool\n${blueColour}"
    read -rsn1 -p "Press any key to continue";/usr/bin/echo
}

function configureTerminal(){
    /usr/bin/printf "\n${grayColour}Now we gonna configurate our zsh\n"
    /usr/bin/sleep 1
    #Configuring zsh SHELL
    /usr/bin/printf "\n${yellowColour}[!]${grayColour}Before start, when i open Tilix, you have to put the 'Hack Nerd Font' font on your terminal to configure the zsh correctly\n${blueColour}"
    read -rsn1 -p "Press any key to continue";/usr/bin/echo
    #Configurate zsh config and p10k for users and root
    /usr/bin/printf "\n${grayColour}Copying zshrc on ${USER}, ${name_new_user}, and ROOT...\n${yellowColour}"
    /usr/bin/cp $HOME/tmp/zshrc $HOME/.zshrc && sudo /usr/bin/ln -s $HOME/.zshrc /home/${name_new_user}/.zshrc && \
        /usr/bin/printf "${grayColour}[*]${blueColour}zshrc on ${USER} and ${name_new_user} ${greenColour}OK\n" >> $HOME/output.txt || \
        /usr/bin/printf "${redColour}[x] zshrc on ${USER} and ${name_new_user} is NOT Installed\n" >> $HOME/output.txt
    sudo /usr/bin/ln -s $HOME/.zshrc /root/.zshrc && /usr/bin/printf "${grayColour}[*]${blueColour}zshrc on ROOT ${greenColour}OK\n" \
                                        >> $HOME/output.txt || /usr/bin/printf "${redColour}[x] zshrc on ROOT is NOT Installed\n" >> $HOME/output.txt
    /usr/bin/sleep 1 && /usr/bin/clear
    #Install lsd (Plugin to see better the folders)
    dpkgInstall "LSD" ${lsd} "lsd.deb"
    #Install bat (Plugin to see "cat" better)
    dpkgInstall "BAT" ${bat} "bat.deb"
    #Install zsh-autosuggestions (Plugin to autocomplete commands)
    aptInstall "ZSH-Autosuggestions" "zsh-autosuggestions"
    sudo /bin/chown $USER:$USER -R /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh && /usr/bin/printf "${greenColour}DONE\n"
    sudo /bin/chown $name_new_user:$name_new_user -R /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh && /usr/bin/printf "${greenColour}DONE\n"
    /usr/bin/sleep 1 && /usr/bin/clear
    #Install zsh-syntax-highlighting (Plugin to colour correct or incorrect commands)
    aptInstall "ZSH-Syntax-Highlighting" "zsh-syntax-highlighting"
    sudo /bin/chown $USER:$USER -R /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh && /usr/bin/printf "${greenColour}DONE\n"
    sudo /bin/chown $name_new_user:$name_new_user -R /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh && /usr/bin/printf "${greenColour}DONE\n"
    /usr/bin/sleep 1 && /usr/bin/clear
    #Putting ZSH a Default SHELL on your system for users
    /usr/bin/printf "${grayColour}Configuring zsh for a default shell on your system...\n${yellowColour}"
    sudo /usr/sbin/usermod -s "/usr/bin/zsh" $USER && /usr/bin/printf "${greenColour}DONE\n" || /usr/bin/printf "${redColour}[x]Sorry can't put zsh for ${USER}..."
    sudo /usr/sbin/usermod -s "/usr/bin/zsh" $name_new_user && /usr/bin/printf "${greenColour}DONE\n" || /usr/bin/printf "${redColour}[x]Sorry can't put zsh for ${name_new_user}..."
    sudo /usr/sbin/usermod -s "/usr/bin/zsh" root && /usr/bin/printf "${greenColour}DONE\n" || /usr/bin/printf "${redColour}[x]Sorry can't put zsh for root..."
    /usr/bin/sleep 1 && /usr/bin/clear
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
    #Installing 3 requirements for next tools
    requirements
    #Installing basic programs to work
    install
    #Only for me
    #personalInstall
    #Installing extensions for the desktop aspect, maybe you must to configurate some extension after...
    #extensions
    #Installing themes, icons, fonts...for your cool desktop
    desktop
    #Installing new user or not and hacking tools
    body
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
    /usr/bin/printf "${grayColour}\nRemember to configurate the Desktop...Saved on end of output.txt\n"
    /usr/bin/printf "\n\tCommand Runner (For ip.sh Script)\n\tThemes\n\t\t1. Arc-Darkest-3.36\n\t\t2. Mint-Y-Dark-Aqua\n\t\t3. Mint-T-Dark-Aqua\n\t\t4. DMZ-Red\n\t\t5. Arc-Darkest-3.36" >> $HOME/output.txt
    sleep 3
    read -rsn1 -p "Press any key to continue";/usr/bin/echo
    sudo /sbin/reboot
else
    /usr/bin/printf "\n${redColour}This tool can't be executed with root privileges\n\n"
fi

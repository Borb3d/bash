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
# Tested on Ubuntu 20.10

## VARIABLES ##
zone=$(pwd)
backgroundImage="wild.png"
terminalImage="pirata1.jpg"

#Programs
chrome="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
vbox="https://download.virtualbox.org/virtualbox/6.1.16/virtualbox-6.1_6.1.16-140961~Ubuntu~eoan_amd64.deb"
vscode="https://go.microsoft.com/fwlink/?LinkID=760868"
dbeaver="https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb"

#ZSH
lsd="https://github.com/Peltoche/lsd/releases/download/0.19.0/lsd-musl_0.19.0_amd64.deb"
bat="https://github.com/sharkdp/bat/releases/download/v0.17.1/bat_0.17.1_amd64.deb"

## USAGE AND HELP ##
usage="\n ${redColour}$(basename "$0") ${grayColour}[-h] -- Configure your work desktop (Tested on Ubuntu 20.10).

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
    /usr/bin/printf "\n${yellowColour}Fixing dependencies, please wait for exit...\n${greenColour}"
    sleep 2
    sudo /usr/bin/dpkg --configure -a
    sudo /usr/bin/apt-get install -f -y
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
    aptInstall "libpcap-dev" "libpcap-dev"
    aptInstall "libbz2-dev" "libbz2-dev"
    #If u have Nvidia GPU install this
    aptInstall "nvidia-opencl-dev" "nvidia-opencl-dev"
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
    #Installing SublimeText3
    /usr/bin/printf "${grayColour}Downloading and configuring Sublime Text 3...\n${yellowColour}"
    /usr/bin/sleep 2
    sublt3
    #Installing Tilix
    aptInstall "Tilix" "tilix"
    #Installing Remmina
    aptInstall "Remmina" "remmina"
    #Installing Dbeaver
    dpkgInstall "Dbeaver" ${dbeaver} "dbeaver.deb"
    #Installing Parcellite
    aptInstall "Parcellite" "parcellite"
    #Installing cool Screen Locker
    aptInstall "Screen Locker" "i3lock-fancy"
}

function configureExt(){
    /usr/bin/printf "\n${yellowColour}[!]${grayColour}Installing extension $1..."
    gnome-extensions install $2 -f 2>>$HOME/error.log
    sudo /usr/bin/cp $2 /home/${name_new_user}/tmp/
    /usr/bin/sleep 1 && /usr/bin/clear
}

function extensions(){ #Function for config my desktop
    #Installing Tweak Tools on we Desktop
    aptInstall "Gnome-Shell Tweak Tool" "gnome-shell-extensions"
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

    #Installing SysMonitor
    /usr/bin/clear
    /usr/bin/printf "${grayColour}Adding repository necesary to install 'SysMonitor' $1...\n${yellowColour}"
    sudo /usr/bin/add-apt-repository ppa:fossfreedom/indicator-sysmonitor
    /usr/bin/sleep 1 && /usr/bin/clear
    sudo /usr/bin/apt-get update && aptInstall "SysMonitor" "indicator-sysmonitor"
    #Configurate SysMonitor
    /usr/bin/printf "\n\n${redColour}I put the ip.sh script on /usr/bin. Now you must to configurate 'SysMonitor'...\n${blueColour}"
    read -rsn1 -p "Press any key to continue";/usr/bin/echo
    sudo /usr/bin/cp $HOME/tmp/ip.sh /usr/bin/ip.sh #Moving script to correctly folder
    sudo /usr/bin/chmod +x /usr/bin/ip.sh #Add execution privilege to sysmonitor manage
    /usr/bin/cp -r $HOME/tmp/.config $HOME/.config #Moving .config directory to user Home
    /usr/bin/cp -r $HOME/tmp/.indicator-sysmonitor.json $HOME/.indicator-sysmonitor.json #Moving sysmonitor configuration to user Home
    /usr/bin/sleep 1
    /usr/bin/printf "\n${greenColour}DONE\n"
}

function desktop(){
    #Unziping folders and puting all in correct folders
    /bin/mkdir $HOME/{".themes",".icons",".fonts"}
    /usr/bin/unzip $HOME/tmp/theme.zip -d $HOME/.themes
    /usr/bin/unzip $HOME/tmp/icons.zip -d $HOME/.icons
    /usr/bin/unzip $HOME/tmp/gnomeTheme.zip -d $HOME/.themes
    /usr/bin/unzip $HOME/tmp/Hack.zip -d $HOME/.fonts
    /usr/bin/printf "${grayColour}I put all you need to configure desktop in correct folders\n${yellowColour}[!]Now you have to configure all on Tweak Tool"
    #Open Tweak Tools to configurate
    aptInstall "Gnome-Tweaks" "gnome-tweaks"
    /usr/bin/printf "\n${redColour}Opening...\n${blueColour}"
    /usr/bin/gnome-tweaks >/dev/null 2>>$HOME/error.log
    read -rsn1 -p "Press any key to continue";/usr/bin/echo
    #Moving my images to your user images folder, you must to configurate after
    /usr/bin/printf "${grayColour}Putting my images on your user images folder...\n${yellowColour}"
    /usr/bin/cp $HOME/tmp/${backgroundImage} $HOME/Pictures/${backgroundImage} 2>>$HOME/error.log || /usr/bin/cp $HOME/tmp/${backgroundImage} $HOME/Imágenes/${backgroundImage} 2>>$HOME/error.log
    /usr/bin/cp $HOME/tmp/${terminalImage} $HOME/Pictures/${terminalImage} 2>>$HOME/error.log || /usr/bin/cp $HOME/tmp/${terminalImage} $HOME/Imágenes/${terminalImage} 2>>$HOME/error.log
    /usr/bin/printf "${yellowColour}[!]${grayColour}You can change the tilix background on (Tilix configuration => Appareance => Background image)...\n${blueColour}"
    read -rsn1 -p "Press any key to continue";/usr/bin/echo
    #Install gdm-brackground (For change background image for Login Page)
    /usr/bin/printf "${grayColour}Downloading and configuring gdm-background...\n"
    git clone https://github.com/thiggy01/gdm-background.git
    cd gdm-background/
    /usr/bin/make
    sudo /usr/bin/make install
    /usr/bin/printf "\n${grayColour}Now i gonna open the program, you must to put your image on the program, so easy...\n${blueColour}"
    sleep 2
    /usr/local/bin/gdm-background
    read -rsn1 -p "Press any key to continue";/usr/bin/echo
    sudo /usr/bin/make uninstall
}

function newUser(){ #Function to create a new user if you select this option
    sudo /bin/mkdir /home/$1
    sudo /usr/sbin/useradd -d /home/$1 -s /bin/bash $1
    sudo /usr/bin/passwd $1
    sudo /usr/bin/chown -R $1:$1 /home/$1
    sudo /usr/sbin/usermod -aG sudo $1
}

function hackingTools(){
    #Creating hacking folder
    /usr/bin/printf "${grayColour}Creating this folders...(/opt/tools/fuzzing)\n${blueColour}"
    sudo /bin/mkdir -p ${mainHome}/hacking/fuzzing
    sudo /bin/mkdir -p ${mainHome}/hacking/bruteForce
    #Installing NMAP
    /usr/bin/sleep 1 && /usr/bin/clear
    aptInstall "Nmap" "nmap"
    #Installing ffuf (Fuzzing tool in GO)
    /usr/bin/printf "\n${grayColour}Downloading and configuring ffuf...\n${yellowColour}"
    sudo /usr/bin/git -C ${mainHome}/hacking/fuzzing/ clone https://github.com/ffuf/ffuf ; cd ${mainHome}/hacking/fuzzing/ffuf ; sudo /usr/bin/go get ; \
                    sudo /usr/bin/go build; cd .. && /usr/bin/printf "${grayColour}[*]${blueColour}ffuf ${greenColour}OK\n" >> $HOME/output.txt || \
                    /usr/bin/printf "${redColour}[x] ffuf is NOT Installed\n" >> $HOME/output.txt
    sudo /usr/bin/ln -s ${mainHome}/hacking/fuzzing/ffuf/ffuf /usr/bin/ffuf
    sudo /usr/bin/chmod +x /usr/bin/ffuf
    /usr/bin/sleep 1 && /usr/bin/clear
    #Installing Dirsearch (Fuzzing tool in Python)
    /usr/bin/printf "\n${grayColour}Downloading and configuring Dirsearch...\n${yellowColour}"
    sudo /usr/bin/git -C ${mainHome}/hacking/fuzzing/ clone https://github.com/maurosoria/dirsearch.git
    sudo /usr/bin/ln -s ${mainHome}/hacking/fuzzing/dirsearch/dirsearch.py /usr/bin/dirsearch
    sudo /usr/bin/chmod +x /usr/bin/dirsearch
    cd $HOME/tmp/
    /usr/bin/sleep 1 && /usr/bin/clear
    #Installing searchsploit (Exploit database)
    /usr/bin/printf "\n${grayColour}Downloading and configuring Searchsploit...\n${yellowColour}"
    sudo /usr/bin/git clone https://github.com/offensive-security/exploitdb.git /opt/exploit-database
    sudo /usr/bin/ln -sf /opt/exploit-database/searchsploit /usr/bin/searchsploit
    #Installing hydra (Brute-Force tool)
    aptInstall "Hydra" "hydra"
    #Installing John The Ripper (Brute-Force tool)
    /usr/bin/printf "\n${grayColour}Downloading and configuring John The Ripper...\n${yellowColour}"
    sudo /usr/bin/git clone https://github.com/openwall/john.git ${mainHome}/hacking/bruteForce/john
    cd ${mainHome}/hacking/bruteForce/john
    sudo ./configure && sudo /usr/bin/make -s clean && sudo /usr/bin/make -sj4
    cd $HOME/tmp/
    /usr/bin/printf "\n${yellowColour}[!]Now you must to create on your zshrc an alias for execute JohnTheRipper from the path...\n${blueColour}"
    read -rsn1 -p "Press any key to continue";/usr/bin/echo
    #Installing HashCat (Brute-Force tool)
    aptInstall "HashCat" "hashcat"
    #Installing BinWalk ("Steganography and more" Tool)
    aptInstall "BinWalk" "binwalk"
    #Installing StegHide (Steganography tool)
    aptInstall "StegHide" "steghide"
    #Installing HashID (For identify hashes)
    aptInstall "HashID" "hashid"
    #Installing Metasploit-Framework
    /usr/bin/printf "\n${grayColour}Downloading and configuring Metasploit-Framework...\n${yellowColour}"
    curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && \
        sudo /usr/bin/chmod 755 msfinstall && /usr/bin/printf "\n${grayColour}Be patience, this gonna take a time...\n${yellowColour}" && \
        sudo ./msfinstall 2>>$HOME/error.log && /usr/bin/printf "${grayColour}[*]${blueColour}Metasploit-Framework ${greenColour}OK\n" >> $HOME/output.txt || \
        /usr/bin/printf "${redColour}[x] Metasploit-Framework is NOT Installed\n" >> $HOME/output.txt
    sudo /usr/bin/apt-get install -f -y >/dev/null 2>>$HOME/error.log
    mainHome=$HOME
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
    #Install powerlevel10k aspect for zsh
    /usr/bin/printf "\n${grayColour}Downloading and configuring PowerLevel10k...\n${yellowColour}"
    /usr/bin/git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/powerlevel10k
    sudo /usr/bin/git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /home/${name_new_user}/powerlevel10k
    sudo /usr/bin/git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/powerlevel10k
    #Configurate zsh config and p10k for users and root
    /usr/bin/printf "\n${grayColour}Copying zshrc and p10k on ${USER}, ${name_new_user}, and ROOT...\n${yellowColour}"
    /usr/bin/cp $HOME/tmp/zshrc $HOME/.zshrc && sudo /usr/bin/ln -s $HOME/.zshrc /home/${name_new_user}/.zshrc && \
        /usr/bin/printf "${grayColour}[*]${blueColour}zshrc on ${USER} and ${name_new_user} ${greenColour}OK\n" >> $HOME/output.txt || \
        /usr/bin/printf "${redColour}[x] zshrc on ${USER} and ${name_new_user} is NOT Installed\n" >> $HOME/output.txt
    sudo /usr/bin/ln -s $HOME/.zshrc /root/.zshrc && /usr/bin/printf "${grayColour}[*]${blueColour}zshrc on ROOT ${greenColour}OK\n" \
                                        >> $HOME/output.txt || /usr/bin/printf "${redColour}[x] zshrc on ROOT is NOT Installed\n" >> $HOME/output.txt
    echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
    /usr/bin/cp $HOME/tmp/p10k.zsh $HOME/.p10k.zsh \
        && /usr/bin/printf "${grayColour}[*]${blueColour} p10k on ${USER} ${greenColour}OK\n" >> $HOME/output.txt || \
        /usr/bin/printf "${redColour}[x] p10k on ${USER} is NOT Installed\n" >> $HOME/output.txt
    sudo /usr/bin/cp $HOME/tmp/p10k.zsh /home/${name_new_user}/.p10k.zsh \
        && /usr/bin/printf "${grayColour}[*]${blueColour} p10k on ${name_new_user} ${greenColour}OK\n" >> $HOME/output.txt || \
        /usr/bin/printf "${redColour}[x] p10k on ${name_new_user} is NOT Installed\n" >> $HOME/output.txt
    sudo /usr/bin/cp "$HOME/tmp/p10k.zsh(root)" /root/.p10k.zsh && /usr/bin/printf "${grayColour}[*]${blueColour}p10k on ROOT ${greenColour}OK\n" \
                                        >> $HOME/output.txt || /usr/bin/printf "${redColour}[x] p10k on ROOT is NOT Installed\n" >> $HOME/output.txt
    /usr/bin/sleep 1 && /usr/bin/clear
    #Install lsd (Plugin to see better the folders)
    dpkgInstall "LSD" ${lsd} "lsd.deb"
    #Install bat (Plugin to see "cat" better)
    dpkgInstall "BAT" ${bat} "bat.deb"
    #Install fzf (Plugin to put a Finder on terminal)
    /usr/bin/printf "\n${yellowColour}[!]${grayColour}Now we gonna configurate fzf (Finder for a terminal).Use 'ctrl+t' for open the Finder. \n
                        You must to configure all users you gonna use (current, newest and root) \nI gonna put the command on your clipboard and open a Tilix terminal.\n
                        You have to put the terminal and configurate like now\n
                        Configurating fzf on current user...\n"
    /usr/bin/git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf; ~/.fzf/install \
        && /usr/bin/printf "${grayColour}[*]${blueColour} fzf on ${USER} ${greenColour}OK\n" >> $HOME/output.txt || \
        /usr/bin/printf "${redColour}[x] fzf on ${USER} is NOT Installed\n" >> $HOME/output.txt
    /usr/bin/echo "/usr/bin/git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf; ~/.fzf/install" | xclip -selection clipboard -rmlastnl
    /usr/bin/printf "\n${yellowColour}Command necesary to configurate fzf copied to clipboard, openning a new terminal for configurate...\n${blueColour}"
    read -rsn1 -p "Press any key to continue";/usr/bin/echo
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
    #Installing extensions for the desktop aspect, maybe you must to configurate some extension after...
    extensions
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
    #Cleaning temporal files ** The "Output.txt and error.log" don't be deleted for you interesting **
    /usr/bin/printf "${grayColour}\nCleaning temporary files...\n"
    sudo /usr/bin/rm -r tmp && /usr/bin/printf "${greenColour}DONE\n" || /usr/bin/printf "${redColour}[x]Sorry can't delete all temporary files..."
    #Thanks to use my script
    /usr/bin/printf "${redColour}\nNow i gonna restart the system\n"
    /usr/bin/printf "${redColour}\nThank you for use my script...\n\nﮊBorb3dﮊ\n\n"
    sleep 3
    read -rsn1 -p "Press any key to continue";/usr/bin/echo
    sudo /sbin/reboot
else
    /usr/bin/printf "\n${redColour}This tool can't be executed with root privileges\n\n"
fi
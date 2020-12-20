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
#Programs
chrome="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
vbox="https://download.virtualbox.org/virtualbox/6.1.16/virtualbox-6.1_6.1.16-140961~Ubuntu~eoan_amd64.deb"
vscode="https://go.microsoft.com/fwlink/?LinkID=760868"
sublt3=$(/usr/bin/wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo /usr/bin/apt-key add - 2>/dev/null && \
            sudo /usr/bin/apt-get install -y apt-transport-https && /usr/bin/echo "deb https://download.sublimetext.com/ apt/stable/" | \
            sudo /usr/bin/tee /etc/apt/sources.list.d/sublime-text.list && sudo /usr/bin/apt-get update >/dev/null 2>&1 && \
            sudo /usr/bin/apt-get install sublime-text -y >/dev/null 2>&1)
dbeaver="https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb"

#Extensions
shell_integration="https://chrome.google.com/webstore/detail/gnome-shell-integration/gphhapmejobijbbhgpjhcjognlahblep?hl=es"
dash_dock="https://extensions.gnome.org/extension/307/dash-to-dock/"
desktop_icons="https://extensions.gnome.org/extension/2087/desktop-icons-ng-ding/"
places_status="https://extensions.gnome.org/extension/8/places-status-indicator/"
user_themes="https://extensions.gnome.org/extension/19/user-themes/"
workspace_indicator="https://extensions.gnome.org/extension/21/workspace-indicator/"

#ZSH
lsd="https://github.com/Peltoche/lsd/releases/download/0.19.0/lsd-musl_0.19.0_amd64.deb"
bat="https://github.com/sharkdp/bat/releases/download/v0.17.1/bat_0.17.1_amd64.deb"

## PERSONAL VARIABLES ##
anydesk="https://download.anydesk.com/linux/anydesk_6.0.1-1_amd64.deb"
vnc="https://www.realvnc.com/download/file/viewer.files/VNC-Viewer-6.20.529-Linux-x64.deb"

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
    /usr/bin/echo -e "\n${yellowColour}[!] ${redColour}Exiting...\n${endColour}"
    exit 0
}

## FUNCTIONS ##

function requirements(){
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
}

function dpkgInstall(){ #Structure to download and configure programs
    /usr/bin/printf "${grayColour}Downloading and configuring $1...\n${yellowColour}"
    /usr/bin/wget $2 -O $3 -q --show-progress
    sudo /usr/bin/dpkg -i $PWD/$3 && /usr/bin/printf "${grayColour}[*]${blueColour}$1 ${greenColour}OK\n" >> ../output.txt || /usr/bin/printf "${redColour}[x] $1 is NOT Installed\n" >> ../output.txt
    /usr/bin/sleep 1 && /usr/bin/clear
}

function aptInstall(){
    /usr/bin/printf "${grayColour}Downloading and configuring $1...\n${yellowColour}"
    sudo /usr/bin/apt-get install $2 -y >/dev/null 2>&1 && /usr/bin/printf "${grayColour}[*]${blueColour}$1 ${greenColour}OK\n" >> ../output.txt || /usr/bin/printf "${redColour}[x] $1 is NOT Installed\n" >> ../output.txt
    /usr/bin/sleep 1 && /usr/bin/clear
}

function install(){ #Programs to install
    #Installing Google Chrome
    /usr/bin/clear
    dpkgInstall "Google Chrome" ${chrome} "chrome.deb"
    #Installing VirtualBox
    dpkgInstall "Virtual Box" ${vbox} "vbox.deb"
    #Installing vsCode
    dpkgInstall "Visual Studio Code" ${vscode} "vscode.deb"
    #Installing SublimeText3
    /usr/bin/printf "${grayColour}Downloading and configuring Sublime Text 3...\n${yellowColour}"
    /usr/bin/sleep 2
    /usr/bin/echo ${sublt3} >/dev/null 2>&1 && /usr/bin/printf "${grayColour}[*]${blueColour}Sublime Text 3 ${greenColour}OK\n" >> ../output.txt || /usr/bin/printf "${redColour}[x] Sublime Text 3 is NOT Installed\n" >> ../output.txt
    /usr/bin/sleep 1 && /usr/bin/clear
    #Installing Tilix
    aptInstall "Tilix" "tilix"
    /usr/bin/dconf load /com/gexperts/Tilix/ < tilix.dconf ##** Solo peronal!!!!! **##
    #Installing Remmina
    aptInstall "Remmina" "remmina"
    #Installing Dbeaver
    dpkgInstall "Dbeaver" ${dbeaver} "dbeaver.deb"
    #Installing Parcellite
    aptInstall "Parcellite" "parcellite"
    #Installing Ansible
    aptInstall "Ansible" "ansible"
    #Installing Keepass
    aptInstall "KeePass" "keepassxc"
}

function personalInstall(){
    #Installing AnyDesk
    programs "AnyDesk" "anydesk.deb"
    #Installing VNC Viewer
    programs "VNC Viewer" "vnc.deb"
    #Installing Pulse Secure
    /usr/bin/printf "Instalando Pulse Secure"
    unzip pulse.zip
    sudo /usr/bin/dpkg -i pulse/libwebkitgtk-1.0-0_2.4.11-3ubuntu3_amd64.deb
    sudo /usr/bin/dpkg -i pulse/libjavascriptcoregtk-1.0-0_2.4.11-3ubuntu3_amd64.deb
    sudo /usr/bin/dpkg -i pulse/libicu60_60.2-3ubuntu3.1_amd64.deb
    sudo /usr/bin/dpkg -i pulse/ps-pulse-linux-9.1r5.0-b151-ubuntu-debian-64-bit-installer.deb
}

function configureExt(){
    /usr/bin/printf "\n${yellowColour}[!]${grayColour}Now i gonna open a Google Chrome window with an another extension you have to install.\n \
            One time this script end you must to configure like you want\n\n${yellowColour}[!]${grayColour}You have to select manually best Gnome-Shell version for you${blueColour}\n"
    /usr/bin/sleep 2
    google-chrome ${$1} >/dev/null 2>&1
    read -rsn1 -p "Press any key to continue";/usr/bin/echo
}

function extensions(){ #Function for config my desktop
    ## You can see your Gnome-Shell version for take the best version of Themes with this command "gnome-shell --version"
    #Installing App for manage your extensions from Google Chrome
    aptInstall "Gnome-Shell Chrome Extension" "chrome-gnome-shell"
    #Installing Tweak Tools on we Desktop
    aptInstall "Gnome-Shell Tweak Tool" "gnome-shell-extensions"
    #Now You must to install this extension from Google Chrome (If you don't like Chrome not have any problem, is only for use this tools, don't have to use it more)
    /usr/bin/printf "\n${yellowColour}[!]${grayColour}Now i gonna open a Google Chrome window with an extension you have to install${blueColour}\n"
    /usr/bin/sleep 2
    google-chrome ${shell_integration} >/dev/null 2>&1
    read -rsn1 -p "Press any key to continue";/usr/bin/echo
    #Installing Extension to modify lateral bar
    configureExt "dash_dock"
    #Installing Desktop Icons (Remove Trash and Home folders from Desktop)
    configureExt "desktop_icons"
    #Installing Places Status Indicator
    configureExt "places_status"
    #Installing User Themes (To put any custom theme)
    configureExt "user_themes"
    #Installing Workspace Indicator (To see the current desktop space)
    configureExt "workspace_indicator"
    #Installing SysMonitor
    sudo /usr/bin/add-apt-repository ppa:fossfreedom/indicator-sysmonitor
    sudo /usr/bin/apt-get update && aptInstall "SysMonitor" "indicator-sysmonitor"
    #Configurate SysMonitor
    /usr/bin/printf "${yellowColour}[!]${grayColour}I put my basic ip script on your /usr/bin/ip.sh directory for configuration SysMonitor\n\
            Maybe you must to check your Network Interface name to modify the script"
    sudo /usr/bin/cp $PWD/ip.sh /usr/bin/ip.sh #Moving script to correctly folder
    /usr/bin/chmod +x /usr/bin/ip.sh #Add execution privilege to sysmonitor manage
    /usr/bin/cp -r $PWD/.config $HOME/ #Moving .config directory to user Home
    /usr/bin/cp -r $PWD/.indicator-sysmonitor.json $HOME/ #Moving sysmonitor configuration to user Home
    /usr/bin/sleep 1
    /usr/bin/printf "${greenColour}DONE"
}

function desktop(){
    #Unziping folders and puting all in correct folders
    mkdir $HOME/{".themes",".icons",".fonts"}
    /usr/bin/unzip theme.zip -d $HOME/.themes
    /usr/bin/unzip icons.zip -d $HOME/.icons
    /usr/bin/unzip gnomeTheme.zip -d $HOME/.themes
    /usr/bin/unzip Hack.zip -d $HOME/.fonts
    /usr/bin/printf "${grayColour}I put all you need to configure desktop in correct folders\n${yellowColour}[!]Now you have to configure all on Tweak Tool"
    /usr/bin/printf "${redColour}Opening...\n${blueColour}"
    #Open Tweak Tools to configurate
    /usr/bin/gnome-tweaks >/dev/null 2>&1 &; disown
    read -rsn1 -p "Press any key to continue";/usr/bin/echo
}

function newUser(){
    sudo /usr/sbin/useradd -d /home/$1 -s /bin/bash $1
    sudo /usr/bin/passwd $1
    sudo /usr/bin/chown $1:$1 /home/$1
    sudo /usr/sbin/usermod -a -G sudo $1
}

function hackingTools(){
    #Installing NMAP
    aptInstall "Nmap" "nmap"
    #Installing ffuf (Fuzzing tool in GO)
    /usr/bin/printf "${grayColour}Downloading and configuring ffuf...\n${yellowColour}"
    /usr/bin/git clone https://github.com/ffuf/ffuf ; cd ffuf ; /usr/bin/go get ; /usr/bin/go build; cd .. && \
        /usr/bin/printf "${grayColour}[*]${blueColour}ffuf ${greenColour}OK\n" >> ../output.txt || /usr/bin/printf "${redColour}[x] ffuf is NOT Installed\n" >> ../output.txt
    sudo /usr/bin/ln -s /home/$PWD/ffuf/ffuf /usr/bin/ffuf; sudo /usr/bin/chmod +x /usr/bin/ffuf
    /usr/bin/sleep 1 && /usr/bin/clear
    #Installing Dirsearch (Fuzzing tool in Python)
    /usr/bin/printf "${grayColour}Downloading and configuring Dirsearch...\n${yellowColour}"
    git clone https://github.com/maurosoria/dirsearch.git
    sudo /usr/bin/ln -s /hom/$PWD/dirsearch/dirsearch.py /usr/bin/dirsearch; sudo /usr/bin/chmod +x /usr/bin/dirsearch
    /usr/bin/sleep 1 && /usr/bin/clear
    #Installing hydra (Brute-Force tool)
    aptInstall "Hydra" "hydra"
    #Installing John The Ripper (Brute-Force tool)
    aptInstall "John The Ripper" "john"
    #Installing BinWalk ("Steganography and more" Tool)
    aptInstall "BinWalk" "binwalk"
    #Installing StegHide (Steganography tool)
    aptInstall "StegHide" "steghide"
    #Installing Metasploit-Framework
    curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && \
        /usr/bin/chmod 755 msfinstall && \
        ./msfinstall && /usr/bin/printf "${grayColour}[*]${blueColour}Metasploit-Framework ${greenColour}OK\n" >> ../output.txt || \
        /usr/bin/printf "${redColour}[x] Metasploit-Framework is NOT Installed\n" >> ../output.txt
    /usr/bin/sleep 1 && /usr/bin/clear
}

function body(){
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
            cd /home/$name_new_user
            hackingTools
        elif [ "$user" = "n" ] || [ "$user" = "N" ]; then 
            cd /home/$USER
            hackingTools
        else
            /usr/bin/printf "Don't understand your response..."
            body
        fi
    elif [ "$sure" = "n" ] || [ "$sure" = "N" ]; then
        /usr/bin/sleep 1
        pass
    else
        /usr/bin/printf "Don't understand your response..."
        body
    fi
}

function configureTerminal(){
    /usr/bin/printf "${grayColour}Now we gonna configurate our zsh\n"
    #Configuring zsh SHELL
    /usr/bin/printf "${yellowColour}[!]${grayColour}Before start, You have to put the 'Hack Nerd Font' font on your terminal to configure the zsh correctly"
    #Install powerlevel10k aspect for zsh
    /usr/bin/printf "${grayColour}Downloading and configuring PowerLevel10k...\n${yellowColour}"
    /usr/bin/git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
    /usr/bin/printf "\n${yellowColour}[!]${grayColour}Now i gonna open a Tilix terminal, you must to open 'zsh' and configure like u want it. \n
                    You must to configure all users you gonna use (current, newest and root) \n"
    /usr/bin/tilix
    read -rsn1 -p "Press any key to continue";/usr/bin/echo
    #Configurate zsh config and p10k for users and root
    /usr/bin/printf "${grayColour}Copying zshrc and p10k on ${USER}, ${name_new_user}, and ROOT...\n${yellowColour}"
    /usr/bin/cp /home/$USER/tmp/zshrc /home/$USER/.zshrc && sudo /usr/bin/ln -s /home/$USER/tmp/zshrc /home/$name_new_user/.zshrc && \
        /usr/bin/printf "${grayColour}[*]${blueColour}zshrc on ${USER} and ${name_new_user} ${greenColour}OK\n" >> ../output.txt || \
        /usr/bin/printf "${redColour}[x] zshrc on ${USER} and ${name_new_user} is NOT Installed\n" >> ../output.txt
    sudo /usr/bin/ln -s /home/$USER/tmp/zshrc /root/.zshrc && /usr/bin/printf "${grayColour}[*]${blueColour}zshrc on ROOT ${greenColour}OK\n" \
                                        >> ../output.txt || /usr/bin/printf "${redColour}[x] zshrc on ROOT is NOT Installed\n" >> ../output.txt
    /usr/bin/cp /home/$USER/tmp/p10k.zsh /home/$USER/.p10k.zsh && /usr/bin/cp /home/$USER/tmp/p10k.zsh /home/$name_new_user/.p10k.zsh \
        && /usr/bin/printf "${grayColour}[*]${blueColour} p10k on ${USER} and ${name_new_user} ${greenColour}OK\n" >> ../output.txt || \
        /usr/bin/printf "${redColour}[x] p10k on ${USER} and ${name_new_user} is NOT Installed\n" >> ../output.txt
    sudo /usr/bin/cp /home/$USER/tmp/p10k.zsh(root) /root/.p10k.zsh && /usr/bin/printf "${grayColour}[*]${blueColour}p10k on ROOT ${greenColour}OK\n" \
                                        >> ../output.txt || /usr/bin/printf "${redColour}[x] p10k on ROOT is NOT Installed\n" >> ../output.txt
    /usr/bin/sleep 1 && /usr/bin/clear
    #Install lsd (Plugin to see better the folders)
    dpkgInstall "LSD" ${lsd} "lsd.deb"
    #Install bat (Plugin to see "cat" better)
    dpkgInstall "BAT" ${bat} "bat.deb"
    #Install fzf (Plugin to put a Finder on terminal)
    /usr/bin/printf "\n${yellowColour}[!]${grayColour}Now we gonna configurate fzf (Finder for a termminal).Use 'ctrl+t' for open the Finder. \n
                        You must to configure all users you gonna use (current, newest and root) \n"
    /usr/bin/git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf; ~/.fzf/install \
        && /usr/bin/printf "${grayColour}[*]${blueColour} fzf on ${USER} ${greenColour}OK\n" >> ../output.txt || \
        /usr/bin/printf "${redColour}[x] fzf on ${USER} is NOT Installed\n" >> ../output.txt
    su ${name_new_user}
    /usr/bin/git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf; ~/.fzf/install \
        && /usr/bin/printf "${grayColour}[*]${blueColour} fzf on ${name_new_user} ${greenColour}OK\n" >> ../output.txt || \
        /usr/bin/printf "${redColour}[x] fzf on ${name_new_user} is NOT Installed\n" >> ../output.txt
    sudo su
    /usr/bin/git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf; ~/.fzf/install \
        && /usr/bin/printf "${grayColour}[*]${blueColour} fzf on ROOT ${greenColour}OK\n" >> ../output.txt || \
        /usr/bin/printf "${redColour}[x] fzf on ROOT is NOT Installed\n" >> ../output.txt
    exit && exit
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
    #Moving my images to your user images folder, you must to configurate after
    /usr/bin/printf "${grayColour}Putting my images on your user images folder...\n${yellowColour}"
    /usr/bin/cp /home/$USER/tmp/wild.png /home/$USER/Pictures/wild.png || /usr/bin/cp /home/$USER/tmp/wild.png /home/$USER/Imágenes/wild.png
    /usr/bin/cp /home/$USER/tmp/wild.png /home/$USER/Pictures/pirata1.jpg || /usr/bin/cp /home/$USER/tmp/wild.png /home/$USER/Imágenes/pirata1.jpg
    /usr/bin/printf "${yellowColour}[!]${grayColour}You can change the tilix background on (Tilix configuration => Appareance => Background image)...\n"
    /usr/bin/sleep 1 && /usr/bin/clear
}

## MAIN ##
/usr/bin/printf "${purpleColour}WELCOME to my configurate script for Linux"
#Create temporary folder and go in
cd /home/$USER
/usr/bin/mkdir $PWD/tmp && cd tmp
/usr/bin/unzip ../tools.zip -d ./
#Manage script execution with sudo privileges
if [ $(id -u) == "0" ]; then
    #Installing 3 requirements for next tools
    requirements
    #Installing basic programs to work
    install
    #Only for me
    personalInstall
    #Installing extensions for the desktop aspect, maybe you must to configurate some extension after...
    extensions
    #Installing themes, icons, fonts...for your cool desktop
    desktop
    #Installing new user or not and hacking tools
    body
    #Updating all System and installing dependencies
    /usr/bin/apt-get update
    /usr/bin/apt-get install -f -y 
    /usr/bin/apt-get upgrade -y
    #Return to home directory
    cd /home/$USER
    #Show result of script
    /usr/bin/printf "${grayColour}Showing results of script...\n${yellowColour}[!]${grayColour}If some installation go wrong please, install manually\n\n"
    /usr/bin/cat output.txt
    #Cleaning temporal files ** The "Output.txt" don't be deleted for you interesting **
    /usr/bin/printf "${grayColour}\nCleaning temporary files...\n"
    sudo /usr/bin/rm -r tmp && /usr/bin/printf "${greenColour}DONE\n" || /usr/bin/printf "${redColour}[x]Sorry can't delete all temporary files..."
    #Thanks to use my script
    /usr/bin/printf "${redColour}\nThank you for use my script...\nﮊBorb3dﮊ\n"
else
    /usr/bin/printf "\n${redColour}This tool must be executed with root privileges\n"
fi
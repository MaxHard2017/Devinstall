#!/bin/bash
# ===== Global =====
# Destination folders for installation
# app home folsers
# INSTALLDIR better be on the same disc as HOME
# making absolet win like path for 7z (as it could only work with reletive path and can not underctend /c/...)
# ABS_INSTALL=${INSTALLDIR:1:1}:${INSTALLDIR:2}
HOME="$HOME/home"   # /path/to/installation/directory/ for all programms
INSTALLDIR="$HOME/devtools"   # /path/to/installation/directory/ for all programms
# for test
HOME="/f/testhome" 
INSTALLDIR="/f/testdevinstall"   # /path/to/installation/directory/ for all programms

VSCHOME="VSC"
MINGWHOME="MinGWx86_64-8.1.0"
PYTHONHOME="Python"
JDKHOME="Java"
JDK="jdk-23.0.1"       # jdk-23
MAVENHOME="Java"
MAVEN="apache-maven-3.9.9"
GITHOME="PortableGit"
LOG4JHOME=""
INSTALL_QUICK="n" # y - for quick install with default settings/locations n - for coice

# Source directories
# echo "$(dirname "$(realpath "$0")")"
# echo "---"
# SRC_DOTNET="$SRC_PATH/dotNet"
# SRC_C="$SRC_PATH/MinGW_GCC"
# SRC_PYTHON="$SRC_PATH/Python"
# SRC_VSC="$SRC_PATH/VSC"
# SRC_GIT="$SRC_PATH/Git"
# SRC_7ZIP="$SRC_PATH/7z"
# SRC_DOCS="$SRC_PATH/Docs"
# SRC_JDK="$SRC_PATH/Jdk" # jdk of paconcrete version
# SRC_MAVEN="$SRC_PATH/Maven"
# # fille with anonimous (instead of personal) git e-mail for using in commits
# SRC_GITINIT="$SRC_PATH/git_conf.txt"

# source installation directory contains install.sh and source folders
#SRC_PATH="$(dirname "$(realpath "$0")")" # resolve path to the curent running file e.g. install.sh
#PP= cygpath -u "$(dirname "$(realpath "$0")")"

# install.sh should be in installation directory, finding the path to it
SRC_PATH="$(cd "$(dirname $0)"; pwd)"
SRC_DOTNET="dotNet"
SRC_C="MinGW_GCC"
SRC_PYTHON="Python"
SRC_VSC="VSC"
SRC_GIT="Git"
SRC_7ZIP="7z"
SRC_DOCS="Docs"
SRC_JDK="Jdk" # jdk of paconcrete version
SRC_MAVEN="Maven"
# fille with anonimous (instead of personal) git e-mail for using in commits
SRC_GITINIT="git_conf.txt"

TEMP_PATH=""
DEV_PATH_WIN=""         # collects data for PATH variable for executables while installing in windows format
DEV_PATH_LNX=""         # collects data for PATH variable for executables while installing in linux format
ENVIRONMENT_VARS_WIN=""        # collects data for environment variables needed in windows format
ENVIRONMENT_VARS_LNX=""        # collects data for environment variables needed in linux format
BOOL_GIT_INSTALLED="n"

# ========== Annatation ==========
annatation() {
    clear
    echo ""
    echo -e "  \e[37;1mContent:\e[0m"
    echo ""
    echo -e "  - \e[32mPortable Visual Studio Code Win x64 1.195.3\e[0m - source:"
    echo "       https://code.visualstudio.com/download#"
    echo -e "    Visual Studio Code site: \e[37;1mhttps://code.visualstudio.com/\e[0m"
    echo ""
    echo -e "  - \e[32mPortable Git win 2.47.0.2 64 bit\e[0m - source:"
    echo "       https://git-scm.com/downloads"
    echo -e "    Git site: \e[37;1mhttps://git-scm.com/\e[0m"
    echo ""
    echo -e "  - \e[32mJava 23 win x64\e[0m - source:"
    echo "       https://www.oracle.com/java/technologies/downloads/#java23"
    echo -e "    Java: \e[37;1mhttps://openjdk.org/, https://jdk.java.net/\e[0m"
    echo ""
    echo -e "  - \e[32mAppache maven 3.9.9\e[0m - source:"
    echo "       https://maven.apache.org/download.html"
    echo -e "    Maven site: \e[37;1mhttps://maven.apache.org/\e[0m"
    echo ""
    echo -e "  - \e[32mMinGW_GCC x86_64 win32 v 8.1.0\e[0m - sourse: https://sourceforge.net/projects"
    echo "       /mingw-w64/files/Toolchains%20targetting%20Win64/Personal%20Builds"
    echo "       /mingw-builds/8.1.0/threads-win32/seh"
    echo "       /x86_64-8.1.0-release-win32-seh-rt_v6-rev0.7z/download "
    echo -e "    MinGW site: \e[37;1mhttp://mingw-w64.org/doku.php\e[0m"
    echo "" 
    echo -e "  - \e[32mpython-amd64 3.12.4\e[0m - source:" 
    echo "       https://www.python.org/ftp/python/3.12.4/python-3.12.4-embed-amd64.zip"
    echo "    For additional information about using Python on Windows, see at"
    echo -e "    Python.org \e[37;1mhttps://docs.python.org/3.9/using/windows.html\e[0m"
    echo ""
    echo -e "  - \e[32mPython3\e[0m Windows help file - source:" 
    echo "       https://www.python.org/ftp/python/3.10.1/python3101.chm "
    echo "------------------------------------------------------------------------------"
    echo ""
    read -s -p $'  press \e[32m[ENTER]\e[0m to continue'
}


# ========== Util functions section ==========

# for test
check_var() {
    echo "vars:"
    echo "home - $HOME"
    echo "installdir -- $INSTALLDIR"
    echo "src dir - $SRC_PATH"
    echo "PWD"
    pwd
    read -s -p $'  press \e[32m[ENTER]\e[0m to continue'
}

# Add text into the file at selected line number
add_sniplet() {
    local sniplet=$1
    echo sn=$sniplet
    local src_file=$2
    echo f1=$src_file
    local out_file=$3
    echo f2=$out_file
    local position=$4
    echo position=$position

    if [ -z "$1" ]; then
        echo "Empty arguments!"
        echo "add_snipl inserts text into selected line number of the sourse file ond save result to output file "
        echo "Usage: add_sniplet <text> <path/to/source> <path/to/output> <line number to inset text>"
        return 1
    fi

    if [ -z "$position" ]; then
        position="1"
        echo position=$position

    elif [[ ! $position == *[0-9] ]]; then
        echo position $position not right!
        return 1
    fi

    if [ ! -f "$src_file" ]; then
        echo "bad sourse file $src_file"
        return 1
    fi

    if [ -s "$out_file" ]; then
        local choises
        read -p "File $out_file exists, owerwrite it? y/n: " choise

        case "$choise" in
            y)
            echo yes--
            ;;
            n)
            echo no--
            return 1
            ;;
            *)
            echo "wrong choise"
            return 1
            ;;
        esac
        echo in if after case
    fi
    sed "${position}i\\$sniplet" "$src_file">"$out_file"
}
# Set installation location in INSTALLDIR global variable
path_set() {
    local name=""
        clear
        echo ""
        echo -e "  Current path: \e[35m$INSTALLDIR\e[0m"
        echo ""
    while :
    do
            clear
            echo ""
            echo -e "  Installation path: \e[35m$INSTALLDIR\e[0m"
            echo ""
            read -p $'  Change it or press \e[32m[ENTER]\e[0m to continue:\e[32m ' name
            echo $'\e[0m'
        if [ -z "$name" ]; then
            clear
            echo ""
            echo -e "  Installation path: \e[37;1m$INSTALLDIR\e[0m"
            sleep 1s
            break
        else
            INSTALLDIR=$name
 
        fi
    done
    # making absolet path for 7z (as it could only work with reletive path and can not underctend /c/...)
    ABS_INSTALL=${INSTALLDIR:1:1}:${INSTALLDIR:2}
}

# ========== Instalation options ==========

option_full() {
    INSTALL_QUICK="y"
    echo ""
    echo ""
    echo -e "  Automatic quick installation of:"
    echo -e "  \e[32mvsc, git, java, maven, mingw, python\e[0m with default settings"  
    echo "------------------------------------------------------------------------------"
    echo -e "  Global installation directory = \e[37;1m$INSTALLDIR\e[0m" 
    echo -e "  Portable Git install directory = \e[37m$INSTALLDIR/$GITHnOME\e[0m"
    echo -e "  Git-bash HOME variable = \e[37;1m$HOME\e[0m"
    echo -e "  VSC install directory = \e[37m$INSTALLDIR/$VSCHOME\e[0m"
    echo -e "  MinGW install directory = \e[37m$INSTALLDIR/$MINGWHOME\e[0m"
    echo -e "  Java install directory = \e[37m$INSTALLDIR/$JDKHOME\e[0m"
    echo -e "  Maven install directory = \e[37m$INSTALLDIR/$MAVENHOME\e[0m"
    echo -e "  Python install directory = \e[37m$INSTALLDIR/$PYTHONHOME\e[0m"
    local choice02
    while :  
    do
        echo "  Do you want proceed installation?"
        read -p $'  \e[32my\e[0m - yes, \e[32mn\e[0m - no: ' -n 1  choice02
        echo ""
        case "$choice02" in
            y)
                git_install
                vsc_install
                jdk_install
                maven_install
                mingw_install
                python_install
                vscode_startup_scripts
                toolchain_test
                exit 0
                ;;
            n)
                echo ""
                echo " Installation cancelled!"
                break
                ;;
            *)
                echo -e "\n\e[33m  Invalid choice.\e[0m Please try again."
                ;;
        esac
    done     
}

option_custom() {
    INSTALL_QUICK="n"
    echo ""
    echo ""
    echo -e "  Custom installation of:"
    echo -e "  \e[32mvsc, git, java, maven, mingw, python\e[0m"  
    echo "------------------------------------------------------------------------------"
    path_set

    local choice21=""
    local choice22=""
    local choice23=""
    local choice24=""
    local choice25=""
    local choice26=""
    while :  
    do
        echo ""
        echo "  Do you want to install GIT?"
        read -p $'  \e[32my\e[0m - yes, \e[32mn\e[0m - no: ' -n 1  choice21
        echo ""
        case "$choice21" in
            y)
                git_install
                echo "  GIT installation finished"
                break
                ;;
            n)
                echo ""
                echo "  GIT installation skipped!"
                break
                ;;
            *)
                echo -e "\n\e[33m  Invalid choice.\e[0m Please try again."
                ;;
        esac
    done

    while :  
    do
        echo ""
        echo "  Do you want to install Java 23?"
        read -p $'  \e[32my\e[0m - yes, \e[32mn\e[0m - no: ' -n 1  choice22
        echo ""
        case "$choice22" in
            y)
                jdk_install
                echo "  Java 23 installed!"
                break
                ;;
            n)
                echo ""
                echo "  Java installation skipped."
                break
                ;;
            *)
                echo -e "\n\e[33m  Invalid choice.\e[0m Please try again."
                ;;
        esac
    done

    while :  
    do
        echo ""
        echo "  Do you want to install Maven?"
        read -p $'  \e[32my\e[0m - yes, \e[32mn\e[0m - no: ' -n 1  choice23
        echo ""
        case "$choice23" in
            y)
                maven_install
                echo "  Maven installed!"
                break
                ;;
            n)
                echo ""
                echo "  Maven installation skipped."
                break
                ;;
            *)
                echo -e "\n\e[33m  Invalid choice.\e[0m Please try again."
                ;;
        esac
    done
    
    while :  
    do
        echo ""
        echo "  Do you want to install MinGW?"
        read -p $'  \e[32my\e[0m - yes, \e[32mn\e[0m - no: ' -n 1  choice24
        echo ""
        case "$choice24" in
            y)
                mingw_install
                echo "  MinGW installed!"
                break
                ;;
            n)
                echo ""
                echo "  MinGW installation skipped."
                break
                ;;
            *)
                echo -e "\n\e[33m  Invalid choice.\e[0m Please try again."
                ;;
        esac
    done

    while :  
    do
        echo ""        
        echo "  Do you want to install Python?"
        read -p $'  \e[32my\e[0m - yes, \e[32mn\e[0m - no: ' -n 1  choice25
        echo ""
        case "$choice25" in
            y)
                python_install
                echo "  Python installed!"
                break
                ;;
            n)
                echo ""
                echo "  Python installation skipped."
                break
                ;;
            *)
                echo -e "\n\e[33m  Invalid choice.\e[0m Please try again."
                ;;
        esac
    done

    while :  
    do
        echo ""
        echo "  Do you want to install Visual Sourse Code?"
        read -p $'  \e[32my\e[0m - yes, \e[32mn\e[0m - no: ' -n 1  choice26
        echo ""
        case "$choice26" in
            y)
                vsc_install
                echo "  VSC installed!"
                vscode_startup_scripts

                break
                ;;
            n)
                echo ""
                echo "  VSC installation skipped."
                break
                ;;
            *)
                echo -e "\n\e[33m  Invalid choice.\e[0m Please try again."
                ;;
        esac
    done
    
    toolchain_test
}


option_dotnet() {
    dotnet_check_install
}

option_git_vsc () {
    INSTALL_QUICK="n"
    path_set
    local choice31=""
    local choice32=""
    while :  
    do
        echo "  Do you want to install GIT?"
        read -p $'  \e[32my\e[0m - yes, \e[32mn\e[0m - no: ' -n 1  choice31
        echo ""
        case "$choice31" in
            y)
                git_install
                echo "  GIT installation finished"
                break
                ;;
            n)
                echo ""
                echo "  GIT installation skipped."
                break
                ;;
            *)
                echo -e "\n\e[33m  Invalid choice.\e[0m Please try again."
                ;;
        esac
    done

    while :  
    do
        echo "  Do you want to install Visual Sourse Code?"
        read -p $'  \e[32my\e[0m - yes, \e[32mn\e[0m - no: ' -n 1  choice32
        echo ""
        case "$choice32" in
            y)
                vsc_install
                vscode_startup_scripts
                break
                ;;
            n)
                echo ""
                echo "  VSC installation skipped."
                break
                ;;
            *)
                echo -e "\n\e[33m  Invalid choice.\e[0m Please try again."
                ;;
        esac
    done

    if [[ "$choice32" == "y" || "$choice31" == "y" ]]; then 
        toolchain_test
    fi
}

option_auto() {
    INSTALL_QUICK="y"
    echo ""
    echo ""
    echo -e "  Automatic installation of most used apps: \e[32mgit, vsc, java, maven\e[0m"
    echo "------------------------------------------------------------------------------"
    echo -e "  Global installation directory = \e[37;1m$INSTALLDIR\e[0m" 
    echo -e "  Portable Git install directory = \e[37m$INSTALLDIR/$GITHOME\e[0m"
    echo -e "  Git-bash HOME variable = \e[37;1m$HOME\e[0m"
    echo -e "  VSC install directory = \e[37m$INSTALLDIR/$VSCHOME\e[0m"
    echo -e "  Java install directory = \e[37m$INSTALLDIR/$JDKHOME\e[0m"
    echo -e "  Maven install directory = \e[37m$INSTALLDIR/$MAVENHOME\e[0m"
    local choice02
    while :  
    do
        echo "  Do you want proceed installation?"
        read -p $'  \e[32my\e[0m - yes, \e[32mn\e[0m - no: ' -n 1  choice02
        echo ""
        case "$choice02" in
            y)
                git_install
                vsc_install
                jdk_install
                maven_install
                vscode_startup_scripts
                toolchain_test
                break
                ;;
            n)
                echo ""
                echo "  Installation cancelled!"
                break
                ;;
            *)
                echo -e "\n\e[33m  Invalid choice.\e[0m Please try again."
                ;;
        esac
    done 
}

# ========== Instalation functions ==========

# Visual Studio Code installation
vsc_install() {
    echo ""
    echo ""
    echo -e "  Installing \e[32mVSC\e[0m to \e[37;1m$INSTALLDIR/$VSCHOME\e[0m..."
    echo "------------------------------------------------------------------------------"
    mkdir -p $INSTALLDIR/$VSCHOME/data/user-data/User
    mkdir -p $INSTALLDIR/$VSCHOME/data/extensions
    mkdir -p $INSTALLDIR/$VSCHOME/data/tmp
    
    #-#
    pushd "$INSTALLDIR" "$@" > /dev/null
    # 7z do not use absolet path in nix style and need win style drive letter like c:
    # ${string:1:1} takes the second one letter 
    # ${string:2} takes the string from third letter to the end of the string
    $SRC_PATH/$SRC_7ZIP/7za.exe x ${SRC_PATH:1:1}:${SRC_PATH:2}/$SRC_VSC/test/*.zip -o$VSCHOME # for test
    # $SRC_PATH/$SRC_7ZIP/7za x ${SRC_PATH:1:1}:${SRC_PATH:2}/$SRC_VSC/*.zip -o$VSCHOME
    popd "$@" > /dev/null
    #-old
    # mkdir -p "$INSTALLDIR/$VSCHOME/bin"
    # cp "$SRC_VSC/code_test" "$INSTALLDIR/$VSCHOME/bin/code"
    # cp "$SRC_VSC/code.test_cmd" "$INSTALLDIR/$VSCHOME/bin/code.cmd"
    # echo "echo vsc - ok " > "$INSTALLDIR/$VSCHOME/bin/vsc"
    # echo "#!/bin/bash" > "$INSTALLDIR/$VSCHOME/Code"
    # echo "echo code - ok " > "$INSTALLDIR/$VSCHOME/Code"
    # echo "current PATH = echo \$PATH" > "$INSTALLDIR/$VSCHOME/Code"
    #-old

    DEV_PATH_WIN+="%~dp0..\..\\$VSCHOME\bin;"
    DEV_PATH_LNX+="./../../$VSCHOME/bin:"
    material_icon_extension
    # Set up user settings

    if [[ $BOOL_GIT_INSTALLED == "y" ]]; then
        # Calculate lines in settings.json
        all=$(wc -l "$SRC_VSC/_user_settings.json")
        line_number=${all%% *}
        let "line_number+=1"
        #add git-bash terminal setting to the end of the settings file
        add_sniplet "    \"terminal.integrated.profiles.windows\":\ {\"Git\ Bash\":\ {\"path\":\
\ \"\${env:USERPROFILE}\\\\\\\\DevTools\\\\\\\\PortableGit\\\\\\\\bin\\\\\\\\bash.exe\"},\ },\n\
    \"terminal.integrated.defaultProfile.windows\":\"Git\ Bash\"" \
        "$SRC_VSC/_user_settings.json" \
        "$INSTALLDIR/$VSCHOME/data/user-data/User/settings.json" \
        "$line_number"
    else
        cat  "$SRC_VSC/_user_settings.json" >> "$INSTALLDIR/$VSCHOME/data/user-data/User/settings.json"
    fi
    # .Net version check
    echo "  DotNET Framework version check:"
    echo "------------------------------------------------------------------------------"
    echo -e "  Visual Sourse Code \e[33mrequares .Net 4.5.2\e[0m or higher.  "
    echo -e "  Check your .NET Framework version under \e[33;1mVersion  REG_SZ\e[0m key:"
    reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\full"
    echo ""
    echo "If required, you can install new version of .Net later from using installer."
}

# Checking installed version of dotNET Framework
dotnet_check_install() {
    echo ""
    echo ""
    echo "  DotNET Framework version check:"
    echo "------------------------------------------------------------------------------"
    echo -e "  DotNET Framework \e[33m4.5.2 or higher\e[0m is required for VSC.  Check your"
    echo -e "  DotNET Framework version under \e[33;1mVersion  REG_SZ\e[0m key:"
    reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\full"
    echo ""

    local choise1=""
    while :
    do
        echo -e "  Do you want to \e[32minstall .Net 4.8\e[0m?"
        read -p $'  \e[32my\e[0m - yes, \e[32mn\e[0m - no: ' -n 1  choise1
        case "$choise1" in
            y)
                # Installing dotNET Framework 4.8 for Win
                echo ""
                echo "------------------------------------------------------------------------------"
                echo "  .Net installing...."
                #-#
                # "$SRC_DOTNET/ndp48-x86-x64-allos-enu.exe"
                $SRC_DOTNET/test/dotnet_test
                #-#
                echo ""
                echo -e "  In case of \e[33m\"Permission denied\"\e[0m error"
                echo -e "  run \e[32minstall.ssh\e[0m intsallation sctipt with admin rights."
                read -s -p $'  press \e[32m[ENTER]\e[0m to continue'
                break
                ;;
            n)
                echo "  .Net 4.8 is not installed"
                break
                ;;                      
            *)
                echo -e "\n\e[33m  Invalid choice.\e[0m Please try again."
                ;;
        esac
    done
}
 
# MinGW installation
mingw_install() {
    echo ""
    echo ""
    echo -e "Installing \e[32mMinGW\e[0m to directory: \e[37;1m$INSTALLDIR/$MINGWHOME\e[0m..."
    echo "------------------------------------------------------------------------------"
    mkdir -p $INSTALLDIR/$MINGWHOME

    pushd "$INSTALLDIR" "$@" > /dev/null
    # 7z do not use absolet path in nix style and need win style drive letter like c:
    # $SRC_PATH/$SRC_7ZIP/7za.exe x ${SRC_PATH:1:1}:${SRC_PATH:2}/$SRC_C/test/*.zip -o$MINGWHOME # for test
    $SRC_PATH/$SRC_7ZIP/7za.exe x ${SRC_PATH:1:1}:${SRC_PATH:2}/$SRC_C/*.7z -o$MINGWHOME
    popd "$@" > /dev/null
    #-old
    # mkdir -p "$INSTALLDIR/$MINGWHOME/mingw64/bin"
    # echo "echo MinGW - ok " > "$INSTALLDIR/$MINGWHOME/mingw64/bin/gcc"
    #-old

    DEV_PATH_WIN+="%~dp0..\..\\$MINGWHOME\mingw64\bin;"
    DEV_PATH_LNX+="./../../$MINGWHOME/mingw64/bin:"
    c_extension
}

# Python installation
python_install() {
    echo ""
    echo ""
    echo -e "Installing \e[32mPython\e[0m to directory: \e[37;1m$INSTALLDIR/$PYTHONHOME\e[0m..."
    echo "------------------------------------------------------------------------------"
    mkdir -p "$INSTALLDIR/$PYTHONHOME"
    
    #-#
    pushd "$INSTALLDIR" "$@" > /dev/null
    # 7z do not use absolet path in nix style and need win style drive letter like c:
    # $SRC_PATH/$SRC_7ZIP/7za.exe x ${SRC_PATH:1:1}:${SRC_PATH:2}/$SRC_PYTHON/test/*.zip -o$PYTHONHOME # for test
    $SRC_PATH/$SRC_7ZIP/7za.exe x ${SRC_PATH:1:1}:${SRC_PATH:2}/$SRC_PYTHON/*.zip -o$PYTHONHOME
    popd "$@" > /dev/null
    # echo "echo python - ok " > "$INSTALLDIR/$PYTHONHOME/python123"
    #-#

    echo ""
    echo "Installing documentation to $INSTALLDIR/$PYTHONHOME/docs..."
    mkdir -p $INSTALLDIR/$PYTHONHOME/docs
    cp $SRC_DOCS/Python/* $INSTALLDIR/$PYTHONHOME/docs
    DEV_PATH_WIN+="%~dp0..\..\\$PYTHONHOME;"
    DEV_PATH_LNX+="./../../$PYTHONHOME:"
    py_extension
}

# JDK installation
jdk_install() {
    echo ""
    echo ""
    echo -e "Installing \e[32mJDK\e[0m to directory: \e[37;1m$INSTALLDIR/$JDKHOME\e[0m..."
    echo "------------------------------------------------------------------------------"
    
    mkdir -p "$INSTALLDIR/$JDKHOME"
    #-#
    pushd "$INSTALLDIR" "$@" > /dev/null
    # 7z do not use absolet path in nix style and need win style drive letter like c:
    # $SRC_PATH/$SRC_7ZIP/7za.exe x ${SRC_PATH:1:1}:${SRC_PATH:2}/$SRC_JDK/test/*.zip -o$JDKHOME # for test
    $SRC_PATH/$SRC_7ZIP/7za.exe x ${SRC_PATH:1:1}:${SRC_PATH:2}/$SRC_JDK/*.zip -o$JDKHOME
    popd "$@" > /dev/null
    #-#

    ENVIRONMENT_VARS_WIN+="set JAVA_HOME=%~dp0..\..\\$JDKHOME\\$JDK"
    ENVIRONMENT_VARS_WIN+=$'\n'

    ENVIRONMENT_VARS_LNX+="JAVA_HOME=./../../$JDKHOME/$JDK"
    ENVIRONMENT_VARS_LNX+=$'\n'

    DEV_PATH_WIN+="%JAVA_HOME%\bin;"
    DEV_PATH_LNX+="./../../$JDKHOME/$JDK/bin:"
}

# Appache Maven installation
maven_install() {
    echo ""
    echo ""
    echo -e "Installing \e[32m Appache Maven\e[0m to directory: \e[37;1m$INSTALLDIR/$MAVENHOME\e[0m..."
    echo "------------------------------------------------------------------------------"
    
    mkdir -p "$INSTALLDIR/$MAVENHOME"
    #-#
    pushd "$INSTALLDIR" "$@" > /dev/null
    # 7z do not use absolet path in nix style and need win style drive letter like c:
    # $SRC_PATH/$SRC_7ZIP/7za.exe x ${SRC_PATH:1:1}:${SRC_PATH:2}/$SRC_MAVEN/test/*.zip -o$MAVENHOME # for test
    $SRC_PATH/$SRC_7ZIP/7za.exe x ${SRC_PATH:1:1}:${SRC_PATH:2}/$SRC_MAVEN/*.zip -o$MAVENHOME
    popd "$@" > /dev/null
    #-#

    DEV_PATH_WIN+="%~dp0..\..\\$MAVENHOME\\$MAVEN\bin;"
    DEV_PATH_LNX+="./../../$MAVENHOME/$MAVEN/bin:"
}

# git installation
git_install() {
    echo ""
    echo ""
    echo -e "  Installing \e[32mGIT\e[0m to directory: \e[37;1m$INSTALLDIR/$GITHOME\e[0m..."
    echo "------------------------------------------------------------------------------"

    # check if git-bash already installed at target location 
    # making git folder if not exist
    if [ ! -d "$INSTALLDIR/$GITHOME" ]; then
        mkdir -p $INSTALLDIR/$GITHOME
    fi

    # Check if file list - "ls -A" command is an empty string
    # extracting if git folder is empty
    if [ $(ls -A  $INSTALLDIR/$GITHOME | wc -l) -eq 0 ]; then
        
        #-#
        # 7z do not use absolet path in nix style and need win style drive letter like c:
        # 7z do not use absolet path in nix style and need win style drive letter like c:
        
        # 7z do not use absolet path in nix style and need win style drive letter like c:    
        
        pushd "$INSTALLDIR" "$@" > /dev/null
        $SRC_PATH/$SRC_7ZIP/7za.exe x ${SRC_PATH:1:1}:${SRC_PATH:2}/$SRC_GIT/test/*.zip -o$GITHOME # for test
        # $SRC_PATH/$SRC_7ZIP/7za.exe x ${SRC_PATH:1:1}:${SRC_PATH:2}/$SRC_GIT/*.exe -o$GITHOME
        echo postinstall git...
        # post-install.bat is generating after installation and self deleting after exeqution
        # pwd - INSTALLDIR - so call it reletive 
        "$GITHOME"/post-install.bat
        popd "$@" > /dev/null
        #-#       
    fi

    local input_str=""
    local choise2=""

    if [[ $INSTALL_QUICK == "n" ]]; then
        echo "------------------------------------------------------------------------------"
        echo "  You can set new HOME environment variable tempory for git-bash "
        echo "  (It would be for the current session only)"
        echo "  Git-bash will track it as it\`s new HOME \"~/\" for storing configuration files"
        echo "  Set HOME directory on the same disc as the main unstallation: $INSTALLDIR"
        echo "  or change installdrive in HOME\gt.bat manualy"
        echo ""
    fi

    while :
    do
        # echo -e "  git-bash HOME variable = \e[37;1m$HOME\e[0m"
        if [[ $INSTALL_QUICK == "y" ]]
            then choise2="n"
        else    
            echo -e "  Change HOME variable = \e[35m$HOME\e[0m?"
            #echo "  Do you want to change it?"
            read -p $'  \e[32my\e[0m - change, \e[32mn\e[0m - do not change, \e[32mi\e[0m - cahge to INSTALLDIR: ' -n 1  choise2
            echo ""
        fi

        case "$choise2" in
            y)
                echo ""
		        read -p $'  Enter new HOME variable: \e[32m' input_str
                echo $' \e[0m'
                HOME=$input_str
                ;;
            n)
                echo -e "  Git-bash HOME variable = \e[37;1m$HOME\e[0m"
                if [ ! -d "$HOME" ]; then
                    echo -e "  Making new directory $HOME..."
                    mkdir $HOME
                fi  
                break
                ;;
            i)
                HOME=$INSTALLDIR
                echo ""
            ;;
            
            *)
                echo -e "\n\e[33m  Invalid choice.\e[0m Please try again."
                ;;
        esac
        
    done

    # HOME_WIN variable for storing path to HOME without drive letter
    # for making reletive paths in win style
    # change slashes to backslashes for windows style path
    HOME_WIN=${HOME//['/']/\\}
    # cut first 2 syumbols (drive letter) from HOME variable
    HOME_WIN=${HOME_WIN:2}



    #ENVIRONMENT_VARS_WIN+="set GITDIR=%~dp0..\..\\$GITHOME"
    #ENVIRONMENT_VARS_WIN+=$'\n'
    #ENVIRONMENT_VARS_LNX+="GITDIR=./../../$GITHOME"
    #ENVIRONMENT_VARS_LNX+=$'\n'

    DEV_PATH_WIN+="%~dp0..\..\\$GITHOME\cmd;"
    DEV_PATH_LNX+="./../../$GITHOME/cmd:"
    
    echo "  Configuring git..."
    # git config initializaition
    # read e-mail and user name from file
    echo "  Reading git settings from ./$SRC_GITINIT for git initialization..."
    local user_name=""
    local user_email=""
    local file=$SRC_GITINIT

    if [ -s $file ]; then
        mapfile -t array < $file
        user_name=${array[0]}
        user_email=${array[1]}
        echo "  User name: $user_name"
        echo "  User e-mail: $user_email"
    else
            echo "  Iitialization file  ./$SRC_GITINIT  not found"
    fi

    # or from cli if no file
    if [[ $user_name == "" ]]; then
        read -p "  Enter user name for configuring git: " user_name
    fi
    if [[ $user_email == "" ]]; then
        read -p "  Enter user e-mail for configuring git: " user_email
    fi
        
    "$INSTALLDIR/$GITHOME"/cmd/git config --global user.name $user_name
    "$INSTALLDIR/$GITHOME"/cmd/git config --global user.email $user_email

    local choise3=""
    while :
    do
        if [[ $INSTALL_QUICK == "y" ]]
            then choise3="n" # Do no setup ssh if quickinstall option is selected
        else
            echo -e "  Do you want to sep up \e[32mSSH\e[0m?"
            read -p $'  \e[32my\e[0m - yes, \e[32mn\e[0m - no: ' -n 1  choise3
        fi
        case "$choise3" in
            y)
                #Setting ssh agent for git-bash
                
                echo ""
                mkdir -p "$HOME/.ssh"

                
                # generate ssh key with SPECIAL name adding 'git_' prefix
                pushd "$HOME/.ssh" "$@" > /dev/null
                echo "installing ssh key in $(pwd)/git_id_ed25519"
                ssh-keygen -t ed25519 -C $user_email -f "git_id_ed25519"
                echo ""               
                echo "launching ssh agent..."
                eval "$(ssh-agent -s)"
                echo "adding ssh key to agent..."
                # key mane should be definded and also in .bashrc file
                ssh-add "git_id_ed25519"
                popd "$@" > /dev/null
                
                #Setting ssh agent for windows
                cp "$SRC_GIT/ssh-agent_winsetup._cmd" "$HOME/ssh-agent_winsetup.cmd"
                cp "$SRC_GIT/run_ssh-agent_winservice._ps1" "$HOME/run_ssh-agent_winservice.ps1"

                # execute bat script through git-bash 
                # $INSTALLDIR/$GITHOME/git-bash.exe --no-needs-console --hide --no-cd --command="$HOME/ssh-agent_winsetup.cmd"
                $HOME/ssh-agent_winsetup.cmd
                
                # for signing comits by SSH key
                "$INSTALLDIR/$GITHOME"/cmd/git config --global gpg.format ssh
                "$INSTALLDIR/$GITHOME"/cmd/git config --global user.signingkey $HOME/.ssh/git_id_ed25519.pub

                # launching ssh on git-bash
                cp "$SRC_GIT/._bashrc" "$HOME/.bashrc"
                cp "$SRC_GIT/._bash_profile" "$HOME/.bash_profile"

                ENVIRONMENT_VARS_WIN+="echo Starting ssh agent... "
                ENVIRONMENT_VARS_WIN+=$'\n'
                ENVIRONMENT_VARS_WIN+="net start ssh-agent"
                ENVIRONMENT_VARS_WIN+=$'\n'
                ENVIRONMENT_VARS_WIN+="ssh-add %~d0"
                ENVIRONMENT_VARS_WIN+=$HOME_WIN
                ENVIRONMENT_VARS_WIN+="\.ssh\git_id_ed25519"
                ENVIRONMENT_VARS_WIN+=$'\n'
                echo ""
                echo "  SSH setup complete"
                echo "  Add the SSH public key to your account on GitHub. For more information,"
                echo "  see: https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account"
                break
                ;;
            n)
                break 
                ;;
            
            *)
                echo -e "\n\e[33m  Invalid choice.\e[0m Please try again."
                ;;
        esac
    done

    # for launching git on windiws - gt.bat
    #_#
    # check_var
    # same to INSTALLDIR_WIN and INSTALLDIR
    INSTALLDIR_WIN=${INSTALLDIR//['/']/\\}
    INSTALLDIR_WIN=${INSTALLDIR_WIN:2}
    #touch $HOME/gt.bat # launch git with new HOME
    echo "@echo off" > $HOME/gt.bat
    echo "set installdir=$INSTALLDIR_WIN" >> $HOME/gt.bat
    echo "set bashhome=$HOME_WIN" >> $HOME/gt.bat
    echo "set githome=\\$GITHOME" >> $HOME/gt.bat
    cat "$SRC_GIT/gt._bat" >> $HOME/gt.bat
    chmod 777 $HOME/gt.bat
    BOOL_GIT_INSTALLED="y"
}

# ========== Extensions for VSC ===========

# Material icons VSC extension installation
material_icon_extension () {
    echo material_icon_extension - ok
    echo ""
    # "$INSTALLDIR/$VSCHOME/bin/code" --install-extension pkief.material-icon-theme
}

# C/C++  VSC extension installation
c_extension() {
    echo "c_extension - Ok"
    echo ""
    # echo "Installing C/C++ ms-vscode.cpptools extension for VSC..."
    # "$INSTALLDIR/$VSCHOME/bin/code" --install-extension ms-vscode.cpptools
}

# Python extension installation
py_extension() {
    echo "py_extension - Ok"
    echo ""
    # echo "Installing Python ms-python.python extension for VSC..."
    # "$INSTALLDIR/$VSCHOME/bin/code" --install-extension ms-python.python
}

# ========== final initialization and test ===========

# This sould be run after installation of all apps in oder to include all their (java, python ets.) paths in 
# temporary PATH variable while starting VSCode through code.cmd(win) or code(sh) scripts
# Setting temporary PATH variable in  $INSTALLDIR$VSCHOME/bin/code.cmd | code
vscode_startup_scripts() {
    echo 
    if [ -f "$INSTALLDIR/$VSCHOME/bin/code.cmd" ]; then
        cp "$INSTALLDIR/$VSCHOME/bin/code.cmd" "$INSTALLDIR/$VSCHOME/bin/code.old_cmd"
    fi
    
    if [ -f "$INSTALLDIR/$VSCHOME/bin/code" ]; then
        cp "$INSTALLDIR/$VSCHOME/bin/code" "$INSTALLDIR/$VSCHOME/bin/code_old"
    fi

    echo '@ECHO OFF' > "$INSTALLDIR/$VSCHOME/bin/code.cmd"
    echo "rem For SSH check if components installed in Windows\System32\OpenSSH" >> "$INSTALLDIR/$VSCHOME/bin/code.cmd"
    # INSTALLDIR:~2 - INSTALLDIR variable string without 2 first letters, i.e. without drive letters (C: - for instance)
    # It gives us the opportunity to set the correct drive letter in PATH variable, even if we will use installation on a USB drive with an assigned random drive letter
    # WRITE_PATH uses extra "%" for correct writing PATH to code.cmd - %~d0% but not its value (c: - for instance)
    # %~d0 shows the current drive letter where <code.cmd> is evoked

    # set path in cmd script for VSCode startup
    echo "$ENVIRONMENT_VARS_WIN" >> "$INSTALLDIR/$VSCHOME/bin/code.cmd"
    echo "set PATH="$DEV_PATH_WIN"%PATH%" >> "$INSTALLDIR/$VSCHOME/bin/code.cmd"
    echo "@ECHO Current PATH: = %PATH%" >> "$INSTALLDIR/$VSCHOME/bin/code.cmd"
    cat "$INSTALLDIR/$VSCHOME/bin/code.old_cmd" >> "$INSTALLDIR/$VSCHOME/bin/code.cmd"
    
    # Set path in sh script for VSCode startup
    # Path variable temporary changed adding search paths to all toolchain apps  git, maven, and etc.
    # code script exports PATH varisble to its child process - Code.exe in order for tollchain apps 
    # be temporary availsble while Code.exe is runing
    
    sed "2i\export PATH=$DEV_PATH_LNX\$PATH" "$INSTALLDIR/$VSCHOME/bin/code_old">"$INSTALLDIR/$VSCHOME/bin/code"
    
    #for control
    echo "DEV_PATH_WIN -- $DEV_PATH_WIN"
    echo "DEV_PATH_LNX -- $DEV_PATH_LNX"
    echo ""
    # echo "PATH --- $PATH"
    # echo code.cmd:
    # cat "$INSTALLDIR/$VSCHOME/bin/code.cmd"
    # echo ===
    # echo code
    # cat "$INSTALLDIR/$VSCHOME/bin/code"
}

toolchain_test() {
    # Checking toolchain availability through the 'PATH' variable
    echo "------------------------------------------------------------------------------"
    # working directiry  for path testing - ../VSCHOME/bin or ../GITHOME/cmd
    if [ -d  "$INSTALLDIR/$VSCHOME/bin" ]; then
        pushd "$INSTALLDIR/$VSCHOME/bin" "$@" > /dev/null
    else
        pushd "$INSTALLDIR/$GITHOME/cmd" "$@" > /dev/null
    fi

    JAVA_HOME="$(dirname "$(dirname "$(realpath "$0")")")/$JDKHOME/$JDK"
    temp_path=$PATH
    PATH="$DEV_PATH_LNX"

    #for check
    echo "checking PATH = $PATH"
    echo "JAVA_HOME = $JAVA_HOME"
    echo ""
    echo ""
    echo "  Cecking installed conponents availability..."
    echo "------------------------------------------------------------------------------"
    echo "VSC test"
    code --version
    echo ""
    echo "gcc test"
    gcc --version
    echo ""
    echo "g++ test"
    g++ --version
    echo ""
    echo "gdb test"
    gdb --version
    echo ""
    echo "Python test"
    python --version
    echo ""
    echo "java test"
    java --version
    echo ""
    echo "maven test"
    mvn.cmd --version
    echo ""
    echo "git test"
    git --version
    # returning to the working folder
    PATH=$temp_path
    popd "$@" > /dev/null
    echo ""
    echo -e "  \e[32mInstasalation finished!\e[0m"
    read -s -p $'  press \e[32m[ENTER]\e[0m to continue'
}

# # Making Uninstall.sh file - TBD
# make_uninstall_bat() {
#     touch $INSTALLDIR/uninstall.sh
#     echo "#!/bin/bash" >> $INSTALLDIR/uninstall.sh
#     echo "VSCHOME=$VSCHOME" >> $INSTALLDIR/uninstall.sh
#     echo "MINGWHOME=$MINGWHOME" >> $INSTALLDIR/uninstall.sh
#     echo "PYTHONHOME=$PYTHONHOME" >> $INSTALLDIR/uninstall.sh
#     echo "JDKHOME=$JDKHOME" >> "$INSTALLDIR/uninstall.sh"
#     echo "INSTALLDIR=$INSTALLDIR" >> $INSTALLDIR/uninstall.sh
#     cat uninstall._sh >> $INSTALLDIR/uninstall.sh
#     echo ""
#     echo "  Uninstall script complete!"
#     # read -s -p $'  press \e[32m[ENTER]\e[0m to continue'
# }


# ========== Menus ===========
custom_menu() {   
    local choice01=""
    local invalid01msg=""
    while :
    do
        clear
        echo ""
        echo -e "  Custom installation option:"
        echo -e "   '\e[32mc\e[0m' - custom full installation of: GIT, VSC, Java, Maven, MinGw, Python"
        echo -e "   '\e[32;1mg\e[0m' - installation of GIT and/or Visual Source Code only"
        echo -e "   '\e[32md\e[0m' - check and update your .Net"
        echo -e "   '\e[32mf\e[0m' - full quick installation of all apps with default settings"
        echo -e "   '\e[32mq\e[0m' - for quit to main menu"
        echo -e "  $invalid01msg"
        read -p "  Enter choice: " -n 1  choice01
        invalid01msg="" # Refresh erroro message after each case option
        echo ""

        case "$choice01" in
            f)
                option_full
                break
                ;;
            c)
                option_custom
                exit 0
                ;;
            g)
                option_git_vsc
                break

                ;;
            d) 
                option_dotnet
                ;;
            
            q)
                break
                ;;
            *)
                    invalid01msg="\e[33mInvalid choice.\e[0m Please try again keys above."
                ;;
        esac
    done
    
}

main_menu() {    
    local choice023=""
    local invalid023msg=""
    cd $SRC_PATH # making working directory as source installation dir. 
    while :
    do
        # clear
        echo "------------------------------------------------------------------------------"
        echo " VS Code portable installation enables all data created and maintained by"
        echo " the app to live near itself, as well as other portable apps, so they coud be"
        echo " moved around across environments, for example, on a USB drive."
        echo "------------------------------------------------------------------------------"
        echo ""
        
        

        echo -e "  Installing to: \e[37;1m$INSTALLDIR\e[0m"
        echo ""
        echo -e "  Main installation options:"
        echo -e "   '\e[32mp\e[0m' - change installation path"
        echo -e "   '\e[32;1ma\e[0m' - auto quick installation of GIT, VSC, Java, Maven"
        echo -e "   '\e[32mi\e[0m' - informaton"
        echo -e "   '\e[32mc\e[0m' - custom installation"
        echo -e "   '\e[32mq\e[0m' - quit installation"
        echo -e "  $invalid023msg"
        read -p "  Enter choice: " -n 1  choice023
        invalid023msg="" # Refresh error message after each case option

        echo ""

        case "$choice023" in
            p) 
                path_set
                ;;
            a)
                option_auto
                exit 0
                ;;
            c)
                custom_menu
                ;;
            q)
                echo ""
                echo "  Quitting installation..."
                #read -s -p $'  press \e[32m[ENTER]\e[0m to continue'
                exit 0
                ;;
            i)
                annatation
                ;;    
            *)
                    invalid023msg="\e[33mInvalid choice.\e[0m Please try again keys above."
                ;;
        esac
    done
}

# ========== Main ===========
main_menu
read -s -p $'  press \e[32m[ENTER]\e[0m to continue'
exit 0


# clear
# echo "  Choose install option:"
# echo -e "   '\e[32mf\e[0m' - for a full installation with castomization,"
# #echo "   'a' - for auto quick installation,"
# echo -e "   '\e[32mg\e[0m' - for Git installation,"
# echo -e "   '\e[32md\e[0m' - for .Net 4.8 installation only,"
# echo -e "   '\e[32mq\e[0m' - for quit"
# while :
# do
# locl choise
# read -p "  Enter choice: " -n 1  choice
# echo ""
#     case "$choice" in
#         p) 
#             path_set
#             ;;
#         a)
# 	        option_auto
#  	        exit 0
#             ;;
#         g)
#             path_set
#             git_install
#  	        exit 0
#             ;;
#         f)
#             option_full
#  	        exit 0
#             ;;
#         d)
# 	        dotnet_check
#  	        exit 0
#             ;;
#         q)
#             echo "\n  Quitting instalation"
#             exit 0
#             ;;
#         *)
#                 echo -e "  \e[33mInvalid choice.\e[0m Please try again."
#             ;;
#     esac
# done
# exit 0

# ======================
# Useful add-ons for VSC
# ======================
#
# Debug Visualizer - UId:hediet.debug-visualize
# Material Icon Theme - иконки UId:pkief.material-icon-theme
# http://code.visualstudio.com
# http://vscode.dev
# http://vscodium.com
# http://open-vsx.org
# http://emmet.io
# http://github.com/tonsky/FiraCode
# Community Material Theme
# Bracket-Pair-Colorizer & Bracket-Pair-Colorizer-2
# Better Comments
# Indent-rainbow
# Path Intellisense
# Live Server
# Prettier
# PHP Intelephense
# GitLens — Git supercharged
# ESLint
# Quokka.js
# Code Runner
# Duckly: Pair Programming with any IDE
# pair-programming-timer ???
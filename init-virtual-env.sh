#!/bin/bash

if [ -t 1 ]; 
then
    bConsole=1
    blue_yellow="\033[1;33;44m"
    blue="\033[1;33;42m"
    off_color="\033[0m"
    red_warning="\033[1;31;46m"
    white_gray="\033[1;30;47m"
fi

C_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd ${C_DIR}

# depandence

dependences=$HOME/.virtual-python/dependences

# sudo apt-get -y install python-dev libffi-dev libssl-dev
# sudo apt-get -y -f install

function install()
{
    exit 0
    # install name version format where url
}

function installReadline()
{
    exit 0
    #ftp://ftp.cwru.edu/pub/bash/readline-6.3.tar.gz
    #ftp://ftp.gnu.org/gnu/readline/readline-6.3.tar.gz
}

function installSqlite()
{
    exit 0
    #https://www.sqlite.org/2016/sqlite-autoconf-3130000.tar.gz
}

function updateOpenSSL()
{
    lastOpenSSL="1.0.2"
    nowOpenSSL=`openssl version|cut -c 9-13`

    if [ "${lastOpenSSL}" = "${nowOpenSSL}" ]
    then
        echo -e "${blue}${nowOpenSSL} openSSL is ok...${off_color}"
    else

        dependences_openssl=`${dependences}/bin/openssl version|cut -c 9-13`
        if [ "${lastOpenSSL}" = "${dependences_openssl}" ]
        then
            echo -e "${blue}${nowOpenSSL} openSSL is ok...${off_color}"
        else
            echo -e "${blue}${nowOpenSSL} is too old, should update to lastOpenSSL...${off_color}"

            if [ -f "openssl-1.0.2h.tar.gz" ]
            then
                rm -rf "openssl-1.0.2h.tar.gz"
            fi

            wget "http://mirror.switch.ch/ftp/mirror/openssl/source/openssl-1.0.2h.tar.gz" --no-check-certificate

            tar -zxf "openssl-1.0.2h.tar.gz"
            cd "openssl-1.0.2h"
            ./config --prefix=${dependences} shared zlib-dynamic
            make
            make install

            cd ../
            rm -rf "openssl-1.0.2h*"
        fi
    fi
}

updateOpenSSL



# python

arg="$1"


if [ "${arg}X" = "X" ]
then
    pyversion="2.7.9"
else
    pyversion=${arg}
fi


pyhome="$HOME/.virtual-python/${pyversion}"
pysrc="Python-${pyversion}.tgz"

function xSrc()
{
    if [ -f "${pysrc}" ]
    then
        echo -e "${blue}Going to extact ${pysrc}...${off_color}"
        tar -zxf ${pysrc}
    else
        echo -e "${red_warning}Download python failed, please check version if like Python-2.7.9.tgz,  will exit${off_color}"
        exit 0
    fi
}

function installPython()
{
    srcD="Python-${pyversion}"
    if [ -d "${srcD}" ]
    then
        echo -e "${blue_yellow}cd the directory ${srcD}...${off_color}"
        cd "${srcD}"

        echo -e "${blue_yellow}new directory ${pyhome}...${off_color}"
        mkdir -p "${pyhome}"

        echo -e "${blue_yellow}./configure ...${off_color}"
        # ./configure "--prefix=${pyhome}" --enable-ipv6 
        LDFLAGS="-lcrypto -lssl -Wl,-rpath=$HOME/.virtual-python/dependences/lib" CPPFLAGS="-I/home/scrapyer/.virtual-python/dependences/include"  ./configure --prefix=${pyhome}

        echo -e "${blue_yellow}make source ...${off_color}"
        make

        echo -e "${blue_yellow}install ${srcD} to directory ${pyhome}...${off_color}"
        make install

        echo -e "${blue_yellow}check ${srcD} if ok in ${pyhome}...${off_color}"

        if [ -f "${pyhome}/bin/python" ]
        then
            echo -e "${blue} Python is installed success ... ${off_color}"
        else
            linkPython
        fi

        v=`${pyhome}/bin/python -V`

        if [ "Python ${pyversion}"="${v}" ]
        then
            echo -e "${blue} ${srcD} is installed success ... ${off_color}"
            cd ../
        else
            echo -e "${red_warning}install python error, not the same verision  will exit${off_color}"
            cd ../
            exit 0
        fi
    else
        echo -e "${red_warning}Extract error,  will exit${off_color}"
        cd ../
        exit 0
    fi

    rm -rf "${srcD}*"
}




if [ -d "${pyhome}" ]
then
    echo -e "${blue}Check ${pyhome} directory exist${off_color}"
elif [ -f "${pysrc}" ]
then
    echo -e "${blue_yellow}going to extract ${pysrc}...${off_color}"
    xSrc
    installPython
else
    wget "http://www.python.org/ftp/python/${pyversion}/${pysrc}"
    xSrc
    installPython
fi



# virtual-env



env="virtual-env"

virtual="${pyhome}/bin/virtualenv"


function linkPython()
{

    if [ -f "${pyhome}/bin/python" ]
    then
        echo -e "${blue} python is fine ...${off_color}"
    else
        py=`ls -l ${pyhome}/bin/python*|grep -v config|grep -v 'lrwx'|awk '{print $9}'|head -1`
        echo -e "${blue_yellow}link ${py} to python ...${off_color}"
        ln -s "${py}" "${pyhome}/bin/python"
        #if [ -f "${pyhome}/bin/python2" ]
        #then
        #    echo -e "${blue_yellow}link python2 to python ...${off_color}"
        #    ln -s "${pyhome}/bin/python2" "${pyhome}/bin/python"
        #elif [ -f "${pyhome}/bin/python3" ]
        #then
        #    echo -e "${blue_yellow}link python3 to python ...${off_color}"
        #    ln -s "${pyhome}/bin/python3" "${pyhome}/bin/python"
        #else
        #    echo -e "${red_warning}cann't find python,  will exit${off_color}"
        #    exit 0
        #fi
    fi
}


function mustHasV()
{
    if [ -f ${virtual} ]
    then
        echo -e "${blue}Has tool ${virtual} ${off_color}"
    else
        echo -e "${blue_yellow}No virtualenv module, will download it ...${off_color}"
        wget
        https://pypi.python.org/packages/5c/79/5dae7494b9f5ed061cff9a8ab8d6e1f02db352f3facf907d9eb614fb80e9/virtualenv-15.0.2.tar.gz#md5=0ed59863994daf1292827ffdbba80a63 --no-check-certificate
        tar -zxf "virtualenv-15.0.2.tar.gz"
        cd "virtualenv-15.0.2"

        linkPython

        ${pyhome}/bin/python setup.py install
        cd ../
        rm -rf virtualenv-15.0.2 virtualenv-15.0.2.tar.gz

        if [ -f ${virtual} ]
        then
            echo -e "${blue}Success install ${virtual} ${off_color}"
        else
            echo -e "${red_warning}Install virtualenv error,  will exit${off_color}"
            exit 0
        fi
    fi
}



# requirement.txt

rfile="requirements.txt"

function installRequirements(){
    
    if [ -f ${rfile} ]
    then
        echo -e "${blue}Pip install ${rfile} ${off_color}"
        pip install -r ${rfile}
        # pip install -r ${rfile}
    else
        echo -e "${red_warning}No ${rfile} will use system Python!${off_color}"
        exit 0
    fi
}

mustHasV

if [ -d "${env}" ]
then
    echo -e "${blue}Check ${env} directory exist${off_color}"

    source ${env}/bin/activate

    ver=`python -c "import sys;print(sys.version)"|awk '{printf $0}'|cut -c -5`

    if [ "${pyversion}" = "${ver}" ]
    then
        installRequirements
    else
        echo -e "${blue_yellow}Python version ${ver} in ${env} not same as set Python ${pyversion}...  ${off_color}"
        echo -e "${blue_yellow}Del ${env} ...  ${off_color}"
        rm -rf ${env}
        # deactivate
        /bin/bash "$0" "${pyversion}"
    fi



elif [ -f "${env}.tar.gz" ]
then
    echo -e "${blue_yellow}No env but has ${env}.tar.gz, will extract it${off_color}"
    tar -zxf "${env}.tar.gz"
    echo -e "${blue}Extract finished!${off_color}"
    
    
    source ${env}/bin/activate

    ver=`python -c "import sys;print(sys.version)"|awk '{printf $0}'|cut -c -5`


    if [ "${pyversion}" = "${ver}" ]
    then
        installRequirements
    else
        echo -e "${blue_yellow}Python version ${ver} in ${env} not same as set Python ${pyversion}...  ${off_color}"
        echo -e "${blue_yellow}Del ${env} ...  ${off_color}"
        rm -rf ${env}
        # deactivate
        /bin/bash "$0" "${pyversion}"
    fi


else
    echo -e "${blue_yellow}no ${env} and no ${env}.tar.gz ...${off_color}"

    ${virtual} -p ${pyhome}/bin/python ${env} --no-site-packages
    if [ -f ${rfile} ]
    then

        echo -e "${blue_yellow}Find ${rfile} will use pip to install it ...  ${off_color}"
        source ${env}/bin/activate
        installRequirements

        
    else
        echo -e "${red_warning}No ${env} and No ${env}.tar.gz,  will exit${off_color}"
        exit 0
    fi
fi

python -V

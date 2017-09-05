#!/bin/bash

install() {
  # Use colors, but only if connected to a terminal, and that terminal
  # supports them.
  if which tput >/dev/null 2>&1; then
      ncolors=$(tput colors)
  fi
  if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
    RED="$(tput setaf 1)"
    GREEN="$(tput setaf 2)"
    YELLOW="$(tput setaf 3)"
    BLUE="$(tput setaf 4)"
    BOLD="$(tput bold)"
    NORMAL="$(tput sgr0)"
  else
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    BOLD=""
    NORMAL=""
  fi

  # Only enable exit-on-error after the non-critical colorization stuff,
  # which may fail on systems lacking tput or terminfo
  set -e

  export PATH=$HOME/.local/bin:$PATH
  hash pyenv > /dev/null 2>&1 && {
	printf "${YELLOW}You have installed py-env already.\n${NORMAL}"
    printf "${BLUE}Usage: pyenv -h${NORMAL}\n"
	exit 1
  }

  if [ ! -n "$VPY" ]; then
    VPY=~/.virtual-python
  fi

  if [ -d "$VPY" ]; then
    printf "You already have py-env installed.\n"
  fi

  printf "${BLUE}Downloading lastest py-env ...${NORMAL}\n"
  hash wget >/dev/null 2>&1 || {
    echo "Error: wget is not installed"
    exit 1
  }

  if [ ! -d "$VPY/temp" ]; then
	  mkdir "$VPY/temp"
  fi		  

  VPY_FILE="$VPY/temp/py-env.sh"

  if [ -f $VPY_FILE ] || [ -h $VPY_FILE ]; then
    printf "${YELLOW}Found $VPY_FILE.${NORMAL} ${GREEN}Cover the old file.${NORMAL}\n";
  fi

  wget "https://github.com/jiusanzhou/py-env/raw/master/py-env.sh" -O "$VPY_FILE" --no-check-certificate > /dev/null 2>&1

  # Move the bash file to .local/bin
  if [ ! -d $HOME/.local ]; then
	  mkdir -p $HOME/.local/bin
  fi

  printf "${BLUE}Installing the pyenv to ~/.local/bin${NORMAL}\n"
  cp "$VPY_FILE" $HOME/.local/bin/pyenv
  chmod +x $HOME/.local/bin/pyenv
  unset VPY_FILE

  # Check pyenv install success.
  if hash pyenv >/dev/null 2>&1; then
      printf "${BLUE}Congraitulations for your successfully install!${NORMAL}\n"
      printf "${BLUE}Usage: pyenv -h${NORMAL}\n"
  else
      printf "I can't install pyenv automatically.\n"
      printf "${BLUE}Please manually install from my github: https://github.com/jiusanzhou/py-env!${NORMAL}\n"
  fi

  printf "${GREEN}"
  echo '         __                                __   '
  echo '  ____  / /_     ____ ___  __  __    _____/ /_  '
  echo ' / __ \/ __ \   / __ `__ \/ / / /   / ___/ __ \ '
  echo '/ /_/ / / / /  / / / / / / /_/ /   (__  ) / / / '
  echo '\____/_/ /_/  /_/ /_/ /_/\__, /   /____/_/ /_/  '
  echo '                        /____/                  ....is now installed!'
  echo ''
  echo 'p.s. Follow me at https://twitter.com/John_Zoe.'
  echo ''
  echo ''
  printf "${NORMAL}"

  # Check dependencies installed
  printf "${YELLOW}"
  echo ''
  echo '   You should to install C dependencies manually.           '
  echo ''
  echo '   If you are on debain/ubuntu use "sudo apt-get install"   '
  echo ''
  echo '   sudo apt-get install zlibg1-dev libssl-dev libsqlite3-dev libncurses5-dev libbz2-dev libreadline-dev libdb4.8-dev libexpat1-dev libxml2-dev libxslt1-dev libmysqlclient-dev tcl8.5-dev,tk8.5-dev           '
  echo ''
  echo ''
  printf "${NORMAL}"
}

main() {
	install
}

main

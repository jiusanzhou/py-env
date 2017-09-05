#!/bin/bash

usage() {
  NAME=$(basename "$0")
  printf "$GREEN"	  
  echo "Usage of $NAME:" 
  echo "		$NAME init|create [<python_version>] [<env_name>] Install python of special version and init virtual env with named,"
  echo "		 	Will run 'pip install -r ...' if  current directory has requirements.txt file."
  echo "		$NAME list List all version of python."
  echo "		$NAME show List all projects which use virtual env."
  echo "		$NAME --help"
  printf "$NORMAL"
  exit
}

main() {
	
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

  VPY=~/.virtual-python
  VPY_DEPEND=$VPY/dependences
  VPY_CACHE=$VPY/cache
  VPY_TEMP=$VPY/temp

  PYENV_HOME=~/PYENV_HOME
  export PYENV_HOME=~/PYENV_HOME


  while test $# != 0
  do
	  case "$1" in
	  init|create)
		  echo "init virtual env."
		  ;;
	  list)
	      echo "list all python"
		  ;;
	  show)
	      echo "list all virtual env"
		  ;;
	  *)
		usage
		;;
      esac
	  shift
  done 	  
}

main $#

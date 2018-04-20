#!/bin/bash
# Functions

exists() {
  type "$1" >/dev/null 2>/dev/null
}

echo_header() {
  echo "     === $1 ==="
}

echo_item() {
  if [[ "$2" == "green" ]]; then
    echogreen "---> $1"
  elif [[ "$2" == "red" ]]; then
    echored "---> $1"
  else
    echo "---> $1"
  fi
}

get_boolean_response() {
  while true; do
    read -p "$1 (Y/N) " yn
    case $yn in
      [Yy]* ) return 0;;
      [Nn]* ) return 1;;
      * ) echo "Please answer yes or no";;
    esac
  done
}

system_is_OSX() {
  if [[ "$(uname)" == "Darwin" ]]; then
    return 0
  else
    return 1
  fi
}

system_is_linux() {
  if [[ "$(expr substr $(uname -s) 1 5)" == "Linux" ]]; then
    return 0
  else
    return 1
  fi
}

# ----- Danielo custom

clean_docker() {
	docker rmi -f $(docker images | grep none | awk '{ print $3 }')
}

# Executes last command as sudo.
__executeLastCommandAsSuperUser() {
  sudo $(history -p \!\!)
}

confirm() {
    # call with a prompt string or use a default
    read -r -p "${1:-Are you sure? [y/N]} " response
    case $response in
        [yY][eE][sS]|[yY])
            true
            ;;
        *)
            false
            ;;
    esac
}
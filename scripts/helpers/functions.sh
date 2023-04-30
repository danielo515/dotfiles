#!/bin/bash
# This is a litlle collection of util functions. They are basically mini commands
# that I want to use in my scritps or in my shell sessions.
# Functions

# Can be used in if conditions to check the existence of something
exists() {
  type "$1" >/dev/null 2>/dev/null
}


favs() {
  fd . $(chezmoi source-path) | fzf --preview 'bat --color=always --style=header,grid --line-range :500 {}'
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

do_if_yes() {
  question="$1"
  cmd=$2
  if get_boolean_response "$question"; then
    eval $cmd
  else
    echo_item Skip "$question" red
  fi
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

# ----- Borrowed from https://github.com/carloscuesta/dotfiles/blob/master/osx/utils.sh

is_git_repository() {
    git rev-parse &> /dev/null
    return $?
}

execute() {
    eval "$1" &> /dev/null
    print_result $? "${2:-$1}"
}

print_success() {
    echogreen "  [✔] $1\n"
}

print_error() {
    echored "  [✖] $1 $2\n"
}

print_result() {
    [ $1 -eq 0 ] \
        && print_success "$2" \
        || print_error "$2"

    return $1
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

# ----- npm related

init_packages(){
  for d in $(ls); do
    (cd $d && npm init -y)
  done
}

inject_in_pkg_json(){
  node -e "const [,key,val]=process.argv,pkg=require('./package');
  pkg[key] = val
  require('fs').writeFileSync('package.json',JSON.stringify(pkg,null,2),'utf8')
  " $1 $2
}

inject_script(){
  node -e "const [,name,val]=process.argv,pkg=require('./package');
  pkg.scripts[name] = val
  require('fs').writeFileSync('package.json',JSON.stringify(pkg,null,2),'utf8')
  " $1 $2
}

fake_monorepo(){
  mkdir $1
  cd $1
  npm init -y
  inject_script publish "lerna publish"
  inject_in_pkg_json author "Danielo Rodríguez"
  npm i -D lerna
  npx lerna init --independent
  ( cd packages && mkdir {alpha,bravo,charlie,tango} && init_packages)
}

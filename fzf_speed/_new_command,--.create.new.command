#!/usr/bin/env sh
read -rp "Enter script name:" NAME
read -rp "Description dot separated:" DESC
script_path=$(realpath "$0")
echo $script_path
newscript="$(dirname $script_path)/_$NAME,--.$DESC"
echo $newscript
read -rp "Press enter to continue or ctrl+c to exit"
touch $newscript
chmod +x $newscript




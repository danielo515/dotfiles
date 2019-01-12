#!/bin/bash
# Install Node and NPM Modules

source 'tools/colors.sh'
source 'tools/functions.sh'

if get_boolean_response "Do you want to install some global npm packages?"; then
    
    for lib in bower yo
    do
        if get_boolean_response "Do you want to install $lib globally"; then
            npm install -g $lib
            echo_item "Installed $lib" green
        else
            echo_item "Skipping $lib" red
        fi
    done
else
    echo_item "Skipping npm global packages" red
fi

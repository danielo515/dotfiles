#!/usr/bin/env sh
read -rp "Enter script name: " NAME
read -rp "Description: " DESC
DESC=$(echo $DESC | tr ' ' '.')
script_path=$(realpath "$0")
newscript="$(dirname $script_path)/_$NAME,--.$DESC"
gum style --foreground 212 $newscript
if ! $(gum confirm "Are you happy with the result?"); then
  exit 1
fi
echo '#!/usr/bin/env sh' > $newscript
chmod +x $newscript
if $(gum confirm 'Edit the script?'); then
  exec lvim nvim "$newscript"
fi



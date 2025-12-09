#!/bin/bash


Themes=('nge_dark' 'nge_purple' 'nge_blue' 'zelda')
Confs=('waybar' 'walker' 'hypr' 'nvim')

local_pth=~/.local/share/omarchy/themes/

config_pth=~/.config/



printf "Start copying themes\n\n"
for theme in "${Themes[@]}"; do
  cp -r $local_pth$theme/* themes/$theme/
  printf "%s copied\n" $theme
done

printf "\nStart copying config Files\n\n"
for conf in "${Confs[@]}"; do
  cp -r $config_pth$conf/* $conf/
  printf "%s copied\n" $conf
done

printf "\nOperation done\n"

defaulAnswer="Y"
echo -n "Git commit? [Y/n]: "
read -n 1 ans

if [[ $ans == defaulAnswer || $ans == "y" ]]; then
  git add .
  git commit -m "Update DotFiles"
  git push
  echo "Files commited"

else printf "\nFiles not commited" && exit

fi

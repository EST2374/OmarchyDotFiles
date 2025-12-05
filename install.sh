#!/bin/bash

Themes=('nge_dark' 'nge_purple' 'nge_blue')
Confs=('waybar' 'walker' 'hypr' 'nvim')

local_pth=~/.local/share/omarchy/themes/

config_pth=~/.config/



printf "Start copying themes\n\n"
for theme in "${Themes[@]}"; do
  cp -r themes/$theme/* $local_pth$theme/
  printf "%s copied\n" $theme
done

printf "\nStart copying config Files\n\n"
for conf in "${Confs[@]}"; do
  cp -r $conf/* $config_pth$conf/ 
  printf "%s copied\n" $conf
done

printf "\nOperation done\n"

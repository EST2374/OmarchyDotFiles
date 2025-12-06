#!/bin/bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

# Add new Themes here 
Themes=('nge_dark' 'nge_purple' 'nge_blue')
# Add new configs here
Confs=('waybar' 'walker' 'hypr' 'nvim')

local_pth=~/.local/share/omarchy/themes/
config_pth=~/.config/
config_omarchy_pth=$config_pth/omarchy/themes/

echo -e "${BLUE}--- Setting up directories ---${NC}"
mkdir -p "$config_omarchy_pth"
echo -e "${GREEN}Target directories ensured.${NC}"

echo -e "\n${BLUE}--- Starting Theme Installation ---${NC}"
for theme in "${Themes[@]}"; do
  echo -e "\n${YELLOW}Processing Theme: ${theme}${NC}"  
  
  # Create Directory for the Theme 
  mkdir -p "$local_pth$theme"
  echo -e "  - ${GREEN}Directory created:${NC} $local_pth$theme"

  # Files get copied 
  cp -r themes/$theme/* $local_pth$theme/
  echo -e "  - ${GREEN}Files copied.${NC}"

  dest_link="$config_omarchy_pth$theme"

  if [[ ! -e $dest_link ]]; then
    ln -s "$local_pth$theme" "$dest_link"
    echo -e "  - ${GREEN}Symlink created:${NC} $dest_link -> $local_pth$theme"
  else
    echo -e "  - ${YELLOW}Symlink/Directory already exists, skipping symlink creation.${NC}"
  fi
done

echo -e "\n${BLUE}--- Starting Configuration File Copy ---${NC}"
for conf in "${Confs[@]}"; do
  cp -r $conf/* $config_pth$conf/ 
  echo -e "  - ${GREEN}${conf}${NC} config files copied to $config_pth$conf"
done

echo -e "\n${BLUE}--- Operation Complete ---${NC}"
echo -e "${GREEN}All themes and configuration files have been processed successfully!${NC}\n"

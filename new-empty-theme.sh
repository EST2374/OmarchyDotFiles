#!/bin/bash


echo -n 'New Theme name: '
read -r name
echo 'Theme' ${name,,} 'is getting created'


mkdir -p themes/${name,,}
cp -r themes/nge_dark/* themes/${name,,}/

echo 'Empty Theme' ${name,,} 'was created'
echo 'Default colors from nge_dark'
echo 'You still have to change the colors'

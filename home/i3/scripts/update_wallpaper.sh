#!/bin/sh

IMAGE=$(shuf -e -n1 /home/$USER/.config/i3/wallpapers/**/*)
feh --bg-fill $IMAGE

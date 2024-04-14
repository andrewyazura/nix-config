#!/bin/sh

IMAGE=$(shuf -e -n1 /home/$USER/.config/i3/wallpapers/**/*)
BLANK='#00000000'
DEFAULT='#ffffffff'
WRONG='#561616ff'
VERIFYING='#94931dff'

i3lock \
--show-failed-attempts       \
--insidever-color=$DEFAULT   \
--ringver-color=$VERIFYING   \
\
--insidewrong-color=$DEFAULT \
--ringwrong-color=$WRONG     \
\
--inside-color=$BLANK        \
--ring-color=$DEFAULT        \
--line-color=$BLANK          \
--separator-color=$DEFAULT   \
\
--verif-color=$DEFAULT       \
--wrong-color=$DEFAULT       \
--time-color=$DEFAULT        \
--date-color=$BLANK          \
--layout-color=$DEFAULT      \
--keyhl-color=$WRONG         \
--bshl-color=$WRONG          \
\
--clock                      \
--image=$IMAGE               \
--time-str="%H:%M"           \

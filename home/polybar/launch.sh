#!/bin/sh

polybar-msg cmd quit
polybar 2>&1 | tee -a /tmp/polybar.log & disown

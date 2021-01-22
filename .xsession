#!/bin/sh
#
# .xsession
#

# merge in defaults and keymaps
userresources="${HOME}/.Xresources"
usermodmap="${HOME}/.Xmodmap"
if test -f "${userresources}"; then
	xrdb -merge "${userresources}"
fi
if test -f "${usermodmap}"; then
	xmodmap "${usermodmap}"
fi

# Source ksh startup file
test -r "${HOME}/.profile" && . "${HOME}/.profile"

# Set locale
export LC_CTYPE='en_US.UTF-8'

# Variables for fcitx
export XMODIFIERS=@im=fcitx
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx

# set various devices
setxkbmap -option caps:swapescape & # swap Esc & Capslock
xset r rate 300 50 &                # increase key speed via a rate change
xset b off &                        # turn off bell
xinput --set-prop '/dev/wsmouse' 'WS Pointer Wheel Emulation' 1 &
xinput --set-prop '/dev/wsmouse' 'WS Pointer Wheel Emulation Button' 2 &
xinput --set-prop '/dev/wsmouse' 'WS Pointer Wheel Emulation Axes' 6 7 4 5 &
xbacklight -set 60 -steps 1 -time 5 & # set brightness
sndioctl -q input.mute=1 &            # mute microphone
sndioctl -q output.mute='1' &         # mute speaker
sndioctl -q output.level='0.250' &    # set initial volume

# launch program
dunst > /dev/null &
fcitx -r -d -s 3 > /dev/null &
setbg &
picom > /dev/null &
test ! -s ~/.config/mpd/mpd.pid && mpd &
pass core > /dev/null 2>&1 &

# start window manager
{ pkill -u "$(id -u)" -qf panel; panel; } &
exec dwm


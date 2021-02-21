#!/bin/sh
#
# .xsession
#

exit_xsession()
{
	pkill -u "$(id -u)" -qf '^mpd$|^/bin/sh.*panel'
	exit
}

# Set locale
export LC_CTYPE='en_US.UTF-8'

# Variables for fcitx
export XMODIFIERS=@im=fcitx
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx

# merge in defaults and keymaps
userresources="${HOME}/.Xresources"
usermodmap="${HOME}/.Xmodmap"
[ -f "${userresources}" ] && xrdb -merge "${userresources}"
[ -f "${usermodmap}"    ] && xmodmap "${usermodmap}"

# Source ksh startup file
ksh_profile="${HOME}/.profile"
[ -r "${ksh_profile}" ] && . "${ksh_profile}"

# set various devices
setxkbmap -option caps:swapescape &   # swap Esc & Capslock
xset r rate 300 50 &                  # increase key speed via a rate change
xset b off &                          # turn off bell
xset s off -dpms &                    # disable screen saver blanking
xinput --set-prop '/dev/wsmouse' 'WS Pointer Wheel Emulation' 1 &
xinput --set-prop '/dev/wsmouse' 'WS Pointer Wheel Emulation Button' 2 &
xinput --set-prop '/dev/wsmouse' 'WS Pointer Wheel Emulation Axes' 6 7 4 5 &
xbacklight -set 60 -steps 1 -time 5 & # set brightness
sndioctl -q input.mute='1' &          # mute microphone
sndioctl -q output.mute='1' &         # mute speaker
sndioctl -q output.level='0.250' &    # set initial volume

# launch program
dunst > /dev/null &
fcitx -r -d -s 3 > /dev/null &
setbg &
picom > /dev/null &
{ [ ! -s "${HOME}/.config/mpd/mpd.pid" ] && mpd; } &
pass core > /dev/null 2>&1 &
xidle &

# start window manager
if command -v 'dwm' > /dev/null; then
	{ pkill -u "$(id -u)" -qf '^/bin/sh.*panel'; panel; } &
	dwm
else
       cwm -c "${XDG_CONFIG_HOME:-${HOME}/.config}/cwm/cwmrc"
fi

exit_xsession


#!/bin/sh
#
# .xsession
#

exit_xsession()
{
	pkill -u "$(id -u)" -qf '^mpd$|^/bin/sh.*panel$|^xcape$'
	exit
}

# Source sh startup file
sh_profile="${HOME}/.profile"
[ -r "${sh_profile}" ] && . "${sh_profile}"

# Set locale
export LC_CTYPE='en_US.UTF-8'

# Variables for fcitx
export XMODIFIERS=@im=fcitx
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx

# merge in defaults and keymaps
userresources="${XDG_CONFIG_HOME:-${HOME}/.config}/x11/Xresources"
usermodmap="${XDG_CONFIG_HOME:-${HOME}/.config}/x11/Xmodmap"
[ -r "${userresources}" ] && xrdb -merge "${userresources}"
[ -r "${usermodmap}"    ] && xmodmap     "${usermodmap}"

# set various devices
setxkbmap -option '' # Flush keybindings
case "${EDITOR:-vi}" in
*vi*)
    setxkbmap -layout us -variant dvorak -option caps:swapescape
	;;
*emacs*)
    setxkbmap -layout us -variant dvorak -option ctrl:swapcaps
	;;
esac
xset r rate 300 50                  & # increase key speed via a rate change
xset b off                          & # turn off bell
xset s off -dpms                    & # disable screen saver blanking
xbacklight -set 50 -steps 1 -time 5 & # set brightness
sndioctl -q input.mute='1'          & # mute microphone
sndioctl -q output.mute='1'         & # mute speaker
sndioctl -q output.level='0.250'    & # set initial volume
xinput --set-prop '/dev/wsmouse' 'WS Pointer Wheel Emulation' 1             &
xinput --set-prop '/dev/wsmouse' 'WS Pointer Wheel Emulation Button' 2      &
xinput --set-prop '/dev/wsmouse' 'WS Pointer Wheel Emulation Axes' 6 7 4 5  &
xinput --set-prop '/dev/wsmouse' 'Device Accel Constant Deceleration' '0.7' &

# launch program
fcitx -r -d -s 3                       > /dev/null &
picom                                  > /dev/null &
[ ! -s "${HOME}/.config/mpd/mpd.pid" ] && mpd      &
pass cckname                           > /dev/null &
xidle                                              &
emacs --daemon                                     &

# start window manager
if [ -x "$(command -v dwm)" ]; then
	setbg &
	dunst > /dev/null &
#	pkill -u "$(id -u)" -qf '^/bin/sh.*panel$'; panel &
	dwm
elif [ -x "$(command -v awesome)" ]; then
	awesome
else
	fvwm
fi

exit_xsession

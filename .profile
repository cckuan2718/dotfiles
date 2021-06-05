#!/usr/bin/env zsh

#
# ~/.zprofile 
# Runs on zsh login. Environmental variables are set here.
#

#
# sh initialization
#

PATH="${HOME}/.local/bin:${HOME}/.local/bin/panel:${HOME}/.local/lib:${PATH}"
export PATH HOME TERM

# set default umask
umask 022

#
# Default programs / options
#

# Default programs
export BROWSER='firefox'
export MANPAGER='less'
export OPENER='xdg-open'
export PAGER='less'
export READER='zathura'
export TERMINAL='xterm'
export TERM_BROWSER='lynx -vikeys -accept_all_cookies -scrollbar -assume_charset=utf-8 -display_charset=utf-8'

for e in 'nvim' 'vim' 'nvi' 'vi'; do
	if [ -x "$(command -v "$e")" ]; then
		export EDITOR="$e"
		export VISUAL="$e"
		break
	fi
done

# Default options
export FZF_DEFAULT_OPTS='--bind=alt-h:up,alt-l:down --no-mouse
--color=fg:#ebdbb2,bg:#282828,hl:#fabd2f,fg+:#ebdbb2,bg+:#3c3836,hl+:#fabd2f
--color=info:#83a598,prompt:#bdae93,spinner:#fabd2f,pointer:#83a598,marker:#fe8019,header:#665c54'
export LESS=' -FgiJMQRWX -x 8 '
export LYNX_LSS='/usr/local/share/doc/lynx/lynx_doc/samples/opaque.lss'
export MORE='-is'
export TOP='-s 5 -o cpu'

if [ -x "$(command -v src-hilite-lesspipe.sh)" ]; then
	export LESSOPEN='| src-hilite-lesspipe.sh %s'
fi

#
# Miscellaneous
#

# XDG base directory
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${HOME}/.local/share"

# ${HOME} Clean-up
export LESSHISTFILE='/dev/null'
export PASSWORD_STORE_DIR="${XDG_DATA_HOME:-${HOME}/.local/share}/password-store"
export ZDOTDIR="${XDG_CONFIG_HOME:-${HOME}/.config}/zsh"

# In order to have an interactive (as opposed to login) ksh shell process a 
# startup file, ENV may be set and exported
export ENV="${XDG_CONFIG_HOME:-${HOME}/.config}/ksh/kshrc"

# Configurations
export MPD_HOST="${XDG_CONFIG_HOME:-${HOME}/.config}/mpd/socket"
export NNN_COLORS='3245'
export NNN_OPTS='AdeHoRU'
export PANEL_FIFO="/tmp/panel_$(id -u)"


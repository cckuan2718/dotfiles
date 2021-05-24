#
# ~/.profile for desktop
#

#
# sh/ksh initialization
#

PATH="${HOME}/.local/bin:${HOME}/.local/bin/panel:${HOME}/.local/lib:${PATH}"
export PATH HOME TERM

# In order to have an interactive (as opposed to login) shell process a startup
# file, ENV may be set and exported
export ENV="${HOME}/.config/ksh/kshrc"

# History
export HISTFILE="${HOME}/.cache/ksh/ksh_history"
export HISTSIZE='5000'
export HISTCONTROL='ignoredups:ignorespace'

# set default umask
umask 022

#
# Environmental variables
#

# Default programs
export BROWSER='firefox'
export MANPAGER='less'
export OPENER='xdg-open'
export PAGER='less'
export READER='zathura'
export TERMINAL='xterm'
export TERM_BROWSER='lynx -vikeys -accept_all_cookies -scrollbar -assume_charset=utf-8 -display_charset=utf-8'

if [ -x "$(command -v nvim)" ]; then
	export EDITOR='nvim'
	export VISUAL='nvim'
elif [ -x "$(command -v vim)" ]; then
	export EDITOR='vim'
	export VISUAL='vim'
elif [ -x "$(command -v nvi)" ]; then
	export EDITOR='nvi'
	export VISUAL='nvi'
else
	export EDITOR='vi'
	export VISUAL='vi'
fi

# Default command options
export LESS=' -FgiJMQRWX -x 8 '
export LYNX_LSS='/usr/local/share/doc/lynx/lynx_doc/samples/opaque.lss'
export MORE='-is'
export TOP='-s 5 -o cpu'

if [ -x "$(command -v src-hilite-lesspipe.sh)" ]; then
	export LESSOPEN='| src-hilite-lesspipe.sh %s'
fi

# XDG base directory
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${HOME}/.local/share"

# ${HOME} Clean-up
export LESSHISTFILE='/dev/null'
export PASSWORD_STORE_DIR="${XDG_DATA_HOME:-${HOME}/.local/share}/password-store"

# nnn
export NNN_BMS="c:${HOME}/.config;d:${HOME}/documents;D:${HOME}/downloads;\
h:${HOME};m:${HOME}/music;M:/mnt;p:${HOME}/pictures;s:${HOME}/.local/bin;\
t:${HOME}/tmp;v:${HOME}/videos"
export NNN_COLORS='3245'
export NNN_OPTS='AdeHoRU'

# Miscellaneous
export FZF_DEFAULT_OPTS='--bind=alt-h:up,alt-l:down --no-mouse
--color=fg:#ebdbb2,bg:#282828,hl:#fabd2f,fg+:#ebdbb2,bg+:#3c3836,hl+:#fabd2f
--color=info:#83a598,prompt:#bdae93,spinner:#fabd2f,pointer:#83a598,marker:#fe8019,header:#665c54'
export MPD_HOST="${XDG_CONFIG_HOME:-${HOME}/.config}/mpd/socket"
export PANEL_FIFO="/tmp/panel_$(id -u)"


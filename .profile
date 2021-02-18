#
# ~/.profile for desktop
#

#
# sh/ksh initialization
#

PATH="${HOME}/.local/bin:${HOME}/.local/bin/panel:${HOME}/.local/lib:/bin:/sbin:/usr/bin:/usr/sbin:/usr/X11R6/bin:/usr/local/bin:/usr/local/sbin:/usr/games"
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
export TERM_BROWSER='lynx -vikeys -accept_all_cookies -scrollbar'
export EDITOR='nvim'
export MANPAGER='more'
export OPENER='xdg-open'
export PAGER='more'
export READER='zathura'
export TERMINAL='st'
export VISUAL='nvim'

# Default command options
export LESS='-eiQMX'
export LYNX_LSS='/usr/local/share/doc/lynx/lynx_doc/samples/opaque.lss'
export MORE='-is'
export NEXINIT='set autoindent noexpandtab extended noflash ignorecase number ruler searchincr showmatch showmode tabstop=8'
export TOP='-s 1 -o cpu'

# XDG base directory
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${HOME}/.local/share"

# ${HOME} Clean-up
export LESSHISTFILE='/dev/null'
export PASSWORD_STORE_DIR="${XDG_DATA_HOME:-${HOME}/.local/share}/password-store"

# Miscellaneous
export FZF_DEFAULT_OPTS='--bind=alt-h:up,alt-l:down --no-mouse
--color=fg:#ebdbb2,bg:#282828,hl:#fabd2f,fg+:#ebdbb2,bg+:#3c3836,hl+:#fabd2f
--color=info:#83a598,prompt:#bdae93,spinner:#fabd2f,pointer:#83a598,marker:#fe8019,header:#665c54'
export MPD_HOST="${XDG_CONFIG_HOME:-${HOME}/.config}/mpd/socket"
export PANEL_FIFO="/tmp/panel_$(id -u)"


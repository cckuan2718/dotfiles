#!/bin/sh

#
# ~/.profile 
# Runs on ksh/zsh login. Environmental variables are set here.
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

for e in 'emacs' 'nvim' 'vim' 'nvi' 'vi' 'nano'; do
	if [ -x "$(command -v "$e")" ]; then
		if [ "$e" = 'emacs' ]; then
			export ALTERNATE_EDITOR=''
			export EDITOR='emacsclient'
			export VISUAL='emacsclient --create-frame'
		else
			export EDITOR="$e"
			export VISUAL="$e"
		fi
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

# Location of ksh/zsh startup file and cache file
export SHELL_CONFIG_DIR="${XDG_CONFIG_HOME:-${HOME}/.config}/shell"
export SHELL_CACHE_DIR="${XDG_CACHE_HOME:-${HOME}/.cache}/shell"
export ENV="${SHELL_CONFIG_DIR}/kshrc"
export ZDOTDIR="${SHELL_CONFIG_DIR}"

# create ${SHELL_CACHE_DIR} for command history to work  
if [ ! -d "${SHELL_CACHE_DIR}" ]; then
	mkdir -p "${SHELL_CACHE_DIR}"
fi

# Configurations
export MPD_HOST="${XDG_CONFIG_HOME:-${HOME}/.config}/mpd/socket"
export NEXINIT='
" Settings
set autoindent
set cedit=\
set extended
set ignorecase
set noexpandtab
set noflash
set number
set report=1
set ruler
set showmatch
set showmode
set tabstop=8

" Key bindings
map gg 1G

" Read and append <cmd> stdout to next line, first white space
map rb :r!tmux show-buffer
map rc :r!xclip -o -selection clipboard
map rd :r!diff -u # %
map rs :r!uname -rs
map rt :r!date +\%Y-\%m-\%d\ \%H:\%S

" Formatting
map gF {!}fmt -spw 80
map gS {j!}sort -r
map gf {!}fmt -spw 72
map gh :!hunspell -d en_US %
map gs {!}sort
map gt mm:%s/[[:space:]]*$//
map gx !tmux load-buffer c'
export NNN_COLORS='3245'
export NNN_OPTS='AdeHoRU'
export PANEL_FIFO="/tmp/panel_$(id -u)"

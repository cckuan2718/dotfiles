#!/usr/bin/env ksh

#
# .zshrc
#

#
# Zsh configuration
#

# History
HISTFILE="${XDG_CACHE_HOME:-${HOME}/.cache}/zsh/histfile"
HISTSIZE='5000'
SAVEHIST='5000'
setopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# Settings
setopt   AUTO_CD
setopt   COMPLETE_ALIASES
setopt   EXTENDED_GLOB
setopt   INTERACTIVE_COMMENTS
unsetopt BEEP

# Directory stack
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_MINUS
setopt PUSHD_SILENT
setopt PUSHD_TO_HOME
DIRSTACKSIZE='20'

# Command completion
autoload -Uz compinit
compinit
zmodload zsh/complist
zstyle ':completion:*' menu select
_comp_options+=(globdots) # Include hidden files

# vi mode
bindkey -v
KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Edit line in ${EDITOR} with ctrl-e
autoload edit-command-line
zle -N edit-command-line
bindkey '^e' edit-command-line

# Disable ctrl-s to freeze terminal.
stty stop undef

# Prompt
autoload -U colors && colors
PS1='%(!.%F{red}.%F{yellow})%n%f%F{green}@%f%F{blue}%m%f %F{yellow}%~%f
%(0?.%F{green}.%F{red} %? )%#%f '

#
# Aliases
#

# Base utils
alias cls='clear'
alias cmpr='diff -uNp'
alias cp='cp -iv'
alias df='df -h'
alias du='du -ch'
alias e="${EDITOR:-vi}"
alias ll='ls -aFhl'
alias lld='ls -dFhl'
alias mv='mv -iv'
alias p='ps -l'
alias pg="${PAGER:-less}"
alias pls='doas'
alias pwd='pwd -P'
alias rm='rm -iv'
alias ta='tmux new-session -A -s'
alias tad='ta default'

if [ -x "$(command -v nvi)" ]; then
	alias vi='nvi'
fi

# OpenBSD Ports
alias portsql='sqlite3 /usr/local/share/sqlports'
alias portslol='make 2>&1 | /usr/ports/infrastructure/bin/portslogger .'
alias portsrc='cd $(make show=WRKSRC)'

# Miscellaneous
alias bc='bc -l'
alias cb=' xclip -filter -selection clipboard'
alias cbk="git --git-dir=${HOME}/.dotfiles/ --work-tree=${HOME}"
alias cweb='wget --mirror --convert-links --adjust-extension --page-requisites --no-parent'
alias g='git'
alias rsize='eval $(resize)'
alias tb="${TERM_BROWSER:-lynx}"
alias tman='tmux split-window -h -l 82 man'
alias trem='transmission-remote'
alias yt='youtube-dl --add-metadata --ignore-errors'
alias yta='youtube-dl --extract-audio --audio-format mp3 --embed-thumbnail'

#
# Bookmarks
#

hash -d -- bb="${HOME}/.local/bin"                     \
           cac="${XDG_CACHE_HOME:-${HOME}/.cache}"     \
           cc="${XDG_CONFIG_HOME:-${HOME}/.config}"    \
           dc="${HOME}/documents"                      \
           dd="${HOME}/downloads"                      \
           dt="${XDG_DATA_HOME:-${HOME}/.local/share}" \
           mm="${HOME}/music"                          \
           mn='/mnt'                                   \
           pp="${HOME}/pictures"                       \
           pt='/usr/ports'                             \
           src="${HOME}/.local/src"                    \
           tt="${HOME}/tmp"                            \
           vv="${HOME}/videos"                         \

#
# Functions
#

# Fuzzy edit config files.
fec()
{
	find "${XDG_CONFIG_HOME:-${HOME}/.config}"                           \
	    -type f -maxdepth 3                                              \
	    \! -name '*db*'                                                  \
	    \! -name '*log*'                                                 \
	    \! -name '*pid*'                                                 \
	    \! -name '*sql*'                                                 \
	    \! -path '*GIMP*'                                                \
	    \! -path '*calibre*'                                             \
	    \! -path '*libreoffice*'                                         \
	    \! -path '*mpv/watch_later*'                                     \
	    \! -path '*plugin*'                                              \
	    \! -path '*stat*'                                                \
	    -print0                                                          \
	    | fzf --read0 --print0 -i -0 -1 -m -d 'config/' --with-nth='2..' \
	        --header='Fuzzy edit config files.'                          \
	    | xargs -0 -r ${EDITOR:-vi}
}

# Fuzzy edit scripts
fes()
{
	find "${HOME}/.local/bin/" "${HOME}/.local/lib/" -type f -print0       \
	    | fzf --read0 --print0 -i -0 -1 -m -d 'bin/|lib/' --with-nth='2..' \
	        --header='Fuzzy edit scripts.'                                 \
	    | xargs -0 -r ${EDITOR:-vi}
}

# Fuzzy cmd history
fh()
{
	print -z "$(
		fc -l 1                   \
		    | fzf --no-sort --tac \
		    | sed -E 's/^[[:blank:]]*[0-9]+[[:blank:]]*//'
	)"
}
myip()
{ 
	printf 'External IPv4: %s\n' "$(curl --silent -4 http://ifconfig.co/)"
	printf 'External IPv6: %s\n' "$(curl --silent -6 http://ifconfig.co/)"
}

# cd on quit in nnn
n()
{
	# Block nesting of nnn in subshells
	if [ -n "${NNNLVL}" ] && [ "${NNNLVL:-0}" -ge 1 ]; then
		printf 'nnn is already running\n'
		return
	fi

	# To cd on quit only on ^G
	NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

	nnn "$@"

	if [ -f "${NNN_TMPFILE}" ]; then
		. "${NNN_TMPFILE}"
		rm -f "${NNN_TMPFILE}" > /dev/null
	fi
}

# Generate and view port diff
portsdiff()
{
	cvs diff > "/usr/ports/mystuff/${PWD##*/}.diff"
	less "/usr/ports/mystuff/${PWD##*/}.diff"
}

# View port diff
portslessdiff()
{
	less "/usr/ports/mystuff/${PWD##*/}.diff"
}

# Grep in port Makefiles
portsgrep()
{
	cd /usr/ports && grep "$@" ./*/*/Makefile ./*/*/*/Makefile
}

# Shellcheck all scripts
sc()
{
	find "${HOME}/.local/bin/" "${HOME}/.local/lib/" -type f \
	    -exec shellcheck --exclude=SC2155 {} +
}

# search word in wordnet
sw()
{
	wn "$*" -over
	return 0
}

z()
{
	zathura "$@" &
}

# Load syntax highlighting; should be last.
zsh_syntax_file='/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'
if [ -r "${zsh_syntax_file}" ]; then
	. "${zsh_syntax_file}"
fi


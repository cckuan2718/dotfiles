#!/usr/bin/env ksh

#
# .zshrc
#

#
# Zsh configuration
#

# History
histfile_dir="${XDG_CACHE_HOME:-${HOME}/.cache}/shell"
if [ ! -d "${histfile_dir}" ]; then
	mkdir -p "${histfile_dir}"
fi

HISTFILE="${histfile_dir}/zsh_history"
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

#
# Prompt
#

_ps1_hostname()
{
        if [ -z "${SSH_CONNECTION}" ]; then
                printf '%%F{blue}%%m%%f'
        else
                printf '%%F{red}%%m%%f'
        fi
}

autoload -U colors && colors
setopt PROMPT_SUBST
PS1='%(!.%F{red}.%F{yellow})%n%f%F{green}@$(_ps1_hostname) %F{yellow}%~%f
%(0?.%F{green}.%F{red} %? )%#%f '

#
# Aliases and functions
#

commonrc_file="${XDG_CONFIG_HOME:-${HOME}/.config}/shell/commonrc"
if [ -r "${commonrc_file}" ]; then
	. "${commonrc_file}" 
else
	printf 'zshrc: %s not found\n' "${commonrc_file}" 1>&2
fi

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
# Finish up
#

# Load syntax highlighting; should be last.
for f in '/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' \
         '/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'; do
	if [ -r "$f" ]; then
		. "$f"
		break
	fi
done


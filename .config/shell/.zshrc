#!/usr/bin/env ksh

#
# .zshrc
#

#
# Variables and functions used only in this file
#

shell_config_dir="${SHELL_CONFIG_DIR:-${XDG_CONFIG_HOME:-${HOME}/.config}/shell}"
shell_cache_dir="${SHELL_CACHE_DIR:-${XDG_CACHE_HOME:-${HOME}/.cache}/shell}"

source_in()
{
	for file; do
		if [ -r "${file}" ]; then
			. "${file}"
			return 0
		fi
	done
	printf 'error sourcing %s\n' "$*" 1>&2
}

#
# Options
#

# History
export HISTFILE="${shell_cache_dir}/zsh_history"
export HISTSIZE='5000'
export SAVEHIST='5000'
setopt HIST_EXPIRE_DUPS_FIRST # Expire a duplicate event first when trimming history.
setopt HIST_FIND_NO_DUPS      # Do not display a previously found event.
setopt HIST_IGNORE_ALL_DUPS   # Delete an old recorded event if a new event is a duplicate.
setopt HIST_IGNORE_DUPS       # Do not record an event that was just recorded again.
setopt HIST_IGNORE_SPACE      # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS      # Do not write a duplicate event to the history file.
setopt HIST_VERIFY            # Do not execute immediately upon history expansion.
setopt SHARE_HISTORY          # Share history between all sessions.

# Settings
setopt   AUTO_CD
setopt   COMPLETE_ALIASES
setopt   CORRECT
setopt   EXTENDED_GLOB
setopt   INTERACTIVE_COMMENTS
unsetopt BEEP

# Directory stack
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_MINUS
setopt PUSHD_SILENT
setopt PUSHD_TO_HOME
export DIRSTACKSIZE='20'

#
# Command completion
#

autoload -Uz compinit \
    && compinit -d "${shell_cache_dir}/zcompdump_${ZSH_VERSION}"

# expand regular aliases only in command position
zstyle ':completion:*' completer _extensions _complete _ignored _approximate
zstyle ':completion:*:*:approximate:*' max-errors 1 numeric

# Menu selection will only be started if there are at least 10 matches
zmodload zsh/complist
zstyle ':completion:*' menu select=long

# use cache to proxy the list of results
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${shell_cache_dir}/zcompcache"

# Prevent CVS files/directories from being completed
zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/)CVS'
zstyle ':completion:*:*:cd:*'       ignored-patterns '(*/)#CVS'

# Include hidden files
_comp_options+=(globdots)

# Formats
zstyle ':completion:*:corrections'  format '%F{red}!- %d (errors: %e) -!%f'
zstyle ':completion:*:descriptions' format '%F{cyan}-- %d --%f'
zstyle ':completion:*:messages'     format '%F{purple}-- %d --%f'
zstyle ':completion:*:warnings'     format '%F{red}-- no matches found --%f'

# Group different type of matches under their descriptions
zstyle ':completion:*' group-name ''
zstyle ':completion:*:*:-command-:*:*' group-order alias builtins \
    functions commands

#
# Key bindings
#

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Edit line in ${EDITOR} with ctrl-e
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^e' edit-command-line

# Disable ctrl-s to freeze terminal.
stty stop undef

#
# Prompt
#

autoload -U colors && colors
setopt PROMPT_SUBST

autoload -Uz vcs_info
zstyle ':vcs_info:*'     check-for-changes true
zstyle ':vcs_info:*'     unstagedstr       '%F{red}%B*%f%b'
zstyle ':vcs_info:*'     stagedstr         '%F{green}%B*%f%b'
zstyle ':vcs_info:*'     formats           '%F{cyan}%r/%S%f %F{green}%b%f%u%c'
zstyle ':vcs_info:*'     actionformats     '%F{cyan}%r/%S%f %F{red}%a | %m%f%u%c'
zstyle ':vcs_info:git:*' patch-format      '%7>>%p%<< (%n applied)'

precmd() 
{
	vcs_info 
}

_ps1_hostname()
{
        if [ -z "${SSH_CONNECTION}" ]; then
                printf '%%F{blue}%%m%%f'
        else
                printf '%%F{red}%%m%%f'
        fi
}

PS1='%(!.%F{red}.%F{yellow})%n%f%F{green}@$(_ps1_hostname) %F{yellow}%~%f
%(0?.%F{green}.%F{red} %? )%#%f '
RPS1='${vcs_info_msg_0_}'

#
# Bookmarks
#

hash -d -- bb="${HOME}/.local/bin"                     \
	   ec='/etc'                                   \
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
# Aliases and functions
#

source_in "${shell_config_dir}/commonrc"

#
# Finish up
#

# Load syntax highlighting, should be last.
source_in                                                                  \
    '/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' \
    '/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'


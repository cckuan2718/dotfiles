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
# Zsh configuration
#

# History
HISTFILE="${shell_cache_dir}/zsh_history"
HISTSIZE='5000'
SAVEHIST='5000'
setopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY

# Settings
setopt   AUTO_CD
setopt   COMPLETE_ALIASES
setopt   CORRECT
setopt   EXTENDED_GLOB
setopt   INTERACTIVE_COMMENTS
setopt   PRINT_EXIT_VALUE
unsetopt BEEP

# Directory stack
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_MINUS
setopt PUSHD_SILENT
setopt PUSHD_TO_HOME
DIRSTACKSIZE='20'

#
# Command completion
#

autoload -Uz compinit
compinit -d "${shell_cache_dir}/zcompdump_${ZSH_VERSION}"

# expand regular aliases only in command position
zstyle ':completion:*' completer _expand_alias _complete _ignored
zstyle ':completion:*' regular true

# Menu selection will only be started if there are at least 10 matches
zmodload zsh/complist
zstyle ':completion:*' menu select=10

# use cache to proxy the list of results
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${shell_cache_dir}/zcompcache"

# Prevent CVS files/directories from being completed
zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/)CVS'
zstyle ':completion:*:cd:*'         ignored-patterns '(*/)#CVS'

# Completing process IDs with menu selection
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always

# Include hidden files
_comp_options+=(globdots)

#
# Key bindings
#

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
# Aliases and functions
#

# POSIX shell
source_in "${shell_config_dir}/commonrc"

# zsh specific
alias -g CB='| xclip -filter -selection clipboard'
alias -g CL='| wc -l'
alias -g DN='/dev/null'
alias -g EG='2>&1 | grep -E'
alias -g EH='2>&1 | head'
alias -g EL='2>&1 | less'
alias -g ELS='2>&1 | less -S'
alias -g EN="2> /dev/null"
alias -g ET='2>&1 | tail'
alias -g F='| fmt -spw 72'
alias -g FL='| fmt -spw 80'
alias -g G='| grep -E'
alias -g H='| head'
alias -g L="| less"
alias -g NS='| sort -n'
alias -g RNS='| sort -rn'
alias -g S='| sort'
alias -g SIL='> /dev/null 2>&1'
alias -g US='| sort -u'
alias -g X0='| xargs -0'
alias -g X='| xargs'

#
# Finish up
#

# Load syntax highlighting, should be last.
source_in                                                                  \
    '/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' \
    '/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'


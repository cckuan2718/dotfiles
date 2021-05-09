#!/bin/sh
# Function:
# *   A dmenu binary prompt script.
# *   Gives a dmenu prompt labeled with $1
# Usage:
# *   prompt 'Do you want to shutdown?'
# Dependency:
# *   dmenu(1)
# Author:
# *   Chang, Chu-Kuan <cckuan@changchukuan.name>

prompt()
{
	prompt_env='cli'
	while getopts 'cx' opt; do
		case "${opt}" in
		'c')
			prompt_env='cli'
			;;
		'x')
			if [ -x "$(command -v dmenu)" ]; then
				prompt_env='xorg'
			else
				printf 'prompt: dmenu not found\n' 1>&2
				printf 'prompt: fall back to cli mode\n' 1>&2
				prompt_env='cli'
			fi
			;;
		esac
	done
	shift "$((OPTIND - 1))"

	case "${prompt_env}" in 
	cli)
		printf '%s (y/N) ' "$1"
		read -r ans
		;;
	xorg)

		ans="$(printf 'No\nyes' | dmenu -p "$1")"
		;;
	esac

	case "${ans}" in
	[yY]*)
		return 0
		;;
	*)
		return 1
		;;
	esac
}


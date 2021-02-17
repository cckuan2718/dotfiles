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
	ans="$(printf 'no\nyes' | dmenu -p "$1")"

	case "${ans}" in
	'yes')
		return 0
		;;
	*)
		return 1
		;;
	esac
}


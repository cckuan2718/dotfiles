#!/bin/sh
# Function:
# *   print progress string
# Usage:
# *   progress_string <length> <perc> <filled_icon> <lead_icon> <unfilled_icon>
# *   there should not be any leading 0 in <perc>, leading 0 in number may
#     cause the number to be treat as octant
# *   For instance:
#     $ progress_string.sh 10 '=' '>' '-' 50
#     ====>-----
# Author:
# *   Chang, Chu-Kuan <cckuan@changchukuan.name>

progress_string()
{
	length="$1"
	perc="$2"
	filled_icon="$3"
	lead_icon="$4"
	unfilled_icon="$5"

	# calculate how many items need to be filled and not filled
	filled_cnt="$(( length * perc / 100 ))"
	unfilled_cnt="$(( length - filled_cnt ))"

	# Assemble the bar string
	str="$(printf "%${filled_cnt}s" "${lead_icon}" | tr ' ' "${filled_icon}")"
	str="${str}$(printf "%${unfilled_cnt}s" | tr ' ' "${unfilled_icon}")"

	printf '%s' "${str}"
}


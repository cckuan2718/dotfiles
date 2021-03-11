#!/bin/sh
# Program:
# *   Feed script a url or file location.
#     If an image, it will view in sxiv,
#     if a video or gif, it will view in mpv
#     if a music file or pdf, it will download,
#     otherwise it opens link in browser.
# *   used in urlscan
# Dependency:
# *   sxiv(1)
# *   mpv(1)
# *   curl(1)
# Author:
# *   Chang, Chu-Kuan <cckuan@changchukuan.name>

readonly file="$1"
readonly progname="$(basename "$0")"

# If no url given. Opens browser. For using script as $BROWSER.
if [ -z "${file}" ]; then
	${BROWSER:-firefox}
	exit 1
fi

case "${file}" in
*mkv|*webm|*mp4|*youtube.com/watch*|*youtube.com/playlist*|*youtu.be*)
	mpv -quiet "${file}" > /dev/null 2>&1 &
	;;
*png|*jpg|*jpe|*jpeg|*gif)
	if tmpfile="$(mktemp -t url_handler.XXXXXXXXXX)"; then
		curl -sL "${file}" > "${tmpfile}" \
		    && sxiv -a "${tmpfile}" > /dev/null 2>&1
		rm -f "${tmpfile}"
	fi &
	;;
*mp3|*flac|*opus|*mp3?source*)
	curl -LO "${file}" > /dev/null 2>&1 &
	;;
*)
	if [ -f "${file}" ]; then
		${TERMINAL:-xterm} -e ${EDITOR:-vi} "${file}" > /dev/null 2>&1 &
	else
		${BROWSER:-firefox} "${file}" > /dev/null 2>&1 &
	fi
	;;
esac


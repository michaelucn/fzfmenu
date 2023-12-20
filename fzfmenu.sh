#!/usr/bin/env bash

set -f;
IFS=:;
get_selection() {
	for dir in $PATH; do
		set +f;
		[ -n "$p" ] || p=.;
		for file in "$dir"/.[.!]* "$dir"/..?* "$dir"/*; do
			[ -f "$file" ] && [ -x "$file" ] && printf '%s\n' "${file##*/}"
		done;
	done | fzf
}

if selection=$( get_selection ); then
	if type -t swaymsg > /dev/null; then
		echo "$selection";
	else
		exec "$selection"
	fi
fi

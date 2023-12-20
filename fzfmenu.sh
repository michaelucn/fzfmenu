#!/usr/bin/env bash
set -f;
IFS=:;
select_path() {
	for dir in $PATH; do
		set +f;
		[ -n "$p" ] || p=.;
		for file in "$dir"/.[.!]* "$dir"/..?* "$dir"/*; do
			[ -f "$file" ] && [ -x "$file" ] && printf '%s\n' "${file##*/}"
		done;
	done | fzf
}
select_run() {
	read -d '' input
	echo $input | fzf
}

get_selection() {
	if selection=$( $1 ); then
		echo "$selection";
	fi
}

run_selection() {
	if selection=$( $1 ); then
		exec "$selection";
	fi
}

if (( $# == 0 )); then
	get_selection "select_run"
	exit
fi

while [ $# -gt 0 ]; do
	case $1 in
		-h | --help)
			echo "This is a dmenu-like tool that redirects to fzf for fuzzy-finding"
			exit;;
		-p | --path)
			get_selection "select_path"
			exit;;
		-r | --run)
			run_selection "select_run"
			exit;;
		*)
			echo "$1 is an invalid option."
			echo "Try 'fzfmenu -h' to see which options you can use."
			exit 1;;
	esac
	shift
done


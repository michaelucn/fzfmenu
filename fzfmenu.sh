#!/usr/bin/env bash
select_path() {
	set -f
	IFS=:
	for dir in $PATH; do
		set +f
		[ -n "$dir" ] || dir=.
		for file in "$dir"/.[.!]* "$dir"/..?* "$dir"/*; do
			[ -f "$file" ] && [ -x "$file" ] && printf '%s\n' "${file##*/}"
		done
	done | fzf
}

select_drun() {
	app_dirs=( "/usr/share/applications" "$HOME/.local/share/applications" )
	set -f
	IFS=:
	for dir in "${app_dirs[@]}"; do
		set +f;
		[ -n "$dir" ] || dir=.
		for file in "$dir"/*.desktop; do
			[ -f "$file" ] && printf '%s\n' "${file##*/}"
		done
	done | fzf
}

select_run() {
	read -d '' input
	echo $input | fzf
}

get_selection() {
	if selection=$( $2 ); then
		$1 "$selection"
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
			get_selection "echo" "select_path"
			exit;;
		-r | --run)
			get_selection "exec" "select_run"
			exit;;
		-d | --drun)
			get_selection "gtk-launch" "select_drun"
			exit;;
		-D | --drun-no-exec)
			get_selection "echo" "select_drun"
			exit;;
		*)
			echo "$1 is an invalid option."
			echo "Try 'fzfmenu -h' to see which options you can use."
			exit 1;;
	esac
	shift
done


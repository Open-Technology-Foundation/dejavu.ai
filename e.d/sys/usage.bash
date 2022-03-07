#!/bin/bash
#!shellcheck disable=SC0000
#@ Function: _e_usage 
#@ Desc    : E.bash 'self-documentation' function for scripts that use
#@         : e.bash documention format.
#@         : ${PRG@A}
#@         : If e.bash self-documetation is not present in the script 
#@         : (perhaps it's been minimised), then _e_usage calls 'rtfm' for 
#@         : assistance. 
#@         : 
#@         : Note: 'usage' is aliased to '_e_usage'.
#@         : 
#@ Synopsis: _e_usage [\$0 [label]]
#@ Examples: 
#@ Depends : rtfm grep sed
#@ See Also: usage
_e_usage() {
	strict.set off
	set +e
	local input=${1:-${_ent_0:-${0:-}}}
	local -i inputfound=0
	if [[ -f "$input" ]]; then
		grep -m1 -qs '^#[X@][[:blank:][:alnum:]._-]*:' "$input" && inputfound=1
	fi
	((inputfound)) || { rtfm "${2:-}"; return 0; }
#	less -FXRS < <(
#		while read -r; do
			#if [[ ${REPLY,,} == *"insert"* ]]; then
			#	( local cmd l; local -a lines
			#		cmd=${REPLY##*:}; cmd=$(trim "$cmd")
			#		mapfile -t lines < <($cmd || true) || true
			#		for l in "${lines[@]}"; do printf '%-9s:%s\n' '' " $l"; done
			#	) || true
			#	continue
			#fi
#			printf '%9s:%s\n' "${REPLY%%:*}" "$(eval "echo \"${REPLY#*:}\"")"
#		done < <(grep '^#[X@][[:blank:][:alnum:]._-]*:' "$input" \
#								|sed 's/^#[X@][[:blank:]]*//; s/\t/  /g;')
#	)

	less -FXRS < <(
		local lbl
		while read -r; do
			lbl=${REPLY%%:*}
			lbl="${lbl#"${lbl%%[![:blank:]]*}"}"
			lbl="${lbl%"${lbl##*[![:blank:]]}"}"
			printf '%9s:%s\n' "$lbl" "$(eval "echo \"${REPLY#*:}\"")"
		done < <(grep '^#[X@][[:blank:][:alnum:]._-]*:' "$input" \
							| sed 's/^#[X@][[:blank:]]*//; s/\t/  /g;')
	);


	return 0
}
declare -fx '_e_usage'


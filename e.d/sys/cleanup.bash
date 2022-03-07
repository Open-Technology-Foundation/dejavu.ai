#!/bin/bash
#!shellcheck disable=SC2154
#@ Function: cleanup
#@ Desc    : A call to this function is made using the 'trap' command,
#@         : or via the on.exit function.
#@         : 
#@         : On exiting the script this function will always be called.
#@         : You should define your own housekeeping cleanup function, using 
#@         : on.exit, where you can delete temporary files and other 
#@         : detritus before terminating.
#@:
#@         : If msg.debug is set, and an error has occurred, then additional
#@         : diagnostic information is outputted.
#@         : 
#@ Synopsis: cleanup [exitcode [_LINENO_ ['onexitfunction']]]
#@         : 'exitcode' defaults to $? if not specified.
#@         : '_LINENO_' defaults to 0 if not specified.
#@         : 'onexitfunction' defaults to '' if not specified.
#@         : 
#@ Example : cleanup 33 192 'xcleanup'
#@         : 
#@ See Also: on.exit on.exit.set on.exit.function
cleanup() {
	local -i exitcode=$?
	(($#)) && exitcode=$1
	strict.set off
	if ((exitcode)); then
		if ((_ent_DEBUG)); then
			msg.info "Debug [${PRG:-$0}]:"
			msg.info <<<"$(set | grep "^_ent_\|^_e_")"
			msg.info <<<"$(set | grep ^BASH	| grep -v BASH_VERSINFO)"
		fi
		if ((exitcode > 1)) && ((_ent_DEBUG)); then
			msg.err "script=[${PRG:-}]"	\
							"exit=[$exitcode]"	\
							"LINENO=[${2:-}]"			\
							"\$@=[${*}]"				\
							"FUNCNAME[]=[${FUNCNAME[*]// /\|}]" \
							"BASH_LINENO=[${BASH_LINENO[*]:-}]"		\
							"BASH_SOURCE=[${BASH_SOURCE[*]:-}]"
		fi
	fi

	if [[ -n "${3:-}" ]]; then
		((_ent_DEBUG)) && >&2 msg.info "Executing '$3 $exitcode', SHLVL=$SHLVL"
		eval "$3 $exitcode" || true
	fi
	((exitcode == 140)) && >&2 echo	
	exit "$exitcode"
}
declare -fx cleanup
#fin

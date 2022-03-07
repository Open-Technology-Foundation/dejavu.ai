#!/bin/bash
#@ Function: pause
#@ Desc    : Pause script, with optional message and timeout.
#@         : Wait for one keypress, or until timeout (default 86400).
#@         :
#@ Synopsis: pause [-t timeout] [message_str]...
#@         :   -t timeout   Timeout in seconds; default 86400.
#@         :   message_str  If not specified, defaults to '*Pause*'.
pause() { 
	local -i timeout=86400
	if [[ "${1:-}" == '-t' ]]; then
		shift
		timeout=${1:-0}
		shift
	fi
	echo
	read -t "$timeout" -n1 -r -p "${*:- *Pause*} " || { echo; return 1; }
	echo
	return 0
}
declare -fx pause
#fin

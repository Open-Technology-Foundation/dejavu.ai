#!/bin/bash
#shellcheck disable=SC0000
#@ Function: _e_random
#@ Desc    : Return random string of characters/numbers/symbols.
#@         : Can be used to generate random passwords.
#@:
#@         : ${CharSet@A} 
#@:
#@ Synopsis: $PRG [Options]
#@ Options : -n|--numchars num	Number of chars to return. Default $NumChars.
#@:
#@ Examples: newpw=$(_e_random -n 16)
#@:
#@ Requires: /dev/urandom
_e_random() {
	local CharSet='A-Za-z0-9#*%^_.-'
	local -i NumChars=14
	while(($#)); do case "$1" in
		-n|--numchars)	shift; NumChars=${1:-14} ;;
		*)							msg.die -e 22 "Invalid parameter '$1'" ;;
	esac; shift; done

	< /dev/urandom tr -dc "$CharSet" | head -c"${NumChars:-14}"; echo
}
declare -fx '_e_random'

#fin

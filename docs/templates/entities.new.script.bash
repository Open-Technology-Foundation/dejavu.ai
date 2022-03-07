#!/bin/bash
#!shellcheck disable=SC0000
#@ Script  : $PRG
#@ Version : $(version.set)
#@ Desc    : 
#@ Synopsis: $PRG [Options]
#@ Options : -|--           
#@         : -|--           
#@         : -v|--verbose   Msg verbose on. (default)
#@         : -q|--quiet     Msg verbose off.
#@         : -V|--version   Print version.
#@ Examples:
#@ Requires:
#@ See Also: 
source entities || exit
	strict.set on
	msg.prefix.set "$PRG"
	version.set '0.0'

	xcleanup() { 
		: #rm -f "${TmpFile}"; 
	}
	on.exit.exec 'xcleanup'

	# global vars
	
# main
main() {
	local -a args=()
	while (($#)); do case "$1" in
		#-|--)					 ;;
		#-|--)					shift; para=${1:-} ;;
		-v|--verbose)		msg.verbose.set on ;;
		-q|--quiet)			msg.verbose.set off ;;
		-V|--version)		echo "$PRG vs $(version.set)"; return 0 ;;
		-h|--help)			_e_usage; return 0 ;;
		-[vqVh]*)				#shellcheck disable=SC2046 # de-aggregate aggregated short options
										set -- '' $(printf -- "-%c " $(grep -o . <<<"${1:1}")) "${@:2}";;
		-?|--*)					msg.die -e 22 "Invalid option '$1'" ;;
		*)							args+=( "$1" ) ;;
										#msg.die -e 22 "Invalid parameter '$1'" ;;
	esac; shift; done
	((${#args[@]})) || msg.die -e 2 "No parameter specified."
	msg "${args[@]:-}"
		
}

main "$@"
#fin

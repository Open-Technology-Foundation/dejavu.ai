#!/bin/bash
#! shellcheck disable=SC2034,SC2154,
#@ Function: chgConfigVar
#@ Desc    : Add or Change a Variable defined within a file, typically
#@         : a system configuration file. 
#@         :
#@         : New values are always enclosed using 'single quotes'.
#@         :
#@         : Space indents are ignored. One line, one variable.
#@         :
#@ Synopsis: chgConfigVar file VAR value [ VAR value...] [!VAR...]
#@         :
#@         : Changes entry for VAR in "file" to new "value".
#@         :
#@         : If 'file' does not exist, then it is created, regardless of
#@         : whether there are any further parameters.
#@         :
#@         : If '!' is prefixed to VAR (eg, '!VAR'), then VAR is removed  
#@         : completely from 'file'.
#@         :
#@ Example : chgConfigVar environment OKROOT '/usr/share/okusi' '!TIME_STYLE'
#@         :
#@         : chgConfigVar ~/.profile.name TIME_STYLE '+%Y-%m-%d %H:%M'
#@         :
chgConfigVar() {
	local Profile=${1:-} key
	shift
	if [[ ! -f $Profile ]]; then
		cat >"$Profile" <<-etxx
		#!/bin/bash
		#! shellcheck disable=SC2034
		#  [$Profile] created $(date +'%F %T')$( [[ -n ${PRG:-} ]] && echo " by $PRG" )
		etxx
	fi
	while (($#)); do
		key="$1"
		if [[ "${key:0:1}" == '!' ]]; then
			sed -i "/^\s*${key:1}=.*/d" "$Profile"
			shift; continue
		fi
		keyval="$key='${2:-}'"
		if grep -q "^[[:blank:]]*${key}=" "$Profile"; then
			sed -i "s!^\s*${key}=.*!${keyval}!" "$Profile"
		else
			echo "$keyval" >>"$Profile"
		fi
		shift; (($#)) && shift
	done
}
declare -fx chgConfigVar
#fin

#!/bin/bash
#@ Function : trim ltrim rtrim
#@ Desc     : Delete leading/trailing blank characters from a string or 
#@          : stream.
#@          :
#@          : Blank charaters are space, tab, and new-line.
#@          :   
#@          :   trim    strip string/file of leading+trailing blank chars.
#@          :   ltrim   strip string/file of leading blank chars.
#@          :   rtrim   strip string/file of trailing blank chars.
#@          :
#@ Synopsis : trim string|-
#@          : ltrim string|-
#@          : rtrim string|-
#@          :
#@ Examples : #0) strip spaces from around 'str'
#@          : str=" 123 "; str=$(trim "$str")
#@          : 
#@          : #1) remove all leading+trailing blanks.
#@          : trim <fat.file >thin.file
#@:
#@          : #2) remove trailing blanks from file.
#@          : rtrim <fat.file >lean.file
#@:
#@          : #3) remove all leading+trailing blanks from file, slow way.
#@          : rtrim <fat.file | ltrim >thin.file
#@:
trim() {
	if(($#)); then
		local v="$*"
		v="${v#"${v%%[![:blank:]]*}"}"
		echo -n "${v%"${v##*[![:blank:]]}"}"   
	else
		local REPLY
		while read -r; do 
			REPLY="${REPLY#"${REPLY%%[![:blank:]]*}"}"
			echo "${REPLY%"${REPLY##*[![:blank:]]}"}"
		done
	fi
}
declare -fx trim

trimv() {
	if(($#)); then
		if [[ $1 == '-n' ]]; then
			declare -n Var=${2:-TRIM}
			shift 2
		fi 
		local v="$*"
		v="${v#"${v%%[![:blank:]]*}"}"
		if [[ -R Var ]]; then
			Var="${v%"${v##*[![:blank:]]}"}"
		else
			echo -n "${v%"${v##*[![:blank:]]}"}"   
		fi
	else
		local REPLY
		while read -r; do 
			REPLY="${REPLY#"${REPLY%%[![:blank:]]*}"}"
			echo "${REPLY%"${REPLY##*[![:blank:]]}"}"
		done
	fi
}
declare -fx trimv

ltrim() {
	if(($#)); then
		local v="$*"
		echo "${v#"${v%%[![:blank:]]*}"}"
	else
		local REPLY
		while IFS= read -r; do
			echo "${REPLY#"${REPLY%%[![:blank:]]*}"}"
		done
	fi
}
declare -fx ltrim

rtrim() {
	if(($#)); then
		local v="$*"
		echo "${v%"${v##*[![:blank:]]}"}"   
	else
		local REPLY
		while IFS= read -r; do
			echo "${REPLY%"${REPLY##*[![:blank:]]}"}"
		done
	fi
}
declare -fx rtrim

#trim()  { 
#	local v="$*"
#	v="${v#"${v%%[![:space:]]*}"}"
#	v="${v%"${v##*[![:space:]]}"}"
#	echo -n "$v"
#}
#ltrim() {
#	local v="$*"
#	v="${v#"${v%%[![:space:]]*}"}"
#	echo -n "$v"
#}
#rtrim() {
#	local v="$*"
#	v="${v%"${v##*[![:space:]]}"}"
#	echo -n "$v"
#}
#declare -fx trim rtrim ltrim

#fin

#!/bin/bash
#@ Function: implode 
#@ Desc    : Convert array[@] into delimited string.
#@         : Default delimiter is ','
#@:
#@ Synopsis: implode [-d "delimiter"] "${array[@]}"
#@         :   -d  if specified must preceed array.
#@:
#@ Example : str=$(implode -d '|' "${files[@]}")
implode() {
	local x d=','
	[[ ${1:-} == '-d' ]] && { shift; d="${1:-,}"; shift; }
	printf -v x "${d}%s" "$@"
	echo "${x:1}"
}
declare -fx implode
#fin

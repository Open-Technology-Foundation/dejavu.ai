#!/bin/bash
#@ Function: explode 
#@ Desc    : Convert delimited string into array.
#@         :
#@         : For most cases, this would be better done inline:
#@         :   IFS=',' array=( "${cdstring" )
#@ Synopsis: explode "delimiter" "${array[@]}"
#@ Example : str=( $(explode '|' "${files[@]}") )
explode() {	
	local IFS
	local -a a
	IFS="$1" a=( "${@:2}" )
	echo "${a[@]}"; 
}
declare -fx explode
#fin

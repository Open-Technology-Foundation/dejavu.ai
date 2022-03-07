#!/bin/bash
#@ Function: in_array in_array.loose
#@ Desc    : Return true if exact match for string is found in string list.
#@:
#@ Synopsis: in_array[.loose] needle haystack...
#@         : If .loose specified, then match is a loose match.
#@:
#@ Example : in_array 'okusi2' 'okusi1 okusi2 okusi3' && echo 'found'
#@:
#@         : in_array.loose 'okusi' 'okusi1 okusi2 okusi3' && echo 'found'
#@:
in_array() { 
	[[ -z ${2:-} ]] && return 1
	local pattern match="$1"
	shift
	for pattern; do [[ $pattern == "$match" ]] && return 0; done
	return 1
}
declare -fx 'in_array'

in_array.loose() { 
	[[ -z ${2:-} ]] && return 1
	local match="$1" pattern
	local -i lenmatch=${#match} lenpattern=0
	shift
	for pattern; do 
		lenpattern=${#pattern}
		((lenmatch < lenpattern)) && continue
		[[ $match == *"$pattern"* ]] && return 0
	done
	return 1
}
declare -fx 'in_array.loose'

#fin



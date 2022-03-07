#!/bin/bash
#!shellcheck disable=SC0000
#@ Function: get.element get.elements
#@ Desc    : Return and element enclosed within two deliminter patterns.
#@ Synopsis: get.element haystack pattern1 pattern2 [offset]
#@         : get.elements haystack pattern1 pattern2 [offset]
#@:
#@ Examples: #0) Extract all elements enclosed with [[ and ]]
#@         : haystack='This is a very [[large]] digital [[haystack]]'
#@         : declare -a elems
#@         : mapfile -t elems < <(get.elements \$haystack '[[' ']]')
#@:
#@         : #1) Extract all elements in double quotes
#@         : haystack='this \"is\" a \"test\"'
#@         : get.elements \"\$haystack\" '\"' '\"'
#@:
#@         : #2) Extract singular element in a string
#@         : haystack='Gary <garydean@linux.id>, Luna <luna@gmail.com'
#@         : get.element \"\$haystack\" '<' '>' # prints 1st email address
#@         : get.element \"\$haystack\" '<' '>' 13 # prints 2nd email address
#@:
#@ See Also: strpos strrpos
get.elements() {
 	local str=${1:${4:-0}} 
	(($# < 3)) && return 1 
	while [[ -n $str ]]; do
		[[ $str != *"${2}"* ]] && break
	 	str="${str#*${2}}"
		[[ $str != *"${3}"* ]] && break
		echo "${str%%${3}*}"
		str=${str#*${3}}
	done
	return 0
}
declare -fx get.elements

get.element() {
 	local str=${1:${4:-0}} 
	if [[ -n $str ]] && (($# > 2)); then
		if [[ $str == *"${2}"* ]]; then
		 	str="${str#*${2}}"
			[[ $str == *"${3}"* ]] && echo "${str%%${3}*}"
		fi
	fi
	return 0
}
declare -fx get.element

#fin

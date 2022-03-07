#!/bin/bash
#@ Function: strpos strrpos 
#@ Desc    : Return position of needle in haystack.
#@:
#@ Synopsis: strpos haystack needle
#@         : strrpos haystack needle
#@:
#@ Examples: strpos "this is a haystack" "is"
#@:
#@ See Also: get.element get.elements
strpos() { 
	#haystack=$1
	#needle=${2//\*/\\*}
	local x="${1%%${2//\*/\\*}*}"
	[[ "$x" == "$1" ]] && echo -1 || echo "${#x}"
}
declare -fx strpos

#@ Function: strposv strrposv 
#@ Desc    : Assign value to variable of the position of 'needle' with in haystack.
#@ Synopsis: strposv var haystack needle
#@         : strrposv var haystack needle
#@:
#@ Examples: declare -i ispos; strposv ispos "this is a haystack" "is"
#@:
#@ See Also: get.element get.elements
strposv() { 
	#var=$1
	#haystack=$2
	#needle=${3//\*/\\*}
	local -n Var="$1"
	local x="${2%%${3//\*/\\*}*}"
	[[ "$x" == "$2" ]] && Var=-1 || Var=${#x}
}
declare -fx strposv

strrposv() { 
	#var=$1
	#haystack=$1
	#needle=${2//\*/\\*}
	local -n Var="$1"
	local x="${2%${3//\*/\\*}*}"
	[[ "$x" == "$2" ]] && Var=-1 || Var="${#x}"
}
declare -fx strrposv

strrpos() { 
	#haystack=$1
	#needle=${2//\*/\\*}
	local x="${1%${2//\*/\\*}*}"
	[[ "$x" == "$1" ]] && echo -1 || echo "${#x}"
}
declare -fx strrpos

#fin

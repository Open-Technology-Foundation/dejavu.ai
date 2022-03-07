#!/bin/bash
#@ Function: elipstr
#@ Desc    : Insert elipsis (...) into middle of fixed with string.
#@:
#@         : NOTE: uses tput if width not specified thus requires terminal.
#@:
#@ Synopsis: elipstr "string" [maxwidth]
#@:
#@ Example : elipstr "the quick brown fox jumped over." 15
elipstr() {
	local str=${1:-} pd=''
	str=$(echo "$str" | head -n1)
	local -i width=${2:-0} 
	local -i strlen=${#str} sx=0
	((width)) || width=$(( $(tput cols) - 1 ))
	((width<6)) && width=78
	((strlen <= width)) && { echo "$str"; return; }
	sx=$(((width-2) / 2))
	((((sx*2)+2) < width)) && pd='.'
	echo "${str:0:$sx}${pd}..${str: -$sx}"
}
declare -fx elipstr
#fin


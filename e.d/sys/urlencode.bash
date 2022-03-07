#!/bin/bash
#@ Function	: urlencode
#@ Desc			: URL-encode a string.
#@ Synopsis	: urlencode "string"
urlencode() {
	local LC_ALL=C encoded='' c
	local -i i strlen=${#1}
	for (( i=0 ; i<strlen ; i++ )); do
		 c="${1:$i:1}"
		 case "$c" in
				[A-Za-z0-9/_.~-])	encoded="${encoded}$c";;
				*)								printf -v encoded "%s%%%02x" "$encoded" "'${c}";;
		 esac
	done
	echo -n "$encoded"
}
declare -fx urlencode
#fin

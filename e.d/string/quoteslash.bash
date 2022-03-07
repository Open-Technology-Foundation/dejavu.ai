#!/bin/bash
#@ Function: sqslash
#@ Desc    : Add backslash to every single quote char (').
#@         : If specified, takes parameter argument first.
#@         : If no parameters are specifed, assume input from stdin. 
#@:
#@ Synopsis: sqslash [string] 
#@:
#@ Example : sqslash "Hello 'World'!
#@         : echo "Hello 'World'! | sqslash
#@         : sqslash <myfile.txt
#@:
sqslash() {
	if (($#)); then
		echo "${@//\'/\\\'}"
	else
		while read -r; do echo "${REPLY//\'/\\\'}"; done
	fi
}
declare -fx sqslash

#@ Function: dqslash
#@ Desc    : Add backslash to every double quote char (").
#@         : If specified, takes parameter argument first.
#@         : If no parameters are specifed, assume input from stdin. 
#@         :
#@ Synopsis: dqslash [string] 
#@:
#@ Example : dqslash 'Hello "World"!'
#@         : echo 'Hello "World"!' | dqslash
#@         : dqslash <myfile.txt
#@:
dqslash() {
	if (($#)); then
		echo "${@//\"/\\\"}"
	else
		while read -r; do echo "${REPLY//\"/\\\"}"; done
	fi
}
declare -fx dqslash

#fin

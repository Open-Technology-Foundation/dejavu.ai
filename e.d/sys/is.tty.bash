#!/bin/bash
#@ Function: is.tty 
#@ Desc    : return 0 if tty available, otherwise 1.
#@ Synopsis: is.tty
#@ Example : is.tty && msg.yn "Continue?"
#@ Depends : tty
is.tty() { 
	# [[ -t 0 ]] is this the same??
	tty --quiet	2>/dev/null	|| return $?
	return 0
}
declare -fx 'is.tty'
	is_tty() { 'is.tty'; }; declare -fx 'is_tty'
	
#fin

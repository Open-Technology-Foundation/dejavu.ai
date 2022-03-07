#!/bin/bash
#@ Function: is.root
#@ Desc    : Return error if not root user. Uses whoami and EUID.
#@ Synopsis: is.root
#@ Depends : whoami
#@ Example : is.root || exit 1
is.root() {
	[[ "$(whoami)" == 'root' || $EUID == 0 ]] && return 0
	return 1
}
declare -fx 'is.root'
#fin

#!/bin/bash
##!shellcheck disable=SC0000
#@ Function: sshexec
#@ Desc    : Execute ssh command only if specified host is not same as 
#@         : current host.
#@         : 
#@         : Default host is $HOSTNAME.  Default user is $USER.
#@         : 
#@         : Returns errorlevel of evaluated command.
#@         : 
#@ Synopsis: ssh [Options] [hostname] command...
#@         : Where 'hostname' is host to execute 'command' on.
#@         : 
#@ Options : -u|--user   Username to use for login.
#@         : -h|--host   Hostname to use.
#@         : 
#@ Examples: sshexec okusi1 ls -la
#@         : sshexec --host okusi2 'ls -ls; df -a'
#@         : 
sshexec() {
	local ssh='' user='' host=''
	while (($#)) && [[ ${1:0:1} == '-' ]]; do case "$1" in
		-u|--user)	shift; user=${1:-} ;;
		-h|--host)	shift; host=${1:-} ;;
		*)					>&2 echo "${FUNCNAME[0]}: Invalid option '$1'" ;;
	esac; shift; done
	[[ -z $user ]] && user=${USER:-root}; 
	[[ -z $host ]] && { host=${1:-$HOSTNAME}; shift; }
  [[ $host != "${HOSTNAME:-$(hostname)}" ]] && ssh="$(command -v ssh) '${user}@${host}'"
	(($#)) || { >&2 echo "${FUNCNAME[0]}: Nothing to execute."; return 22; }
	eval "$ssh" "$@"
	return $?
}

#fin

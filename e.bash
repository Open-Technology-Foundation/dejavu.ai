#!/bin/bash
#@ About: e.bash.license
#@ Desc : e.bash - Bash programming environment and library
#@      : Copyright (C) 2019-2022  Gary Dean <garydean@okusi.id>
#@      : 
#@      : This program is free software: you can redistribute it and/or modify
#@      : it under the terms of the GNU General Public License as published by
#@      : the Free Software Foundation, either version 3 of the License, or
#@      : (at your option) any later version.
#@      : 
#@      : This program is distributed in the hope that it will be useful,
#@      : but WITHOUT ANY WARRANTY; without even the implied warranty of
#@      : MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#@      : GNU General Public License for more details.
#@      : 
#@      : You should have received a copy of the GNU General Public License
#@      : along with this program.  If not, see <https://www.gnu.org/licenses/>.
#@      : 
#@      : Okusi Associates
#@      :   https://okusiassociates.com
#@      :   https://github.com/OkusiAssociates/entities.bash
#@      : Gary Dean
#@      :   https://garydean.id

#@ About  : e.bash
#@ Desc   : E.bash Functions/Globals Declarations and Initialisations.
#@        :
#@        : E.bash is a light-weight Bash function library for systems
#@        : programmers and administrators.
#@        : 
#@        : Latest release is available at
#@        : http://github.com/OkusiAssociates/entities.bash
#@        : 
#@        : To install, use e.install.
#@        :
#@        :   _ent_0       $PRGDIR/$PRG
#@        :   PRG          basename of current script. 
#@        :   PRGDIR       directory location of current script, with 
#@        :                symlinks resolved to actual location.
#@        :   _ent_LOADED  is set if e.bash has been successfully 
#@        :                loaded.
#@        : 
#@        : PRG/PRGDIR are *always* initialised as local vars regardless of 
#@        : 'inherit' status when loading e.bash.
#@        : 
#@ Depends: readlink


#@ Reference: Reference
#@ Desc     : Reference placeholder.
#@          : 

#@ Global  : _ent_0 PRGDIR PRG
#@ Desc    : [_ent_0], [PRGDIR] and [PRG] are global variables that are 
#@         : initialised every time e.bash is sourced.
#@         : 
#@         :    _ent_0  is the fully-qualified path of the calling program.
#@:
#@         :    PRGDIR  is the directory location of the calling program.
#@:
#@         :    PRG     is the basename of the calling program.
#@         : 
#@         : PRG is most often used to identify a running script. 
#@:
#@         : PRGDIR is used to identify the directory location of the 
#@         : running script, which often comes in handy.
#@         :
#@ Examples: 0. source e.bash 
#@         :    # If e.bash has already been loaded, 
#@         :    # then only _ent_0, PRGDIR and PRG globals are initialised.
#@         :    # If e.bash has not been loaded, then a full load or
#@         :    # reload of all functions and global variables is done also.
#@         : 
#@         : 1. source e.bash new 
#@         :    # ^ load new instance of e.bash; 
#@         :    # do not use any existing instance already loaded.
#@:

#@ Ref : extglob globstar
#@ Desc: E.bash makes extensive use of globs.
#@     : Thus 'shopt -s extglob globstar' is executed every time 
#@     : e.bash is sourced to ensure all functions operate 
#@     : correctly.
#@     : 
#@:
shopt -s extglob globstar

declare -- _ent_0 PRG PRGDIR
declare -x _ent_scriptstatus="\$0=$0\n"
#_ent_scriptstatus+="${BASH_SOURCE[*]@A}\n"
	# Is e.bash being executed as a script?
	if ((SHLVL > 1)) || [[ ! $0 == ?'bash' ]]; then
		_ent_0=$(readlink -fn -- "$0") || _ent_0=''
		_ent_scriptstatus+="is.script\n${_ent_0@A}\n"
		# Has e.bash been executed?
		if [[ "$(readlink -fn -- "${BASH_SOURCE[0]:-}")" == "$_ent_0" ]]; then
			_ent_scriptstatus+="execute\n${BASH_SOURCE[0]@A}\n"
			declare -ix _ent_LOADED=0
			# do options for execute mode
			while (($#)); do case "$1" in
				help)	
						exec "${ENTITIES:-/lib/include/e.bash}/e.help" "${@:2}"
						exit $? ;;
				install|reinstall)	
						[[ -z ${_ent_INSTALLED_FROM:-} ]] && _ent_INSTALLED_FROM=$(<"$ENTITIES"/.e.production.dir) 
						exec "${_ent_INSTALLED_FROM:-}/e.install" "${@:2}"
						exit $? ;;
				-h|--help)	
						#shellcheck source=/lib/include/e.bash/e.d/e.version.bash
						source "${ENTITIES:-/lib/include/e.bash}/e.d/e.version.bash"
						cat <<-etx
							Program : e.bash
							Version : ${_ent_VERSION:- e.bash version not found. Check installation.}
							Desc    : e.bash function library.
							Synopsis: 0. e.bash [help|install|reinstall] [-V|--version] [-h|--help] 
							        : 1. source e.bash [new|inherit] 
							See Also: e.help
						etx
						exit 0 ;;
				-V|--version)
						#shellcheck source=/lib/include/e.bash/e.d/e.version.bash
						source "${ENTITIES:-/lib/include/e.bash}/e.d/e.version.bash"
						echo "$_ent_VERSION"; exit ;;	
				# All other passed parameters return error.
				-*)	echo >&2 "$(basename "$0"): Bad option '$1'";		exit 22;;
				*)	echo >&2 "$(basename "$0"): Bad argument '$1'";	exit 22;;
			esac; shift; done		
			exit $?
		fi
		_ent_scriptstatus+="sourced-from-script\n${SHLVL@A}\n"
		PRG=${_ent_0##*/}	
		PRGDIR=${_ent_0%/*}
		_ent_scriptstatus+="${PRGDIR@A}\n"
		# e.bash is already loaded, and no other parameters have 
		# been given, so do not reload.
		if (( ! $# )); then
			(( ${_ent_LOADED:-0} )) && return 0
		fi
	else
		# [source e.bash] has been sourced from shell command prompt
		_ent_scriptstatus+="sourced-from-shell\n${SHLVL@A}\n"
		_ent_0=$(/bin/readlink -fn -- "${BASH_SOURCE[0]}") || _ent_0=''
		PRG=${_ent_0##*/}	
		PRGDIR=${_ent_0%/*}
		_ent_scriptstatus+="${PRGDIR@A}\n"
		if [[ -n "${ENTITIES:-}" ]]; then
			PATH="${PATH//\:${ENTITIES}/}"
			PATH="${PATH//\:\:/\:}"
		fi
		export ENTITIES="$PRGDIR"
		export PATH="${PATH}:${ENTITIES}"		
		declare -ix _ent_LOADED=0		# always reload when sourced from command line
	fi

	# There are parameters.
	case "${1,,}" in
		# Force e.bash to load/reload.
		new)			shift;  _ent_LOADED=0;;
		# Does the calling script wish to inherit the current 
		# E.bash environment/functions?
		# Inherit is the default. Can only inherit if called from a script.
		inherit)	shift; _ent_LOADED=${_ent_LOADED:-0};;
		# all other passed parameters are ignored (possibly script parameters? 
		# but not for e.bash)
	esac

#@ Global  : _ent_LOADED
#@ Desc    : _ent_LOADED global flags whether e.bash has 
#@         : already been loaded or not. If it has, then it exits 
#@         : immediately without re-initialising e.bash functions.
#@ Example : (( ${_ent_LOADED:-0} )) \
#@         :     || { echo >&2 'e.bash not loaded!'; exit; }
(( ${_ent_LOADED:-0} )) && return 0;
declare -ix _ent_LOADED=0

_ent_scriptstatus+="reloading\n"

# Turn on 'strict' while e.bash itself is being traversed.
set -o errexit -o nounset -o pipefail

# msgx ########################################################################
#@ Function: msgx msg msg.die msg.emerg msg.alert msg.crit msg.err msg.warning msg.notice msg.info msg.debug msg.sys 
#@ Desc    : Console message functions.  msg() functions support verbose, 
#@         : message prefixes, tabs and color. 
#@         : If msg.verbose.set is enabled, send strings to output.
#@         : embedded chars (\n \t etc) enabled by default.
#@         : Tabs and prefixes (if set) are printed with the string.
#@         :
#@ Synopsis: msg.* [--log] [--notag] [--raw] [--errno num] \"str\" [\"str\" ...]
#@         :   msg           Print to stdout with no color or stdio tag.
#@         :   msg.die       Print die message to stderr and exit.
#@         :   msg.emerg     Print emergency message to stderr and exit.
#@         :   msg.alert     Print alert message to stderr and and exit.
#@         :   msg.crit      Print critical message to stderr and exit.  
#@         :   msg.err       Print error message to stderr.
#@         :   msg.warning   Print warning message to stderr.
#@         :   msg.notice    Print notice message to stdout.
#@         :   msg.info      Print notice message to stdout.
#@         :   msg.debug     Print debug message to stderr.
#@         :   msg.sys       Print system message to stderr and log
#@         :                 message using stdio code.
#@         :   -e|--errno n  Set error return/exit code to n.
#@         :   -l|--log      Log message to syslog.
#@         :   -n|--raw      Print without tabs, prefixes or linefeeds.
#@         :   -t|--notag    Do not print stdio tag (eg, info, err, sys).
#@         :
#@ Example : msg.usetag.set on
#@         : msg "\hello world!\" \"it's so nice to be back!\"
#@         : msg.sys \"Sir, I have something to announce more broadly.\"
#@         : msg.info \"Sir. There's something you need to know.\"
#@         : msg.warn --log \"Pardon me, Sir.\" \"Is this supposed to happen?\"
#@         : msg.err --log \"Sir!\" \"I think you better come here.\"
#@         : msg.die --log --errno 119 \"Sir!\" \"This isn't working out.\"
#@         : # Results:
#@         : [0;39;49mhello world!
#@         : [0;39;49m[0;39;49mit's so nice to be back!
#@         : [0;39;49msys: Sir, I have something to announce more broadly.
#@         : [0;39;49m[32minfo: Sir. There's something you need to know.
#@         : [0;39;49m[33mwarning: Pardon me, Sir.
#@         : [0;39;49m[33mwarning: Is this supposed to happen?
#@         : [0;39;49m[31merr: Sir!
#@         : [0;39;49m[31merr: I think you better come here.
#@         : [0;39;49mdie: Sir!
#@         : [0;39;49mdie: This isn't working out.
#@         : [0;39;49m
#@         : 
#@ See Also: msg.verbose.set msg.color.set msg.prefix.set msg.tab.set
# shellcheck disable=SC2034,2016
declare -x \
	io_='stdio="";' 								\
	io_die='std=2;die=1;errno=1;' 	\
	io_emerg='std=2;die=1;errno=1;' \
	io_alert='std=2;die=1;errno=1;' \
	io_crit='std=2;die=1;errno=1;' 	\
	io_err='std=2;' 								\
	io_warning='std=2;' 						\
	io_notice='std=1;' 							\
	io_info='std=1;' 								\
	io_debug='std=2;' 							\
	io_sys='std=2;log=1;' 

msgx() { 
	local -i std=1 die=0 log=0 raw=0 errno=0 tag=1
	local stdio='' sx nc=''
	if (($#)) && [[ ${1:0:2} == '--' ]]; then
		stdio="${1:2:8}"
		sx="io_$stdio"
		if [[ -v "$sx" ]]; then
			shift
			eval "${!sx}"
		else
			stdio=''
		fi
	fi
	(( std == 1 && ! _ent_VERBOSE )) && return 0
	
	(( die )) && set +o errexit +o nounset
		
	while (($#)); do
		# these are all front-facing options; the first non-option signals 
		# that consequent strings are printed using these settings.
		case $1 in
			-t|--notag)		tag=0;;
			-n|--raw)			raw=1;;
			-e|--errno)		std=2; shift; errno=$((${1:-0}));;
			-l|--log|log)	log=1;;
			*)						break;;
		esac
		shift
	done	
	((tag)) && ((_ent_MSG_USE_TAG)) && [[ -n $stdio ]] && _ent_MSG_PRE+=( "$stdio" )

	local -i readline=1
	while (($#)); do
		if ((raw)); then
			((_ent_COLOR)) && { nc=color$stdio; echo -ne "${!nc:-}"; }
			echo >&${std} -en "$1"
			((_ent_COLOR)) && echo -ne "$colorreset"
		else
			((_ent_COLOR)) && { nc=color$stdio; echo -ne "${!nc:-}"; }
			if (( ${#_ent_MSG_PRE[*]} )); then
				p=${_ent_MSG_PRE[*]}
				echo -n "${p//[[:blank:]]/${_ent_MSG_PRE_SEP}}${_ent_MSG_PRE_SEP}"
			fi
			((_ent_TABSET)) && printf '\t%.0s' $(seq 1 "$_ent_TABSET")
			echo >&${std} -e "$1"
			((_ent_COLOR)) && echo -ne "$colorreset"
		fi
		if ((log)); then
			sx=${stdio:-err}
			[[ $sx == 'sys' || $sx == 'die'  ]] && sx='err'
			systemd-cat -t "${_ent_MSG_PRE[*]}" -p "$sx" echo "$( ((errno)) && echo "$errno: ")$1"
		fi
		shift
		readline=0
	done
	
	# shellcheck disable=SC2162
	if ((readline)) && read -t 0; then 
		while read -sr line; do 
			((_ent_COLOR)) && { nc=color$stdio; echo -ne "${!nc:-}"; }
			if (( ${#_ent_MSG_PRE[*]} )); then
				p=${_ent_MSG_PRE[*]}
				echo -n "${p//[[:blank:]]/${_ent_MSG_PRE_SEP}}${_ent_MSG_PRE_SEP}"
			fi
			((_ent_TABSET)) && printf '\t%.0s' $(seq 1 "$_ent_TABSET")
			echo >&${std} "$line"
			((_ent_COLOR)) && echo -ne "$colorreset"
			if ((log)); then
				sx=${stdio:-err}
				[[ $sx == 'sys' || $sx == 'die'  ]] && sx='err'
				systemd-cat -t "${_ent_MSG_PRE[*]}" -p "$sx" echo "$( ((errno)) && echo "$errno: ")$line"
			fi
		done
	fi

	((tag)) && ((_ent_MSG_USE_TAG)) && [[ -n $stdio ]] && msg.prefix.set '--'
	((die)) && exit "$errno"
	return 0
}
declare -fx 'msgx'
msg()					{ msgx "$@"; }
msg.die() 		{ msgx --die "$@"; }
msg.emerg() 	{ msgx --emerg "$@"; }
msg.alert() 	{ msgx --alert "$@"; }
msg.crit()	 	{ msgx --crit "$@"; }
msg.err() 		{ msgx --err "$@"; }
msg.error()		{ msgx --err "$@"; } #X legacy X#
msg.warning() { msgx --warning "$@"; }
msg.warn() 		{ msgx --warning "$@"; }  #X legacy X#
msg.notice() 	{ msgx --notice "$@"; }
msg.info() 		{ msgx --info "$@"; }
msg.debug() 	{ msgx --debug "$@"; }
msg.sys() 		{ msgx --sys "$@"; }
declare -fx 'msg' 'msg.die' 'msg.emerg' 'msg.alert' 'msg.crit' 'msg.err' 'msg.warning' 'msg.warn' 'msg.notice' 'msg.info' 'msg.debug' 'msg.sys'

#@ Global  : _PATH_LOG LOG_EMERG LOG_ALERT LOG_CRIT LOG_ERR LOG_WARNING LOG_NOTICE LOG_INFO LOG_DEBUG LOG_PRIORITYNAMES 
#@ Desc    : Global Exported Read-Only constants from [syslog.h].
#@         :  _PATH_LOG='/dev/log'
#@         : 	# priorities (these are ordered)
#@         :	LOG_EMERG=0		# system is unusable 
#@         : 	LOG_ALERT=1		# action must be taken immediately 
#@         : 	LOG_CRIT=2		# critical conditions 
#@         : 	LOG_ERR=3			# error conditions 
#@         : 	LOG_WARNING=4	# warning conditions 
#@         : 	LOG_NOTICE=5	# normal but significant condition 
#@         : 	LOG_INFO=6		# informational 
#@         : 	LOG_DEBUG=7		# debug-level messages 
#@         : 	LOG_PRIORITYNAMES='emerg alert crit err warning notice info debug'
#@ See Also: msg*
# read-only vars can only be declared once.
if (( ! ${LOG_ALERT:-0} )); then
	declare -xr		_PATH_LOG='/dev/log'
	# priorities (these are ordered)
	declare -ixr	LOG_EMERG=0		# system is unusable 
	declare -ixr	LOG_ALERT=1		# action must be taken immediately 
	declare -ixr	LOG_CRIT=2		# critical conditions 
	declare -ixr	LOG_ERR=3			# error conditions 
	declare -ixr	LOG_WARNING=4	# warning conditions 
	declare -ixr	LOG_NOTICE=5	# normal but significant condition 
	declare -ixr	LOG_INFO=6		# informational 
	declare -ixr	LOG_DEBUG=7		# debug-level messages 
	declare -xr		LOG_PRIORITYNAMES='emerg alert crit err warning notice info debug'
fi

#@ Global  : CR CH9 LF OLDIFS IFS
#@ Desc    : Constant global char values.
#@         : NOTE: IFS is 'normalised' on every 'new' execution of 
#@         :       e.bash. OLDIFS retains the existing IFS.
#@         :
#@ Synopsis: CR=\$'\r' CH9=\$'\t' LF=\$'\n' OLDIFS="\$IFS" IFS=\$' \t\n'  
#@         : 
#@         : OLDIFS=\$IFS    # captures existing IFS before assigning 
#@         :                 # 'standard' IFS.
#@         : IFS=\$' \\t\\n' # standard IFS
#@         :
#@ Example : str="\$LF\$CH9This is a line.\$LF\$CH9This is another line."
#@         : echo -e \"\$str\"
#@:
declare -x	CR=$'\r' CH9=$'\t' LF=$'\n'
declare -x	OLDIFS="$IFS" IFS=$' \t\n'
declare -nx	OIFS='OLDIFS'

#@ Function: onoff 
#@ Desc    : echo 1 if 'on', 0 if 'off'
#@:
#@ Synopsis: onoff on|1 || off|0 [defaultval]
#@         : for ambiguous value, returns defaultval if defined, otherwise 0.
#@:
#@ Example : result=$(onoff off 1)
#@:
onoff() {
	local o=${1:-0}
	case "${o,,}" in
		on|1)			o=1;;
		off|0)		o=0;;
		*)				o=$(( ${2:-0} ));; 
	esac
	echo -n $((o))
	return 0
}
declare -fx 'onoff'

#@ Global  : _ent_VERBOSE
#@ Desc    : '_ent_VERBOSE'  
#@         : 
#@ Example : _ent_VERBOSE
#@         : 
#@ See Also: msg.verbose.set
declare -ix _ent_VERBOSE
[ -t 1 ] && _ent_VERBOSE=1 || _ent_VERBOSE=0
#@ Function: msg.verbose.set msg.verbose
#@ Desc    : Set global verbose status for msg* functions. For shell 
#@         : terminal verbose is ON by default, otherwise, when called 
#@         : from another script, verbose is OFF by default.
#@:
#@         : msg.verbose.set status is used in the msg.yn and some msg.* 
#@         : commands, except msg.sys, msg.die and msg.crit, which will 
#@         : always ignore verbose status and output to STDERR.
#@         : 
#@ Synopsis: msg.verbose.set [on|1] | [off|0]
#@         : curstatus=$(msg.verbose.set)      
#@         : msg.verbose returns true if verbose is set, false if not.
#@         : 
#@ Examples: oldverbose=$(msg.verbose.set)
#@         : msg.verbose.set on
#@         : # do stuff... #
#@         : msg.verbose.set $oldverbose
#@         : msg.verbose && echo \"Verbose is on.\"
#@         : _ent_VERBOSE controls output from msg*() functions.
msg.verbose() { return $(( ! _ent_VERBOSE )); }
declare -fx 'msg.verbose'
#	verbose() { msg.verbose "$@"; }; 		declare -fx verbose 
	is.verbose() { msg.verbose "$@"; };	declare -fx 'is.verbose' #X legacy X#
msg.verbose.set() {
	if (( ${#@} )); then
		_ent_VERBOSE=$(onoff "$1")
	else
		echo -n "$_ent_VERBOSE"
	fi
#	return 0
}
declare -fx 'msg.verbose.set'
	verbose.set() { msg.verbose.set "$@"; }; declare -fx 'verbose.set' #X legacy X#
	
declare -ix '_ent_MSG_USE_TAG'
_ent_MSG_USE_TAG=0
msg.usetag.set() {
	if (( ${#@} )); then
		_ent_MSG_USE_TAG=$(onoff "$1")
	else
		echo -n "$_ent_MSG_USE_TAG"
	fi
#	return 0
}
declare -fx 'msg.usetag.set'
	
#@ Global  : colorreset colordebug colorinfo colornotice colorwarning colorerr colorcrit coloralert coloremerg
#@ Desc    : Colors used by e.bash msg.* functions.
#@         : emerg alert crit err warning notice info debug
#@         : panic (dep=emerg) err (dep=error) warning (dep=warn)
#@ See Also:
declare -x colorreset="\x1b[0;39;49m"
declare -x color="\x1b[0;39;49m"
declare -x color0="\x1b[0;39;49m"
declare -x colordebug="\x1b[35m"
declare -x colorinfo="\x1b[32m"
declare -x colornotice="\x1b[34m"
declare -x colorwarning="\x1b[33m";					declare -nx colorwarn='colorwarning'
declare -x colorerr="\x1b[31m";							declare -nx colorerror='colorerr'
declare -x colorcrit="\x1b[1;31m";					declare -nx colorcritical='colorcrit'
declare -x coloralert="\x1b[1;33;41m"
declare -x coloremerg="\x1b[1;4;5;33;41m";	declare -nx colorpanic='coloremerg'

#@ Global  : _ent_COLOR
#@ Desc    : '_ent_COLOR'  
#@         : 
#@ Example : _ent_COLOR
#@         : 
#@ See Also: msg.color.set
declare -ix '_ent_COLOR'
_ent_COLOR=1
[ -t 1 ] && _ent_COLOR=1 || _ent_COLOR=0
#@ Function: msg.color.set msg.color
#@ Desc    : Turn on/off colorized output from msg.* functions.
#@         : 
#@ Synopsis: msg.color.set [on|1][off|0][auto]
#@         : curstatus=\$(msg.color.set)
#@ Examples: 
#@         : oldstatus=\$(msg.color.set)
#@         : msg.color.set off
#@         : # do stuff... #
#@         : msg.color.set $oldstatus
msg.color() { return $(( ! _ent_COLOR )); }
declare -fx 'msg.color'
	color() { 'msg.color' "$@"; }; declare -fx 'color' #X legacy X#
	is.color() { 'msg.color' "$@"; };	declare -fx 'is.color' #X legacy X#
	
msg.color.set() {
	if (( ${#@} )); then 
		if [[ $1 == 'auto' ]]; then
			[ -t 1 ] && status=1 || status=0
		else
			status=$1
		fi
		_ent_COLOR=$(onoff "$status" "$_ent_COLOR")
	else 
		echo -n "$_ent_COLOR"
	fi
#	return 0
}
declare -fx 'msg.color.set'
	color.set() { 'msg.color.set' "$@"; };	declare -fx 'color.set' #X legacy X#

#@ Function : msg.tab.set msg.tab.width
#@ Synopsis : msg.tab.set [offset]; msg.tab.width [tabvalue]
#@ Desc     :   msg.tab.set    set tab position for output from msg.* functions.
#@          :   msg.tab.width  set tab width (default 4).
#@          : used for formatting output for msg.* and ask.* functions.
#@          : 
#@ Synopsis : msg.tab.set [reset | [forward|++] | [backward|--] [indent|+indent|-indent] ]
#@          : no argument causes current tab level to be returned.
#@          : 
#@ Example  : msg.tab.width 2; msg.info \"msg.tab.width is \$(msg.tab.width)\"
#@          : msg.tab.set ++; msg.sys \"indent 2 columns\"
#@          : msg.tab.set reset; msg.warn \"indent reset to 0\"
#@          : msg.tab.set +3; msg.info \"indent to column 6\"
#@          : msg \"current tab setting is \$(msg.tab.set)\" 
declare -ix '_ent_TABWIDTH'
_ent_TABWIDTH=4
msg.tab.width() {
	if (( $# )); then
		_ent_TABWIDTH=$(( $1 ))
		((_ent_COLOR)) && tabs $_ent_TABWIDTH
	else
		echo -n $_ent_TABWIDTH
	fi
	return 0
}
declare -fx 'msg.tab.width'
	tab.width() { 'msg.tab.width' "$@"; }; declare -fx 'tab.width' #X legacy X#

declare -ix '_ent_TABSET'
_ent_TABSET=0
msg.tab.set() {
	if (( $# )); then
		case "$1" in
			0|reset)	_ent_TABSET=0;;
			++)				_ent_TABSET=$((_ent_TABSET+1))			;;
			--)				_ent_TABSET=$((_ent_TABSET-1))			;;
			 *)				if [[ "${1:0:1}" == '+' ]]; then
									_ent_TABSET=$(( _ent_TABSET + ${1:1} ))
								elif [[ "${1:0:1}" == '-' ]]; then
									_ent_TABSET=$(( _ent_TABSET - ${1:1} ))
								else
									_ent_TABSET=$(( $1 ))						
								fi
								;;
		esac
		(( _ent_TABSET < 0 )) &&	_ent_TABSET=0 # please, curb your enthusiasm.
	else
		echo -n $_ent_TABSET
	fi
	return 0
}
declare -fx	'msg.tab.set'
	tab.set() { 'msg.tab.set' "$@"; }; declare -fx 'tab.set' #X legacy X#
	
#@ Function: msg.prefix.separator.set
#@ Desc    : Set/Retrieve value of _ent_MSG_PRE_SEP for appending as a separator for msg.prefix.
#@         : Default separator is ': '
#@ Synopsis: msg.prefix.separator.set [separator]
#@         : 
#@ Example : # 0. set a msg prefix with '>' separator
#@         : msg.prefix.separator.set '>'
#@         : msg.prefix.set "\$PRG"
#@         : msg 'Hello world.'
#@ See Also: msg.prefix.set
declare -x '_ent_MSG_PRE_SEP'
_ent_MSG_PRE_SEP=': '
msg.prefix.separator.set() {
	if (( $# ));	then 
		_ent_MSG_PRE_SEP="$1" 
	else 
		echo -n "$_ent_MSG_PRE_SEP"
	fi
}
declare -fx 'msg.prefix.separator.set'

#@ Function: msg.prefix.set
#@ Desc    : Set/Retrieve value of _ent_MSG_PRE for prefixing a string 
#@         : before every string output by the msg.* system.
#@ Synopsis: msg.prefix.set [-a] msgprefix
#@         : -a  makes msgprefix additive to the existing msg prefix.
#@ Example : # 0. set a msg prefix
#@         : msg.prefix.set "\$PRG"
#@         : # 1. retrieve current msgprefix
#@         : oldprefix=\$(msg.prefix.set)
#@         : # 2. set additive msg prefix
#@         : msg.prefix.set -a 'processing'
#@ See Also: msg.prefix.separator.set
declare -ax '_ent_MSG_PRE'
_ent_MSG_PRE=()
msg.prefix.set() {
	if (( $# ));	then 
		local -i add=0 sub=0
		if [[ $1 == '++' ]]; then
			shift; add=1
		elif [[ $1 == '--' ]]; then
			shift; sub=1 
		else
			_ent_MSG_PRE=( "$1" )
			return 0
		fi
		if ((add)); then
			_ent_MSG_PRE+=( "${1:-}" )
		elif ((sub)); then
			if (( ${#_ent_MSG_PRE[@]} > 1 )); then
				# shellcheck disable=SC2206
				_ent_MSG_PRE=( ${_ent_MSG_PRE[@]:0:${#_ent_MSG_PRE[@]}-1} )
			else
				_ent_MSG_PRE=()
			fi
		fi
		return 0
	fi
	if [[ -n ${_ent_MSG_PRE[*]:-} ]]; then
		local p
		p=${_ent_MSG_PRE[*]}
    echo -n "${p//[[:blank:]]/${_ent_MSG_PRE_SEP}}${_ent_MSG_PRE_SEP}"
	else
		echo -n ''
	fi
	return 0
}
declare -fx 'msg.prefix.set'

#@ Function: msg.line 
#@ Desc    : Print a line of replicated characters (default underline) 
#@         : from current cursor position to end of screen.
#@ Synopsis: msg.line [repchar [iterations]]
#@         :   repchar     Default repchar is '_'.
#@         :   iterations  Default iterations is number of screen 
#@         :               columns minus 1.
#@         : 
#@         : If msg.verbose.set is off, return without processing 
#@         : further arguments.
#@         : If msg.color.set is enabled, use color.
#@         : If msg.prefix is set, print prefix before string.
#@         : If msg.tab.set is enabled, print tabs.
#@         : 
#@ Example : msg.line
#@         : msg.line '+'
#@         : msg.line '=' 42
#@         : 
#@ See Also: msg* msg.verbose.set msg.color.set msg.tab.set msg.prefix.set
msg.line() {
	((_ent_VERBOSE)) || return 0
	local -i  width=78 screencols=0 plen
	local --  repchar='_'	sx

	if (( $# )); then
		repchar="${1:0:1}"
		shift
		[[ -n "${1:-}" ]] && screencols=$1
	fi

	if (( ! screencols )); then
		local -- IFS=' '
		local -ai sz
		mapfile 2>/dev/null -d' ' -t sz < <(stty size) || sz=()
		if (( ${#sz[@]} )); then
			screencols=$(( sz[1] ))
		else
			screencols=$(( ${COLUMNS:-78} ))
		fi
		IFS=$' \t\n'
	fi
	
	sx="${_ent_MSG_PRE[*]}${_ent_MSG_PRE_SEP[*]}" || sx=''
	plen=$(( ${#sx} + ${#_ent_MSG_PRE[@]} ))
	((plen)) || plen=1
	width=$(( (screencols - plen - (_ent_TABSET * _ent_TABWIDTH)) ))

  msg "$(head -c $width < /dev/zero | tr '\0' "${repchar:-_}")"

	#msg "$(printf "${repchar}%.0s" $(seq 1 "${width}") )"
	return 0
}
declare -fx 'msg.line'
	msgline() { 'msg.line' "$@"; }; declare -fx 'msgline' #X legacy X#

#@ Function : msg.yn
#@ Desc     : Ask y/n question,d return 0/1 
#@ Synopsis : msg.yn [--warning|--err|--info|--notice|--debug] [prompt] 
#@:
#@          : NOTE: If msg.verbose.set is off (disabled), or there is no 
#@          : tty, msg.yn will *always* return 0, without printing the 
#@          : prompt or waiting for a response.
#@:
#@ Example  : msg.yn 'Continue?' || msg.die 'Not Continuing.'
#@:
msg.yn() {
	((_ent_VERBOSE)) || return 0
	[ -t 0 ] || return 0
	local stdio=''
	if (($#)); then
		if [[ ${1:0:2} == '--' ]]; then
			stdio="$1"
			shift
		fi
	fi
	local question="${1:-}" yn=''
	# shellcheck disable=SC2086
	question=$(msgx $stdio --notag "$question (y/n)" 2>&1 )
	question="${question//$'\n'/ }"
	while true; do
		read -e -r -p "$question" yn
		case "${yn,,}" in
			[y]*)		return 0;;
			[n]*) 	return 1;;
			*) 			msg.err 'Answer [y]es or [n]o.';;
		esac
	done
}
declare -fx 'msg.yn'

#@ Function : version.set
#@ Desc     : Set or return version number/version string for the 
#@          : current script. Default version string is '0'
#@:
#@ Synopsis : version.set verstring
#@:
#@          : version.set returns '$(version.set)'
#@          :
#@ Example  : version.set '4.20.lts'	# set script version string.
#@:
#@          : version.set					    # print current script version.
#@:
#@          : ver=\$(version.set)	    # store current version setting to variable.
#@:
declare -x '_ent_SCRIPT_VERSION'
_ent_SCRIPT_VERSION='0'
version() { echo -n "$_ent_SCRIPT_VERSION"; return 0; }
declare -fx 'version'
version.set() {
	if (( ${#@} )); then _ent_SCRIPT_VERSION="$1"
								else echo -n "$_ent_SCRIPT_VERSION"
	fi
	return 0
}
declare -fx 'version.set'

#@ Function: dryrun.set is.dryrun
#@ Desc    : General purpose global var for debugging. 
#@ Defaults: 0
#@ Synopsis: dryrun.set [[on|1] | [off|0]]
#@         : \$(dryrun.set)
#@ Example : dryrun.set off
#@         : is.dryrun || doit.bash
declare -ix '_ent_DRYRUN'
_ent_DRYRUN=0
is.dryrun() { return $(( ! _ent_DRYRUN )); }
declare -fx 'is.dryrun'
	dryrun() { 'is.dryrun' "$@"; }; declare -fx 'dryrun' #X legacy X#
dryrun.set() {
	if (( $# )); then 
		_ent_DRYRUN=$(onoff "$1" "$_ent_DRYRUN")
	else 
		#	-- SC2086: Double quote to prevent globbing and word splitting.
		# shellcheck disable=SC2086
		echo -n $_ent_DRYRUN
	fi
	return 0
}
declare -fx 'dryrun.set'

#@ Global  : _ent_DEBUG
#@ Desc    : '_ent_DEBUG'  
#@         : 
#@ Example : _ent_DEBUG
#@         : 
#@ See Also: 
declare -ix '_ent_DEBUG'
_ent_DEBUG=0
#@ Function: debug.set is.debug
#@ Desc    : General purpose globalx setting for debugging. 
#@         : debug.set sets the debug value (0|1) when a 
#@         : parameter is passed. If a parameter is not passed, 
#@         : the current status of debug is echoed.
#@         : debug is a conditional test function, returning 
#@         : !(debug.set).
#@ Defaults: 0|off
#@ Synopsis: debug.set [[on|1] | [off|0]]
#@         : $(debug.set)
#@         : debug
#@ Example : debug.set on
#@         : debug && msg \"my debug message\"
#@         : olddebug=$(debug.set)
is.debug() {	return $(( ! _ent_DEBUG )); }
declare -fx 'is.debug'
	debug() { is.debug "$@"; }; declare -fx 'debug' #X legacy X#
debug.set() {
	if (( $# )); then _ent_DEBUG=$(onoff "$1" $_ent_DEBUG)
	else							echo "$_ent_DEBUG"
	fi
	return 0
}
declare -fx 'debug.set'


#@ Global  : _ent_STRICT
#@ Desc    : '_ent_STRICT'  
#@         : 
#@ Example : _ent_STRICT
#@         : 
#@ See Also: strict.set is.strict
declare -ix '_ent_STRICT'
_ent_STRICT=0
#@ Function: strict.set is.strict
#@ Desc    : Sets/unsets options errexit, nounset and pipefail to
#@         : enable a 'strict' enviroment. Default is off. 
#@         :
#@         : Use of strict.set on (-o errexit -o nounset -o pipefile)
#@         : is particuarly recommended for development.
#@         :
#@         : Without parameters, strict.set echos current status (0|1).
#@         :
#@ Synopsis: strict.set [[on|1] | [off|0*]]
#@         :
#@ Example : strict.set on
#@         : curstatus=$(strict.set)
is.strict() { return $(( ! _ent_STRICT )); }
declare -fx 'is.strict'
strict.set() {
	if (( $# )); then
	 	local opt='+'
		_ent_STRICT=$(onoff "$1" $_ent_STRICT)
		((_ent_STRICT)) && opt='-'
		set ${opt}o errexit ${opt}o nounset ${opt}o pipefail # ${opt}o noclobber -E
	else
		echo -n "$_ent_STRICT"
	fi
	return 0
}
declare -fx 'strict.set'


#@ Function : exit_if_not_root
#@ Desc     : If not root user, print failure message and exit script.
#@ Synopsis : exit_if_not_root
exit_if_not_root() {
	is.root || msg.die "$PRG can only be executed by root user."
	return 0
}
declare -fx 'exit_if_not_root'

#@ Function : check.dependencies
#@ Desc     : Check for script dependencies (programs, scripts, or functions 
#@          : in the environment).
#@:
#@ Synopsis : check.dependencies [-q|--quiet] name...
#@ 	        :	  -q|--quiet  do not print 'dependency-not-found' messages.
#@          : 	name        is a list of programs, scripts or functions.
#@:
#@ Example  : (( check.dependencies dirname ln )) && msg.die \"Dependencies missing.\"
#@:
#@ Depends  : which (not fatal if not found)
check.dependencies() {
	(( ${#@} )) || return 0
	local -- needed_dep=''
	local -- missing_deps=''
	local -i missing=0
	if [[ "${1:-}" == '--quiet' || "${1:-}" == '-q' ]]; then
		local -i _ent_VERBOSE=0 
		shift
	fi
	for needed_dep in "$@"; do
		if [[ ! -x "$needed_dep" ]]; then
      #shellcheck disable=SC2230 #^---^ SC2230: which is non-standard. Use builtin 'command -v' instead.
			if [[ ! -x $(which "$needed_dep") ]]; then
				if ! declare -Fp "$needed_dep" >/dev/null 2>&1; then
					if ! hash "$needed_dep" >/dev/null 2>&1; then
						((missing++))
						missing_deps+="$needed_dep "
					fi
				fi
			fi
		fi
	done
	((missing && _ent_VERBOSE)) && \
			echo >&2 "These dependencies are missing: ${missing_deps}"
	return "$missing"
}
declare -fx 'check.dependencies'


#--_ent_MINIMAL if defined, don't do this section.
if (( ! ${_ent_MINIMAL:-0} )); then
#@ File: Modules 
#@ Desc: By default, *all* files with a '.bash' extension located in
#@     : $ENTITIES/e.d/** are automatically included in the 
#@     : e.bash source file. 
#@     : Symlinks to *.bash files are processed last.
	shopt -s globstar
	if [[ -d "${ENTITIES:-/lib/include/e.bash}/e.d" ]]; then
		declare '_e'
		declare -a _userbash=()
		for _e in "${ENTITIES:-/lib/include/e.bash}"/e.d/**/*.bash; do
			if [[ -r "$_e" ]]; then
				if [[ ! -L "$_e" ]] ; then
					_userbash+=( "$_e" )
				else
					#shellcheck disable=SC1090
					source "$_e" || echo >&2 "**Source file [$_e] could not be included!" && true
				fi
			fi
		done
		# do symlinks last (includes e.d/user/*)
		for _e in "${_userbash[@]}"; do
			#shellcheck disable=SC1090
			source "$_e" || echo >&2 "**Source file [$_e] could not be included!" && true
		done
		unset _e _userbash
	fi
	
	#--check dependencies if not minimal
	if ! check.dependencies \
			readlink mkdir ln cat \
			systemd-cat wget base64 seq tty find touch tree lynx; then
		echo >&2 'Warning: Dependencies not found. e.bash may not run correctly.'	
	fi 
fi
#^^_ent_MINIMAL
#-Function Declarations End --------------------------------------------------

# expand all the aliases defined above.
#shopt -s expand_aliases # Enables alias expansion.

# by default, set +o errexit +o nounset +o pipefail
# unless changed otherwise in /etc/e.bash/e.bash.startup.conf
set +o errexit +o nounset +o pipefail

#@ REF     : e.bash.startup.conf 
#@ Desc    : If it exists, the file '/etc/e.bash/e.bash.startup.conf'
#@         : is executed immediately *after* e.bash has been fully 
#@         : loaded.
#@         : 
#@         : This file can contain server-preferred global defaults for 
#@         : every e.bash instance on this machine.
#@         : 
#@         : Keep entries simple.
#@         : 
#@ See Also: /etc/e.bash/e.bash.startup.conf
if [[ -r '/etc/e.bash/e.bash.startup.conf' ]]; then
	#shellcheck source=/etc/e.bash/e.bash.startup.conf
	source '/etc/e.bash/e.bash.startup.conf'
fi

#@ Global  : _ent_LOADED
#@ Desc    : Integer flag to announce that e.bash has been loaded. 
#@         : If not set, or set to 0, then e.bash is not loaded.
declare -xig '_ent_LOADED'
_ent_LOADED=1
_ent_scriptstatus+="e.bash loaded $(date +'%F %T')"

#@ Global  : _ent_DRYRUN
#@ Desc    : '_ent_DRYRUN'  
#@         : 
#@ Example : _ent_DRYRUN
#@         : 
#@ See Also: 

#@ Global  : _ent_EXITTRAP
#@ Desc    : '_ent_EXITTRAP'  
#@         : 
#@ Example : _ent_EXITTRAP
#@         : 
#@ See Also: 

#@ Global  : _ent_EXITTRAPFUNCTION
#@ Desc    : '_ent_EXITTRAPFUNCTION'  
#@         : 
#@ Example : _ent_EXITTRAPFUNCTION
#@         : 
#@ See Also: 

#@ Global  : _ent_MINIMAL
#@ Desc    : '_ent_MINIMAL'  
#@         : 
#@ Example : _ent_MINIMAL
#@         : 
#@ See Also: 

#@ Global  : _ent_MSG_PRE
#@ Desc    : '_ent_MSG_PRE'  
#@         : 
#@ Example : _ent_MSG_PRE
#@         : 
#@ See Also: 

#@ Global  : _ent_MSG_PRE_SEP
#@ Desc    : '_ent_MSG_PRE_SEP'  
#@         : 
#@ Example : _ent_MSG_PRE_SEP
#@         : 
#@ See Also: 

#@ Global  : _ent_MSG_USE_TAG
#@ Desc    : '_ent_MSG_USE_TAG'  
#@         : 
#@ Example : _ent_MSG_USE_TAG
#@         : 
#@ See Also: 

#@ Global  : _ent_ONEXITTRAPFUNCTION
#@ Desc    : '_ent_ONEXITTRAPFUNCTION'  
#@         : 
#@ Example : _ent_ONEXITTRAPFUNCTION
#@         : 
#@ See Also: 

#@ Global  : _ent_SCRIPT_VERSION
#@ Desc    : '_ent_SCRIPT_VERSION'  
#@         : 
#@ Example : _ent_SCRIPT_VERSION
#@         : 
#@ See Also: 


#@ Global  : _ent_TABSET
#@ Desc    : '_ent_TABSET'  
#@         : 
#@ Example : _ent_TABSET
#@         : 
#@ See Also: 

#@ Global  : _ent_TABWIDTH
#@ Desc    : '_ent_TABWIDTH'  
#@         : 
#@ Example : _ent_TABWIDTH
#@         : 
#@ See Also: 

#@ Global  : _ent_perrnoListFile
#@ Desc    : '_ent_perrnoListFile'  
#@         : 
#@ Example : _ent_perrnoListFile
#@         : 
#@ See Also: 

#@ Global  : _ent_scriptstatus
#@ Desc    : '_ent_scriptstatus'  
#@         : 
#@ Example : _ent_scriptstatus
#@         : 
#@ See Also: 

#fin

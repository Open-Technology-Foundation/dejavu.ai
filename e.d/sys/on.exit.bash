#!/bin/bash
#@ Function: on.exit
#@ Desc    : Sets an additional function that the on.exit cleanup function 
#@         : will call just before exiting a script (signal EXIT).
#@         :   OR 
#@         : Returns current value of the on.exit function.
#@         : 
#@         : Default on.exit function is null, meaning no additional 
#@         : function will be executed.
#@         : 
#@         : Note that exit trapping is enabled whenever a function 
#@         : is passed.  See also on.exit.set. 
#@         : 
#@         : errno ($?) is automatically passed as $1, and this 
#@         : should be preferred to $?.
#@         : 
#@ Synopsis: on.exit [exitfunction]
#@         : 
#@ Examples: exitroutine() {
#@         :   rm -rf "/tmp/tempdir"
#@         :   >&2 echo 'Bye.'
#@         :   return "${1:-$?}"
#@         : }
#@         : on.exit 'exitroutine' 
#@         : ...
#@         : 
#@ See Also: cleanup on.exit.set on.exit.function
#shellcheck disable=SC2016
declare -x _ent_ONEXITTRAPFUNCTION=''
on.exit() {
	if (($#));	then 
		_ent_ONEXITTRAPFUNCTION="$1" 
		on.exit.set on
	else 
		echo -n "$_ent_ONEXITTRAPFUNCTION"
	fi
	return 0
}
declare -fx 'on.exit'
  onexit() { 'on.exit' "$@"; };  declare -fx 'onexit' #X legacy X#
  trap.onexit() { 'on.exit' "$@"; };  declare -fx 'trap.onexit' #X legacy X#

#@ Function: on.exit.exec
#@ Desc    : Sets a function that must be called on exit from the program.
#@         : The 'cleanup' and 'on.exit.set' functions are enabled, and 
#@         : the specified function will be called just before script exit
#@         : (signal EXIT).
#@         : 
#@         : Default on.exit.exec is null.
#@         : 
#@         : Note that exit trapping is enabled whenever a function 
#@         : is passed.  See also on.exit.set. 
#@         : 
#@ Synopsis: on.exit.exec exitfunction
#@         : 
#@ Examples: exitroutine() {
#@         :   rm -rf "/tmp/tempdir"
#@         :   >&2 echo 'Bye.'
#@         : }
#@         : on.exit.exec 'exitroutine' 
#@         : ...
#@         : 
#@ See Also: cleanup on.exit.set on.exit.function
on.exit.exec() {
	_ent_EXITTRAPFUNCTION='{ cleanup $? ${LINENO:-0} '"${1:-}"'; }'
	on.exit.set 1
}
declare -fx 'on.exit.exec'

#@ Function: on.exit.set
#@ Desc    : Enables/disabled signal traps for EXIT and SIGINT (Ctrl-C) 
#@         : exit trap. 
#@         : 
#@         : on.exit.set is on (1) by default, and is enabled whenever a
#@         : new on.exit function is executed.
#@         : 
#@ Synopsis: on.exit.set [[on|1] | [off|0]]
#@         : See on.exit for examples.
#@         : 
#@ See Also: on.exit.function on.exit cleanup
declare -ix _ent_EXITTRAP=1
on.exit.set() {
	if (( $# )); then
		_ent_EXITTRAP=$(onoff "${1}" ${_ent_EXITTRAP})
		if ((_ent_EXITTRAP)); then
			#-- SC2064: Use single quotes, otherwise this expands now rather than when signalled.
			#shellcheck disable=SC2064
			trap '{ builtin echo -e >&2 "^C\n"; builtin exit; }' SIGINT
			local onexit="$_ent_EXITTRAPFUNCTION"
			if [[ ${onexit:0:1} == '{' ]]; then
				onexit="${onexit//;[[:blank:]]*\}/ \"${_ent_ONEXITTRAPFUNCTION}\"; \}}"
			else
				onexit="${onexit} ${_ent_ONEXITTRAPFUNCTION}"
			fi
			#shellcheck disable=SC2064
			trap "$onexit" SIGINT EXIT
		else
			trap -- SIGINT EXIT
		fi
	else
		echo -n "${_ent_EXITTRAP}"
	fi
	return 0
}
declare -fx 'on.exit.set'
  onexit.set() { 'on.exit.set' "$@"; };  declare -fx 'onexit.set' #X legacy X#
  trap.set() { 'on.exit.set' "$@"; };  declare -fx 'trap.set' #X legacy X#

#@ Function: on.exit.function
#@ Desc    : Sets the function defined that on.exit will call upon either 
#@         : EXIT signals.
#@         :   OR 
#@         : Returns current value of the function.
#@         : 
#@         : Default function is '{ cleanup $? ${LINENO:-0}; }'
#@         :
#@ Synopsis: on.exit.function ['trap_function']
#@         : 
#@ See Also: on.exit on.exit.set cleanup
#shellcheck disable=SC2016
declare -x _ent_EXITTRAPFUNCTION='{ cleanup $? ${LINENO:-0}; }'
on.exit.function() {
	if (($#));	then	_ent_EXITTRAPFUNCTION="$1" 
	else 							echo -n "$_ent_EXITTRAPFUNCTION"
	fi
	return 0
}
declare -fx 'trap.function'
  onexit.function() { 'on.exit.function' "$@"; };  declare -fx 'onexit.function' #X legacy X#
  trap.function() { 'on.exit.function' "$@"; };  declare -fx 'trap.function' #X legacy X#

  onexit.exit() { 'cleanup' "$@"; };  declare -fx 'onexit.exit' #X legacy X#
  on.exit.exit() { 'cleanup' "$@"; };  declare -fx 'on.exit.exit' #X legacy X#

#fin

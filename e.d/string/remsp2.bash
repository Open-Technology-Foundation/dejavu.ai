#!/bin/bash
#@ Function: remsp2
#@ Desc    : Remove double space from string, replace with 
#@         : single space, and remove leading and trailing blanks, 
#@:
#@ Synopsis: remsp [-b] "string"
#@         :   -b  include tab characters as space.
#@:
#@ Example : str=" 123     456 789     0123   "
#@         : str2=$(remsp2 "$str") 
#@         : echo "$str" | remsp2
#@:
#@ Depends : trim
remsp2() { 
	local -i incblank=0
	if (($#)); then
		if [[ $1 == '-b' ]]; then
			incblank=1
			shift
		fi
		if (($#)); then 
			if ((incblank)); then
				trim "${*//+([[:blank:]])/ }"; echo
			else
				trim "${*//+( )/ }"; echo
			fi
			return $?
		fi
	fi
	if ((incblank)); then
		while read -r; do trim "${REPLY//+([[:blank:]])/ }"; echo; done
	else
		while read -r; do trim "${REPLY//+( )/ }"; echo; done
	fi
	return $?
}
declare -fx remsp2
#fin

#!/bin/bash
#@ Function: hr2int
#@ Desc    : Return integer from human-readable number text.
#@         : b)ytes  k)ilobytes m)egabytes g)igabytes t)erabytes p)etabytes
#@:
#@         : Capitalise to use multiples of 1000 (S.I.) instead of 1024.
#@: 
#@ Synopsis: hr2int integer[bkmgtp] [integer[bkmgtp]]...
#@:
#@ Example:s 1) hr2int 34M
#@         : 2) hr2int 34m
#@         : 3) hr2int 34000000
#@:
#@ Requires: numfmt
hr2int() {
	local num h fmt
	while (($#)); do
		num=${1:-0} 
		h=${num: -1}
		if [[ ${h:-} =~ ^[-+]?[0-9.]+$ ]]; then 
			fmt=si
		else
			local LC_ALL=C
			if [[ "$h" > 'a' ]]; then 
				fmt=iec
			else 
				fmt=si		
			fi
		fi
		numfmt --round=nearest --from="$fmt" "${num^^}" || return 1
		shift 1
	done
	return 0
}
declare -fx hr2int

#@ Function: int2hr 
#@ Desc    : Convert integer to human-readable string, using SI (base 1000)
#@         : or IEC (1024) for conversion.
#@:
#@ Synopsis: int2hr number [si|iec] [number [si|iec]]...
#@         :   number   is any integer.
#@:
#@ Options : si|iec   number format (si: 1k=1000, iec: 1K=1024)
#@         :          Default format is 'si'.
#@         :
#@ Examples: 1) int2hr 1000 si 1000 iec 1024 si 1024 iec
#@         : 2) int2hr 10382 iec 872929292929 si
#@ Requires: numfmt
int2hr() {
	local -i num=0
	local fmt hr
	while (($#)); do
		num=$(( ${1:-0} )) || { echo >&2 "Invalid number [$num]"; return 1; }
 		fmt=${2:-si}
		fmt=${fmt,,}
		hr=$(numfmt --round=nearest --to="$fmt" "$num") || { echo >&2 "Invalid hr code [$h]"; return 1; }
		[[ $fmt == 'iec' ]] && hr="${hr,,}"
		echo "$hr"
		shift 1
		(($#)) && shift 1
	done
	return 0	
}
declare -fx int2hr
#fin

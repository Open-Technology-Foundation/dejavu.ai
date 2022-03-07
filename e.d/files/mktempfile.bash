#!/bin/bash
#! shellcheck disable=SC2174,SC2154
#@ Function: mktempfile 
#@ Desc    : Make a temporary file. 
#@:
#@         : Template format is:
#@         :    /{TMPDIR}/{subdir}/filename.ext
#@:
#@         : If TMPDIR not specified in environment, defaults to '/tmp'. 
#@         : (See: tmpdir.set)
#@:
#@         : TMPDIR is currently $(tmpdir.set)
#@:
#@ Synopsis: mktempfile [subdir [filename_base [file_ext]]]
#@         : If subdir not specified, defaults to current value of \$PRG.
#@:
#@         : If filename_base not specified, defaults to current value of 
#@         : \$PRG.
#@:
#@         : If file_ext not specified, defaults to '.tmp'. Leading '.' is 
#@         : optional.
#@:
#@         : Return value of '' means failure.
#@         : Filename always echoed to stdout.
#@:
#@ Examples: mytmpfile=$(mktempfile "\$PRG" "logs-\$(date +%F%T)" log) 
#@:
#@ See Also: tmpdir.set
mktempfile() {
	local TmpDir TmpFile
	local base_subdir="${1:-${PRG:-e.bash}}"
	local ext=${3:-tmp}
	[[ ${ext:0:1} == '.' ]] && ext=${ext:1}
	local filename_base="${2:-${PRG:-"$(basename "$0")"}}_XXXX.${ext}"
	TmpDir="${TMPDIR:-/tmp}/$base_subdir"
	mkdir --mode=770 -p "$TmpDir" || { echo ''; return; }
	TmpFile=$(mktemp "$TmpDir/$filename_base")
	chmod 660 "$TmpFile"
	echo "$TmpFile"
	return 0
}
declare -fx mktempfile

#@ Function: tmpdir.set
#@ Desc    : Sets TMPDIR location, with optional fallback if first 
#@         : option not writable. Final fallback is always /tmp.
#@         :
#@ Synopsis: tmpdir.set ["tmpdir" ["fallbackdir"]] 
#@         :
#@ Example : tmpdir.set '/run/e.bash' '/tmp/e.bash'
#@         : tmpdir="$(tmpdir.set)"
#@         :
#@ See Also: mktempfile
declare -x TMPDIR="${TMPDIR:-/tmp}"
tmpdir.set() {
	if (( $# )); then
		local tmp=$1
		tmp=$(readlink -e "$1" >/dev/null)
		# fail silently if not found; do not change TMPDIR
		if [[ ! -d "$tmp" ]]; then
			mkdir -m 777 -p "$tmp" || { echo ''; return 1; }
		fi
		if [[ -w "$tmp" ]]; then
			TMPDIR="$tmp"
		elif [[ -n "${2:-}" ]]; then
			if [[ -d "$2" ]]; then
				mkdir -m 777 -p "$2" || { echo ''; return $?; }
			fi
			if [[ -w "$2" ]]; then
				TMPDIR="$2"
			else
				echo ''
				return 1
			fi
		fi
	fi
	echo "${TMPDIR:-/tmp}"
}
declare -fx 'tmpdir.set'

#fin

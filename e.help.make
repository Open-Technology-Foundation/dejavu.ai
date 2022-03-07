#!/bin/bash
#shellcheck source=e.bash.min
source "$(dirname "$0")/e.bash.min" new || { echo >&2 "Could not open [$(dirname "$0")/e.bash]."; exit 1; }

	on.exit.set on
	strict.set off
	#shellcheck disable=2154
	version.set "${_ent_VERSION}"
	msg.usetag.set off
	msg.prefix.set 'e.help.make'
		
	declare EDir
	EDir="${PRGDIR:-}"
	[[ -z $EDir ]] && msg.die -e 2 "Directory '$EDir' not found!"
	# sanity check
	[[ "$(basename "$EDir")" == 'e'* ]] || msg.die -e 69 "Sanity check fail."
	
	declare HelpFilesDir="${EDir}/docs/help"

	# Canonical Category Labels
	declare -ura CatHdrs=(
			ABOUT
			LICENCE
			GLOBALVAR
			FUNCTION
			SCRIPT
			PROGRAM
			REFERENCE
		)
	#shellcheck disable=SC2174,SC2086	
	mkdir -p --mode=755 ${CatHdrs[*]/#/${HelpFilesDir}\/}
	
	# Canonical Subheader Labels
	declare -ura SubHdrs=(
			AUTHOR
			BUGS
			COPYRIGHT
			DEFAULTS
			DEPENDS
			DESC
			ENVIRON
			EXAMPLE
			FILES
			OPTIONS
			SEE_ALSO
			SYNOPSIS
			TAGS
			TODO
			VERSION
		)

	# transpostion aliases
	declare -urA TransHdrs=(
			[FUNC]='FUNCTION'
			[GLOBAL]='GLOBALVAR'
			[GLOBALX]='GLOBALVAR'
			[INTRO]='ABOUT'
			[INTRODUCTION]='ABOUT'
			[REF]='REFERENCE'

			[BUG]='BUGS'
			[BY]='AUTHOR'
			[COPYLEFT]='COPYRIGHT'
			[DEF]='DEFAULTS'
			[DEFS]='DEFAULTS'
			[DESCRIPTION]='DESC'
			[EG]='EXAMPLE'
			[ENV]='ENVIRON'
			[ENVIRONMENT]='ENVIRON'
			[EXAMPLES]='EXAMPLE'
			[EX]='EXAMPLE'
			[FILE]='FILES'
			[OPTS]='OPTIONS'
			[REQ]='DEPENDS'
			[REQUIRE]='DEPENDS'
			[REQUIRES]='DEPENDS'
			[SEE]='SEE_ALSO'
			['SEE ALSO']='SEE_ALSO'
			[TAG]='TAGS'
			[USE]='SYNOPSIS'
			[USAGE]='SYNOPSIS'
			[USEAGE]='SYNOPSIS'
			[VER]='VERSION'
		)

	#declare -i HelpColWidth=69
	
main() {
	local SourceFile HelpOutputFile=''
	local -a DocLines
	local DocLine txt lbl sx
	local -a symlinks=()

	rm -rf "${HelpFilesDir:-:}/"

processSource() {
	local htype=${1:-}
	# go through them one-by-one ...
	for SourceFile in "${bashfiles[@]}"; do
		[[ $(file "$SourceFile") == *"ASCII text"* ]] || continue
		msg.info "Searching ${SourceFile/${EDir}\//}"
		
		if [[ $htype == 'script' ]]; then
			mapfile -t DocLines < <("$SourceFile" --help || true)
		else
			mapfile -t DocLines < <(grep '^#[X@][[:blank:][:alnum:]._-]*:' "$SourceFile")
		fi

		for	DocLine in "${DocLines[@]}"; do
			txt=$(rtrim "${DocLine#*:}")
			#[[ -z $txt ]] && continue
			lbl=${DocLine%%:*}; lbl=${lbl^^}
			if [[ $htype == 'script' ]]; then 
				lbl=$(trim "$lbl")
			else
				lbl=$(trim "${lbl:2}")
			fi
			if [[ -n $lbl ]]; then
				# transpose aliases
				# shellcheck disable=SC2102
				[[ -v TransHdrs[$lbl] ]] && lbl=${TransHdrs[$lbl]}
				# has HEADER changed? Then change the HelpOutputFile
				if [[ " ${CatHdrs[*]} " == *" $lbl "* ]]; then
					# say goodbye to current HelpOutputFile
					[[ -n $HelpOutputFile ]] && \
							print2OutputFile 'URL'  "file://${SourceFile//\/\//\/}"
					# close current HelpOutputFile

					# open new HelpOutputFile ===================
					Label=$lbl
					Header=$txt
					mkdir -p "$HelpFilesDir/$Label" || msg.die "mkdir '$HelpFilesDir/$Label' failed."
					read -r -a symlinks <<<"$Header"
					HelpOutputFile="$HelpFilesDir/$Label/${symlinks[0]}"
					rm -f "$HelpOutputFile"
					#print2OutputFile 'SOURCE' "${SourceFile/${EDir}\//}"
					# if more than one entry in Header, then make symlinks to first entry.
					for sx in "${symlinks[@]:1}"; do
						(	cd "$HelpFilesDir/$Label" || msg.die "cd '$HelpFilesDir/$Label' failed."		# catastophic error that Must Not Happen
							ln -fs "${symlinks[0]}" "${sx}"
						)
					done
				elif [[ " ${SubHdrs[*]} " == *" $lbl "* ]]; then
					Label=$lbl #???	
				else
					msg.warn "Unknown Help Label '$lbl' in '$SourceFile'" "docline='$DocLine' CatHdrs='${CatHdrs[*]}'"
				fi
			fi
			print2OutputFile "${lbl:0:11}" "${txt}" "$htype"
		done
		# say goodbye to current HelpOutputFile
		print2OutputFile 'URL' "file://$SourceFile" ''
		# close current HelpOutputFile
		HelpOutputFile=''
		# say goodbye to Label
		Label=''
		Header=''
	done
}

	# find all .bash and .c files
	mapfile -t bashfiles < \
			<(find "$EDir/" \( -name "*.bash" -o -name "*.c" \) -type f 2>/dev/null \
					| grep -v "/docs/\|.gudang\|.min\|/dev/\|/test/\|/_\|~" | sort)
	processSource
	
	mapfile -t bashfiles < \
			<(find "$EDir/scripts/" -executable -maxdepth 1 -type f 2>/dev/null \
					| grep -v "/docs/\|.gudang\|.min\|/dev/\|/test/\|/_\|~" | sort)
	
	processSource script || msg.die 'Error in docs'
	
#	mapfile -t -O ${#bashfiles[@]} bashfiles < \
#			<(find "$EDir" -executable -maxdepth 4 -type f 2>/dev/null \
#					| grep -v ".git\|/docs/\|.gudang\|.min\|/dev/\|/test/\|~" | sort)


	msg.info "Finished."
	return 0
}

print2OutputFile() {
#set -e
#HelpOutputFile=/tmp/eh
	local lbl="${1:-}" txt="${2:-}"
	local htype="${3:-}"
	local -a WR
	if [[ -z $HelpOutputFile ]]; then
		((_ent_DEBUG)) && msg.warn "No Output File for '$lbl:$txt'"
		return 0
	fi
	txt=$(expand -t 2 <<<"$txt")
	txt=${txt//\\\"/\"}
	txt=${txt//\\\$/\$}
#	mapfile -t WR < <(fold -w "$HelpColWidth" -s <<<"$txt")
	mapfile -t WR <<<"$txt"
	lbl="${lbl,,}"
	for txt in "${WR[@]}"; do
#		if [[ $htype == 'script' ]]; then
#			printf '%10s: %s\n' "${lbl^}" "$(eval "echo \"$txt\"")" >>"$HelpOutputFile"
#		else
			printf '%10s: %s\n' "${lbl^}" "$txt" >>"$HelpOutputFile"
#		fi
		lbl=''
	done
	return 0
}

main "$@"
#fin

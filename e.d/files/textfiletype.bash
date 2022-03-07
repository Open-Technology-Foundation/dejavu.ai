#!/bin/bash
#!shellcheck disable=SC2249
# joe
#   for f in /usr/share/joe/syntax/*.jsf; do basename -s '.jsf' "$f"; done
# nano
#   for f in /usr/share/nano/*.nanorc; do basename -s '.nanorc' "$f"; done
#   -Y <str>   --syntax=<str>      Syntax definition to use for coloring

# File stats from Scripts directory
#   4683 ASCII text
#    411 Bourne-Again shell script
#    233 XML 1.0 document
#    105 HTML document
#     41 POSIX shell script
#     17 PHP script
#     12 C source
#      6 SMTP mail
#      5 exported SGML document
#      2 Windows WIN.INI
#      2 troff or preprocessor input
#      2 TeX document
#      2 Python script
#      2 Non-ISO extended-ASCII text
#      1 Perl5 module source
#      1 BSD makefile script         
#     38 a /usr/bin/env bats script
#     11 a /usr/bin/php script
#      3 a /usr/bin/env /bin/bash script
#      1 a /usr/bin/perl script
#      1 a /bin/env -i /bin/bash script

#@ Function: editorsyntaxstring
#@ Desc    : Return full path and arguments to edit a text file.
#@         : Only editors 'joe' and 'nano' are supported at the moment.
#@ Usage   : editorsyntaxstring filetype filename
editorsyntaxstring() {
	local FileType="${1:-text}"
	local FileName="${2:-}"
	local editor
	editor="${3:-${EDITOR}}"
	local opt=''

	editor="$(basename "${editor%% *}")"

	# aggregate some filetypes	
	case "$FileType" in
		html)		FileType='php';;
		bash)		FileType='sh';;
	esac

	case "$editor" in
		joe) 	[[ $FileType == 'text' ]] && FileType='sh'
					if [[ ! -f "/usr/share/joe/syntax/$FileType.jsf" ]]; then 
						echo >&2 "joe: Syntax file [$FileType].jsf not found for [$FileName]"
						FileType=text
						opt=''
					else
						opt="-syntax $FileType"			
					fi
					;;
		nano)
					opt="--syntax=$FileType"
					;;
		*)		msg.err "Editor [$editor] not found.";;
	esac
x	echo "$EDITOR $opt $FileName"
}
declare -fx editorsyntaxstring


DefineTextFileTypes() {
	local -Axg _ent_TextFileTypes=(	
			['ASCII text']='text'
			['Bourne-Again shell script']='bash'
			['XML 1.0 document']='xml'
			['HTML document']='html'
			['POSIX shell script']='sh'
			['PHP script']='php'
			['C source']='c'
			['SMTP mail']='smtp'
			['exported SGML document']='sgml'
			['Windows WIN.INI']='ini'
			['TeX document']='tex'
			['Python script']='python'
			['Non-ISO extended-ASCII text']='text'
			['Perl5 module source']='perl'
			['BSD makefile script']='bsdmake'
		)
}
declare -fx DefineTextFileTypes

#@ Function: textfiletype
#@ Desc    : Return type of text.
#@ Usage   : textfiletype [-t] filename
#@         :   -t  Return type only without filename.
textfiletype() {
set -e
	[[ ! -v _ent_TextFileTypes[@] ]] && DefineTextFileTypes
	local -- testfile='' ext
	local -i typeonly=0
	local -- File=''
	local -- FileType='text'
	while (( $# )); do
		testfile="${1}"
		# for typeonly option 
		[[ $testfile == '-t' ]] && { typeonly=1; shift; continue; }
		# why are you giving me a directory?
		[[ -d "$testfile" ]] && { shift; continue; }

		FileType=''
		ext=${testfile##*\.}
		case "$ext" in
			php)				FileType='php';;
			htm|html)		FileType='html';;
			sh|conf)		FileType='sh';;
			bash|cnf)		FileType='bash';;
			c|h)				FileType='c';;
			xml)				FileType='xml';;
		esac
		
		# still equals text, so check header, then 'file' command output
		if [[ -z $FileType ]]; then
			# the file exists therefore examine it.
			if [[ -f "$testfile" ]]; then
				# head examination. first 32 chars
				h="$( { head -c 64 "$testfile" 2>/dev/null || echo ' '; } | strings -w 2>/dev/null)" || h=''
				if 	 [[ "$h" =~ ^\#\!.*/bash.* ]];	then	
					FileType='bash'
				elif [[ "$h" =~ ^\#\!.*/sh.* || "$h" =~ ^\#\!.*/dash.* ]];	then	
					FileType='sh'
				elif [[ "$h" =~ ^\#\!.*/php.*  || ${h} == '<?' || ${h:0:5} == '<?php' ]];	then	
					FileType='php'
				else
					# file command examination
					File="$(trim "$(file "$testfile" | grep ' text' | cut -d':' -f2)")"
					[[ -z $File ]] && { shift; continue; }
					File=${File%%,*}
					[[ -z $File ]] && File='text'
					if [[ "${!_ent_TextFileTypes[*]}" == *"$File"* ]]; then
						FileType="${_ent_TextFileTypes[$File]}"
						[[ -z $FileType ]] && FileType='text'
					fi
				fi
			fi
		fi
				
		[[ -z $FileType ]] && FileType='text'
		if ((typeonly)); then
			echo "${FileType}"
		else
			echo "${FileType} ${testfile}"
		fi
		shift
	done
}
declare -fx textfiletype
#fin

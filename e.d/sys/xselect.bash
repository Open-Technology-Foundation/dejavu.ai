#!/bin/bash
#@ Function: xselect
#@ Desc    : Alternative to the 'select' command.
#@:
#@         : Returns name of item selected, OR exit key preceeded with '!'.
#@:
#@         : By default, exit keys are:
#@         :   Exit key '!0' or '!b' means back up a level.
#@         :   Exit key '!t' or '!^' means return to top level.
#@         :   Exit key '!q'         meansquit program.   
#@         :
#@ Synopsis: xselect [Options] list... [[Options] list...]
#@         : Where 'list' is a list of filesname/menuitems.
#@         :
#@ Options : -n|--var varname    Assign selected item to 'varname'.
#@         : -p|--prompt str     Select prompt. Default is '? '
#@         : -c|--columns num    Number of screen columns (Default COLUMNS) 
#@         : -f|--file           File item. Do not apply basename to 
#@         :                     subsequent items. (Default)
#@         : -m|--menu           Menu item. Display basename only of all 
#@         :                     subsequent items, but return full path.
#@         : -e|--exitkeys keys  Keys that can be used to exit the
#@         :                     selection, returned in the form '!k' where 
#@         :                     'k' is an allowed exit character. Default 
#@         :                     exitkeys are '0b^tq'
#@         : -H|--helptext text  Help test to display on entry to selection 
#@         :                     menu. Default helptext is 
#@         :                     'Keys: 0|b=back ^|t=top q=quit' 
#@         : 
#@ Examples: xselect -v SelFile -f * -m Exit)
#@         : [[ ${SelFile:0:1} != '!' ]] && \$EDITOR \"\$SelFile\"
#@         : 
xselect() {
	local pathname reply \
			prompt='? ' \
			ExitKeys='0b^tq' \
			HelpText='Keys: 0|b=back ^|t=top q=quit' DisplayHelpText=''
	local -i i=0 lennum menu=0
	local -a Items=() ItemsDisp=()
	#declare -i COLUMNS
	COLUMNS=${COLUMNS:-$(tput cols 2>/dev/null || echo '80')}

	while(($#)); do	case $1 in
		-n|-v|--var)		shift; local -n Var="$1"				;;
		-p|--prompt)		shift; (($#)) && prompt="$1"		;;
		-c|--columns)		shift; (($#)) && COLUMNS="$1"		;;
		-m|--menu)			menu=1 													;;
		-f|--file)			menu=0 													;;
		-e|--exitkeys)	shift; (($#)) && ExitKeys="$1"	;;
		-H|--helptext)	shift; (($#)) && HelpText="$1"	;;
		-[nvpcmfeH]*)		#shellcheck disable=SC2046 # expand aggregated short options
										set -- '' $(printf -- "-%c " $(grep -o . <<<"${1:1}")) "${@:2}" ;;
		-*)							: 															;;
		*)							pathname="$1"
										Items+=( "$pathname" )
										((menu)) || pathname=$(basename "$pathname")
										ItemsDisp+=( "$pathname" ) 			;;
	esac; shift; done

	while((1)); do
	  lennum=${#ItemsDisp[@]}; lennum=${#lennum}
		i=0
 		for pathname in "${ItemsDisp[@]}"; do 
    	i+=1
    	printf "%${lennum}i) %s\n" "$i" "$pathname"
  	done | column -c "${COLUMNS:-80}" | expand -t 8 >&2

		[[ -n $DisplayHelpText ]] && { >&2 msg.warn "$DisplayHelpText"; DisplayHelpText=''; }
		read -r -p "$prompt" reply >&2
		[[ -z "$reply" ]] && continue
		# is it a one-character exit command?
		if ((${#reply} == 1)); then
			[[ $reply == '?' ]] && { DisplayHelpText="$HelpText"; continue; }
			[[ $reply =~ [$ExitKeys] ]] && { 
				[[ -R Var ]] && Var="!$reply" || echo "!$reply"
				return 0
			}		
		fi
    [[ $reply =~ ^[-+]?[0-9]+$ ]] || continue
		i=${reply%%)*}	
		if (( i > "${#Items[@]}" || i < 1 )); then
			>&2 echo 'Invalid selection.'
		else
			if [[ -R Var ]]; then
				#shellcheck disable=SC2034
				Var="${Items[$i-1]}"
			else
				echo "${Items[$i-1]}"  
			fi
			return 0
		fi
	done
}
declare -fx 'xselect'

#fin

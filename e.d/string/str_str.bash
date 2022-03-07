#!/bin/bash
#@ Function : str_str
#@ Desc     : Return the string that occurs between two match strings.
#@          :
#@ Synopsis : str_str \"string\" \"matchbegin\" \"matchend\" 
#@          :
#@ Example  : # This will return 'test'
#@          : param=\$(str_str \"this is a [[test]] of str_str\" '[[' ']]'
#@          :
str_str() {
	local str
	str="${1#*${2}}"
 	echo -n "${str%%${3}*}"
}
declare -fx str_str
#fin

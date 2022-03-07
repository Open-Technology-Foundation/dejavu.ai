#!/bin/bash
#@ Function: titlecase
#@ Desc    : Upper case first letter of each word, lowercase the rest.
#@ Synopsis: titlecase "str" [...]
#@ Example : str="dharmA bUms"
#@         : titlecase "$str"
titlecase() { 
	(( $# )) || { echo ''; return 0; }
	[[ -z $* ]] && { echo ''; return 0; } 
	set ${*,,}
	echo ${*^}
}
declare -fx titlecase
#fin

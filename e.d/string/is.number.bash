#!/bin/bash
#@ Function: is.number 
#@ Desc    : Is parameter a number? Return true/false
#@ Synopsis: is.number "numstr"
#@         :
#@ Example : is.number "420"  && echo "$1 is number"  # returns true
#@         : is.number "4.20" && echo "$1 is number"  # returns true
#@         : is.number "4Z20" && echo "$1 is number"  # returns false
#@         : 
is.number() {	[[ ${1:-} =~ ^[-+]?[0-9.]+$ ]] || return 1; }
declare -fx 'is.number'

#@ Function: is.int
#@ Desc    : Is parameter an integer? Return true/false
#@ Synopsis: is.int "numstr"
#@         :
#@ Example : is.int "420"  && echo "is int"  # returns true 
#@         : is.int "4.20" && echo "is int"  # returns false 
#@         : is.int "4Z20" && echo "is int"  # returns false
#@         :
is.int() {	[[ ${1:-} =~ ^[-+]?[0-9]+$ ]] || return 1; }
declare -fx 'is.int'
#fin

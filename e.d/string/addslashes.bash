#!/bin/bash
#!shellcheck disable=SC2162
#@ Function: addslashes
#@ Desc    : Insert \\ backslash before every single and double quote char. 
#@ Synopsis: addslashes
#@ Example : cat text1 | addslashes > text2
addslashes() {
	read line; 
	while [[ "$line" != "" ]]; do 
		echo "$line" | sed "s/'/\\\\'/g; s/\"/\\\\\"/g;"
		read line
	done
	return 0
}
declare -fx addslashes
#fin

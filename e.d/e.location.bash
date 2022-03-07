#!/bin/bash
#@ Function: e.location
#@ Desc    : Return with current setting for ENTITIES and PATH.
#shellcheck disable=SC2154
e.location() { 
	echo "${ENTITIES@A};${PATH@A}"
}
declare -fx e.location
#fin

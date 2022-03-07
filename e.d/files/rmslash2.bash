#!/bin/bash
#! shellcheck disable=SC2154
#@ Function: rmslash2
#@ Desc    : Remove double slashes in a pathname.
#@ Synopsis: rmslash string
#@         :
#@ Example : filename="//123/456///789/0"
#@         : rmslash2 "$filename" # returns /123/456/789/0
#@         :
rmslash2() { echo "${@//+(\/)\//\/}"; }
declare -fx rmslash2
#fin

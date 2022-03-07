#!/bin/bash
#@ Function	: urldecode
#@ Desc			: URL-decode a string.
#@ Synopsis	: urldecode "string"
#@          :
#@ Example  : for f in /opt/logs/*.log; do
#@          :   name=${f##/*/}
#@          :   cat $f | urldecode > /mylogdir/$HOSTNAME.$name
#@          : done
urldecode() { echo -e "$(sed 's/+/ /g;s/%\(..\)/\\x\1/g;')"; }
declare -fx urldecode
#fin

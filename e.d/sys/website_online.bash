#!/bin/bash
#@ Function: website_online 
#@ Desc    : Return true if all website/s are available and online (200 || 301).
#@ Synopsis: website_online "website"...
#@ Example : website_online 'okusi.id' 'okusiassociates.com' && echo 'Online'
website_online() {
	while(($#)); do
		( curl --head --insecure "$1" 2>/dev/null | grep -w "200\|301" >/dev/null) ||	return 1
		shift
	done
	return 0	
}
declare -fx 'website_online'
#fin

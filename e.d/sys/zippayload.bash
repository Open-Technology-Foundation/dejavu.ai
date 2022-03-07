#!/bin/bash
#@ Function: urlpayload_encode 
#@ Synopsis: urlpayload_encode "payload_string"
urlpayload_encode() {	
	echo -n "$( urlencode "$(payload_encode "${1}")" )" 
	return 0
}
declare -fx urlpayload_encode

#@ Function: payload_encode
#@ Synopsis: payload_encode "payload_string"
payload_encode() { 
	echo -n "$( echo -n "${1:-}" | gzip 2>/dev/null | base64 -w0 2>/dev/null)" 
	return 0
}
declare -fx payload_encode 

#@ Function: payload_decode
#@ Synopsis: payload_decode "encoded_payload_string"
payload_decode() {
	local str="${1:-}" bstr='' gzipid
	gzipid="$(echo -e "\x1f\x8b")" 
	[[ -z "$str" ]] && { echo -n ''; return 0; }
	# is base64?
  bstr="$(echo "$str" | base64 -d -i 2> /dev/null | tr -d '\r\n\0')"
  if ((! ${#bstr})); then
		echo -n "$str"
		return 0
	fi
	# is gzip?
	if [[ "${bstr:0:2}" == "$gzipid" ]]; then
#		echo -n "$( echo "${str}" | base64 -d  2> /dev/null | /bin/gzip -d  2>/dev/null)"
#		echo -n "$( echo "${str}" | base64 -d  2>/dev/null | tr -d '\r\n\0' | /bin/gzip -d  2>/dev/null)"
#		echo -n "$( echo "${str}" | base64 -d | tr -d '\r\n\0' | /bin/gzip -d)"
		echo -n "$( echo -n "${str}" | base64 -d | gzip -d)"
#		echo -n "$( echo "${bstr}" | /bin/gzip -d  2>/dev/null)"
	else
		echo -n "${bstr}"
	fi
	unset str bstr
	return 0
}
declare -fx payload_decode

#fin

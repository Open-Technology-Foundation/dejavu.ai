#!/bin/bash
#@ Function: post_slug
#@ Desc    : Produce a URL-friendly slug string.
#@:
#@         : String is lowercased, and non-ASCII chars replaced with 
#@         : ASCII-equivalent.
#@:
#@         : All non-alnum chars are replaced with {replacestr} (default '-')
#@:
#@				 : Multiple occurances of {replacestr} are reduced to one, and 
#@         : leading and trailing {replacestr} chars removed.
#@         :
#@ Synopsis: myslug=$(post_slug \"str\" [\"replacestr\"])
#@         :   replstr   is optional, defaults to '-'
#@         :
#@ Example : post_slug 'A title, with  Ŝŧřãņġę  cHaracters ()'
#@         : # ^ returns "a-title-with-strange-characters" 
#@:
#@         : post_slug ' A title, with  Ŝŧřãņġę  cHaracters ()" '_'
#@         : # ^ returns: "a_title_with_strange_characters"
#@:
#@ Depends : iconv
post_slug() {
	shopt -s extglob
	local str="${1:-}" repl="${2:--}" preserve_case="${3:-0}"
	# lowercase all
	if ((preserve_case)); then
		str="$(echo "${str}"   | iconv -f UTF-8 -t ASCII//TRANSLIT )"
	else 
		str="$(echo "${str,,}" | iconv -f UTF-8 -t ASCII//TRANSLIT )"
	fi
	# replace all non alnum chars with {repl}
	str="${str//[^[:alnum:]]/${repl}}"
  # replace all double occurences of {repl} with one only {repl}
	str="${str//+([${repl}])/${repl}}"
	# remove beginning {repl} char
	[[ ${str:0:1} == "$repl" ]] && str="${str:1}"
	# remove ending {repl} char
	[[ ${str: -1} == "$repl" ]] && str="${str:0: -1}"
	# translate non ascii chars
	echo -n "$str"
}
declare -fx post_slug

#@ Function: remove_accents
#@ Desc    : Transliterate non-ASCII characters to an ASCII 
#@         : near-equivalent.
#@         :
#@ Synopsis: remove_accents "string"
#@         :
#@ Requires: iconv
remove_accents() {
	echo -n "${1:-}" | iconv -c -f UTF-8 -t ASCII//TRANSLIT//IGNORE
}
declare -fx remove_accents

#fin

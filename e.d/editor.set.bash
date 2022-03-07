#!/bin/bash
#! shellcheck disable=SC1090
#@ GLOBAL  : _ent_EDITOR
#@ Desc    : Defines/validates default EDITOR envvar.
#@:
#@         : Sets value of EDITOR *if* EDITOR is unset/empty.
#@         :   1. first priority is SUDO_EDITOR
#@         :   2. then SELECTED_EDITOR
#@ 	       :   3. then try sourcing \$HOME/.selected_editor
#@ 	       :   4. test for /etc/alternatives/editor
#@:
#@	       : If none of the above, EDITOR defaults to _ent_EDITOR
#@ 	       : The first argument is tested to see if it is executable.
#@    	   : If it is not, then EDITOR defaults back to _ent_EDITOR.
#@         :
#@ See Also: EDITOR SUDO_EDITOR SELECTED_EDITOR _ent_EDITOR

	# Default entitites fallback EDITOR setting
	declare -gx '_ent_EDITOR'
	# explicit Lowest Common Denominator editor
	_ent_EDITOR="$(command -v nano 2>/dev/null || command -v joe 2>/dev/null)"

	declare -gx 'EDITOR'
	if [[ -z "${EDITOR:-}" ]]; then
		# default bottom line editor, in the absense of all others
		[[ -n "${_ent_EDITOR:-}" ]] && EDITOR="${_ent_EDITOR}"
		# first prioity is SUDO_EDITOR
		if [[ -n "${SUDO_EDITOR:-}" ]]; then
			EDITOR="${SUDO_EDITOR}"
		# then SELECTED_EDITOR
		elif [[ -n "${SELECTED_EDITOR:-}" ]]; then
			EDITOR="${SELECTED_EDITOR}"
		# then try sourcing .selected_editor
		elif [[ -r "${HOME:-}/.selected_editor" ]]; then
			source "${HOME:-}/.selected_editor" || true
			[[ -n "${SELECTED_EDITOR:-}" ]] && EDITOR="${SELECTED_EDITOR}"
		# is the alt-editor home?
		elif [[ -x /etc/alternatives/editor ]]; then
			EDITOR='/etc/alternatives/editor'
		fi
	fi
	# the first argument must be found as an executable program
	declare '_ed_'
	_ed_="${EDITOR%% *}"
	_ed_="$(command -v "${_ed_}" 2>/dev/null)"
	if [[ ! -x "${_ed_}" ]]; then
		echo >&2 "Editor '${EDITOR}' not found! Using '${_ent_EDITOR}'"
		EDITOR="${_ent_EDITOR}"
	else
		[[ $EDITOR != *' '* ]] && EDITOR='' 
		EDITOR="${_ed_} ${EDITOR#* }"
	fi
	
	unset '_ed_'
	export EDITOR _ent_EDITOR

#fin

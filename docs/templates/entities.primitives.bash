# start entities 'primitives' for stand-alone scripts
#shellcheck disable=SC2034
declare -- _e_0 PRG PRGDIR; PRG=$(basename "${_e_0}"); PRGDIR=$(dirname "${_e_0}")
_e_VERSION='0.1';	version.set() { (($#)) && _e_VERSION="$*" || echo "$_e_VERSION"; }
_e_VERBOSE=1;  msg.verbose.set() { (($#)) && _e_VERBOSE=$(onoff "$*") || echo "$_e_VERBOSE"; }
cleanup() { local -i err=${1:-$?}; ((err>1)) && errno "$err"; exit "$err"; }
trap 'cleanup' SIGINT EXIT; trap.set() { :; }
_e_STRICT=0; strict.set() { (($#)) || { echo -n "${_e_STRICT}"; return 0; }; local opt='+'; _e_STRICT=$(onoff "${1}" ${_e_STRICT}); ((_e_STRICT)) && opt='-'; set ${opt}o errexit ${opt}o nounset ${opt}o pipefail; return 0; }
_e_MSG_PRE="$PRG"; msg.prefix.set() { (($#)) && _e_MSG_PRE="$*" || echo "$_e_MSG_PRE"; }
msg() { ((_e_VERBOSE)) || return 0; while read -r l; do echo "$_e_MSG_PRE:" "$l"; done <<<"$@"; }
msg.info() { ((_e_VERBOSE)) || return 0; while read -r l; do echo "$_e_MSG_PRE:" "$l"; done <<<"$@"; }
msg.warn() { ((_e_VERBOSE)) || return 0; while read -r l; do echo >&2 "$_e_MSG_PRE: !!! " "$l"; done <<<"$@"; }
msg.warning() { ((_e_VERBOSE)) || return 0; while read -r l; do echo >&2 "$_e_MSG_PRE: !!! " "$l"; done <<<"$@"; }
msg.err() { while read -r l; do echo >&2 "$_e_MSG_PRE: *** " "$l"; done <<<"$@"; }
msg.sys() { systemd-cat -t "$_e_MSG_PRE" -p err  echo "$@"; echo "$@"; }
msg.die() { local -i err=$?; msg.sys "$@"; exit "$err"; }
exit_if_already_running() { for p_ in $(pidof -x "$_e_MSG_PRE"); do [ "${p_}" -ne "$$" ] && msg.die "$0 is currently running."; done; }
onoff() {	local o="${1:-0}"; case "${o,,}" in 	on|1) o=1;; off|0) o=0;;	*) o=0; (( $# > 1 )) && o=$(( ${2} ));; esac;	echo -n $((o)); }
trim() { local v="$*";v="${v#"${v%%[![:space:]]*}"}";v="${v%"${v##*[![:space:]]}"}";echo -n "$v"; }
declare -fx version.set msg.verbose.set strict.set msg.prefix.set msg msg.info msg.warn msg.warning msg.err msg.sys msg.die exit_if_already_running onoff trim
# end entities 'primitives'

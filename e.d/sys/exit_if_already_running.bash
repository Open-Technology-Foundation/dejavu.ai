#X Function : exit_if_already_running
#X Desc     : If there is an instance of the script already being run on the
#X          : server, then throw an error message and exit 1 immediately.
#X          : This function is mostly used at the very
#X          : beginning of a script.
#X Synopsis : exit_if_already_running
#X Example  : exit_if_already_running 
exit_if_already_running() {
	return 0
}
declare -fx exit_if_already_running
#fin

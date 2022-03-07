#!/bin/bash
	opt=-; set ${opt}o errexit ${opt}o nounset ${opt}o pipefail
	shopt -s globstar extglob || exit
	declare -- _ent_0 PRG PRGDIR
	_ent_0=$(readlink -fn -- "$0") || _ent_0=''
	PRG=${_ent_0##*/}	
	PRGDIR=${_ent_0%/*}
	ENTITIES="$PRGDIR"
	#shellcheck source=/usr/share/e.bash/e.bash.min
	source "$ENTITIES/e.bash.min" new || exit
	strict.set on
	on.exit cleanup
	
	cat <<-etx
	###### Version [$_ent_VERSION]
	# E.bash Environment/Function Library

	etx
	cat <<-'etx'
	E.bash is a lightweight Bash scripting environment and library for systems and network administrators who use `Ubuntu 18.04` or higher.
	
	The philosophy is to be simple, unobtrusive, flexible, with minimal dependencies, while providing a standard functionality across an entire network environment.
	
	### E.bash requires:
	
		* Ubuntu 18.04, or higher
		* Bash 4.4, or higher
	
		Use on non-Ubuntu systems should be possible with minimal changes.  
	
	### Quick One-Liner Install:
	
	    sudo git clone https://github.com/OkusiAssociates/entities.bash.git /usr/share/e.bash && sudo /usr/share/e.bash/e.install --auto
	
	### Invocation
	
	To invoke `e.bash`, just enter `source e.bash` at the top of your script, or invoke it at the command line.
	````
	    source e.bash new
	    msg "Hello World"
	    e.bash help
	````
	Once loaded into the environment `e.bash` can be invoked without reloading the entire library.
	
	If `e.bash` is already loaded at the time a script is run, it is not loaded again, greatly speeding up load and execution time for downstream scripts that also use `e.bash` library functions.
	
	### Functions
	
	Current functions:
	
	etx

	declare -a arr
	mapfile -t arr < <("$ENTITIES"/e.show -f)
	for f in "${arr[@]}"; do 
		echo -n '`'"$f"'`'' '
	done
	echo
	
	cat <<-'etx'
	### Script/Function Templates

	Scripting templates are an important part of a programmer's armory.  `e.bash` comes with several simple but powerful templates for new scripts, or functions.  Here are the ones used most frequently:

	etx

	for f in "$ENTITIES"/docs/templates/*.bash; do
		[[ $f == *"primitive"* ]] && continue
		echo '#### Template `'"$(basename "$f")"'`'
		echo '````'
		expand -t 2 "$f"
		echo '````'
		echo
	done

	cat <<-'etx'
	### Scripts

	etx

	for f in "$ENTITIES"/scripts/**; do
		[[ -d $f ]] ||	[[ ! -x $f ]] || [[ $f == *e.*  || $f == */dev/* || $f == *is.binary* || $f == *mailheader* ]] && continue
		echo '#### Script `'"$(basename "$f")"'`'
		echo '````'
		"$f" --help 2>&1 | expand -t 2
		echo '````'
		echo
	done

	cat <<-'etx'
	### Help
	
	See `e.help` for full documentation.
	
	### Developers
	
	Are you a bash programmer? If you would like to assist with this project, go to the repository at:
	
	    http://github.com/OkusiAssociates/e.bash
	
	Bugs/Features/Reports/Requests/Criticism send to `garydean@linux.id`
	
	etx

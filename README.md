###### Version [0.998.420.51.omicron-1305]
# E.bash Environment/Function Library

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

`addslashes` `calcfp` `check.dependencies` `chgConfigVar` `cleanup` `convertCfg2php` `debug.set` `DefineTextFileTypes` `dqslash` `dryrun.set` `editorsyntaxstring` `elipstr` `e.location` `exit_if_already_running` `exit_if_not_root` `exitscript` `explode` `get.element` `get.elements` `hr2int` `implode` `in_array` `in_array.loose` `int2hr` `is.debug` `is.dryrun` `is.int` `is.interactive` `is_interactive` `is.number` `is.root` `is.strict` `is.tty` `is_tty` `ltrim` `mktempfile` `msg` `msg.alert` `msg.color` `msg.color.set` `msg.crit` `msg.debug` `msg.die` `msg.emerg` `msg.err` `msg.error` `msg.info` `msg.line` `msg.notice` `msg.prefix.separator.set` `msg.prefix.set` `msg.sys` `msg.tab.set` `msg.tab.width` `msg.usetag.set` `msg.verbose` `msg.verbose.set` `msg.warning` `msgx` `msg.yn` `on.exit` `onexit` `on.exit.exec` `on.exit.exit` `onexit.exit` `on.exit.function` `onexit.function` `on.exit.set` `onexit.set` `onoff` `pause` `payload_decode` `payload_encode` `perrno` `phpini_short_tags` `post_slug` `remove_accents` `remsp2` `rmslash2` `rtrim` `s` `sqslash` `sshexec` `strict.set` `strpos` `strposv` `strrpos` `strrposv` `str_str` `textfiletype` `titlecase` `tmpdir.set` `trap.function` `trap.onexit` `trap.set` `trim` `trimv` `urldecode` `urlencode` `urlpayload_encode` `usage` `version` `version.set` `website_online` `xselect` 
### Script/Function Templates

Scripting templates are an important part of a programmer's armory.  `e.bash` comes with several simple but powerful templates for new scripts, or functions.  Here are the ones used most frequently:

#### Template `e.new.script.bash`
````
#!/bin/bash
#!shellcheck disable=SC0000
#@ Script  : $PRG
#@ Version : $(version.set)
#@ Desc    : 
#@ Synopsis: $PRG [Options]
#@ Options : -|--           
#@         : -|--           
#@         : -v|--verbose   Msg verbose on. (default)
#@         : -q|--quiet     Msg verbose off.
#@         : -V|--version   Print version.
#@ Examples:
#@ Requires:
#@ See Also: 
source e.bash.min || exit
  strict.set on
  msg.prefix.set "$PRG"
  version.set '0.0'

  xcleanup() { 
    : #rm -f "${TmpFile}"; 
  }
  on.exit.exec 'xcleanup'

  # global vars
  
# main
main() {
  local -a args=()
  while (($#)); do case "$1" in
    #-|--)           ;;
    #-|--)          shift; para=${1:-} ;;
    -v|--verbose)   msg.verbose.set on ;;
    -q|--quiet)     msg.verbose.set off ;;
    -V|--version)   echo "$PRG vs $(version.set)"; return 0 ;;
    -h|--help)      _e_usage; return 0 ;;
    -[vqVh]*)       #shellcheck disable=SC2046 # de-aggregate aggregated short options
                    set -- '' $(printf -- "-%c " $(grep -o . <<<"${1:1}")) "${@:2}";;
    -?|--*)         msg.die -e 22 "Invalid option '$1'" ;;
    *)              args+=( "$1" ) ;;
                    #msg.die -e 22 "Invalid parameter '$1'" ;;
  esac; shift; done
  ((${#args[@]})) || msg.die -e 2 "No parameter specified."
  msg "${args[@]:-}"
    
}

main "$@"
#fin
````

#### Template `entities.new.script.bash`
````
#!/bin/bash
#!shellcheck disable=SC0000
#@ Script  : $PRG
#@ Version : $(version.set)
#@ Desc    : 
#@ Synopsis: $PRG [Options]
#@ Options : -|--           
#@         : -|--           
#@         : -v|--verbose   Msg verbose on. (default)
#@         : -q|--quiet     Msg verbose off.
#@         : -V|--version   Print version.
#@ Examples:
#@ Requires:
#@ See Also: 
source entities || exit
  strict.set on
  msg.prefix.set "$PRG"
  version.set '0.0'

  xcleanup() { 
    : #rm -f "${TmpFile}"; 
  }
  on.exit.exec 'xcleanup'

  # global vars
  
# main
main() {
  local -a args=()
  while (($#)); do case "$1" in
    #-|--)           ;;
    #-|--)          shift; para=${1:-} ;;
    -v|--verbose)   msg.verbose.set on ;;
    -q|--quiet)     msg.verbose.set off ;;
    -V|--version)   echo "$PRG vs $(version.set)"; return 0 ;;
    -h|--help)      _e_usage; return 0 ;;
    -[vqVh]*)       #shellcheck disable=SC2046 # de-aggregate aggregated short options
                    set -- '' $(printf -- "-%c " $(grep -o . <<<"${1:1}")) "${@:2}";;
    -?|--*)         msg.die -e 22 "Invalid option '$1'" ;;
    *)              args+=( "$1" ) ;;
                    #msg.die -e 22 "Invalid parameter '$1'" ;;
  esac; shift; done
  ((${#args[@]})) || msg.die -e 2 "No parameter specified."
  msg "${args[@]:-}"
    
}

main "$@"
#fin
````

#### Template `function-header.bash`
````
#!/bin/bash
#!shellcheck disable=SC0000
#@ Script:Function:GlobalX:Global:Local: 
#@ Desc    : 
#@ Synopsis: 
#@ Options :
#@ Examples: 
#@ Depends :
#@ See Also:
X() {
  
  :
  
}
X "$@"

#fin
````

### Scripts

### Help

See `e.help` for full documentation.

### Developers

Are you a bash programmer? If you would like to assist with this project, go to the repository at:

    http://github.com/OkusiAssociates/e.bash

Bugs/Features/Reports/Requests/Criticism send to `garydean@linux.id`


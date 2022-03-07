#!/bin/bash
#@ Function: s
#@ Desc    : Print 's' if number is not 1.
#@ Synopsis: s number
#@         :
#@ Example : num=30; echo "$num file$(s $num) counted."
#@         : num=1;  echo "$num file$(s $num) counted."
#@:
s() {	(( ${1:-1} == 1 )) || echo -n 's'; }
declare -fx s
#fin

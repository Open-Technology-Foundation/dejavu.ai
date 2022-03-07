#X Function: calcfp 
#X Desc    : Simple [bc] wrapper. Requires /usr/bin/bc
#X Synopsis: calcfp numericExpression
calcfp() { echo "$*" | /usr/bin/bc -l; }
declare -fx calcfp

#fin


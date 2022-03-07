/* mailhead
#@ Program : is.binary
#@ Desc    : Examine *first 24 chars* of file for binary chars.  
#@         : Return true if found.  
#@         : Return 255 if file not found.
#@         : 'Binary chars' are defined as follows:
#@         :    >=127 <9 (<32 && >13)
#@         : 
#@ Synopsis: is.binary [filename]
#@         :   filename  File to examine. Default is stdin.
#@         : 
#@ Example : is.binary /bin/bash && echo 'Is binary!'
#@         :  
#@ See Also: is.binary.c
gcc is.binary.c -o is.binary
*/
#include <stdio.h>

#define MAXSAMP 24

int main(int argc, char* argv[]) {
  FILE *fp1;
  int i=MAXSAMP;
  int binflag=0;
  unsigned int c;
  
  if(argc > 1) {
    fp1 = fopen(argv[1], "r");
    if(fp1 == NULL) return(-1);
  } else fp1=stdin;
  
  while(i--) {
    if(feof(fp1)) break;
    c = fgetc(fp1);
    if(c>=127 || c<9 || (c<32 && c>13) ) { binflag=1; break; } 
  }
  
  if(fp1 != stdin) fclose(fp1);
  return(!binflag);
}
/*fin*/

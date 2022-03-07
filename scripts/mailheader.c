/* mailhead
gcc mailheader.c -o mailheader

#@ Program : mailheader
#@ Desc    : Program to extract the *header portion* of an email message
#@         : file up to the first blank line. CR are ignored and not output.
#@         : 
#@         : NOTE: A space/tab char in the first postiion of a line is 
#@         : concatenated onto the previous line. This may have implications
#@         : in certain circumstances.
#@         : 
#@         : Max size of mail header returned is 100k. Max line length is 4k.
#@         : 
#@ Synopsis: mailheader [\"mailfile\"]
#@         :   mailfile  A mail file from which to extract header.  If not
#@         :             specified, defaults to stdin. 
#@ See Also: mailhead.c

*/
#include <stdio.h>
#include <string.h>

#define MAXHDR  102400
#define MAXLINE 4096

void main(int argc, char* argv[]) {
  char hdr[MAXHDR];
  hdr[0]='\0';
  char line[MAXLINE];
  FILE *fp1;
  int linelen;
  
  if(argc > 1) fp1 = fopen(argv[1], "r");
  else fp1=stdin;
  
  while((fgets(line, MAXLINE, fp1)) != (char *)0 ) {
    linelen=strlen(line);
    if(line[linelen-2] == '\r') {
      line[linelen-2]='\n';
      line[linelen-1]='\0';
    }
    if(line[0] == '\n') break; 
    if(line[0] == '\t' || line[0] == ' ') {
        line[0]=' ';
        if(hdr[0]) hdr[strlen(hdr)-1]='\0';
    }
    if(strlen(hdr) < (MAXHDR-MAXLINE-1)) strcat(hdr, line);
  }
  fputs(hdr, stdout);
  if(fp1 != stdin) fclose(fp1);
}
/*fin*/

/****************************************************************/
/*                                                              */
/*      EBC2ASC (Ver. 1.01)                                     */
/*                                                              */
/*      Ebcdic to Ascii convertor                               */
/*                                                              */
/*      Author   : F. Pynckels                                  */
/*                                                              */
/*      Date     : 22 June 1994                                 */
/*                                                              */
/*      Remark   : Compile with SMALL memory model              */
/*                                                              */
/****************************************************************/

#include <stdio.h>
#include <string.h>

#define BUFSIZE 4096

extern void ebcdic_to_ascii (char *, int);                      /* Routine in SENDCA.ASM                        */
void error (int);                                               /* Predeclaration                               */

char    buffer[BUFSIZE];                                        /* Input and output buffers                     */
int     buflen;                                                 /* Number of bytes in the input buffer          */
FILE    *inf, *outf;                                            /* Input and output file descriptors            */

int main(int argc, char *argv[])
	{
	puts("");                                               /* Show logo on screen                          */
	puts("Ebc2Asc (Ver 1.00)");
	puts("(c) CopyRight 1994 by Filip Pynckels\n");

	if(argc != 3) error(-1);                                /* Check nr parameters given                    */

	if ((inf = fopen(argv[1], "rb")) == NULL) error(-2);    /* Open input file                              */

	if ((outf = fopen(argv[2], "wb")) == NULL) error(-3);   /* Open output file                             */

	while ((buflen = fread(buffer, 1, BUFSIZE, inf)) != 0)  /* Repeat, get data                             */
		{
		ebcdic_to_ascii(buffer, buflen);                /* Translate to Ascii                           */
		if (fwrite(buffer, 1, buflen, outf) != buflen) error(-4); /* Write data in the output file      */
		}

	fcloseall();                                            /* Close all used files                         */
	}

static char *err[] = {
	"",
	"EBC2ASC <Input filename> <Output filename>",           /* Error nr 1                                   */
	"unable to open input file",                            /* Error nr 2                                   */
	"unable to open output file",                           /* Error nr 3                                   */
	"unable to write to output file"                        /* Error nr 4                                   */
	};

void error(int enr)
	{
	if (enr == -5) printf("\n");
	if (enr < 0)
	  printf("\007Fatal error - %s.\n", err[-enr]);
	else if (enr > 0)
	  printf("Warning - %s.\n", err[enr]);
	fcloseall();
	exit(99);
	}

/*   R E M A R K   :   U s e   H U G E   m e m o r y   m o d e l   */

#define	BYTE_FREE	(unsigned)	1024 * 20
#define	KBYTE_MASK	(unsigned long) 0xFFFFFC00
#define LINELEN		(unsigned char)	16
#define MINVISIBLE	(unsigned char)	32
#define MAXVISIBLE	(unsigned char)	127

#include <alloc.h>
#include <dos.h>
#include <stdio.h>

char filter (unsigned char);

main(int argc, char **argv)
	{
	unsigned long		nrread = 1, nrleft, nrlines, offset = 0;
	unsigned long		col, line, mem_avail;
	char			filename[81];
	unsigned char far	*buffer;
	FILE			*binfile;

	printf("HEXDUMP (Ver 2.0)\n");
	printf("CopyRight (c) 1991 by Pynckels Filip\n\n");

	if (argc != 2) {
		printf("Error in format : HEXDUMP filename\n\n");
		exit(1);
		}

	memcpy (filename, argv[1], strlen(argv[1])+1);

	printf("File : %s\n\n", filename);

	mem_avail = farcoreleft() & KBYTE_MASK;
	mem_avail -= BYTE_FREE;

	if ((buffer = (unsigned char far *) farmalloc(mem_avail)) == NULL) {
		printf("Memory allocation (%lu bytes) failed !\n", mem_avail);
		exit (1);
		}

	if ((binfile = fopen(filename, "rb")) == NULL) {
		printf("File opening failed !\n");
		printf("Error : %u\n", ferror(binfile));
		exit(1);
		}

	while (nrread != 0) {
		nrread  = (long) fread((void *) buffer,
				       sizeof(unsigned char),
				       mem_avail, binfile);

		if (nrread != 0) {
			nrlines = nrread / LINELEN;
			nrleft  = nrread % LINELEN;
			for (line=1; line <= nrlines; line++) {
				printf("%05lX    ", offset);
				offset = offset + LINELEN;
				for (col=1; col<=LINELEN; col++)
					printf("%02X ", *(buffer++));
				buffer = buffer - LINELEN;
				printf("   ");
				for (col=1; col<=LINELEN; col++)
					printf("%c", filter(*(buffer++)));
				printf("\n");
				}
			printf("%05lX    ", offset);
			for (col=1; col<=nrleft; col++)
				printf("%02X ", *(buffer++));
			buffer = buffer - nrleft;
			for (col=nrleft; col<LINELEN; col++)
				printf("   ");
			printf("   ");
			for (col=1; col<=nrleft; col++)
				printf("%c", filter(*(buffer++)));
			printf("\n\n");
			}
		}

	farfree(buffer);
	}

char filter (unsigned char c)
	{
	if ((MINVISIBLE <= c) && (c <= MAXVISIBLE))
		return ((char) c);
	else
		return ('.');
	}

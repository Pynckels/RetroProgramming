/*
* To connect to DosBox-x COM1 from the Linux command
* line interface, execute the following program in a
* Linux terminal to connect to COM1 (see dosbox-x.conf
* for the port numbers of COM2..COM9) :
*
* socat -,rawer TCP:127.0.0.1:5001
*
* The DosBox-x program takes up the role of a serial
* server, the Linux program socat takes up the role
* of a serial client.
*
* To close the server program in DosBox-x: push ESC
*/

#include <stdio.h>
#include <conio.h>
#include <dos.h>

#define COM1 0x3F8   // IRQ 4
#define COM2 0x2F8   // IRQ 3
#define COM3 0x3E8   // IRQ 4
#define COM4 0x2E8   // IRQ 3
#define COM5 0x2F0   // IRQ 4 - Address should be checked...
#define COM6 0x3E0   // IRQ 3 - Address should be checked...
#define COM7 0x2E0   // IRQ 4 - Address should be checked...
#define COM8 0x260   // IRQ 3 - Address should be checked...
#define COM9 0x250   // IRQ 4 - Address should be checked...

int main(void)
{
    int c;

    /* Initialize COM1: 9600 baud, 8 data bits, no parity, 1 stop bit */
    outportb(COM1 + 1, 0x00);  /* Disable interrupts */
    outportb(COM1 + 3, 0x80);  /* Enable divisor latch */
    outportb(COM1 + 0, 12);    /* Divisor: 115200 / 12 = 9600 */
    outportb(COM1 + 1, 0);
    outportb(COM1 + 3, 0x03);  /* 8N1 */
    outportb(COM1 + 2, 0xC7);  /* Enable/clear FIFO */
    outportb(COM1 + 4, 0x0B);  /* DTR, RTS, OUT2 */

    puts("COM1 ready: 9600 8N1. Send text from Linux; ESC quits.");

    while (!kbhit() || getch() != 27) {
        if (inportb(COM1 + 5) & 0x01) {    /* Received byte available */
            c = inportb(COM1);             /* Read it */
            putchar(c);                    /* Display it */

            while (!(inportb(COM1 + 5) & 0x20)) {
                /* Wait until transmitter can accept a byte */
            }
            outportb(COM1, c);             /* Echo it */
        }
    }

    return 0;
}

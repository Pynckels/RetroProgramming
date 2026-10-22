#include <stdio.h>
#include <conio.h>
#include <dos.h>

#define COM1 0x3F8

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

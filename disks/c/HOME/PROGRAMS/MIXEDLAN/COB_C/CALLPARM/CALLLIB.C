/* CALLLIB.C - Microsoft C for DOS
 *
 * Compile in the same (large) memory model COBOL expects:
 *     cl /c /AL calllib.c
 *
 * Three parameters, one per COBOL passing mode:
 *
 * a : BY REFERENCE - C gets a far pointer to COBOL's own variable.
 *                    Writing through it CHANGES the COBOL variable.
 *                    (the only true input/output parameter)
 *
 * b : BY CONTENT   - C gets a far pointer to a TEMPORARY COPY made by
 *                    COBOL. Looks identical to by-reference in C, but
 *                    writing through it does NOT change the COBOL variable.
 *                    (input only)
 *
 * c : BY VALUE     - C gets the integer itself on the stack.
 *                    Changing it only changes C's local copy.
 *                    (input only)
 */

void far calllib_func(int far *a, int far *b, int c)
{
    *a = *a + 100;    /* BY REFERENCE: COBOL will see 10 -> 110           */
    *b = *b + 100;    /* BY CONTENT  : only the temp copy changes         */
    c  = c  + 100;    /* BY VALUE    : only the local copy changes        */
}

/* CALLLIB.C - Microsoft C for DOS (compile with /Gh not needed)
 *
 * Use the same memory model COBOL expects (large model):
 *     cl /c /AL calllib.c
 *
 * a : in,  by reference (far pointer in large model)
 * b : in,  by value
 * c : out, by reference (value returned to COBOL)
 */
void far calllib_func(int far *a, int b, int far *c)
{
    *a = *a + 1;      /* modify the by-reference arg to show it's shared */
    b  = b + 1;       /* modifies only the local copy; COBOL unaffected  */
    *c = *a + b;      /* result handed back to COBOL                     */
}

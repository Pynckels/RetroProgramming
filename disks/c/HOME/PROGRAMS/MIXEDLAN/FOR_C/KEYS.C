#include <conio.h>
#include <time.h>

int _fortran keyhit(void)
{
    if (kbhit()) return getch();
    return 0;
}

void _fortran waitms(const long far *ms)
{
    clock_t start;
    clock_t ticks;

    start = clock();
    ticks = (clock_t)(*ms * CLOCKS_PER_SEC / 1000L);
    while ((clock() - start) < ticks);
}

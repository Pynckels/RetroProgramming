
int func(int a, int b, int c)
{
    return a+b-c;
}

int main(void)
{
    const int i = 1;
    const int j = 2;
    const int k = 3;

    int result;

    result = func(i, j, k);

    printf("Result: %d\n", result);

    return 0;
}

void incrementa(int *p) {
    *p = *p + 1;
}

int usa_ponteiro(void) {
    int x = 10;
    incrementa(&x);
    return x;
}

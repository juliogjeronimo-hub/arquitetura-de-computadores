int aritmetica(int x, int y) {
    int s = x - y;
    int m = x * y;
    int d = x / y;
    int r = x % y;
    int l = (x & y) | (x ^ y);
    int sh = (x << 2) + (y >> 1);
    return s + m + d + r + l + sh;
}

int dobro(int x) {
    return x * 2;
}

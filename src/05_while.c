int soma_while(int n) {
    int soma = 0;
    int i = 0;
    while (i < n) {
        soma += i;
        i++;
    }
    return soma;
}

int soma_dowhile(int n) {
    int soma = 0;
    int i = 0;
    do {
        soma += i;
        i++;
    } while (i < n);
    return soma;
}

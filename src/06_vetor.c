int soma_vetor(void) {
    int v[10];
    for (int i = 0; i < 10; i++) {
        v[i] = i * 2;
    }
    int soma = 0;
    for (int i = 0; i < 10; i++) {
        soma += v[i];
    }
    return soma;
}

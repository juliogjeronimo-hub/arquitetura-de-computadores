
#include <stdio.h>

int main(void) {
    double numero1, numero2;

    printf("Digite o primeiro numero: ");
    scanf("%lf", &numero1);

    printf("Digite o segundo numero: ");
    scanf("%lf", &numero2);

    printf("\nPrimeiro numero: %.2f\n", numero1);
    printf("Segundo numero: %.2f\n", numero2);
    printf("Soma: %.2f\n", numero1 + numero2);

    printf("\nPressione Enter para encerrar...");
    getchar(); // Consome o '\n' deixado pelo scanf
    getchar(); // Aguarda o Enter do usuario

    return 0;
}

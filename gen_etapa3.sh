#!/bin/bash
cd /c/Documents/Repositorios/hello_world
export PATH=/ucrt64/bin:$PATH

for f in 06_vetor 07_funcao 08_recursao 09_ponteiro; do
    gcc -S -O0 src/${f}.c -o build/O0/${f}.s
    gcc -S -O2 src/${f}.c -o build/O2/${f}.s
done
echo "Done"

#include <iostream>
#include <vector>
#include <cstdlib>
#include <cmath>
#include <chrono>  // Inclui a biblioteca chrono para medir o tempo

std::vector<double> createNotes() {
    int N = 1000000;
    std::vector<double> notas(N, 0.0);

    for (int i = 0; i < N; ++i) {
        double nota = (static_cast<double>(std::rand()) / RAND_MAX) * 10.0;
        notas[i] = std::round(nota * 100.0) / 100.0;
    }

    return notas;
}

std::vector<double> takeRange(double min, double max, std::vector<double> &notas) {
    std::vector<double> resultVector;

    if (min == 0) {
        min = -0.9;
    }

    for (const auto &nota: notas) {
        if (nota > min && nota <= max) {
            resultVector.push_back(nota);
        }
    }
    return resultVector;
}

int main(int argc, char *argv[]) {
    auto start = std::chrono::high_resolution_clock::now();  // Inicia a contagem do tempo

    std::vector<double> notas = createNotes();
    std::vector<std::vector<double>> listVector;

    int sumResult = 0;
    for (int i = 0; i < 10; ++i) {

        std::vector<double> result = takeRange(i, i + 1, notas);
        listVector.push_back(result);
        sumResult += result.size();
        if (i == 0 ) {
            printf("Notas entre %d e %d: %d\n", i, i+1, result.size());
            continue;
        }
        printf("Notas entre %d.1 e %d: %d\n", i, i+1, result.size());
    }

    printf("\nTotal de valores é %d\n", sumResult);

    auto end = std::chrono::high_resolution_clock::now();  // Termina a contagem do tempo
    std::chrono::duration<double> duration = end - start;  // Calcula a duração
    std::cout << "\nTempo de execução: " << duration.count() << " segundos" << std::endl;

    return 0;
}
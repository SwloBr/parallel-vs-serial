#include <iostream>
#include <vector>
#include <cstdlib>
#include <cmath>
#include <chrono>
#include <cuda_runtime.h>

void createNotes(std::vector<double>& notas, int n) {
    for (int i = 0; i < n; ++i) {
        double nota = (static_cast<double>(rand()) / RAND_MAX) * 10.0;
        notas[i] = std::round(nota * 100.0) / 100.0;
    }
}

__global__ void takeRangeKernel(const double* notas, double min, double max, int n, int* count) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    if (idx < n) {
        if (notas[idx] > min && notas[idx] <= max) {
            atomicAdd(count, 1);
        }
    }
}

int main(int argc, char* argv[]) {
    const int N = 100000000;
    std::vector<double> notas(N);
    createNotes(notas, N);
    printf("Quantidade de notas: %d\n", N);

    auto start = std::chrono::high_resolution_clock::now();

    double* d_notas;
    cudaMalloc(&d_notas, N * sizeof(double));
    cudaMemcpy(d_notas, notas.data(), N * sizeof(double), cudaMemcpyHostToDevice);

    // Definindo o tamanho dos blocos e grid
    int blockSize = 256;
    int numBlocks = (N + blockSize - 1) / blockSize;

    int* d_count;
    cudaMalloc(&d_count, sizeof(int));
    int sumResult = 0;

    for (int i = 0; i < 10; ++i) {
        cudaMemset(d_count, 0, sizeof(int));

        if (i == 0) {
            takeRangeKernel<<<numBlocks, blockSize>>>(d_notas, -0.9, i + 1, N, d_count);
        } else {
            takeRangeKernel<<<numBlocks, blockSize>>>(d_notas, i, i + 1, N, d_count);
        }

        // Transferência do resultado após todas as execuções
        int count;
        cudaMemcpy(&count, d_count, sizeof(int), cudaMemcpyDeviceToHost);
        sumResult += count;

        printf("Notas entre %d.1 e %d: %d\n", i, i + 1, count);
    }

    printf("\nTotal de valores é %d\n", sumResult);

    auto end = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double> duration = end - start;
    std::cout << "\nTempo de execução: " << duration.count() << " segundos" << std::endl;

    cudaFree(d_count);
    cudaFree(d_notas);


    return 0;
}

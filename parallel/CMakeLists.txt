cmake_minimum_required(VERSION 3.29)
project(notas_compiladores CUDA)

set(CMAKE_CUDA_STANDARD 20)

add_executable(notas_compiladores main.cu)

set_target_properties(notas_compiladores PROPERTIES
        CUDA_SEPARABLE_COMPILATION ON)

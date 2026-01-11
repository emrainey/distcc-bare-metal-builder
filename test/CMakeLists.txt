cmake_minimum_required(VERSION 3.12)
project(DistccExample)

foreach(index RANGE 0 1 100)
    # Add the executable target
    add_library(test${index} STATIC test.c)
    target_compile_options(test${index} PRIVATE -O0 -g)
    target_compile_definitions(test${index} PRIVATE TEST=${index})
endforeach()


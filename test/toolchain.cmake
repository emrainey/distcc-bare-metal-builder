
set(CMAKE_SYSTEM_NAME Generic) # No explicit OS, used by bare-metal systems
set(CMAKE_SYSTEM_PROCESSOR arm)

find_program(CMAKE_C_COMPILER NAMES arm-none-eabi-gcc REQUIRED)
find_program(CMAKE_CXX_COMPILER NAMES arm-none-eabi-g++ REQUIRED)
find_program(CMAKE_ASM_COMPILER NAMES arm-none-eabi-g++ REQUIRED)
find_program(CMAKE_OBJDUMP NAMES arm-none-eabi-objdump REQUIRED)

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

add_compile_options(-Wall -Wextra -Wno-char-subscripts -pedantic)
add_compile_options(-mthumb -mno-thumb-interwork)
add_compile_options(-march=armv7e-m)
add_compile_options(-mfloat-abi=hard -mfpu=fpv4-sp-d16)
add_compile_options(-nostartfiles -nostdlib)

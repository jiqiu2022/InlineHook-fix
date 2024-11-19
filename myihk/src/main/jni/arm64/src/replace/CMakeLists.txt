# 设置当前目录为 CMake 的源目录
set(REPLACE_PATH ${CMAKE_CURRENT_SOURCE_DIR})

# 输出当前 ABI 信息
message(WARNING "abi: ${ANDROID_ABI}")

# 仅针对 arm64-v8a 架构进行设置
if(${ANDROID_ABI} STREQUAL "arm64-v8a")

    # 添加静态库 replace
    add_library(replace STATIC
            ${REPLACE_PATH}/../mhk.c
            ${REPLACE_PATH}/replace.c
            ${REPLACE_PATH}/lr.cpp
            ${REPLACE_PATH}/../fixPCOpcode.c
            ${REPLACE_PATH}/../../asm/replace_neon.s
    )

    # 设置头文件路径
    target_include_directories(replace PRIVATE
            ${REPLACE_PATH}/../../../include
            ${REPLACE_PATH}/../../asm
    )

endif()

# 设置当前目录为 CMake 的源目录
set(DUMP_PATH ${CMAKE_CURRENT_SOURCE_DIR})

# 输出当前 ABI 信息
message(WARNING "abi: ${ANDROID_ABI}")

# 仅针对 arm64-v8a 架构进行设置
if(${ANDROID_ABI} STREQUAL "arm64-v8a")

    # 添加静态库 dump
    add_library(dump STATIC
            ${DUMP_PATH}/../mhk.c
            ${DUMP_PATH}/dump.c
            ${DUMP_PATH}/../fixPCOpcode.c
            ${DUMP_PATH}/../../asm/dump_neon.s
    )

    # 设置头文件路径
    target_include_directories(dump PRIVATE
            ${DUMP_PATH}/../../../include
            ${DUMP_PATH}/../../asm
    )

endif()

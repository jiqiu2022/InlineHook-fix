# 设置当前目录为 CMake 的源目录
set(DUMP_WITH_RET_PATH ${CMAKE_CURRENT_SOURCE_DIR})

# 输出当前 ABI 信息
message(WARNING "abi: ${ANDROID_ABI}")

# 仅针对 arm64-v8a 架构进行设置
if(${ANDROID_ABI} STREQUAL "arm64-v8a")
#    enable_language(ASM)  # 启用汇编语言支持

    # 添加静态库 dump_with_ret
    add_library(dump_with_ret STATIC
            ${DUMP_WITH_RET_PATH}/../mhk.c
            ${DUMP_WITH_RET_PATH}/dump.c
            ${DUMP_WITH_RET_PATH}/lr.cpp
            ${DUMP_WITH_RET_PATH}/../fixPCOpcode.c
            ${DUMP_WITH_RET_PATH}/../../asm/dump_neon_with_ret.s
    )

    # 设置头文件路径
    target_include_directories(dump_with_ret PRIVATE
            ${DUMP_WITH_RET_PATH}/../../../include
            ${DUMP_WITH_RET_PATH}/../../asm
    )

endif()

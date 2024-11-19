# 设置当前目录为 CMake 的源目录
set(DUMP_JUST_RET_PATH ${CMAKE_CURRENT_SOURCE_DIR})

# 输出当前 ABI 信息
message(WARNING "abi: ${ANDROID_ABI}")

# 仅针对 arm64-v8a 架构进行设置
if(${ANDROID_ABI} STREQUAL "arm64-v8a")

    # 添加静态库 dump_just_ret
    add_library(dump_just_ret STATIC
            ${DUMP_JUST_RET_PATH}/../mhk.c
            ${DUMP_JUST_RET_PATH}/dump.c
            ${DUMP_JUST_RET_PATH}/../fixPCOpcode.c
            ${DUMP_JUST_RET_PATH}/../../asm/dump_neon_just_ret.s
    )

    # 设置头文件路径
    target_include_directories(dump_just_ret PRIVATE
            ${DUMP_JUST_RET_PATH}/../../../include
            ${DUMP_JUST_RET_PATH}/../../asm
    )

endif()

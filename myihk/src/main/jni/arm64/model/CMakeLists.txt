# 设置当前目录为 CMake 的源目录
set(MODEL_PATH ${CMAKE_CURRENT_SOURCE_DIR})

# 输出当前 ABI 信息
message(WARNING "abi: ${ANDROID_ABI}")

# 仅针对 arm64-v8a 架构进行设置
if(${ANDROID_ABI} STREQUAL "arm64-v8a")
    # 添加库
    add_library(imodel STATIC
            ${MODEL_PATH}/iModel.cpp
    )
    # 设置头文件路径
    target_include_directories(imodel PRIVATE
            ${MODEL_PATH}/../../include
    )

    # 链接库
    target_link_libraries(imodel
            dump_with_ret
            dump
            replace
            dump_just_ret
            log  # 等价于 -llog
    )

endif()

# 设置当前目录为 CMake 的源目录
set(SHK_PATH ${CMAKE_CURRENT_SOURCE_DIR})

# 输出当前 ABI 信息
message(WARNING "abi: ${ANDROID_ABI}")

# 定义共享库 shk
add_library(shk SHARED
        ${SHK_PATH}/main.cpp
        # 如果需要切换不同的入口文件，可以替换为以下注释中的文件：
        # ${SHK_PATH}/main_exportHook.cpp
        # ${SHK_PATH}/main_arm.cpp
)

# 设置头文件路径
target_include_directories(shk PRIVATE
        ${SHK_PATH}/../include
)

# 链接静态库和系统库
target_link_libraries(shk
        imodel  # 链接静态库 imodel
        log     # 等价于 -llog
)

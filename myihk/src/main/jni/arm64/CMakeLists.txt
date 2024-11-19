# 顶层 CMakeLists.txt
cmake_minimum_required(VERSION 3.6)


enable_language(ASM)
# 输出当前 ABI 信息
message(WARNING "abi: ${ANDROID_ABI}")

# 添加子目录
add_subdirectory(model)
add_subdirectory(src)

# 输出 ABI 确认
message(WARNING "abi: ${ANDROID_ABI}")

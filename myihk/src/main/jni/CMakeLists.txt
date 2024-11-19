cmake_minimum_required(VERSION 3.4.1)

# 设置项目名称
project(myihk)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/include)

## 添加ARM的子模块
#add_subdirectory(arm)

# 添加ARM64的子模块
add_subdirectory(arm64)
#
## 添加测试模块
add_subdirectory(test)

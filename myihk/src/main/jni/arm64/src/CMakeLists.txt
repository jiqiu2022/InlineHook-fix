# 输出当前 ABI 信息
message(WARNING "abi: ${ANDROID_ABI}")

# 遍历 src 文件夹中的所有子目录并导入 CMakeLists.txt
file(GLOB SUBDIRS RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/*)

foreach(SUBDIR ${SUBDIRS})
    if(IS_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/${SUBDIR})
        add_subdirectory(${SUBDIR})
    endif()
endforeach()

# 再次输出当前 ABI 信息
message(WARNING "abi: ${ANDROID_ABI}")

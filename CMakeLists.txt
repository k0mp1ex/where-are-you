cmake_minimum_required(VERSION 3.21)

project(kxWhereAreYou VERSION 2.0.0 LANGUAGES CXX)

#set(DEPLOY_ROOT "$ENV{SKYRIM_MODS_FOLDER}")
set(LOCAL_DEPLOY_ROOT ${CMAKE_SOURCE_DIR})

find_package(CommonLibSSE CONFIG REQUIRED)
add_commonlibsse_plugin(${PROJECT_NAME} SOURCES src/Main.cpp)
target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_23)
target_precompile_headers(${PROJECT_NAME} PRIVATE src/PCH.h)

if(EXISTS "${DEPLOY_ROOT}")
    set(MOD_FOLDER "${DEPLOY_ROOT}/${PROJECT_NAME}")
    set(DLL_FOLDER "${MOD_FOLDER}/SKSE/Plugins")
    message(STATUS "Plugin output directory: ${MOD_FOLDER}")
    add_custom_command(
        TARGET "${PROJECT_NAME}"
        POST_BUILD
        COMMAND "${CMAKE_COMMAND}" -E make_directory    "${DLL_FOLDER}"
        COMMAND "${CMAKE_COMMAND}" -E copy_if_different "$<TARGET_FILE:${PROJECT_NAME}>"     "${DLL_FOLDER}/$<TARGET_FILE_NAME:${PROJECT_NAME}>"
        COMMAND "${CMAKE_COMMAND}" -E copy_if_different "$<TARGET_PDB_FILE:${PROJECT_NAME}>" "${DLL_FOLDER}/$<TARGET_PDB_FILE_NAME:${PROJECT_NAME}>"
        VERBATIM
    )
endif()

if(EXISTS "${LOCAL_DEPLOY_ROOT}")
    set(DLL_FOLDER "${LOCAL_DEPLOY_ROOT}/SKSE/Plugins")
    message(STATUS "Local plugin output directory: ${DLL_FOLDER}")
    add_custom_command(
        TARGET "${PROJECT_NAME}"
        POST_BUILD
        COMMAND "${CMAKE_COMMAND}" -E make_directory    "${DLL_FOLDER}"
        COMMAND "${CMAKE_COMMAND}" -E copy_if_different "$<TARGET_FILE:${PROJECT_NAME}>"     "${DLL_FOLDER}/$<TARGET_FILE_NAME:${PROJECT_NAME}>"
        COMMAND "${CMAKE_COMMAND}" -E copy_if_different "$<TARGET_PDB_FILE:${PROJECT_NAME}>" "${DLL_FOLDER}/$<TARGET_PDB_FILE_NAME:${PROJECT_NAME}>"
        VERBATIM
    )
endif()
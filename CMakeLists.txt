cmake_minimum_required(VERSION 3.21)
message("Using toolchain file ${CMAKE_TOOLCHAIN_FILE}.")

project(kxWhereAreYou VERSION 2.0.2 LANGUAGES CXX)

include(cmake/functions.cmake)
include(cmake/headerlist.cmake)
include(cmake/sourcelist.cmake)

find_package(CommonLibSSE CONFIG REQUIRED)
add_commonlibsse_plugin(${PROJECT_NAME} SOURCES ${headers} ${sources})
target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_23)
target_precompile_headers(${PROJECT_NAME} PRIVATE src/PCH.h)

#set(DEPLOY_ROOT "$ENV{SKYRIM_MODS_FOLDER}")
set(LOCAL_DEPLOY_ROOT ${CMAKE_SOURCE_DIR})

if(EXISTS "${DEPLOY_ROOT}")
    deploy_plugin(${DEPLOY_ROOT}/${PROJECT_NAME})
endif()

if(EXISTS "${LOCAL_DEPLOY_ROOT}")
    deploy_plugin(${LOCAL_DEPLOY_ROOT})
endif()

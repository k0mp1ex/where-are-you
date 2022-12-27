function(deploy_plugin BASE_DEPLOY_FOLDER)
    set(DEPLOY_FOLDER ${BASE_DEPLOY_FOLDER}/SKSE/Plugins)
    message(STATUS "Plugin output directory: ${DEPLOY_FOLDER}")
    add_custom_command(
            TARGET "${PROJECT_NAME}"
            POST_BUILD
            COMMAND "${CMAKE_COMMAND}" -E make_directory    "${DEPLOY_FOLDER}"
            COMMAND "${CMAKE_COMMAND}" -E copy_if_different "$<TARGET_FILE:${PROJECT_NAME}>"     "${DEPLOY_FOLDER}/$<TARGET_FILE_NAME:${PROJECT_NAME}>"
            COMMAND "${CMAKE_COMMAND}" -E copy_if_different "$<TARGET_PDB_FILE:${PROJECT_NAME}>" "${DEPLOY_FOLDER}/$<TARGET_PDB_FILE_NAME:${PROJECT_NAME}>"
            VERBATIM
    )
endfunction()
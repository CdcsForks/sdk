cmake_minimum_required(VERSION 3.13.4)

find_program(GEODE_CLI NAMES geode.exe geode-cli.exe geode geode-cli)

if(NOT GEODE_CLI)
    message(STATUS "Unable to find Geode CLI - You will need to manually package the .geode files")
else()
    message(STATUS "Found Geode CLI: ${GEODE_CLI}")
endif()
    
function(create_geode_file proname)

    if(NOT GEODE_CLI)
        message(WARNING "create_geode_file called, but Geode CLI was not found - You will need to manually package the .geode files")
    else()

        if (GEODE_DONT_AUTO_INSTALL)
            set(INSTALL_FLAGS "")
            message(STATUS "Not installing after build")
        else()
            if (GEODE_AUTO_INSTALL_IN_API)
                set(INSTALL_FLAGS --install --api)
                message(STATUS "Installing in geode/api after build")
            else()
                set(INSTALL_FLAGS --install)
                message(STATUS "Installing in geode/mods after build")
            endif()
        endif()

        add_custom_command(
            TARGET ${proname} POST_BUILD
            COMMAND ${GEODE_CLI} pkg ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_BINARY_DIR}/$<CONFIG> ${CMAKE_CURRENT_BINARY_DIR}/$<CONFIG>/${proname}.geode ${INSTALL_FLAGS}
            VERBATIM USES_TERMINAL
        )
    endif()

endfunction()

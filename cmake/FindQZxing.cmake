cmake_minimum_required(VERSION 3.16)

include(FetchContent)

function(git_clone url name tag make_available)
    if(NOT DEFINED tag)
        set(tag "master")
    endif()
    FetchContent_Declare(
        ${name}
        GIT_REPOSITORY ${url}
        GIT_TAG ${tag}
    )
    IF(make_available)
    message(${name})
        FetchContent_MakeAvailable(${name})
    ENDIF()
endfunction(git_clone)


git_clone("https://github.com/ftylitak/qzxing" QZXing "master" ON)

FetchContent_GetProperties(QZXing)
add_subdirectory(${CMAKE_CURRENT_BINARY_DIR}/_deps/qzxing-src/src)

cmake_minimum_required(VERSION 3.16)

project(PeakMapPHApp VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Felgo REQUIRED COMPONENTS Positioning Location Multimedia Sql QPSQLDriverPlugin Concurrent Qt6WebSockets)
find_package(FelgoHotReload REQUIRED COMPONENTS Multimedia Positioning Location )
add_definitions(-DQZXING_QML -DENABLE_ENCODER_GENERIC)
set(QZXING_QML ON)
set(QZXING_MULTIMEDIA ON )
#include(cmake/FindQZxing.cmake)
# Project identifier and version
# More information: https://felgo.com/doc/felgo-publishing/#project-configuration
set(PRODUCT_IDENTIFIER "com.plm.PeakMapPHApp")
set(PRODUCT_VERSION_NAME "1.0.0")
set(PRODUCT_VERSION_CODE 1)
set(PRODUCT_LICENSE_KEY "260C4CB69866E3F31C7C48404E0BCD8571A976A40C1DBE912407CA7D1E712A86120D01D346087624CB63FE7A06892C3E0C7A4AA25423F05ED81EBCDFFAD75D7CF941BC2A30C6E8A9449C17CD2BC579FD3DA3360FEC221834C57167A92C50CD3A4175D08078B78FCB315B0B7E3795E6E9A1C6F14C9AA7E31C501D0D754937ABA9EA5E42D5B5648C358EDAB3C9ED92B11EE985BABE4A2E0C85AAA44E37071B3CDBB7A318B4717033647392140B78DD0490298CD0A4F594C352108D7A27F1CBFC0666C6ED7D4201C97E1CAA529EFD8A9155E0615FB485A9276CEBC1656D5C00D8F40FF81B94B6B740C186EDFECF9F3F28A69FBDF3A7D1DA19D4041F424181936083C0BE24DF9BF5A3843561BE05762E40BCC8D7E260159F7A8E60A63E2AD482B780A0DC1BD14CF37B35AE1FF7FC9520F1DD")

# Set either "test" or "publish" stage:
set(PRODUCT_STAGE "test")

# Optionally set a license key that is used instead of the license key from
# main.qml file (App::licenseKey for your app or GameWindow::licenseKey for your game)
# Only used for local builds and Felgo Cloud Builds (https://felgo.com/cloud-builds)
# Not used if using Felgo Developer App
set(PRODUCT_LICENSE_KEY "")

set(FELGO_PLUGINS
)

# Find all QML/JS files for the QML compiler:
file(GLOB_RECURSE QmlFiles RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} qml/*.qml qml/*.js)

# Find all non-QML/JS files in the qml and assets folder to add as resources:
file(GLOB_RECURSE AssetsFiles RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} assets/* qml/*)
list(REMOVE_ITEM AssetsFiles ${QmlFiles})

file(GLOB_RECURSE SrcFiles RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}  src/*.cpp src/*h)
#set PeakMapConfig.qml as Singleton
set_source_files_properties("${CMAKE_CURRENT_SOURCE_DIR}/qml/PeakMapConfig.qml"
    "${CMAKE_CURRENT_SOURCE_DIR}/qml/network/graphql/CoreType.qml"
    "${CMAKE_CURRENT_SOURCE_DIR}/qml/network/graphql/GraphQLType.qml"
    PROPERTIES QT_QML_SINGLETON_TYPE TRUE)
set_source_files_properties("./qml/qmldir" PROPERTIES ALIAS "/Com/Plm/PeakMapPH/qmldir")
qt_add_executable(appPeakMapPHApp
    main.cpp
    ${SrcFiles}
)
if(ANDROID)
    set(QZXing ${CMAKE_CURRENT_SOURCE_DIR}/libraries/qzxing/android/${CMAKE_ANDROID_ARCH_ABI}/libQZXing.so)
    set_target_properties(appPeakMapPHApp PROPERTIES
          QT_ANDROID_EXTRA_LIBS
          ${QZXing}
      )
ELSE()
set(QZXing ${CMAKE_CURRENT_SOURCE_DIR}/libraries/qzxing/linuxdesktop/libQZXing.so)

ENDIF()
target_include_directories(appPeakMapPHApp PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/libraries/qzxing/src)
message(${QZXing})
target_link_libraries(appPeakMapPHApp PRIVATE
    ${QZXing}
FelgoHotReload
)


felgo_configure_executable(appPeakMapPHApp)

qt_add_qml_module(appPeakMapPHApp
    URI PeakMapPHApp
    VERSION 1.0
# uncomment for publishing:
    QML_FILES ${QmlFiles}
    RESOURCES ${AssetsFiles}
    NO_RESOURCE_TARGET_PATH
)


target_compile_definitions(appPeakMapPHApp
    PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)

target_link_libraries(appPeakMapPHApp PRIVATE Felgo)
target_include_directories(appPeakMapPHApp PRIVATE ./src)

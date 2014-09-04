file(GLOB UBUNTU-UI-EXTRAS_QML_JS_FILES *.qml *.js)

# make the files visible in the qtcreator tree
add_custom_target(ubuntu-ui-extras_QMlFiles ALL SOURCES ${UBUNTU-UI-EXTRAS_QML_JS_FILES})

install(FILES ${UBUNTU-UI-EXTRAS_QML_JS_FILES} DESTINATION ${APP_DIR}/ubuntu-ui-extras)

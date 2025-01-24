HEADERS += \
    x8192bit.h \
    loginapi.h

SOURCES += \
    loginapi.cpp

contains(MEEGO_EDITION,harmattan) {
    DEFINES += _LOGINFIX_VER=\\\"0.9.6loginfix2025r1\\\"
}

DEFINES += USING_NCMAPI_HEADERS

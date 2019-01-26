#headers
HEADERS += \
					 karin.h


contains(MEEGO_EDITION,harmattan) {
    DEFINES += _NL_VER=\\\"0.9.6harmattan2019r1\\\"
}

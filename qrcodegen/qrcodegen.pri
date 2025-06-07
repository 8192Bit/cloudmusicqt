HEADERS += \
    qrcodegen/qrcodegen.h

SOURCES += \
    qrcodegen/qrcodegen.c

QMAKE_CFLAGS += --std=c99

# man why can't you only apply this flag to qrcodegen.c

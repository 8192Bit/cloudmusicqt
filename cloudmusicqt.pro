TEMPLATE = app
TARGET = cloudmusicqt

VERSION = 0.9.8
DEFINES += VER=\\\"$$VERSION\\\"

QT += network webkit sql

CONFIG += mobility
MOBILITY += multimedia systeminfo

QMAKE_CFLAGS += -w

# cuz symbian sdk itself and --std=c99 flag that is essential to build qrcodegen will create PLENTY OF warnings
# and they are harmless

HEADERS += \
    qmlapi.h \
    networkaccessmanagerfactory.h \
    singletonbase.h \
    userconfig.h \
    musicfetcher.h \
    blurreditem.h \
    musiccollector.h \
    musicdownloader.h \
    musicdownloaddatabase.h \
    musicdownloadmodel.h \
    lyricloader.h \
    typespatch.h \
    loginapi.h

SOURCES += main.cpp \
    qmlapi.cpp \
    networkaccessmanagerfactory.cpp \
    userconfig.cpp \
    musicfetcher.cpp \
    blurreditem.cpp \
    musiccollector.cpp \
    musicdownloader.cpp \
    musicdownloaddatabase.cpp \
    musicdownloadmodel.cpp \
    lyricloader.cpp \
    loginapi.cpp

include(qjson/qjson.pri)
DEFINES += QJSON_MAKEDLL

include(qrcodegen/qrcodegen.pri)

TRANSLATIONS += i18n/cloudmusicqt_zh.ts

folder_symbian3.source = qml/cloudmusicqt
folder_symbian3.target = qml

folder_symbian1.source = qml/symbian1
folder_symbian1.target = qml

folder_harmattan.source = qml/harmattan
folder_harmattan.target = qml

folder_js.source = qml/js
folder_js.target = qml

simulator {
    DEFINES += SIMULATE_HARMATTAN
    DEPLOYMENTFOLDERS = folder_js
    contains(DEFINES, SIMULATE_HARMATTAN) {
        DEPLOYMENTFOLDERS += folder_harmattan
        HEADERS += harmattanbackgroundprovider.h
        SOURCES += harmattanbackgroundprovider.cpp
    }
    else {
        DEPLOYMENTFOLDERS += folder_symbian3
    }
}

contains(MEEGO_EDITION,harmattan) {
    DEFINES += Q_OS_HARMATTAN
    DEPLOYMENTFOLDERS += folder_harmattan folder_js

    HEADERS += harmattanbackgroundprovider.h
    SOURCES += harmattanbackgroundprovider.cpp

    OTHER_FILES += \
        qtc_packaging/debian_harmattan/rules \
        qtc_packaging/debian_harmattan/README \
        qtc_packaging/debian_harmattan/manifest.aegis \
        qtc_packaging/debian_harmattan/copyright \
        qtc_packaging/debian_harmattan/control \
        qtc_packaging/debian_harmattan/compat \
        qtc_packaging/debian_harmattan/changelog
}



symbian {
    #contains(S60_VERSION, 5.0){
    contains(QT_VERSION, 4.7.3){
        DEFINES += Q_OS_S60V5
        DEPLOYMENTFOLDERS = folder_symbian1 folder_js
        QT -= webkit

        INCLUDEPATH += $$[QT_INSTALL_PREFIX]/epoc32/include/middleware
        INCLUDEPATH += $$[QT_INSTALL_PREFIX]/include/Qt
    } else {
        DEPLOYMENTFOLDERS = folder_symbian3 folder_js

        # only available in Symbian Belle
        DEFINES += PIGLER_API
    }

    CONFIG += qt-components localize_deployment

    TARGET.UID3 = 0x2006DFF5

    TARGET.CAPABILITY += \
        NetworkServices \
        ReadUserData \
        WriteUserData \
        ReadDeviceData \
        WriteDeviceData \
        SwEvent

    TARGET.EPOCHEAPSIZE = 0x40000 0x4000000

    LIBS += -lavkon -leikcore -lgslauncher

    contains(DEFINES, PIGLER_API) {
        LIBS += -lpiglerapi_qt.lib -lrandom -laknnotify
    }

    vendorinfo = "%{\"Yeatse\"}" ":\"Yeatse\""
    my_deployment.pkg_prerules += vendorinfo
    DEPLOYMENT += my_deployment

    # Symbian have a different syntax
    DEFINES -= VER=\\\"$$VERSION\\\"
    DEFINES += VER=\"$$VERSION\"

    MMP_RULES += "EPOCPROCESSPRIORITY windowserver"
}

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()

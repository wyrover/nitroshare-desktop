include(../nitroshare.pri)

# Build an application and specify the required Qt modules
TEMPLATE = app
QT      += network widgets svg

# Some compilers require a flag to enable C++11
CONFIG += c++11

# Generate the config.h file and add its path for inclusion
config_h.input     = config.h.in
config_h.output    = $${INCLUDE_DIR}/config.h
QMAKE_SUBSTITUTES += config_h
INCLUDEPATH       += $${INCLUDE_DIR}

# Files common to all platforms
HEADERS += \
    application/aboutdialog.h \
    application/application.h \
    application/splashdialog.h \
    bundle/bundle.h \
    bundle/bundle_p.h \
    bundle/bundleitem.h \
    device/device.h \
    device/devicedialog.h \
    device/devicelistener.h \
    device/devicemodel.h \
    device/devicemodel_p.h \
    icon/icon.h \
    icon/trayicon.h \
    settings/settings.h \
    settings/settings_p.h \
    settings/settingsdialog.h \
    transfer/transfer.h \
    transfer/transfermodel.h \
    transfer/transfermodel_p.h \
    transfer/transferreceiver.h \
    transfer/transfersender.h \
    transfer/transferserver.h \
    transfer/transferserver_p.h \
    transfer/transferwindow.h \
    util/json.h \
    util/platform.h

SOURCES += \
    application/aboutdialog.cpp \
    application/application.cpp \
    application/splashdialog.cpp \
    bundle/bundle.cpp \
    device/device.cpp \
    device/devicedialog.cpp \
    device/devicelistener.cpp \
    device/devicemodel.cpp \
    icon/icon.cpp \
    icon/trayicon.cpp \
    settings/settings.cpp \
    settings/settingsdialog.cpp \
    transfer/transfer.cpp \
    transfer/transfermodel.cpp \
    transfer/transferreceiver.cpp \
    transfer/transfersender.cpp \
    transfer/transferserver.cpp \
    transfer/transferwindow.cpp \
    util/json.cpp \
    util/platform.cpp \
    main.cpp

FORMS += \
    application/aboutdialog.ui \
    application/splashdialog.ui \
    device/devicedialog.ui \
    settings/settingsdialog.ui \
    transfer/transferwindow.ui

RESOURCES += \
    data/resource.qrc

OTHER_FILES += \
    data/misc/Info.plist \
    data/resource.rc \
    config.h.in

# Include the update-checking code if requested
updatechecker {
    DEFINES += BUILD_UPDATECHECKER
    HEADERS += application/updatechecker.h
    SOURCES += application/updatechecker.cpp
}

# Files and settings specific to the Windows build
win32 {
    RC_FILE         = data/resource.rc
    RC_INCLUDEPATH += $${INCLUDE_DIR}
}

# Files and settings specific to the Mac build
macx {
    ICON             = data/icon/nitroshare.icns
    QMAKE_INFO_PLIST = data/misc/Info.plist
}

# Files and settings specific to the Linux build
linux-* {
    # NOTE: when cross-compiling, you will need to manually
    # specify CONFIG+=debian or CONFIG+=rpm

    # Check to see if dpkg is available
    system(dpkg --version >/dev/null)|debian {
        DEFINES += __DEBIAN__
    }

    # Check to see if rpm is available
    system(rpm --version >/dev/null)|rpm {
        DEFINES += __RPM__
    }

    # Check for the packages needed to build the appindicator class
    CONFIG += link_pkgconfig
    packagesExist(gtk+-2.0 appindicator-0.1 libnotify) {
        PKGCONFIG += gtk+-2.0 appindicator-0.1 libnotify

        # Indicate that the appindicator class should be built and turn
        # off the 'signals' and 'slots' keywords to avoid symbol collisions
        DEFINES += \
            BUILD_APPINDICATOR \
            QT_NO_SIGNALS_SLOTS_KEYWORDS

        # Add the necessary source files
        HEADERS += icon/indicatoricon.h
        SOURCES += icon/indicatoricon.cpp
    }
}

# Setup the target for the main executable
TARGET      = $${PROJECT_NAME}
target.path = $${PREFIX}/bin
INSTALLS   += target

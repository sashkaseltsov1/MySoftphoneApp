QT +=quick sql

CONFIG += c++11 console

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        appcore.cpp \
        conference.cpp \
        conferencecall.cpp \
        config.cpp \
        friend.cpp \
        main.cpp \
        myaccount.cpp \
        mybuddy.cpp \
        mycall.cpp \
        sqlqueries.cpp \
        subscribe.cpp \
        subscriber.cpp

RESOURCES += qml.qrc \
    icons.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    appcore.h \
    conference.h \
    conferencecall.h \
    config.h \
    friend.h \
    myaccount.h \
    mybuddy.h \
    mycall.h \
    sqlqueries.h \
    subscribe.h \
    subscriber.h

QMAKE_LFLAGS += /NODEFAULTLIB:LIBCMT

win32:CONFIG(release, debug|release): LIBS += -L$$PWD/pjproject-2.9/lib/ -llibpjproject-i386-Win32-vc14-Release
else:win32:CONFIG(debug, debug|release): LIBS += -L$$PWD/pjproject-2.9/lib/ -llibpjproject-i386-Win32-vc14-Released

INCLUDEPATH += $$PWD/pjproject-2.9
DEPENDPATH += $$PWD/pjproject-2.9

LIBS += ws2_32.lib ole32.lib

INCLUDEPATH += $$PWD/pjproject-2.9/pjlib/include
INCLUDEPATH += $$PWD/pjproject-2.9/pjlib-util/include
INCLUDEPATH += $$PWD/pjproject-2.9/pjnath/include
INCLUDEPATH += $$PWD/pjproject-2.9/pjsip/include
INCLUDEPATH += $$PWD/pjproject-2.9/pjmedia/include

#
# Copyright (c) 2020 Alex Spataru <https://github.com/alex-spataru>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

#-------------------------------------------------------------------------------
# Make options
#-------------------------------------------------------------------------------

UI_DIR = uic
MOC_DIR = moc
RCC_DIR = qrc
OBJECTS_DIR = obj

CONFIG += c++11

#-------------------------------------------------------------------------------
# Qt configuration
#-------------------------------------------------------------------------------

TEMPLATE = app
TARGET = siglab

CONFIG += qtc_runnable
CONFIG += resources_big
CONFIG += qtquickcompiler

QT += xml
QT += svg
QT += core
QT += quick
QT += serialport
QT += quickcontrols2

QTPLUGIN += qsvg

#-------------------------------------------------------------------------------
# Deploy options
#-------------------------------------------------------------------------------

win32* {
    TARGET = SigLAB
    RC_FILE = deploy/windows/resources/info.rc
}

macx* {
    TARGET = SigLAB
    ICON = deploy/mac/icon.icns
    RC_FILE = deploy/mac/icon.icns
    QMAKE_INFO_PLIST = deploy/mac/info.plist
    QMAKE_POST_LINK = macdeployqt SigLAB.app -qmldir=$$PWD/assets/qml
}

linux:!android {
    target.path = /usr/bin
    icon.path = /usr/share/pixmaps
    desktop.path = /usr/share/applications
    icon.files += deploy/linux/siglab.png
    desktop.files += deploy/linux/siglab.desktop

    INSTALLS += target desktop icon
}

#-------------------------------------------------------------------------------
# Import source code
#-------------------------------------------------------------------------------

RESOURCES += \
    assets/assets.qrc

HEADERS += \
    src/AppInfo.h \
    src/CSV_Export.h \
    src/Categories.h \
    src/DataBridge.h \
    src/DataParser.h \
    src/SerialManager.h

SOURCES += \
    src/CSV_Export.cpp \
    src/Categories.cpp \
    src/DataBridge.cpp \
    src/DataParser.cpp \
    src/SerialManager.cpp \
    src/main.cpp

DISTFILES += \
    assets/qml/Components/Console.qml \
    assets/qml/Components/DataGrid.qml \
    assets/qml/Components/DeviceManager.qml \
    assets/qml/Components/GraphGrid.qml \
    assets/qml/Components/ToolBar.qml \
    assets/qml/UI.qml \
    assets/qml/Widgets/CategoryDelegate.qml \
    assets/qml/Widgets/DataDelegate.qml \
    assets/qml/Widgets/GraphDelegate.qml \
    assets/qml/Widgets/LED.qml \
    assets/qml/Widgets/MapDelegate.qml \
    assets/qml/Widgets/Window.qml \
    assets/qml/main.qml

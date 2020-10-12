/*
 * Copyright (c) 2020 Alex Spataru <https://github.com/alex-spataru>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0

import Group 1.0
import Dataset 1.0

import "../Widgets"

Item {
    id: dataGrid

    property string title: ""
    property bool groupCountChanged: false

    Connections {
        target: CppQmlBridge
        function onUpdated() {
            var previousCount = groupGenerator.count
            var currentCount = CppQmlBridge.groupCount

            if (previousCount != currentCount)
                dataGrid.groupCountChanged = true
            else
                dataGrid.groupCountChanged = false

            groupGenerator.model = 0
            logoWindow.visible = (currentCount % 2) !== 0

            if (currentCount > 0) {
                dataGrid.title = CppQmlBridge.projectTitle
                groupGenerator.model = CppQmlBridge.groupCount
            }

            else {
                dataGrid.title = ""
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: app.spacing * 2
        anchors.margins: app.spacing * 2

        Rectangle {
            radius: 5
            height: 32
            color: "#484"
            Layout.fillWidth: true

            RowLayout {
                spacing: app.spacing

                anchors {
                    left: parent.left
                    leftMargin: app.spacing
                    verticalCenter: parent.verticalCenter
                }

                Image {
                    width: sourceSize.width
                    height: sourceSize.height
                    sourceSize: Qt.size(24, 24)
                    source: "qrc:/icons/arrow-right.svg"
                    Layout.alignment: Qt.AlignVCenter

                    ColorOverlay {
                        source: parent
                        anchors.fill: parent
                        color: palette.text
                    }
                }

                Label {
                    font.bold: true
                    font.pixelSize: 16
                    text: dataGrid.title
                    font.family: app.monoFont
                }
            }

            Label {
                font.family: app.monoFont
                text: CppSerialManager.receivedBytes

                anchors {
                    right: parent.right
                    rightMargin: app.spacing
                    verticalCenter: parent.verticalCenter
                }
            }
        }

        GridLayout {
            columns: 2
            Layout.fillWidth: true
            Layout.fillHeight: true
            rowSpacing: app.spacing
            columnSpacing: app.spacing

            Repeater {
                id: groupGenerator

                delegate: Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    
                    GroupDelegate {
                        anchors.fill: parent
                        group: CppQmlBridge.getGroup(index)
                    }
                }
            }

            Item {
                id: logoWindow
                visible: false
                Layout.fillWidth: true
                Layout.fillHeight: true
                
                Window {
                    id: _window

                    spacing: 0
                    showIcon: false
                    title: qsTr("About")
                    borderColor: "#484"
                    anchors.fill: parent
                    backgroundColor: "#000"

                    Image {
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectFit
                        source: "qrc:/images/siglab.svg"
                        anchors.margins: (Math.min(dataGrid.width, dataGrid.height) / 20)

                        ColorOverlay {
                            source: parent
                            anchors.fill: parent
                            color: app.consoleColor
                        }
                    }
                }
            }
        }
    }
}

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

    Connections {
        target: CppQmlBridge
        function onUpdated() {
            groupGenerator.model = 0

            if (CppQmlBridge.groupCount > 0) {
                dataGrid.title = CppQmlBridge.projectTitle
                groupGenerator.model = CppQmlBridge.groupCount

                statusImage.source = "qrc:/icons/update.svg"
                statusTimer.start()
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
                    id: statusImage
                    width: sourceSize.width
                    height: sourceSize.height
                    sourceSize: Qt.size(24, 24)
                    Layout.alignment: Qt.AlignVCenter

                    Timer {
                        interval: 250
                        id: statusTimer
                        onTriggered: statusImage.source = "qrc:/icons/schedule.svg"
                    }

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

                delegate: GroupDelegate {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    group: CppQmlBridge.getGroup(index)
                }
            }
        }
    }
}

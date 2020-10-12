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
            var count = CppQmlBridge.groupCount

            groupGenerator.model = 0
            logoWindow.visible = (count % 2) !== 0

            if (count > 0) {
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
            Layout.fillWidth: true
            color: Qt.darker(app.consoleColor)

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
                    anchors.fill: parent
                    backgroundColor: "#000"
                    borderColor: Qt.darker(app.consoleColor)

                    Canvas {
                        id: canvas
                        onPaint: drawSine()
                        anchors.fill: parent
                        anchors.margins: _window.borderWidth

                        property var time: 0
                        property var color: Qt.darker(app.consoleColor)

                        function drawSine()
                        {
                            var context = canvas.getContext("2d")
                            var tvHeight = canvas.height
                            var tvWidth = canvas.width
                            var pixelWidth = 10
                            var pixelHeight = 10

                            for (var v = 0; v < tvHeight; v += pixelHeight){
                                for (var h = 0; h < tvWidth; h += pixelWidth) {
                                    var lum = Math.random() * 0.10
                                    var r = (0x52 * lum) / 0xff
                                    var g = (0xd7 * lum) / 0xff
                                    var b = (0x88 * lum) / 0xff
                                    context.fillStyle = Qt.rgba(r, g, b, 1)
                                    context.fillRect(h,v,pixelWidth,pixelHeight)
                                }
                            }
                        }

                        Timer {
                            interval: 50
                            repeat: true
                            Component.onCompleted: start()
                            onTriggered: canvas.requestPaint()
                        }
                    }

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

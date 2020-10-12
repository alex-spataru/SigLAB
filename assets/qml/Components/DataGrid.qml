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
            dataGrid.title = CppQmlBridge.projectTitle
            if (groupGenerator.model !== CppQmlBridge.groupCount) {
                groupGenerator.model = 0
                groupGenerator.model = CppQmlBridge.groupCount
            }
        }
    }

    Connections {
        target: CppGraphProvider
        function onDataUpdated() {
            if (graphGenerator.model !== CppGraphProvider.graphCount) {
                graphGenerator.model = 0
                graphGenerator.model = CppGraphProvider.graphCount
            }
        }
    }

    ColumnLayout {
        x: 2 * app.spacing
        anchors.fill: parent
        spacing: app.spacing * 2
        anchors.margins: app.spacing * 2

        //
        // Title
        //
        Rectangle {
            radius: 5
            height: 32
            Layout.fillWidth: true
            color: palette.highlight

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
                        color: palette.brightText
                    }
                }

                Label {
                    font.bold: true
                    font.pixelSize: 16
                    text: dataGrid.title
                    color: palette.brightText
                    font.family: app.monoFont
                }
            }

            Label {
                font.family: app.monoFont
                color: palette.brightText
                text: CppSerialManager.receivedBytes

                anchors {
                    right: parent.right
                    rightMargin: app.spacing
                    verticalCenter: parent.verticalCenter
                }
            }
        }

        //
        // Group data & graphs
        //
        RowLayout {
            spacing: app.spacing
            Layout.fillWidth: true
            Layout.fillHeight: true

            //
            // View options
            //
            Window {
                title: qsTr("View")
                Layout.fillHeight: true
                Layout.minimumWidth: 240

                Rectangle {
                    anchors.fill: parent
                    anchors.topMargin: 0
                    anchors.margins: 3

                    gradient: Gradient {
                        GradientStop {
                            position: 0
                            color: Qt.rgba(46 / 255, 48 / 255, 58 / 255, 1)
                        }

                        GradientStop {
                            position: 1
                            color: Qt.rgba(18 / 255, 18 / 255, 24 / 255, 1)
                        }
                    }
                }

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: app.spacing * 2

                    Label {
                        font.bold: true
                        text: qsTr("Groups")
                    }

                    Repeater {
                        model: groupGenerator.model
                        delegate: Switch {
                            checked: true
                            Layout.fillWidth: true
                            text: CppQmlBridge.getGroup(index).title
                        }
                    }

                    Label {
                        font.bold: true
                        text: qsTr("Graphs")
                    }

                    Repeater {
                        model: graphGenerator.model
                        delegate: Switch {
                            checked: true
                            Layout.fillWidth: true
                            text: CppGraphProvider.getDataset(index).title
                        }
                    }

                    Item {
                        Layout.fillHeight: true
                    }
                }
            }

            //
            // Data grid
            //
            ScrollView {
                id: _sv
                clip: true
                contentWidth: -1
                Layout.fillWidth: true
                Layout.fillHeight: true
                ScrollBar.vertical.z: 5
                ScrollBar.vertical.policy: ScrollBar.AlwaysOn
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                ScrollBar.vertical.visible: ScrollBar.vertical.size < 1

                GridLayout {
                    columns: Math.floor(width / 320)
                    rowSpacing: app.spacing
                    columnSpacing: app.spacing
                    width: _sv.width - 10 - app.spacing

                    Repeater {
                        id: groupGenerator

                        delegate: Item {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.minimumHeight: 196

                            GroupDelegate {
                                groupIndex: index
                                anchors.fill: parent
                                group: CppQmlBridge.getGroup(index)
                            }
                        }
                    }

                    Repeater {
                        id: graphGenerator

                        delegate: Item {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.minimumHeight: 196

                            GraphDelegate {
                                graphId: index
                                anchors.fill: parent
                            }
                        }
                    }
                }
            }
        }
    }
}

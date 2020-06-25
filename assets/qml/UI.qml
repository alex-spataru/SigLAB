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

import "Widgets" as Widgets
import "Components" as Components


Page {
    id: page

    //
    // Toolbar
    //
    header: Components.ToolBar {
        id: toolbar
    }

    //
    // Widgets
    //
    RowLayout {
        spacing: app.spacing
        anchors.fill: parent
        anchors.margins: app.spacing

        //
        // Data display & console
        //
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true

            //
            // Data display widget
            //
            Widgets.Window {
                id: dataDis
                Layout.fillWidth: true
                Layout.fillHeight: true
                opacity: enabled ? 1 : 0
                title: qsTr("Data Display")
                enabled: toolbar.dataDisChecked

                TabBar {
                    id: tabBar
                    contentHeight: 32

                    anchors {
                        leftMargin: 3
                        rightMargin: 3
                        top: parent.top
                        left: parent.left
                        right: parent.right
                    }

                    TabButton {
                        text: qsTr("Data")
                    }

                    TabButton {
                        text: qsTr("Graphs")
                    }
                }

                StackLayout {
                    anchors.fill: parent
                    anchors.topMargin: tabBar.height
                    currentIndex: tabBar.currentIndex

                    Components.DataGrid {
                        id: dataGrid
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }

                    Components.GraphGrid {
                        id: graphGrid
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }
                }
            }

            //
            // Console
            //
            Components.Console {
               id: console
               Layout.fillWidth: true
               Layout.fillHeight: true
               opacity: enabled ? 1 : 0
               enabled: toolbar.consoleChecked
               Layout.maximumHeight: !dataDis.enabled ? page.height : implicitHeight

               Behavior on Layout.maximumHeight {NumberAnimation{}}
            }
        }

        //
        // Devices hub
        //
        Components.DeviceManager {
            id: devMan
            Layout.fillHeight: true
            opacity: enabled ? 1 : 0
            enabled: toolbar.devicesChecked
        }
    }
}

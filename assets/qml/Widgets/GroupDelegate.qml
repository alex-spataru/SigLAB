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

Window {
    id: groupWindow

    spacing: -1
    showIcon: false
    title: group.title
    visible: opacity > 0
    opacity: enabled ? 1 : 0
    Behavior on opacity {NumberAnimation{}}
    borderColor: Qt.rgba(81/255, 116/255, 151/255, 1)

    property int groupIndex: 0
    property Group group: null

    Connections {
        target: CppQmlBridge
        function onUpdated() {
            if (groupWindow.enabled)
                group = CppQmlBridge.getGroup(groupIndex)
        }
    }

    Rectangle {
        anchors.fill: parent
        anchors.topMargin: 0
        anchors.margins: borderWidth
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

    ScrollView {
        id: _sv
        clip: true
        contentWidth: -1
        anchors.fill: parent
        anchors.margins: app.spacing

        ScrollBar.vertical.z: 5
        enabled: contentHeight > parent.width
        ScrollBar.vertical.policy: ScrollBar.AlwaysOn
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        ScrollBar.vertical.visible: ScrollBar.vertical.size < 1

        ColumnLayout {
            x: 0
            spacing: app.spacing
            width: _sv.width - (_sv.ScrollBar.vertical.visible ? 10 : 0)

            Repeater {
                model: group.datasetCount
                delegate: DataDelegate {
                    Layout.fillWidth: true
                    dataset: group.getDataset(index)
                }
            }
        }
    }
}

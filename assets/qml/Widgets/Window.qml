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

Page {
    id: window

    //
    // Custom properties
    //
    property alias icon: _bt.icon
    property color borderColor: "#666"
    property alias showIcon: _bt.visible
    property color titleColor: palette.text
    property color backgroundColor: "#212121"

    //
    // Animations
    //
    Behavior on opacity {NumberAnimation{}}
    Behavior on Layout.preferredWidth {NumberAnimation{}}
    Behavior on Layout.preferredHeight {NumberAnimation{}}

    //
    // Layout properties
    //
    visible: opacity > 0
    Layout.preferredWidth: enabled ? implicitWidth : 0
    Layout.preferredHeight: enabled ? implicitHeight : 0

    //
    // Background widget
    //
    background: Rectangle {
        radius: 5
        border.width: 3
        color: window.backgroundColor
        border.color: window.borderColor
    }

    //
    // Window title & controls
    //
    header: Rectangle {
        radius: 5
        height: 32
        color: window.borderColor

        Rectangle {
            color: parent.color
            height: parent.radius

            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
        }

        RowLayout {
            spacing: 0
            anchors.fill: parent

            ToolButton {
                id: _bt
                flat: true
                enabled: false
                icon.width: 24
                icon.height: 24
                Layout.minimumWidth: 32
                Layout.maximumWidth: 32
                icon.color: window.titleColor
                Layout.alignment: Qt.AlignVCenter
                Layout.maximumHeight: parent.height
                Layout.minimumHeight: parent.height
                icon.source: "qrc:/icons/equalizer.svg"
            }

            Label {
                font.bold: true
                text: window.title
                Layout.fillWidth: true
                color: window.titleColor
                Layout.alignment: Qt.AlignVCenter
                horizontalAlignment: window.showIcon ? Label.AlignLeft : Label.AlignHCenter
            }
        }
    }
}

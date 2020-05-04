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

import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.3

import "../Widgets" as Widgets

Widgets.Window {
    id: window

    //
    // Window properties
    //
    implicitHeight: 256
    title: qsTr("Console")
    icon.source: "qrc:/icons/code.svg"

    //
    // Set the CppSerialManager's text document pointer so that the console
    // ouput is handled automatically by the CppSerialManager
    //
    Component.onCompleted: CppSerialManager.setTextDocument(_console.textDocument)

    //
    // Controls
    //
    ColumnLayout {
        anchors.fill: parent
        spacing: app.spacing
        anchors.margins: app.spacing * 1.5

        //
        // Console display
        //
        TextField {
            id: _cont
            readOnly: true
            Layout.fillWidth: true
            Layout.fillHeight: true

            ScrollView {
                id: _scrollView
                clip: true
                anchors.fill: parent
                contentWidth: parent.width
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

                TextArea {
                    id: _console
                    readOnly: true
                    font.pixelSize: 12
                    wrapMode: TextEdit.Wrap
                    textFormat: Text.RichText
                    font.family: app.monoFont
                    width: _scrollView.contentWidth
                    placeholderText: qsTr("No data received so far...")
                }
            }
        }

        //
        // Data-write controls
        //
        RowLayout {
            Layout.fillWidth: true

            TextField {
                id: _tf
                height: 24
                Layout.fillWidth: true
                font.family: app.monoFont
                opacity: enabled ? 1 : 0.5
                enabled: CppSerialManager.readWrite
                placeholderText: qsTr("Send data to device") + "..."
                Keys.onReturnPressed: {
                    CppSerialManager.sendData(_tf.text)
                    _tf.clear()
                }

                Behavior on opacity {NumberAnimation{}}
            }

            Button {
                height: 24
                icon.color: palette.text
                opacity: enabled ? 1 : 0.5
                icon.source: "qrc:/icons/send.svg"
                enabled: CppSerialManager.readWrite
                onClicked: {
                    CppSerialManager.sendData(_tf.text)
                    _tf.clear()
                }

                Behavior on opacity {NumberAnimation{}}
            }
        }
    }
}

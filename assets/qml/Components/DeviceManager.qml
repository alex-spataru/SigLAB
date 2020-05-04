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
import QtQuick.Controls 2.0

import "../Widgets" as Widgets

Widgets.Window {
    //
    // Window properties
    //
    implicitWidth: 256
    title: qsTr("Device Manager")
    icon.source: "qrc:/icons/usb.svg"

    //
    // Control arrangement
    //
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: app.spacing * 1.5
        spacing: app.spacing / 2

        //
        // COM port selector
        //
        Label {
            text: qsTr("COM Port") + ":"
        } ComboBox {
            Layout.fillWidth: true
            model: CppSerialManager.portList
            currentIndex: CppSerialManager.portIndex
            onCurrentIndexChanged: {
                if (CppSerialManager.portIndex !== currentIndex)
                    CppSerialManager.portIndex = currentIndex
            }
        }

        //
        // Baud rate selector
        //
        Label {
            text: qsTr("Baud Rate") + ":"
        } ComboBox {
            Layout.fillWidth: true
            model: CppSerialManager.baudRateList
            currentIndex: CppSerialManager.baudRateIndex
            onCurrentIndexChanged: {
                if (CppSerialManager.baudRateIndex !== currentIndex)
                    CppSerialManager.baudRateIndex = currentIndex
            }
        }

        //
        // Spacer
        //
        Item {
            Layout.fillHeight: true
        }

        //
        // RX LED
        //
        Widgets.LED {
            id: _rx
            enabled: false
            text: qsTr("RX")
            Layout.fillWidth: true

            Connections {
                target: CppSerialManager
                onRx: _rx.flash()
            }
        }

        //
        // RX LED
        //
        Widgets.LED {
            id: _tx
            enabled: false
            text: qsTr("TX")
            Layout.fillWidth: true

            Connections {
                target: CppSerialManager
                onTx: _tx.flash()
            }
        }

        //
        // Spacer
        //
        Item {
            Layout.fillHeight: true
        }

        //
        // Data bits selector
        //
        Label {
            text: qsTr("Data Bits") + ":"
        } ComboBox {
            Layout.fillWidth: true
            model: CppSerialManager.dataBitsList
            currentIndex: CppSerialManager.dataBitsIndex
            onCurrentIndexChanged: {
                if (CppSerialManager.dataBitsIndex !== currentIndex)
                    CppSerialManager.dataBitsIndex = currentIndex
            }
        }

        //
        // Parity selector
        //
        Label {
            text: qsTr("Parity") + ":"
        } ComboBox {
            Layout.fillWidth: true
            model: CppSerialManager.parityList
            currentIndex: CppSerialManager.parityIndex
            onCurrentIndexChanged: {
                if (CppSerialManager.parityIndex !== currentIndex)
                    CppSerialManager.parityIndex = currentIndex
            }
        }

        //
        // Stop bits selector
        //
        Label {
            text: qsTr("Stop Bits") + ":"
        } ComboBox {
            Layout.fillWidth: true
            model: CppSerialManager.stopBitsList
            currentIndex: CppSerialManager.stopBitsIndex
            onCurrentIndexChanged: {
                if (CppSerialManager.stopBitsIndex !== currentIndex)
                    CppSerialManager.stopBitsIndex = currentIndex
            }
        }

        //
        // Flow control selector
        //
        Label {
            text: qsTr("Flow Control") + ":"
        } ComboBox {
            Layout.fillWidth: true
            model: CppSerialManager.flowControlList
            currentIndex: CppSerialManager.flowControlIndex
            onCurrentIndexChanged: {
                if (CppSerialManager.flowControlIndex !== currentIndex)
                    CppSerialManager.flowControlIndex = currentIndex
            }
        }

        //
        // Spacer
        //
        Item {
            Layout.fillHeight: true
        }

        //
        // Start sequence string
        //
        Label {
            text: qsTr("Packet start sequence") + ":"
        } TextField {
            Layout.fillWidth: true
            font.family: app.monoFont
            text: CppSerialManager.startSequence
            onTextChanged: CppSerialManager.startSequence = text
        }

        //
        // End sequence selector
        //
        Label {
            text: qsTr("Packet end sequence") + ":"
        } TextField {
            Layout.fillWidth: true
            font.family: app.monoFont
            text: CppSerialManager.finishSequence
            onTextChanged: CppSerialManager.finishSequence = text
        }
    }
}

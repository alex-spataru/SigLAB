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
import QtQuick.Window 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Qt.labs.settings 1.0

import "Dialogs" as Dialogs
import "Widgets" as Widgets

ApplicationWindow {
    id: app

    //
    // Global properties
    //
    readonly property int spacing: 8
    readonly property string monoFont: {
        switch (Qt.platform.os) {
        case "osx":
            return "Menlo"
        case "windows":
            return "Consolas"
        default:
            return "Monospace"
        }
    }

    //
    // Window geometry
    //
    minimumWidth: 640
    minimumHeight: 480
    title: CppAppName + " " + CppAppVersion

    //
    // Save/load settings
    //
    Settings {
        property alias mwX: app.x
        property alias mwY: app.y
        property alias mwWidth: app.width
        property alias mwHeight: app.height
    }

    //
    // Set fusion palette
    //
    palette.base: "#191919"
    palette.text: "#ffffff"
    palette.link: "#2a82da"
    palette.button: "#353535"
    palette.window: "#252525"
    palette.highlight: "#666666"
    palette.buttonText: "#ffffff"
    palette.brightText: "#ff0000"
    palette.windowText: "#ffffff"
    palette.toolTipBase: "#ffffff"
    palette.toolTipText: "#ffffff"
    palette.alternateBase: "#353535"
    palette.highlightedText: "#ffffff"

    //
    // User interface loader
    //
    Loader {
        anchors.fill: parent

        onStatusChanged: {
            if (status == Loader.Ready)
                timer.start()
        }

        sourceComponent: UI {
            anchors.fill: parent
            background: Rectangle {
                color: "#111"
            }
        }
    }

    //
    // Window loader timer
    //
    Timer {
        id: timer
        interval: 500
        onTriggered: app.visible = true
    }
}

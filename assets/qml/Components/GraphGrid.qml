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

import "../Widgets"

Item {
    id: graphGrid

    Connections {
        target: CppGraphProvider
        function onDataUpdated() {
            grid.columns = (CppGraphProvider.graphCount < 4) ? 1 : 3

            if (graphGenerator.model !== CppGraphProvider.graphCount) {
                graphGenerator.model = 0
                graphGenerator.model = CppGraphProvider.graphCount
            }
        }
    }

    GridLayout {
        id: grid
        columns: 3
        anchors.fill: parent
        rowSpacing: app.spacing
        columnSpacing: app.spacing
        anchors.margins: app.spacing * 2

        Repeater {
            id: graphGenerator

            delegate: Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                GraphDelegate {
                    graphId: index
                    anchors.fill: parent
                }
            }
        }
    }
}

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
import QtCharts 2.0

import Dataset 1.0

Window {
    property int graphId: -1
    property real minimumValue: 0
    property real maximumValue: 1

    spacing: -1
    showIcon: false
    borderColor: Qt.darker(app.consoleColor)
    backgroundColor: Qt.darker(app.consoleColor)
    title: CppGraphProvider.getDataset(graphId).title +
           " (" + CppGraphProvider.getDataset(graphId).units + ")"

    Item {
        anchors.fill: parent
        anchors.margins: -9
        anchors.topMargin: -11

        ChartView {
            antialiasing: true
            anchors.fill: parent
            legend.visible: false
            backgroundRoundness: 0
            theme: ChartView.ChartThemeDark

            ValueAxis {
                id: timeAxis
                min: 0
                max: CppGraphProvider.maxPoints
            }

            ValueAxis {
                id: positionAxis
                min: Math.min(0, minimumValue)
                max: Math.max(0, maximumValue)
            }

            LineSeries {
                width: 2
                id: series
                useOpenGL: true
                axisX: timeAxis
                axisY: positionAxis
                color: app.consoleColor
            }
        }
    }

    Timer {
        interval: 1000 / 60
        repeat: true
        running: true
        onTriggered: {
            var value = CppGraphProvider.getValue(graphId)
            if (value > maximumValue)
                maximumValue = value * 1.2
            if (value < minimumValue)
                minimumValue = value

            positionAxis.min = Math.min(0, minimumValue)
            positionAxis.max = Math.max(1, maximumValue)
            series.axisX = positionAxis

            CppGraphProvider.updateGraph(series, graphId)
        }
    }
}

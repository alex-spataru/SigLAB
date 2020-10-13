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
import QtCharts 2.3

import Dataset 1.0

Window {
    id: graphWindow

    property int graphId: -1
    property real maximumValue: -Infinity
    property real minimumValue: +Infinity

    spacing: -1
    showIcon: false
    visible: opacity > 0
    opacity: enabled ? 1 : 0
    Behavior on opacity {NumberAnimation{}}
    borderColor: Qt.rgba(81/255, 116/255, 151/255, 1)
    title: CppGraphProvider.getDataset(graphId).title +
           " (" + CppGraphProvider.getDataset(graphId).units + ")"

    Connections {
        target: CppGraphProvider
        function onDataUpdated() {
            // Cancel if window is not enabled
            if (!graphWindow.enabled)
                return

            // Update maximum value (if required)
            var value = CppGraphProvider.getValue(graphId)
            if (value > maximumValue)
                maximumValue = value
            if (value < minimumValue)
                minimumValue = value

            // Get central value
            var medianValue = Math.max(1, (maximumValue + minimumValue)) / 2

            // Center graph verticaly
            positionAxis.min = medianValue * (1 - 0.5)
            positionAxis.max = medianValue * (1 + 0.5)

            // Draw graph
            CppGraphProvider.updateGraph(series, graphId)
        }
    }

    ChartView {
        antialiasing: false
        anchors.fill: parent
        legend.visible: false
        backgroundRoundness: 0
        enabled: graphWindow.enabled
        visible: graphWindow.enabled
        backgroundColor: graphWindow.backgroundColor

        margins {
            top: 0
            bottom: 0
            left: 0
            right: 0
        }

        ValueAxis {
            id: timeAxis
            min: 0
            labelFormat: " "
            lineVisible: false
            labelsVisible: false
            tickType: ValueAxis.TicksFixed
            labelsFont.family: app.monoFont
            max: CppGraphProvider.displayedPoints
            gridLineColor: Qt.rgba(81/255, 116/255, 151/255, 1)
        }

        ValueAxis {
            id: positionAxis
            min: 0
            max: 1
            lineVisible: false
            tickType: ValueAxis.TicksFixed
            labelsFont.family: app.monoFont
            labelsColor: Qt.rgba(81/255, 116/255, 151/255, 1)
            gridLineColor: Qt.rgba(81/255, 116/255, 151/255, 1)
        }

        LineSeries {
            id: series
            width: 2
            axisX: timeAxis
            useOpenGL: true
            capStyle: Qt.RoundCap
            axisYRight: positionAxis
            color: Qt.rgba(215/255, 45/255, 96/255, 1)
        }
    }
}

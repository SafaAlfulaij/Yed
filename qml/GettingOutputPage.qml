/**
* Copyright 2016 Safa AlFulaij <safa1996alfulaij@gmail.com>
*
* This file is part of Yed.
*
* Yed is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* Yed is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with Yed.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.3
import QtQuick.Controls 1.4

import Utils 1.0

Item {
    id: gettingOutputPage

    property string problemID: ""
    property string problemDescribtion: ""

    Component.onCompleted: {
        myMainDataBase.prepareProblemTypeCommands(problemID)
        myThreadingClass.commandList = myMainDataBase.getProblemTypeCommands
        myThreadingClass.start()
    }

    ThreadingClass {
        id: myThreadingClass
        onFinished: {
            gettingOutputPage.parent.push({
                item: Qt.resolvedUrl("OverviewBeforeSendPage.qml"),
                properties: {problemID: problemID,
                    problemDescribtion: problemDescribtion,
                    problemCommandsOutput: myThreadingClass.commandsOutput,
                    distroName: myThreadingClass.distroName
                }})
        }
    }

    BusyIndicator {
        id: busyIndicator
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        running: true
    }

    Text {
        id: gettingOutputText
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: busyIndicator.bottom
        text: "يجلب مخرجات الأمر.."
        font.pointSize: 14
    }

    Text {
        id: commandNameText
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: gettingOutputText.bottom
        text: myThreadingClass.commandName
    }
}

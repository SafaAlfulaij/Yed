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
import QtQuick.Layouts 1.2

Item {
    id: overviewBeforeSendPage

    property string problemID: ""
    property string distroName: ""
    property string problemDescribtion: ""
    property string problemCommandsOutput: ""

    ColumnLayout {
        anchors.fill: parent

        Text {
            text: "هنا تجد التقرير الذي سيُرسل إلينا."
            font.pointSize: 13
            Layout.fillWidth: true
        }

        TextArea {
            id: reportContentsOverviewBeforeSendPlainTextEdit
            Layout.margins: 10
            Layout.fillWidth: true
            Layout.fillHeight: true
            focus: true
            wrapMode: TextEdit.Wrap
            readOnly: true
            textFormat: TextEdit.RichText
            text: "%1<br><br><br><br><br><p dir=\"ltr\">%2<br>ID: %3<br>Distro: %4<br>Commands output:<br>%5<br></p>".arg(
                problemDescribtion).arg(Array(100).join("-")).arg(problemID).arg(distroName).arg(problemCommandsOutput)
            font.family: "Kawkab Mono"
        }
        
        RowLayout {
            anchors.right: parent.right
            anchors.left: parent.left

            Button {
                id: overviewBeforeSendPageSendButton
                anchors.right: parent.right
                text: "أرسل"
                onClicked: console.log("DEBUG: send report now")
            }

            Button {
                id: overviewBeforeSendPageBackButton
                anchors.left: parent.left
                text: "ارجع"
                onClicked: {
                    overviewBeforeSendPage.parent.pop(overviewBeforeSendPage.parent.get(1)) // ProblemTypeDescribtionPage
                }
            }
        }
    }
}







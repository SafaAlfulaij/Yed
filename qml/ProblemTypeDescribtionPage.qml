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
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.2
import QtQuick.Dialogs 1.0

Item {
    id: problemTypeDescribtionPage

    property string problemID: ""
    property alias problemDescribtion: problemDescribtionPageProblemType.text

    ColumnLayout {
        anchors.fill: parent

        RowLayout {

            Text {
                text: "من فضلك أدخل هنا وصف المشكلة التي تواجهها (ومتى تحدث إن أمكن):"
                font.pointSize: 13
                Layout.fillWidth: true
            }

            Text {
                id: problemDescribtionPageProblemType
                font.pointSize: 10
                font.bold: true

                TooltipArea {
                    text: "مشكلتي هي في %1    ".arg(parent.text) // Spaces are for Clipping issue, remove when solved
                }
            }
        }

        TextArea {
            id: problemDescribtionPlainTextEdit
            Layout.margins: 10
            Layout.fillWidth: true
            Layout.fillHeight: true
            focus: true
            wrapMode: TextEdit.Wrap
            font.pointSize: 12
            text: ""
        }

        RowLayout {
            anchors.right: parent.right
            anchors.left: parent.left

            PropertyAnimation {
                id: fadeOutAnimation
                property: "opacity"
                to: 0
            }
            
            Timer {
                id: noTextLabelTimer
                interval: 2000
                running: true
                onTriggered: {
                    fadeOutAnimation.target = noTextLabel
                    fadeOutAnimation.running = true
                }
            }

            Button {
                id: problemDescribtionPageContinueButton
                anchors.right: parent.right
                text: "تابع"
                onClicked: {
                    backConfirmationLabel.visible = false
                    if (problemDescribtionPlainTextEdit.text == "") {
                        noTextLabel.opacity = 1
                        noTextLabel.visible = true
                        noTextLabelTimer.start()
                    }
                    else {
                        noTextLabel.visible = false
                        
                        problemTypeDescribtionPage.parent.push({
                        item: Qt.resolvedUrl("GettingOutputPage.qml"),
                        properties: {
                            problemID: problemID,
                            problemDescribtion: problemDescribtionPlainTextEdit.text        
                        }})
                    }
                }
            }

            Text {
                id: backConfirmationLabel
                visible: false
                text: "أأنت متأكد من الرجوع؟ ستفقد كل ما كتبت هنا! <a href=\"Yes\">نعم</a> <a href=\"No\">لا</a>"
                font.pointSize: 11
                color: "red"
                anchors.left: problemDescribtionPageBackButton.right
                anchors.leftMargin: 10

                onLinkActivated: (link == "Yes") ? problemTypeDescribtionPage.parent.pop() : visible = false

                MouseArea {
                    anchors.fill: parent
                    cursorShape: backConfirmationLabel.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
                    acceptedButtons: Qt.NoButton
                }
            }

            Text {
                id: noTextLabel
                visible: false
                text: "لم تدخل أي نص!"
                font.pointSize: 11
                color: "red"
                anchors.right: problemDescribtionPageContinueButton.left
                anchors.rightMargin: 10
            }

            Button {
                id: problemDescribtionPageBackButton
                anchors.left: parent.left
                text: "ارجع"
                onClicked: {
                    if (problemDescribtionPlainTextEdit.text == "") problemTypeDescribtionPage.parent.pop()
                    else backConfirmationLabel.visible = true
                }
            }
        }
    }
}

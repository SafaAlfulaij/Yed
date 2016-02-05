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
    id: problemTypePage

    RowLayout {
        anchors.fill: parent

        Text {
            id: problemIsInLabel
            text: "مشكلتي هي في:"
            font.pointSize: 13
            anchors.top: parent.top
        }

        Component {
            id: contactDelegate

            Rectangle {
                x:10
                y: 10
                width: 80
                height: 80
                radius: 4
                color: "transparent"

                ColumnLayout {
                    anchors.fill: parent
                    Text { text: problemTypeUnicodeIcon; font.pointSize: 22; anchors.horizontalCenter: parent.horizontalCenter }
                    Text { text: problemTypeTypeText;    font.pointSize: 16; anchors.horizontalCenter: parent.horizontalCenter }
                }

                TooltipArea { //Return to MouseArea if tooltip not needed (don't forget to get anchors and others back)
                    text: problemTypeHelpText

                    onClicked: {
                        problemTypesGrid.currentIndex = index
                        problemTypePage.parent.push({
                            item: Qt.resolvedUrl("ProblemTypeDescribtionPage.qml"),
                            properties: {problemDescribtion: problemTypeTypeText, problemID: problemTypeID}})
                    }

                    onPressed: parent.color = "lightGray"
                    onReleased: parent.color = "transparent"
                    onCanceled: parent.color = "transparent"
                    onEntered: parent.border.color = "lightGray"
                    onExited : parent.border.color = "transparent"
                }
            }
        }

        GridView {
            id: problemTypesGrid
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: problemIsInLabel.right // It's how the layout is before mirroring
            anchors.right: parent.right
            anchors.margins: 5
            clip: true
            cellWidth: 90
            cellHeight: 90
            focus: true
            delegate: contactDelegate

            Component.onCompleted: {
                myMainDataBase.prepareTableModel("ID|TypeText|UnicodeIcon|HelpText", "ProblemTypes", "problemType")
                problemTypesGrid.model = myMainDataBase.problemTypesTableModel
            }
        }
    }
}

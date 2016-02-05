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
import QtQuick.Controls 1.2
import QtQuick.Window 2.2

import DataBaseData 1.0
import Utils 1.0

ApplicationWindow {

    title: "مُرشدك إلى حلّ مشكلتك"
    width: 640
    minimumWidth: 640
    height: 480
    minimumHeight: 480

    MainDatabase {
        id: myMainDataBase
        databaseName: "../data/database.sqlite"
    }

    InternetConnectionClass {
        id: myUtilsClass
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: noInternetImage.visible = !myUtilsClass.isThereInternetConnection
    }

    Image {
        id: noInternetImage
        source: "../data/images/network-wired-unavailable.svg"
        visible: false
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.left: parent.left
        anchors.leftMargin: 5

        TooltipArea {
            text: "ليس هناك اتصال بالإنترنت!  " // Spaces are for Clipping issue, remove when solved
        }
    }

    Label {
        id: inTheNameOfAllahLabel
        text: "بسم الله الرحمن الرحيم"
        font.pointSize: 12.5
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 5
    }

    Label {
        id: programDescribtionLabel
        text: "هذا البرنامج هو لمساعدتك في الحصول على المساعدة بتقديم المعلومات الضرورية."
        font.pointSize: 13.5
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: inTheNameOfAllahLabel.bottom
        anchors.topMargin: 5
    }

    StackView {
        id: mainStakView
        initialItem: ProblemTypePage {}
        anchors.top: programDescribtionLabel.bottom
        anchors.topMargin: 10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.right: parent.right
        anchors.rightMargin: 5

        LayoutMirroring.enabled: true
        LayoutMirroring.childrenInherit: true

        delegate: StackViewDelegate {
            function transitionFinished(properties)
            {
                properties.exitItem.opacity = 1
            }

            pushTransition: StackViewTransition {
                PropertyAnimation {
                    target: enterItem
                    property: "opacity"
                    from: 0
                    to: 1
                }
                PropertyAnimation {
                    target: exitItem
                    property: "opacity"
                    from: 1
                    to: 0
                }
            }
        }
    }

}

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

//Borrowed from https://www.kullo.net/blog/tooltiparea-the-missing-tooltip-component-of-qt-quick/

import QtQuick 2.4
import QtQuick.Controls.Private 1.0

// TooltipArea.qml
// This file contains private Qt Quick modules that might change in future versions of Qt
// Tested on: Qt 5.4.1

MouseArea {
    id: _root
    property string text: ""

    anchors.fill: parent
    hoverEnabled: _root.enabled

    onExited: Tooltip.hideText()
    onCanceled: Tooltip.hideText()

    Timer {
        interval: 1000
        running: _root.enabled && _root.containsMouse && _root.text.length
        onTriggered: Tooltip.showText(_root, Qt.point(_root.mouseX, _root.mouseY), _root.text)
    }
}
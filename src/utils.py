# Copyright 2016 Safa AlFulaij <safa1996alfulaij@gmail.com>
#
# This file is part of Yed.
#
# Yed is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Yed is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Yed.  If not, see <http://www.gnu.org/licenses/>.

from PyQt5.QtCore import pyqtProperty, pyqtSignal, QObject, QThread, QVariant
from PyQt5.QtNetwork import QNetworkConfigurationManager

import subprocess, re

def getDistroName():
    with open('/etc/os-release') as handle:
        fileContent = handle.read()
        
        name = re.findall('^NAME=["\']?([^"\']*)["\']?', fileContent)
        try:
            return name[0]
        except:
            return 'Other'

class InternetConnectionClass(QObject):

    ignore = pyqtSignal()

    def __init__(self, parent=None):
        super(InternetConnectionClass, self).__init__(parent)

        self.internetConnectionManager = QNetworkConfigurationManager()

    @pyqtProperty(bool, notify=ignore)
    def isThereInternetConnection(self):
        return self.internetConnectionManager.isOnline()

class ThreadingClass(QThread):

    commandNameChanged = pyqtSignal()

    def __init__(self, parent=None):
        super(ThreadingClass, self).__init__(parent)

        self._commandList = []
        self._commandName = ''
        self._commandsOutput = ''

    def __del__(self):
        self.wait()

    @pyqtProperty(QVariant)
    def commandList(self):
        return self._commandList

    @commandList.setter
    def commandList(self, commandList):
        self._commandList = commandList.toVariant()

    @pyqtProperty(str)
    def commandsOutput(self):
        return self._commandsOutput

    @pyqtProperty(str)
    def distroName(self):
        return getDistroName()

    def getCommandName(self):
        return self._commandName

    def setCommandName(self, commandName):
        self._commandName = commandName
        self.commandNameChanged.emit()

    def run(self):
        for each in self._commandList:
            p = subprocess.Popen(each, stdout=subprocess.PIPE, shell=True)
            (output, err) = p.communicate()
            p_status = p.wait()
            self.setCommandName(each)
            self._commandsOutput += '({status}) {command}<br>{commandOutput}<br>{spearator}<br>'.format(
                status= p_status,
                command= each,
                commandOutput= output.decode('UTF-8')[:-1].replace('\n', '<br>').replace(' ', '&nbsp;'),
                spearator= '-'*100)

    commandName = pyqtProperty(str, fget=getCommandName, fset=setCommandName, notify=commandNameChanged)

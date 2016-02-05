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

import subprocess, re

from PyQt5.QtCore import (Qt, pyqtProperty, pyqtSlot, pyqtSignal, QObject,
                          QFileInfo, QUrl, QVariant, QAbstractListModel, QModelIndex)
from PyQt5.QtSql import QSqlDatabase, QSqlQuery

from src.utils import getDistroName #HACK : FIX!

DISTRIBUTIONS_SUPPORTED = {'Ubuntu': 'ubuntu',
                           'Arch Linux': 'arch',
                           'Fedora': 'fedora'}

def getDistroNameInCommandsList(distroName):
    if (distroName in list(DISTRIBUTIONS_SUPPORTED.keys())):
        return DISTRIBUTIONS_SUPPORTED[distroName]
    else:
        return 'other'

def getFullPath(path):
    currentPath = QUrl(QFileInfo(__file__).absolutePath()+'/')
    return currentPath.resolved(QUrl(path)).toString()

def parseCommandsReturnedFromDatabase(reportCommands):
    commandList = []
    distroIsRight = False
    distroName = getDistroNameInCommandsList(getDistroName())
    reportCommandLines = reportCommands.split('\n')

    for line in reportCommandLines:
        if (not line):
            continue
        if (line[0] == '#'):
            if (line[1:] == distroName):
                distroIsRight = True
            else:
                continue
        else:
            if distroIsRight:
                commandList.append(line)
    return commandList

class queryResultModel(QAbstractListModel):
    def __init__(self, columns, suffix=''):
        super(queryResultModel, self).__init__()
        self._data = []
        self._columns = columns
        self._suffix = suffix

    def rowCount(self, parent=QModelIndex()):
        return len(self._data)

    def data(self, index, role=Qt.DisplayRole):
        if (not index.isValid()) or not (0 <= index.row() < self.rowCount()):
            return ''
        return self._data[index.row()][self._columns[role]]

    def roleNames(self):
        roles = {}
        for i in range(len(self._columns)):
            roles[i] = (self._suffix+self._columns[i]).encode('UTF-8')
        return roles

    def setData(self, data):
        self.beginRemoveRows(QModelIndex(), 0, self.rowCount()-1)
        self._data = []
        self.endRemoveRows()

        for string in data:
            self.beginInsertRows(QModelIndex(), self.rowCount(), self.rowCount())
            self._data.append(string)
            self.endInsertRows()

class MainDatabase(QObject):

    ignore = pyqtSignal()

    def __init__(self, parent=None):
        super(MainDatabase, self).__init__(parent)

        self._database = QSqlDatabase('QSQLITE')

        self._databaseName = ''
        self._databaseQuery = ''
        self._model = ''
        self._databaseQueryResult = []

    @pyqtProperty(str)
    def databaseName(self):
        return self._databaseName

    @databaseName.setter
    def databaseName(self, databaseName):
        self._databaseName = databaseName

    @pyqtProperty(str)
    def databaseQuery(self):
        return self._databaseQuery

    @databaseQuery.setter
    def databaseQuery(self, databaseQuery):
        self._databaseQuery = databaseQuery

    @pyqtProperty(QAbstractListModel, notify=ignore)
    def problemTypesTableModel(self):
        return self._model

    @pyqtSlot(str, str, str)
    @pyqtSlot(str, str)
    def prepareTableModel(self, columns, tableName, suffix=''):
        if (not columns) or (not tableName):
            return

        columns = columns.split('|')

        self.runQuery(columns, tableName)
        self._model = queryResultModel(columns, suffix)
        self._model.setData(self._databaseQueryResult)

    def runQuery(self, columns, tableName, addToQuery=''):
        if (not self._databaseName == ''):
            self._databaseQuery = 'SELECT {columns} FROM {tableName} {addToQuery}'.format(columns = ', '.join(columns),
                                                                                          tableName = tableName,
                                                                                          addToQuery = addToQuery)
            self._database.setDatabaseName(getFullPath(self._databaseName))
            if self._database.open():
                query = QSqlQuery(self._database)
                query.exec_(self._databaseQuery)

                self._databaseQueryResult = []
                while query.next():
                    item = {}
                    for i in range(len(columns)):
                        item[columns[i]] = query.value(i)
                    self._databaseQueryResult.append(item)

    @pyqtSlot(str)
    def prepareProblemTypeCommands(self, problemID):
        self.runQuery(['ReportCommands'], 'ProblemTypes', 'WHERE ID LIKE "{}"'.format(problemID))

    @pyqtProperty(QVariant)
    def getProblemTypeCommands(self):
        return QVariant(parseCommandsReturnedFromDatabase(self._databaseQueryResult[0]['ReportCommands']))

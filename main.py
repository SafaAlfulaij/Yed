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

import sys

try:
    from PyQt5.QtWidgets import QApplication
    from PyQt5.QtQml import QQmlApplicationEngine, qmlRegisterType
except ImportError:
    print('You need Qt5 (SQL, Quick and Quick Controls modules), Python3 and Python3-PyQt5 installed to run this app.')
    sys.exit()

app = QApplication(sys.argv)

from src import database, utils #HACK to init QApplication

engine = QQmlApplicationEngine()

qmlRegisterType(database.MainDatabase, 'DataBaseData', 1, 0, 'MainDatabase')
qmlRegisterType(utils.InternetConnectionClass, 'Utils', 1, 0, 'InternetConnectionClass')
qmlRegisterType(utils.ThreadingClass, 'Utils', 1, 0, 'ThreadingClass')

engine.load("./main.qml")
window = engine.rootObjects()[0]
window.show()
sys.exit(app.exec_())
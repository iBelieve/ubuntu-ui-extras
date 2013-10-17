/*
 * Copyright 2013 Canonical Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.0
import U1db 1.0 as U1db

/*!
    \qmltype SettingsStorage
    \inqmlmodule Ubuntu.Components 0.1
    \ingroup ubuntu
    \brief Singleton managing storage of all settings.
*/
QtObject {
    /*!
      The global list of declared Settings by group.
      */
    property var groups: null
    /*!
      Register a settings with a unique group name.
      */
    function addGroup(group, settings){
        if (groups == null)
            groups = {}
        if (group in groups)
            return false
        groups[group] = settings
        return true
    }
}

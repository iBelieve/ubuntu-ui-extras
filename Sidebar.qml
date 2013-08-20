/***************************************************************************
 * Whatsoever ye do in word or deed, do all in the name of the             *
 * Lord Jesus, giving thanks to God and the Father by him.                 *
 * - Colossians 3:17                                                       *
 *                                                                         *
 * Ubuntu UI Extras - A collection of QML widgets not available            *
 *                    in the default Ubuntu UI Toolkit                     *
 * Copyright (C) 2013 Michael Spencer <spencers1993@gmail.com>             *
 *                                                                         *
 * This program is free software: you can redistribute it and/or modify    *
 * it under the terms of the GNU General Public License as published by    *
 * the Free Software Foundation, either version 3 of the License, or       *
 * (at your option) any later version.                                     *
 *                                                                         *
 * This program is distributed in the hope that it will be useful,         *
 * but WITHOUT ANY WARRANTY; without even the implied warranty of          *
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the            *
 * GNU General Public License for more details.                            *
 *                                                                         *
 * You should have received a copy of the GNU General Public License       *
 * along with this program. If not, see <http://www.gnu.org/licenses/>.    *
 ***************************************************************************/
import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1

/*!
    \qmltype Sidebar
    \brief A sidebar component for use in adaptive layouts

    To use, simply add an instance to your code, and anchor other components to it.

    To show or hide, set the expanded property.

    Examples:
    \qml
        property bool wideAspect: width > units.gu(80)

        Sidebar {
            expanded: wideAspect

            // Anchoring is automatic
        }
    \endqml
*/
Rectangle {
    color: Qt.rgba(0.2,0.2,0.2,0.4)

    property bool expanded: true

    anchors {
        left: parent.left
        top: parent.top
        bottom: parent.bottom
    }

    Item {
        ThinDivider {
            rotation: 90

            width: parent.height
            height: 2
            anchors {
                left: undefined
                right: undefined
                centerIn: parent
            }
        }
        width: 2

        anchors {
            top: parent.top
            bottom: parent.bottom
            right: parent.right
            rightMargin: 0
        }
    }

    width: units.gu(35)


    anchors.leftMargin: expanded ? 0 : -width

    Behavior on anchors.leftMargin {
        PropertyAnimation {
            duration: 250
        }
    }

    default property alias contents: contents.data

    Item {
        id: contents

        anchors {
            fill: parent
            rightMargin: 1
        }
    }
}

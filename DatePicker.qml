/***************************************************************************
 * Whatsoever ye do in word or deed, do all in the name of the             *
 * Lord Jesus, giving thanks to God and the Father by him.                 *
 * - Colossians 3:17                                                       *
 *                                                                         *
 * Ubuntu UI Extras - A collection of QML widgets not available            *
 *                    in the default Ubuntu UI Toolkit                     *
 * Copyright (C) 2013 Michael Spencer <sonrisesoftware@gmail.com>          *
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

UbuntuShape {
    color: Qt.rgba(0.5,0.5,0.5,0.4)

    width: units.gu(20)
    height: units.gu(18)

    property var initialDate: new Date()

    property var date: {
        var date = new Date()
        date.setHours(0)
        date.setMinutes(0)
        date.setSeconds(0)

        print("Year", yearSpinner.value)
        date.setFullYear(yearSpinner.value)
        print("Month:", monthSpinner.selectedIndex)
        date.setMonth(monthSpinner.selectedIndex)
        print("Date:", dateSpinner.value)
        date.setDate(dateSpinner.value)
        return date
    }

    Item {
        id: rectangle
        //color: Qt.rgba(0.2,0.2,0.2,0.2)

        anchors {
            fill: parent
            //left: parent.left
            //right: parent.right
            //top: header.bottom
        }

        ValuesSpinner {
            id: monthSpinner
            anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
                right: parent.horizontalCenter
            }

            value: values[initialDate.getMonth()]

            width: units.gu(20)
            values: ["January", "February", "March", "April",
                "May", "June", "July", "August",
                "September", "October", "November", "December"]
        }
        VerticalDivider {
            id: divider1
            anchors.margins: 1
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Item {
            anchors {
                left: parent.horizontalCenter
                right: parent.right
                top: parent.top
                bottom: parent.bottom
            }

            Spinner {
                id: dateSpinner
                anchors {
                    left: parent.left
                    right: parent.horizontalCenter
                    top: parent.top
                    bottom: parent.bottom
                }

                value: initialDate.getDate()
                minValue: 1
                maxValue: 31
            }

            VerticalDivider {
                id: divider2
                anchors.margins: 1
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Spinner {
                id: yearSpinner
                anchors {
                    left: parent.horizontalCenter
                    right: parent.right
                    top: parent.top
                    bottom: parent.bottom
                }

                value: initialDate.getFullYear()
                minValue: initialDate.getFullYear() - 5
                maxValue: initialDate.getFullYear() + 10
            }
        }
    }
}

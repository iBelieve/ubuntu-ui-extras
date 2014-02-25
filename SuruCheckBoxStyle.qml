/***************************************************************************
 * Whatsoever ye do in word or deed, do all in the name of the             *
 * Lord Jesus, giving thanks to God and the Father by him.                 *
 * - Colossians 3:17                                                       *
 *                                                                         *
 * Ubuntu Tasks - A task management system for Ubuntu Touch                *
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

Item {
    id: checkBoxStyle

    /*!
      The image to show inside the checkbox when it is checked.
     */
    property url tickSource: getIcon("tick")

    opacity: enabled ? 1.0 : 0.5

    implicitWidth: units.gu(4.25)
    implicitHeight: units.gu(4)

    UbuntuShape {
        id: background
        anchors.fill: parent
    }

    Image {
        id: tick
        anchors.centerIn: parent
        smooth: true
        source: tickSource
        visible: styledItem.checked || transitionToChecked.running || transitionToUnchecked.running
    }

    state: styledItem.checked ? "checked" : "unchecked"
    states: [
        State {
            name: "checked"
            PropertyChanges {
                target: tick
                anchors.verticalCenterOffset: 0
            }
            PropertyChanges {
                target: background
                color: Theme.palette.selected.foreground
            }
        },
        State {
            name: "unchecked"
            PropertyChanges {
                target: tick
                anchors.verticalCenterOffset: checkBoxStyle.height
            }
            PropertyChanges {
                target: background
                color: Qt.rgba(0.2,0.2,0.2,0.3)
            }
        }
    ]

    transitions: [
        Transition {
            id: transitionToUnchecked
            to: "unchecked"
            ColorAnimation {
                target: background
                duration: UbuntuAnimation.BriskDuration
                easing: UbuntuAnimation.StandardEasingReverse
            }
            SequentialAnimation {
                PropertyAction {
                    target: checkBoxStyle
                    property: "clip"
                    value: true
                }
                NumberAnimation {
                    target: tick
                    property: "anchors.verticalCenterOffset"
                    duration: UbuntuAnimation.BriskDuration
                    easing: UbuntuAnimation.StandardEasingReverse
                }
                PropertyAction {
                    target: checkBoxStyle
                    property: "clip"
                    value: false
                }
            }
        },
        Transition {
            id: transitionToChecked
            to: "checked"
            ColorAnimation {
                target: background
                duration: UbuntuAnimation.BriskDuration
                easing: UbuntuAnimation.StandardEasing
            }
            SequentialAnimation {
                PropertyAction {
                    target: checkBoxStyle
                    property: "clip"
                    value: true
                }
                NumberAnimation {
                    target: tick
                    property: "anchors.verticalCenterOffset"
                    duration: UbuntuAnimation.BriskDuration
                    easing: UbuntuAnimation.StandardEasing
                }
                PropertyAction {
                    target: checkBoxStyle
                    property: "clip"
                    value: false
                }
            }
        }
    ]
}


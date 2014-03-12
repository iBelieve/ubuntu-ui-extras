/*
 * Copyright 2012 Canonical Ltd.
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
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem

Item {
    id: visuals
    // styling properties
    property color backgroundColor: Qt.rgba(0.2,0.2,0.2,0.97)
    property color headerColor: Qt.rgba(0,0,0,0.2)
    property real headerHeight: units.gu(6)
    property real buttonContainerWidth: units.gu(14)

    implicitWidth: MathUtils.clamp(styledItem.contentsWidth, styledItem.minWidth, styledItem.maxWidth)
    implicitHeight: header.height + containerItem.height

    property alias contentItem: containerItem

    property bool maximized: styledItem.contentsWidth > styledItem.maxWidth

    UbuntuShape {
        id: background
        color: backgroundColor
        visible: !maximized
        anchors {
            left: parent.left
            right: parent.right
            top: header.top
            bottom: containerItem.bottom
        }
    }

    Rectangle {
        color: backgroundColor
        visible: maximized
        anchors {
            left: parent.left
            right: parent.right
            top: header.top
            bottom: containerItem.bottom
        }
    }

    Item {
        id: header
        height: visuals.headerHeight
        clip: true

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        UbuntuShape {
            anchors {
                fill: parent
                bottomMargin: -units.gu(2)
            }

            visible: !maximized
            color: visuals.headerColor
        }

        Rectangle {
            anchors {
                fill: parent
            }

            visible: maximized
            color: visuals.headerColor
        }

        Label {
            id: headerText
            anchors {
                verticalCenter: parent.verticalCenter
                left: leftButtonContainer.right
                right: rightButtonContainer.left
            }
            width: headerText.implicitWidth + units.gu(4)
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignHCenter
            text: styledItem.title
            fontSize: "large"
            color: "#F3F3E7"
        }

        Item {
            id: leftButtonContainer
            anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
            }
            width: visuals.buttonContainerWidth
            Component.onCompleted: header.updateButton(styledItem.leftButton, leftButtonContainer)
        }

        Item {
            id: rightButtonContainer
            anchors {
                right: parent.right
                top: parent.top
                bottom: parent.bottom
            }
            width: visuals.buttonContainerWidth
            Component.onCompleted: header.updateButton(styledItem.rightButton, rightButtonContainer)
        }

        function updateButton(button, container) {
            if (!button) return;
            button.parent = container;
            button.anchors.left = container.left;
            button.anchors.right = container.right;
            button.anchors.verticalCenter = container.verticalCenter;
            button.anchors.margins = units.gu(1);
        }

        Connections {
            target: styledItem
            onLeftButtonChanged: header.updateButton(styledItem.leftButton, leftButtonContainer)
            onRightButtonChanged: header.updateButton(styledItem.rightButton, rightButtonContainer)
        }
    }

    Item {
        id: containerItem
        height: false ? styledItem.maxHeight - header.height : MathUtils.clamp(styledItem.contentsHeight, styledItem.minHeight - header.height, styledItem.maxHeight - header.height)
        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
        }
    }
}

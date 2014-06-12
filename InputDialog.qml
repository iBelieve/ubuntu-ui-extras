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
 * the Free Software Foundation, either version 2 of the License, or       *
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
import Ubuntu.Components 1.1
import Ubuntu.Components.Popups 1.0
import Ubuntu.Components.ListItems 1.0 as ListItem

Dialog {
    id: root

    signal accepted
    signal rejected

    property alias value: textField.text
    property alias placeholderText: textField.placeholderText

    Component.onCompleted: textField.forceActiveFocus()

    TextField {
        id: textField
        objectName: "inputField"

        onAccepted: okButton.clicked()
        validator: RegExpValidator {
            regExp: /.+/
        }
        style: DialogTextFieldStyle {}
    }

    Item {
        width: parent.width
        height: childrenRect.height

        Button {
            objectName: "cancelButton"
            text: i18n.tr("Cancel")

            anchors {
                left: parent.left
                right: parent.horizontalCenter
                rightMargin: units.gu(1)
            }

            color: "gray"

            onTriggered: {
                PopupUtils.close(root)
                rejected()
            }
        }

        Button {
            id: okButton
            objectName: "okButton"

            anchors {
                left: parent.horizontalCenter
                right: parent.right
                leftMargin: units.gu(1)
            }

            text: i18n.tr("Ok")
            enabled: textField.acceptableInput

            onTriggered: {
                print("TRIGGERED")
                PopupUtils.close(root)
                accepted()
            }
        }
    }
}

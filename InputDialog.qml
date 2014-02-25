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
import Ubuntu.Components 0.1
import Ubuntu.Components.Popups 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem

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
    }

    Button {
        id: okButton
        objectName: "okButton"

        text: i18n.tr("Ok")
        enabled: textField.acceptableInput

        onClicked: {
            PopupUtils.close(root)
            accepted()
        }
    }

    Button {
        objectName: "cancelButton"
        text: i18n.tr("Cancel")

        gradient: Gradient {
            GradientStop {
                position: 0
                color: "gray"
            }

            GradientStop {
                position: 1
                color: "lightgray"
            }
        }

        onClicked: {
            PopupUtils.close(root)
            rejected()
        }
    }
}

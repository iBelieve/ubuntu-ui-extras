import QtQuick 2.0
import Ubuntu.Components 1.1


Item {
    width: parent.width
    height: childrenRect.height

    signal accepted
    signal rejected

    property alias enabled: okButton.enabled

    Button {
        objectName: "cancelButton"
        text: i18n.tr("Cancel")

        anchors {
            left: parent.left
            right: parent.horizontalCenter
            rightMargin: units.gu(1)
        }

        onTriggered: {
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
        color: UbuntuColors.orange

        onTriggered: {
            print("TRIGGERED")
            accepted()
        }
    }
}

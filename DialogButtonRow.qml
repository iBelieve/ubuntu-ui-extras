import QtQuick 2.0
import Ubuntu.Components 1.1


Item {
    width: parent.width
    height: childrenRect.height

    signal accepted
    signal rejected

    property alias acceptText: okButton.text
    property alias rejectText: cancelButton.text
    property alias acceptColor: okButton.color

    property alias enabled: okButton.enabled

    Button {
        id: cancelButton
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
        color: "#3fb24f"

        onTriggered: {
            print("TRIGGERED")
            accepted()
        }
    }
}

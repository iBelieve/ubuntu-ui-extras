import QtQuick 2.0
import Ubuntu.Components 0.1

Rectangle {
    id: notification

    anchors {
        horizontalCenter: parent.horizontalCenter
        bottom: parent.bottom
        margins: (toolbar.opened && !toolbar.locked ? toolbar.height : 0) + units.gu(2)
    }

    height: label.height + units.gu(3)
    width: label.width + units.gu(4.5)
    radius: height/2
    color: Qt.rgba(0,0,0,0.7)

    opacity: showing ? 1 : 0

    Behavior on opacity {
        UbuntuNumberAnimation {}
    }

    property bool showing: false
    property string text

    function show(text) {
        notification.text = text
        notification.showing = true
    }

    onShowingChanged: {
        if (showing)
            timer.restart()
    }

    Label {
        id: label
        anchors.centerIn: parent
        text: notification.text
        fontSize: "medium"
    }

    Timer {
        id: timer
        interval: 2000
        onTriggered: showing = false
    }
}

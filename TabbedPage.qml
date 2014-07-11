import QtQuick 2.0
import Ubuntu.Components 1.1

Page {
    id: page

    property int headerHeight: header.height + tabbar.visible ? -tabbar.anchors.bottomMargin : 0

    property var tabs: []
    property int selectedIndex: 0
    property var selectedTab: tabs[selectedIndex]
    property bool showTabs: tabs.length > 0

    Item {
        id: tabbar
        visible: showTabs && page.active

        property var headerItem: header

        onHeaderItemChanged: updateHeight()

        onVisibleChanged: updateHeight()

        function updateHeight() {
            if (header)
                header.height = header.__styleInstance.contentHeight + (visible ? tabbar.height : units.gu(2))
        }

        anchors.bottom: parent.bottom
        height: units.gu(3.5)
        parent: header
        width: parent.width
        BorderImage {
            id: separator
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }
            source: "PageHeaderBaseDividerLight.sci"
        }

        Rectangle {
            color: "#3e3e3e" //FIXME: This color is hard-coded based on the current app background color
            height: units.gu(2.8)
            anchors {
                bottom: parent.bottom
                left: parent.left
                right: parent.right
            }
        }

//        Image {
//            id: separatorBottom
//            anchors {
//                top: parent.bottom
//                left: parent.left
//                right: parent.right
//            }
//            source: "PageHeaderBaseDividerBottom.png"
//        }

        Row {
            id: row
            anchors.centerIn: parent

            Repeater {
                model: tabs
                delegate: Item {
                    height: tabbar.height
                    width: Math.min(tabbar.width/tabs.length, label.width + units.gu(12))
                    MouseArea {
                        anchors.fill: parent
                        onClicked: selectedIndex = index
                    }

                    Label {
                        id: label
                        text: modelData

                        anchors.centerIn: parent
                    }

                    Rectangle {
                        width: label.width + units.gu(4)
                        height: units.gu(0.2)
                        color: UbuntuColors.orange
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom

                        opacity: selectedIndex == index ? 1 : 0
                    }
                }
            }
        }
    }
}

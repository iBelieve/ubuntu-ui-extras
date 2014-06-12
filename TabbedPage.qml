import QtQuick 2.0
import Ubuntu.Components 1.1

Page {
    id: page

    property int headerHeight: header.height + tabbar.visible ? -tabbar.anchors.bottomMargin : 0

    property var tabs: []
    property int selectedIndex: 0
    property var selectedTab: tabs[selectedIndex]

    Item {
        id: tabbar
        visible: tabs.length > 1 && page.active

        property var headerItem: header

        onHeaderItemChanged: updateHeight()

        onVisibleChanged: updateHeight()

        function updateHeight() {
            if (header)
                header.height = header.__styleInstance.contentHeight + (visible ? tabbar.height : units.gu(2))
        }

        anchors.bottom: parent.bottom
        height: units.gu(3)
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
            anchors.verticalCenterOffset: units.gu(-0.1)
            spacing: units.gu(1)

            Repeater {
                model: tabs
                delegate: Row {
                    Label {
                        text: modelData
                        width: units.gu(10)
                        horizontalAlignment: index === 0 ? Text.AlignRight
                                                         : index ===  tabs.length - 1 ? Text.AlignLeftt
                                                                                      : Text.AlignHCenter
                        color: selectedIndex == index ? UbuntuColors.orange : Theme.palette.selected.backgroundText

                        Behavior on color {
                            ColorAnimation {
                                duration: UbuntuAnimation.FastDuration
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: selectedIndex = index
                        }
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Label {
                        text: "|"
                        visible: index < tabs.length - 1
                        opacity: 0.75
                    }

                    spacing: units.gu(1)
                }
            }
        }
    }
}

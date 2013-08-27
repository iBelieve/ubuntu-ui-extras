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

Item {
    id: root

    clip: true
    //color: "white"
    //color: Qt.rgba(0.2,0.2,0.2,0.4)

    width: units.gu(10)
    height: units.gu(30)

    property alias selectedIndex: listView.currentIndex

    onSelectedIndexChanged: {
        value = model.get(listView.currentIndex).modelData
    }

    property var value: model.get(listView.currentIndex).modelData

    property var values: []

    onValuesChanged: {
        model.clear()
        for (var i = 0; i < values.length; i++) {
            model.append({modelData: values[i]})
        }
    }

    Component.onCompleted: {
        createModel()
        for (var i = 0; i < model.count; i++) {
            if (model.get(i).modelData === value)
                listView.currentIndex = i
        }
    }

    property int minValue: 0

    onMinValueChanged: {
        if (model.count === 0) {
            createModel()
            return
        }
        while (minValue < model.get(0).modelData)
            model.insert({modelData: model.get(0) - 1}, 0)
        while (minValue > model.get(0).modelData)
            model.remove(0)

        listView.currentIndex = value - minValue
        print("Model length", model.count)
    }

    property int maxValue: 10

    onMaxValueChanged: {
        if (model.count === 0) {
            createModel()
            return
        }
        while (maxValue < model.get(model.count - 1).modelData)
            model.insert({modelData: model.get(model.count - 1) + 1}, model.count - 1)
        while (maxValue > model.get(model.count - 1).modelData)
            model.remove(model.count - 1)
        print("Model length", model.count)
    }

    function createModel() {
        for (var i = minValue; i <= maxValue; i++) {
            model.append({modelData: i})
        }
    }

    ListModel {
        id: model
    }

    PathView {
        id: listView
        anchors.fill: parent
        model: model

        delegate: Standard {
            highlightWhenPressed: false
            Label {
                anchors.centerIn: parent
                text: modelData
            }
            onClicked: listView.currentIndex = index
            showDivider: false
        }

        pathItemCount: listView.height / highlightItem.height + 1
        preferredHighlightBegin: 0.5
        preferredHighlightEnd: 0.5
        clip: true

        property int contentHeight: pathItemCount * highlightItem.height

        path: Path {
            startX: listView.width / 2; startY: -(listView.contentHeight - listView.height) / 2
            PathLine { x: listView.width / 2; y: listView.height + (listView.contentHeight - listView.height) / 2 }
        }

        maximumFlickVelocity: 400

        highlight: Rectangle {
            width: parent.width
            height: units.gu(6)
            property color baseColor: "#dd4814"
            gradient: Gradient {
                GradientStop {
                    position: 0.00;
                    color: Qt.lighter(baseColor, 1.3);
                }
                GradientStop {
                    position: 1.0;
                    color: baseColor;
                }
            }
        }
    }

}

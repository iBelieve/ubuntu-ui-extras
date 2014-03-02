import QtQuick 2.0

/*
example usage:

Rectangle {
    width: 600
    height: 600

    ColumnFlow {
        id: grid
        anchors.fill: parent
        columns: 5
        model: 20

        delegate: Rectangle {
            id: item
            height: 100.0 * Math.random()
            color: Qt.rgba(Math.random(), Math.random(), Math.random(), Math.random())
            Text {text: index}
        }
    }
}
*/
Item {
    id: columnFlow

    property int columns
    property bool repeaterCompleted: false
    property var model: []
    readonly property bool modelIsArray: model instanceof Array
    property alias delegate: repeater.delegate
    property int contentHeight: 0

    onColumnsChanged: reEvalColumns()
    onModelChanged: reEvalColumns()

    onWidthChanged: {
        if (repeaterCompleted)
            for (var i = 0; i < Math.min(repeater.count, columns); i++)
                repeater.itemAt(i).width = width / columns
    }

    function reEvalColumns() {
        if (!repeaterCompleted)
            return
        var i, j
        var columnHeights = new Array(columns);
        var lastItem = new Array(columns)

        //add the first <column> elements
        for (i = 0; i < Math.min(repeater.count, columns); i++) {
            lastItem[i] = i
            if (!repeater.itemAt(i)) continue

            columnHeights[i] = repeater.itemAt(i).height

            repeater.itemAt(i).anchors.top = columnFlow.top
            repeater.itemAt(i).anchors.left = (i === 0 ? columnFlow.left : repeater.itemAt(i - 1).right)
            repeater.itemAt(i).anchors.right = undefined
            repeater.itemAt(i).width = columnFlow.width / columns
        }

        //add the other elements
        for (i = i; i < repeater.count; i++) {
            var highestHeight = Number.MAX_VALUE
            var newColumn = 0

            // find the shortest column
            for (j = 0; j < columns; j++) {
                if (columnHeights[j] < highestHeight) {
                    newColumn = j
                    highestHeight = columnHeights[j]
                }
            }

            // add the element to the shortest column
            repeater.itemAt(i).anchors.top = repeater.itemAt(lastItem[newColumn]).bottom
            repeater.itemAt(i).anchors.left = repeater.itemAt(newColumn).left
            repeater.itemAt(i).anchors.right = repeater.itemAt(newColumn).right

            lastItem[newColumn] = i
            columnHeights[newColumn] += repeater.itemAt(i).height
        }

        var cHeight = 0
        for (i = 0; i < columns; i++)
            cHeight = Math.max(cHeight, columnHeights[i])
        contentHeight = cHeight
    }


//    function appendToModel (item) {
//        // only if model is an array
//        if ((model instanceof Array) !== (item instanceof Array))
//            return

//        if (item instanceof Array)
//            for (var i = 0; i < item.length; i++)
//                repeater.model.push(item)
//    }


    Repeater {
        id: repeater
        model: columnFlow.model

        Component.onCompleted: {
            columnFlow.repeaterCompleted = true
            columnFlow.reEvalColumns()
        }
    }
}

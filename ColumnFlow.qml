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

    property int columns: 1
    property bool repeaterCompleted: false
    property alias model: repeater.model
    property alias delegate: repeater.delegate
    property int contentHeight: 0

    onColumnsChanged: reEvalColumns()
    onModelChanged: reEvalColumns()

    onWidthChanged: updateWidths()

    function updateWidths() {
        if (repeaterCompleted) {
            var count = 0

            //dump(columnFlow)

            //add the first <column> elements
            for (var i = 0; count < columns && i < columnFlow.children.length; i++) {
                print(i, count)
                if (!columnFlow.children[i] || String(columnFlow.children[i]).indexOf("QQuickRepeater") == 0
                         || !columnFlow.children[i].visible) continue

                columnFlow.children[i].width = width / columns
                count++
            }
        }
    }

    function dump(obj, indent) {
        if (indent === undefined)
            indent = 0
        var spacing = ""
        for (var a = 0; a < indent; a++) {
            spacing += " "
        }
        print(spacing + String(obj))
        if (obj.hasOwnProperty("children")) {
            for (var i = 0; i < obj.children.length; i++) {
                dump(obj.children[i], indent+1)
            }
        }
    }

    function reEvalColumns() {
        print("COMPLETED:", columnFlow.repeaterCompleted)
        if (columnFlow.repeaterCompleted === false)
            return
        print("DONE")
        var i, j
        var columnHeights = new Array(columns);
        var lastItem = new Array(columns)
        var lastI = -1
        var count = 0

        //dump(columnFlow)

        //add the first <column> elements
        //print(columns,columnFlow.children.length)
        for (i = 0; count < columns && i < columnFlow.children.length; i++) {
            //print(columnFlow.children[i], columnFlow.children[i].visible)

            if (!columnFlow.children[i] || String(columnFlow.children[i]).indexOf("QQuickRepeater") == 0
                     || !columnFlow.children[i].visible) continue

            lastItem[count] = i
            columnHeights[count] = columnFlow.children[i].height

            columnFlow.children[i].anchors.top = columnFlow.top
            columnFlow.children[i].anchors.left = (lastI === -1 ? columnFlow.left : columnFlow.children[lastI].right)
            columnFlow.children[i].anchors.right = undefined
            columnFlow.children[i].width = columnFlow.width / columns

            lastI = i
            count++
        }

        print("HEIGHTS 1", JSON.stringify(columnHeights))

        //add the other elements
        for (i = i; i < columnFlow.children.length; i++) {
            var highestHeight = Number.MAX_VALUE
            var newColumn = 0

            print(columnFlow.children[i])

            if (!columnFlow.children[i] || String(columnFlow.children[i]).indexOf("QQuickRepeater") == 0
                     || !columnFlow.children[i].visible) continue

            // find the shortest column
            for (j = 0; j < columns; j++) {
                if (columnHeights[j] !== null && columnHeights[j] < highestHeight) {
                    newColumn = j
                    highestHeight = columnHeights[j]
                }
            }

            // add the element to the shortest column
            columnFlow.children[i].anchors.top = columnFlow.children[lastItem[newColumn]].bottom
            columnFlow.children[i].anchors.left = columnFlow.children[lastItem[newColumn]].left
            columnFlow.children[i].anchors.right = columnFlow.children[lastItem[newColumn]].right

            lastItem[newColumn] = i
            columnHeights[newColumn] += columnFlow.children[i].height
        }

        var cHeight = 0
        print("HEIGHTS:", JSON.stringify(columnHeights))
        for (i = 0; i < columnHeights.length; i++) {
            if (columnHeights[i] === null)
                continue
            cHeight = Math.max(cHeight, columnHeights[i])
        }
        print(cHeight, cHeight/units.gu(1))
        contentHeight = cHeight

        updateWidths()
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
